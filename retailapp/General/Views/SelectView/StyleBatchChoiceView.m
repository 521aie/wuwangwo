//
//  StyleBatchChoiceView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StyleBatchChoiceView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SearchBar2.h"
#import "ListStyleVo.h"
#import "ViewFactory.h"
#import "GoodsStyleBatchSelectCell.h"
#import "StyleChoiceTopView.h"
#import "XHAnimalUtil.h"
#import "DateUtils.h"
#import "WechatService.h"
#import "LSWechatStyleManageViewController.h"
#import "RoleCommissionnDetailView.h"
@interface StyleBatchChoiceView ()

@property (nonatomic, strong) WechatService* wechatService;

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic, strong) NSMutableDictionary* condition;

@property (nonatomic, retain) NSString *searchCode;

@property (nonatomic, strong) NSString* createTime;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic, strong) NSMutableArray* styleList;

@property (nonatomic, strong) NSString* type;

/**
 1表示为从搜索框搜索，当查询出来为一条信息时，跳转到下一个页面
 */
@property (nonatomic) short isJump;

@property (nonatomic, copy) NSString *token;

@end



@implementation StyleBatchChoiceView

- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    _wechatService = [ServiceFactory shareInstance].wechatService;
    [self configViews];
    [self initHead];
    [self initGrid];
    
    __weak StyleBatchChoiceView* weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        _createTime = @"";
        [weakSelf selectStyleList];
    }];
    [weakSelf.mainGrid ls_addFooterWithCallback:^{
        [weakSelf selectStyleList];
    }];
    
    [self loaddatas];
}

- (void)configViews {
    self.searchBar = [SearchBar2 searchBar2];
    [self.searchBar initDelagate:self placeholder:@"名称/款号"];
    [self.view addSubview:self.searchBar];
    
    __weak typeof(self) wself = self;
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.view).offset(kNavH);
        make.height.equalTo(44);
    }];
    
    self.mainGrid = [[UITableView alloc] init];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.rowHeight = 88.0f;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.mainGrid];
    [self.mainGrid makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.searchBar.bottom);
    }];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
    [self.view addSubview:self.footView];
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
    
}


-(void) loaddatas
{
    
    [self.mainGrid reloadData];
    
    self.mainGrid.ls_show = YES;
}

-(void) loaddatas:(NSString *)shopId type:(NSString*) type condition:(NSMutableDictionary *)condition styleList:(NSMutableArray *)styleList callBack:(SelectBatchBack)callBack
{
    _selectBatchBack = callBack;
    _shopId = shopId;
    _condition = [[NSMutableDictionary alloc] initWithDictionary:condition];
    [_condition setValue:@"" forKey:@"searchCode"];
    [_condition setValue:_shopId forKey:@"shopId"];
    _type = type;
    _createTime = [condition objectForKey:@"createTime"];
    _styleList = [[NSMutableArray alloc] init];
    self.datas = [NSMutableArray arrayWithArray:styleList];
    if (self.datas != nil && self.datas.count > 0) {
        for (ListStyleVo *vo in self.datas) {
            vo.isCheck =@"0";
        }
    }
    [self.mainGrid reloadData];
}

-(void) loadDatasFromSelect:(NSMutableDictionary *)condition
{
    self.searchBar.keyWordTxt.text = @"";
    _createTime = @"";
    _condition = condition;
    [self selectStyleList];
}

-(void) selectStyleList
{
    __weak StyleBatchChoiceView* weakSelf = self;
    [_condition setValue:_createTime != nil? _createTime:@"" forKey:@"createTime"];
    [_goodsService selectStyleList:_condition completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

- (void)responseSuccess:(id)json
{
    if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
        NSMutableArray *array = [json objectForKey:@"styleVoList"];
        if ([NSString isBlank:[_condition objectForKey:@"createTime"]]) {
            self.datas = [[NSMutableArray alloc] init];
        }
        if ([ObjectUtil isNotNull:array]) {
            for (NSDictionary* dic in array) {
                [self.datas addObject:[ListStyleVo convertToListStyleVo:dic]];
            }
        }
        
        if ([NSString isBlank:_createTime]) {
            [_styleList removeAllObjects];
            [self configNavigationBar:LSNavigationBarButtonDirectRight title: @"筛选" filePath:Head_ICON_CHOOSE];
        }
        
        if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
            _createTime = [[json objectForKey:@"createTime"] stringValue];
        }
        
        if (self.datas.count == 1 && _isJump == 1) {
            _selectBatchBack(self.datas);
        }
        _isJump = 0;
        [self.mainGrid reloadData];
    } else if ([[json objectForKey:@"searchStatus"] integerValue] == 0) {
        [self.datas removeAllObjects];
        _createTime = @"";
        if ([NSString isBlank:_createTime]) {
            [_styleList removeAllObjects];
            [self configNavigationBar:LSNavigationBarButtonDirectRight title: @"筛选" filePath:Head_ICON_CHOOSE];
        }
        [self.mainGrid reloadData];
    }
    
    self.mainGrid.ls_show = YES;
}

#pragma navigateTitle.
-(void) initHead
{
    [self configTitle:@"选择款式" leftPath:Head_ICON_CANCEL rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title: @"筛选" filePath:Head_ICON_CHOOSE];
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        _selectBatchBack(nil);
    }else{
        if (_styleList.count > 0) {
            if (self.type.intValue==2) {//微店商品添加
                 [self saveStyleList:_styleList];
            } else {
                 _selectBatchBack(_styleList);
            }
   
        }else{
            [self loadStyleChoiceTopView];
            self.styleTopSelectView.conditionOfInit = self.conditionOfBatchView;
            self.styleTopSelectView.delegate = self;
            self.styleTopSelectView.shopId = _shopId;
            self.styleTopSelectView.fromViewTag = STYLE_BATCH_CHOICE_VIEW;
            [self.styleTopSelectView loaddatas];
            [self.styleTopSelectView oper];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.token = nil;
}
//微店商品批量添加
-(void)saveStyleList:(NSArray *) styleList{
   self.shopId=[[Platform Instance] getkey:SHOP_ID];
    NSMutableArray *listStyleArray=[NSMutableArray array];
    for(ListStyleVo *vo in styleList){
        if (vo.upDownStatus == 2) {//实体已下架的款式
            [AlertBox show:@"在款式详情中设为已下架的款式不能在微店中销售"];
            return;
        }
        [listStyleArray addObject:vo.styleId];
    }
    if ([ObjectUtil isNull:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    [_wechatService batchAddWechatGoodsStyles:self.shopId styleIdList:listStyleArray token:self.token completionHandler:^(id json) {
        self.token = nil;
            LSWechatStyleManageViewController *wechatVc = nil;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LSWechatStyleManageViewController class]]) {
                    wechatVc = (LSWechatStyleManageViewController *)vc;
                }
            }
            [self.navigationController popToViewController:wechatVc animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
   
    
}
-(void) showStyleListView:(NSMutableDictionary *)condition
{
    self.searchBar.keyWordTxt.text = @"";
    [self loadDatasFromSelect:condition];
}

/*加载商品款式筛选页面*/
- (void)loadStyleChoiceTopView
{
    if (self.styleTopSelectView) {
        self.styleTopSelectView.view.hidden = NO;
    }else{
        self.styleTopSelectView = [[StyleTopSelectView alloc] initWithNibName:[SystemUtil getXibName:@"StyleTopSelectView"] bundle:nil];
        [self.view addSubview:self.styleTopSelectView.view];
    }
}

-(void) imputFinish:(NSString *)keyWord
{
    [_condition setValue:@"1" forKey:@"searchType"];
    [_condition setValue:_shopId forKey:@"shopId"];
    [_condition setValue:keyWord forKey:@"searchCode"];
    [_condition setValue:@"" forKey:@"categoryId"];
    [_condition setValue:@"" forKey:@"applySex"];
    [_condition setValue:@"" forKey:@"prototypeValId"];
    [_condition setValue:@"" forKey:@"auxiliaryValId"];
    [_condition setValue:@"" forKey:@"year"];
    [_condition setValue:@"" forKey:@"seasonValId"];
    [_condition setValue:@"" forKey:@"minHangTagPrice"];
    [_condition setValue:@"" forKey:@"maxHangTagPrice"];
    [_condition setValue:@"" forKey:@"createTime"];
    _createTime = @"";
    _isJump = 1;
    [self selectStyleList];
}
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectNo]) {
        [self notCheckAllEvent];
    } else  if ([footerType isEqualToString:kFootSelectAll]) {
        [self checkAllEvent];
    }
}
-(void) checkAllEvent
{
    _styleList = [NSMutableArray array];
    if (self.datas.count > 0) {
        for (ListStyleVo *vo in self.datas) {
            vo.isCheck =@"1";
            [_styleList addObject:vo];
        }
    }
    if (_styleList.count > 0) {
        NSString *rightTitle = nil;
        if ([_type isEqualToString:@"1"]) {
            rightTitle= @"确认";
        }else{
            rightTitle = @"保存";
        }
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:rightTitle filePath:Head_ICON_OK];
    }
    
    [self.mainGrid reloadData];
}

-(void) notCheckAllEvent
{
    if (self.datas.count > 0) {
        for (ListStyleVo *vo in self.datas) {
            vo.isCheck =@"0";
        }
    }
    
    [_styleList removeAllObjects];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"筛选" filePath:Head_ICON_CHOOSE];
    [self.mainGrid reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"goods" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

-(void) showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    ListStyleVo* editObj = (ListStyleVo*) obj;
    if ([editObj.isCheck isEqualToString:@"1"]) {
        editObj.isCheck = @"0";
        [_styleList removeObject:editObj];
    }else{
        
        editObj.isCheck = @"1";
        
        [_styleList addObject:editObj];
    }
    
    if (_styleList.count == 0) {
        
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"筛选" filePath:Head_ICON_CHOOSE];
    }else{
        NSString *rightTitle = nil;
        if ([_type isEqualToString:@"1"]) {
            rightTitle= @"确认";
        }else{
            rightTitle = @"保存";
        }
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:rightTitle filePath:Head_ICON_OK];
    }
    
    [self.mainGrid reloadData];
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsStyleBatchSelectCell *detailItem = (GoodsStyleBatchSelectCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsStyleBatchSelectCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsStyleBatchSelectCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        ListStyleVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = [item.styleName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        detailItem.lblStyleNo.text = item.styleCode;
        if ([item.isCheck isEqualToString:@"1"]) {
            detailItem.imgUnCheck.hidden = YES;
            detailItem.imgCheck.hidden = NO;
        }else{
            detailItem.imgUnCheck.hidden = NO;
            detailItem.imgCheck.hidden = YES;
        }
        if (item.upDownStatus == 2) {
            detailItem.img_updown.hidden = NO;
        } else {
            detailItem.img_updown.hidden = YES;
        }
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

-(void)initGrid
{
    self.mainGrid.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


@end
