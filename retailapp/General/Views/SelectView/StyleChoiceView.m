//
//  StyleChoiceView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StyleChoiceView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SearchBar2.h"
#import "ListStyleVo.h"
#import "NavigateTitle2.h"
#import "GoodsStyleListCell.h"
#import "MyUILabel.h"
#import "ViewFactory.h"
#import "StyleBatchChoiceView.h"
#import "styleTopSelectView.h"
#import "XHAnimalUtil.h"
#import "DateUtils.h"

@interface StyleChoiceView ()

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic, strong) NSMutableDictionary* condition;

@property (nonatomic, strong) NSString* createTime;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic, strong) NSString* type;

/**
 1表示为从搜索框搜索，当查询出来为一条信息时，跳转到下一个页面
 */
@property (nonatomic) short isJump;

@end

@implementation StyleChoiceView

- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self initHead];
    [self configViews];
    self.searchBar.keyWordTxt.text=self.searchCode;
    __weak StyleChoiceView* weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        _createTime = @"";
        [weakSelf selectStyleList];
    }];
    [weakSelf.mainGrid ls_addFooterWithCallback:^{
        [weakSelf selectStyleList];
    }];
    //
    //    [weakSelf loaddatas];
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
    [self.footView initDelegate:self btnsArray:@[kFootBatch]];
    [self.view addSubview:self.footView];
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
    
}
- (void)loaddatas
{
    [self.mainGrid headerBeginRefreshing];
}

- (void)loaddatas:(NSString *)shopId type:(NSString *)type callBack:(StyleChoiceViewSelectBack)callBack
{
    _selectBlock = callBack;
    _type = type;
    _shopId = shopId;
    _condition = [[NSMutableDictionary alloc] init];
    [_condition setValue:@"1" forKey:@"searchType"];
    [_condition setValue:_shopId forKey:@"shopId"];
    [_condition setValue:self.searchCode forKey:@"searchCode"];
    [_condition setValue:@"" forKey:@"categoryId"];
    [_condition setValue:@"" forKey:@"applySex"];
    [_condition setValue:@"" forKey:@"prototypeValId"];
    [_condition setValue:@"" forKey:@"auxiliaryValId"];
    [_condition setValue:@"" forKey:@"year"];
    [_condition setValue:@"" forKey:@"seasonValId"];
    [_condition setValue:@"" forKey:@"minHangTagPrice"];
    [_condition setValue:@"" forKey:@"maxHangTagPrice"];
    [_condition setValue:@"" forKey:@"createTime"];
}

- (void)loadDatasFromSelect:(NSMutableDictionary *)condition
{
    self.searchBar.keyWordTxt.text = @"";
    _createTime = @"";
    self.conditionOfBatchView = condition;
    _condition = condition;
    [self selectStyleList];
}

- (void)selectStyleList
{
    __weak StyleChoiceView* weakSelf = self;
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
        
        if (self.datas.count == 1 && _isJump == 1) {
            _selectBlock(self.datas);
        }
        _isJump = 0;
        [self.mainGrid reloadData];
    } else if ([[json objectForKey:@"searchStatus"] integerValue] == 0) {
        [self.datas removeAllObjects];
        _createTime = @"";
        [self.mainGrid reloadData];
    }
    
    self.mainGrid.ls_show = YES;
}

#pragma navigateTitle.
- (void)initHead
{
    [self configTitle:@"选择款式" leftPath:Head_ICON_BACK rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"筛选" filePath:Head_ICON_CHOOSE];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootBatch]) {
        [self showBatchEvent];
    }
}

- (void)showBatchEvent
{
    StyleBatchChoiceView* vc = [[StyleBatchChoiceView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];    
    vc.conditionOfBatchView = self.conditionOfBatchView;
    [_condition setValue:self.createTime forKey:@"createTime"];
    __weak StyleChoiceView* weakSelf = self;
    [vc loaddatas:_shopId type:_type condition:_condition styleList:self.datas callBack:^(NSMutableArray *styleList) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        if (styleList) {
            _selectBlock(styleList);
        }
    }];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        if ( _selectBlock1) {
            _selectBlock1(nil);
        }
        if (_selectBlock) {
            _selectBlock(nil);
        }
        
        
        
    }else{
        [self loadStyleChoiceTopView];
        self.styleTopSelectView.delegate = self;
        self.styleTopSelectView.shopId = _shopId;
        self.styleTopSelectView.fromViewTag = STYLE_CHOICE_VIEW;
        NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
        [condition setValue:@"" forKey:@"categoryId"];
        [condition setValue:@"" forKey:@"applySex"];
        [condition setValue:@"" forKey:@"prototypeValId"];
        [condition setValue:@"" forKey:@"auxiliaryValId"];
        [condition setValue:@"" forKey:@"year"];
        [condition setValue:@"" forKey:@"seasonValId"];
        [condition setValue:@"" forKey:@"minHangTagPrice"];
        [condition setValue:@"" forKey:@"maxHangTagPrice"];
        self.styleTopSelectView.conditionOfInit = condition;
        [self.styleTopSelectView loaddatas];
        [self.styleTopSelectView oper];
    }
}

- (void)showStyleListView:(NSMutableDictionary *)condition
{
    self.searchBar.keyWordTxt.text = @"";
    _createTime = @"";
    self.conditionOfBatchView = condition;
    _condition = condition;
    [self selectStyleList];
}

- (void)imputFinish:(NSString *)keyWord
{
    [_condition setValue:@"1" forKey:@"searchType"];
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


//
- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    ListStyleVo* editObj = (ListStyleVo*) obj;
    NSMutableArray* list = [[NSMutableArray alloc] init];
    [list addObject:editObj];
    _selectBlock(list);
}

#pragma table部分
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GoodsStyleListCell *detailItem = (GoodsStyleListCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsStyleListCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsStyleListCell" owner:self options:nil].lastObject;
    }
    
        ListStyleVo *item = [self.datas objectAtIndex:indexPath.row];
        [detailItem fillStyleVoInfo:item];
        NSString *styleName = nil;
        if (item.upDownStatus == 2) {//已下架的标志显示出来
            detailItem.imgUpDown.image =  [UIImage imageNamed:@"ico_alreadyOffShelf"];
            styleName = [NSString stringWithFormat:@"            %@", item.styleName];
            detailItem.imgUpDown.hidden = NO;
        } else {
            detailItem.imgUpDown.hidden = YES;
            styleName = [item.styleName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
        return detailItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"goods" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

/*加载商品款式筛选页面*/
- (void)loadStyleChoiceTopView
{
//    if (self.styleChoiceTopView) {
//        self.styleChoiceTopView.view.hidden = NO;
//    }else{
//        self.styleChoiceTopView = [[StyleChoiceTopView alloc] initWithNibName:[SystemUtil getXibName:@"StyleChoiceTopView"] bundle:nil];
//        [self.view addSubview:self.styleChoiceTopView.view];
//    }
    if (self.styleTopSelectView) {
        self.styleTopSelectView.view.hidden = NO;
        
    }else{
        self.styleTopSelectView = [[StyleTopSelectView alloc] initWithNibName:[SystemUtil getXibName:@"StyleTopSelectView"] bundle:nil];
        [self.view addSubview:self.styleTopSelectView.view];
    }

}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mainGrid headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
