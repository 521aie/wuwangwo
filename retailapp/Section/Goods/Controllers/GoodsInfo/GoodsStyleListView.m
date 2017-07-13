//
//  GoodsStyleListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsStyleListView.h"
#import "GoodsStyleListCell.h"
#import "ObjectUtil.h"
#import "SearchBar2.h"
#import "MyUILabel.h"
#import "GoodsStyleEditView.h"
#import "GoodsStyleBatchSelectView.h"
#import "EditItemList.h"
#import "GoodsModuleEvent.h"
#import "StyleTopSelectView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "ListStyleVo.h"
#import "DateUtils.h"
#import "XHAnimalUtil.h"
#import "StyleVo.h"
#import "GoodsStyleInfoView.h"
#import "SearchBar.h"
#import "ViewFactory.h"
#import "LSFooterView.h"

@interface GoodsStyleListView ()

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic, strong) NSString* createTime;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic, strong) ListStyleVo* tempVo;

@property (nonatomic, retain) NSString *searchCode;

@property (nonatomic, retain)  StyleVo* addStyleVo;

@end

@implementation GoodsStyleListView


- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;

    [self initGrid];
    [self initHead];
    [self configViews];
    
    [self loaddatas];
}

- (void)configViews {
    CGFloat y = kNavH;
    self.searchBar = [SearchBar2 searchBar2];
     [self.searchBar initDelagate:self placeholder:@"名称/款号"];
    [self.view addSubview:self.searchBar];
    self.searchBar.ls_top = y;
    y = y + self.searchBar.ls_height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak GoodsStyleListView* weakSelf = self;
    [weakSelf.tableView ls_addHeaderWithCallback:^{
        _createTime = nil;
        [weakSelf selectStyleList];
    }];
    
    [weakSelf.tableView ls_addFooterWithCallback:^{
        [weakSelf selectStyleList];
    }];
    [self.view addSubview:self.tableView];
    
    self.footView = [LSFooterView footerView];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
    
    NSArray* arr= nil;
    if (![[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD]) {
        if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_EDIT] && [[Platform Instance] lockAct:ACTION_GOODS_STYLE_DELETE] && [[Platform Instance] lockAct:ACTION_MARKET_SET]) {
            arr=[[NSArray alloc] initWithObjects:kFootAdd, nil];
        } else {
            arr=[[NSArray alloc] initWithObjects:kFootAdd, kFootBatch , nil];
        }
        
    } else if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD]) {
        if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_EDIT] && [[Platform Instance] lockAct:ACTION_GOODS_STYLE_DELETE] && [[Platform Instance] lockAct:ACTION_MARKET_SET]) {
            arr=[[NSArray alloc] init];
        } else {
            arr=[[NSArray alloc] initWithObjects:kFootBatch, nil];
        }
    }
    [self.footView initDelegate:self btnsArray:arr];
    
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootBatch]) {
        [self showBatchEvent];
    }
    
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView headerBeginRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loaddatas
{
    _searchBar.keyWordTxt.text = [_condition objectForKey:@"searchCode"];
    _shopId = [_condition objectForKey:@"shopId"];
    if ([[_condition objectForKey:@"searchType"] isEqualToString:@"2"]) {
        [self.tableView headerBeginRefreshing];
    }else{
        _createTime = [_condition objectForKey:@"createTime"];
        self.datas = [_condition objectForKey:@"styleList"];
        
        [self.tableView reloadData];
        
        self.tableView.ls_show = YES;
    }
}

- (void)loadDatasFromEditView:(StyleVo*) styleVo action:(int)action
{
    if (action == ACTION_CONSTANTS_DEL) {
        
        [self.datas removeObject:_tempVo];
        [self.tableView reloadData];
        
        self.tableView.ls_show = YES;
    }else if (action == ACTION_CONSTANTS_EDIT){
        _tempVo.styleName = styleVo.styleName;
        _tempVo.styleCode = styleVo.styleCode;
        _tempVo.filePath = styleVo.filePath;
        [self.tableView reloadData];
    }else if (action == ACTION_CONSTANTS_ADD){
//        [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(selectStyleList) userInfo:nil repeats:NO];
        [self.tableView headerBeginRefreshing];
    }
}

- (void)loadDatasFromBatchSelectView
{
    [_condition setValue:self.searchBar.keyWordTxt.text forKey:@"searchCode"];
    [self.tableView headerBeginRefreshing];
}

- (void)selectStyleList
{
    __weak GoodsStyleListView* weakSelf = self;
    [_condition setValue:_createTime != nil? _createTime:@"" forKey:@"createTime"];
    [_condition setValue:@YES forKey:@"needUpDownStatus"];//非必传 如果需要上下架这个参数传
    [_goodsService selectStyleList:_condition completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
    }];
}

- (void)responseSuccess:(id)json
{
    if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
        NSMutableArray *array = [json objectForKey:@"styleVoList"];
        if (_createTime == nil || [_createTime isEqualToString:@""]) {
            self.datas = [[NSMutableArray alloc] init];
        }
        if ([ObjectUtil isNotNull:array]) {
            for (NSDictionary* dic in array) {
                [self.datas addObject:[ListStyleVo convertToListStyleVo:dic]];
            }
        }
        
        if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
            _createTime = [[json objectForKey:@"createTime"] stringValue];
        }
    } else if ([[json objectForKey:@"searchStatus"] integerValue] == 0) {
        _createTime = @"";
        [self.datas removeAllObjects];
    }
    
    [self.tableView reloadData];
    
    self.tableView.ls_show = YES;
}

#pragma navigateTitle.
- (void)initHead
{
    [self configTitle:@"款式" leftPath:Head_ICON_BACK rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"筛选" filePath:Head_ICON_CHOOSE];
}

- (void)showAddEvent
{
    GoodsStyleEditView* vc = [[GoodsStyleEditView alloc] init];
    vc.styleId = nil;
    vc.shopId = _shopId;
    vc.action = ACTION_CONSTANTS_ADD;
    vc.viewTag = GOODS_STYLE_LIST_VIEW;
    vc.synShopId = self.synShopId;
    vc.synShopName = self.synShopName;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[GoodsStyleInfoView class]]) {
                GoodsStyleInfoView *goodsVc = (GoodsStyleInfoView *)vc;
                [goodsVc loadDatasFromEdit];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
            }

        }
    }else{
        
        [self loadStyleTopSelectView];
        self.styleTopSelectView.delegate = self;
        self.styleTopSelectView.shopId = _shopId;
        self.styleTopSelectView.shopName = [_condition objectForKey:@"shopName"];
        self.styleTopSelectView.fromViewTag = GOODS_STYLE_LIST_VIEW;
        self.styleTopSelectView.conditionOfInit = self.conditionOfInit;
        [self.styleTopSelectView loaddatas];
        [self.styleTopSelectView oper];
    }
}

/*加载商品款式筛选页面*/
- (void)loadStyleTopSelectView
{
    if (self.styleTopSelectView) {
        self.styleTopSelectView.view.hidden = NO;

    }else{
        self.styleTopSelectView = [[StyleTopSelectView alloc] initWithNibName:[SystemUtil getXibName:@"StyleTopSelectView"] bundle:nil];
        [self.view addSubview:self.styleTopSelectView.view];
    }
}

- (void)showStyleListView:(NSMutableDictionary *)condition
{
    _condition = condition;
    self.conditionOfBatchView = condition;
    [self loaddatas];
}

- (void)showBatchEvent
{
    [_condition setValue:self.searchBar.keyWordTxt.text forKey:@"searchCode"];
    if (self.createTime == nil) {
        [_condition setValue:@"" forKey:@"createTime"];
    }else{
        [_condition setValue:self.createTime forKey:@"createTime"];
    }
    GoodsStyleBatchSelectView* vc = [[GoodsStyleBatchSelectView alloc] init];
    vc.datas = self.datas;
    vc.condition = [[NSMutableDictionary alloc] init];
    vc.condition = [[NSMutableDictionary alloc] initWithDictionary:_condition];
//    vc.condition = _condition;
    vc.conditionOfBatchView = self.conditionOfBatchView;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
}



#pragma  mark 搜索框检索
- (void)imputFinish:(NSString *)keyWord
{
    _searchCode = keyWord;
    _createTime = nil;
    NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
    [condition setValue:@"1" forKey:@"searchType"];
    [condition setValue:[_condition objectForKey:@"shopId"] forKey:@"shopId"];
    [condition setValue:[_condition objectForKey:@"shopName"] forKey:@"shopName"];
    [condition setValue:_searchCode forKey:@"searchCode"];
    [condition setValue:@"" forKey:@"categoryId"];
    [condition setValue:@"" forKey:@"applySex"];
    [condition setValue:@"" forKey:@"prototypeValId"];
    [condition setValue:@"" forKey:@"auxiliaryValId"];
    [condition setValue:@"" forKey:@"year"];
    [condition setValue:@"" forKey:@"seasonValId"];
    [condition setValue:@"" forKey:@"minHangTagPrice"];
    [condition setValue:@"" forKey:@"maxHangTagPrice"];
    [condition setValue:@"" forKey:@"createTime"];
    _condition = condition;
    __weak GoodsStyleListView* weakSelf = self;
    [_goodsService selectStyleList:condition completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        NSMutableArray *styleArray = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[json objectForKey:@"styleVoList"]]) {
            for (NSDictionary* dic in [json objectForKey:@"styleVoList"]) {
                [styleArray addObject:[ListStyleVo convertToListStyleVo:dic]];
            }
        }
        
        if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
            if (styleArray.count == 1) {
                ListStyleVo* vo = [styleArray objectAtIndex:0];
                GoodsStyleEditView* vc = [[GoodsStyleEditView alloc] init];
                vc.styleId = vo.styleId;
                vc.shopId = _shopId;
                vc.action = ACTION_CONSTANTS_EDIT;
                vc.viewTag = GOODS_STYLE_INFO_VIEW;
                vc.synShopId = _synShopId;
                vc.synShopName = _synShopName;
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [weakSelf.navigationController pushViewController:vc animated:NO];
            }else if (styleArray.count == 0){
                if (![[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD]) {
                    static UIAlertView *alertView;
                    if (alertView != nil) {
                        [alertView dismissWithClickedButtonIndex:0 animated:NO];
                        alertView = nil;
                    }
                    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的款式不存在，是否添加该款式?" delegate:self cancelButtonTitle:@"是"  otherButtonTitles:@"否", nil];
                    [alertView show];
                }
            }else{
                NSMutableArray *array = [json objectForKey:@"styleVoList"];
                if (_createTime == nil || [_createTime isEqualToString:@""]) {
                    self.datas = [[NSMutableArray alloc] init];
                }
                if ([ObjectUtil isNotNull:array]) {
                    for (NSDictionary* dic in array) {
                        [self.datas addObject:[ListStyleVo convertToListStyleVo:dic]];
                    }
                }
                
                if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
                    _createTime = [[json objectForKey:@"createTime"] stringValue];
                }
                
                
                [self.tableView reloadData];
                
                self.tableView.ls_show = YES;
            }
        } else if ([[json objectForKey:@"searchStatus"] integerValue] == 0) {
            if (![[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD]) {
                [weakSelf selectStyleBaseInfo:nil];
            }
        } else {
            if (![[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD]) {
                ListStyleVo* vo = [styleArray objectAtIndex:0];
                [weakSelf selectStyleBaseInfo:vo];
            }
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark 查询款式基础信息
- (void)selectStyleBaseInfo:(ListStyleVo *)listStyleVo
{
    if (listStyleVo == nil) {
        _addStyleVo = nil;
        if (_addStyleVo == nil) {
            _addStyleVo = [[StyleVo alloc] init];
        }
        //如果输入的是数字默认赋值到详情添加页
        if ([NSString isValidNumber:self.searchCode]) {
            _addStyleVo.styleCode = self.searchCode;
        }
        static UIAlertView *alertView;
        if (alertView != nil) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            alertView = nil;
        }
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的款式不存在，是否添加该款式?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
        [alertView show];
    } else {
        __weak GoodsStyleListView* weakSelf = self;
        [_goodsService selectStyleBaseInfo:listStyleVo.styleId completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            _addStyleVo = [StyleVo convertToStyleVo:[json objectForKey:@"styleVo"]];
            static UIAlertView *alertView;
            if (alertView != nil) {
                [alertView dismissWithClickedButtonIndex:0 animated:NO];
                alertView = nil;
            }
            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的款式不存在，是否添加该款式?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
            [alertView show];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        GoodsStyleEditView* vc = [[GoodsStyleEditView alloc] init];
        vc.styleId = nil;
        vc.shopId = _shopId;
        vc.action = ACTION_CONSTANTS_ADD;
        vc.viewTag = GOODS_STYLE_INFO_VIEW;
        vc.addStyleVo = _addStyleVo;
        vc.synShopId = _synShopId;
        vc.synShopName = _synShopName;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    _tempVo = (ListStyleVo*) obj;
    GoodsStyleEditView* vc = [[GoodsStyleEditView alloc] init];
    vc.styleId = _tempVo.styleId;
    vc.shopId = _shopId;
    vc.action = ACTION_CONSTANTS_EDIT;
    vc.viewTag = GOODS_STYLE_LIST_VIEW;
    vc.synShopId = self.synShopId;
    vc.synShopName = self.synShopName;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma table部分
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsStyleListCell *detailItem = (GoodsStyleListCell *)[self.tableView dequeueReusableCellWithIdentifier:GoodsStyleListCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsStyleListCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        ListStyleVo *item = [self.datas objectAtIndex:indexPath.row];
        [detailItem fillStyleVoInfo:item];
        NSString *styleName = nil;
        if (item.upDownStatus == 2) {//已下架的标志显示出来
            detailItem.imgUpDown.image =  [UIImage imageNamed:@"ico_alreadyOffShelf"];
            styleName = [NSString stringWithFormat:@"            %@", item.styleName];
            detailItem.imgUpDown.hidden = NO;
        } else {
            detailItem.imgUpDown.hidden = YES;
            styleName = [NSString stringWithFormat:@"%@", item.styleName];
        }
        detailItem.lblName.text = styleName;
        detailItem.lblStyleNo.text = [NSString stringWithFormat:@"款号：%@", item.styleCode];
        [detailItem.lblName setVerticalAlignment:VerticalAlignmentTop];
        //暂无图片
        UIImage* placeholder = [UIImage imageNamed:@"img_default.png"];
        if (item.filePath != nil && ![item.filePath isEqualToString:@""]) {
            [detailItem.img.layer setMasksToBounds:YES];
            [detailItem.img.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
            NSURL* url = [NSURL URLWithString:[NSString urlFilterRan:item.filePath]];
            [detailItem.img sd_setImageWithURL:url placeholderImage:placeholder
                                 options:SDWebImageRetryFailed|SDWebImageRefreshCached];
            
        }
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
}

#pragma mark UITableView无section列表
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"goodsStyle" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

-(void)initGrid
{
    self.tableView.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

@end
