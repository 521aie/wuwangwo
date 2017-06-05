//
//  StyleBatchChoiceView2.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StyleBatchChoiceView2.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SearchBar2.h"
#import "ListStyleVo.h"
#import "NavigateTitle2.h"
#import "ViewFactory.h"
#import "StyleChoiceView.h"
#import "GoodsStyleBatchSelectCell.h"
#import "StyleChoiceTopView2.h"

@interface StyleBatchChoiceView2 ()

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic, strong) NSMutableDictionary* condition;

@property (nonatomic, retain) NSString *searchCode;

@property (nonatomic, strong) NSString* createTime;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic, strong) NSString* type;

@property (nonatomic, strong) NSMutableArray* styleList;

/**
 1表示为从搜索框搜索，当查询出来为一条信息时，跳转到下一个页面
 */
@property (nonatomic) short isJump;

@end

@implementation StyleBatchChoiceView2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    return self;
}

- (void)loaddatas
{
    [self.mainGrid headerBeginRefreshing];
}

- (void)loaddatas:(NSString *)shopId type:(NSString *)type callBack:(SelectBatchBack)callBack
{
    _selectBatchBack = callBack;
    _type = type;
    self.searchBar.keyWordTxt.text = @"";
    _shopId = shopId;
    _styleList = [[NSMutableArray alloc] init];
    _condition = [[NSMutableDictionary alloc] init];
    [_condition setValue:@"1" forKey:@"searchType"];
    [_condition setValue:_shopId forKey:@"shopId"];
    [_condition setValue:@"" forKey:@"searchCode"];
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
    _condition = condition;
    [self selectStyleList];
}

- (void)selectStyleList
{
    __weak StyleBatchChoiceView2* weakSelf = self;
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
            [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
            self.titleBox.lblRight.text = @"筛选";
            [_styleList removeAllObjects];
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
        [self.mainGrid reloadData];
    }
    
    self.mainGrid.ls_show = YES;
}

- (void)clearCheckStatus
{
    for (ListStyleVo* tempVo in self.datas) {
        tempVo.isCheck = @"0";
    }
    [_styleList removeAllObjects];
    [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    self.titleBox.lblRight.text = @"筛选";
    [self.mainGrid reloadData];
}

#pragma mark - navigateTitle.
- (void)initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    self.titleBox.lblRight.text = @"筛选";
    self.titleBox.lblRight.hidden = NO;
    [self.titleDiv addSubview:self.titleBox];
}

- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event == DIRECT_LEFT) {
        _selectBatchBack(nil);
    }else{
        if (_styleList.count > 0) {
            _selectBatchBack(_styleList);
        }else {
            // 筛选
            [self showView:STYLE_CHOICE_TOP_VIEW2];
            [self.styleChoiceTopView2 loadDatas:_shopId fromViewTag:STYLE_BATCH_CHOICE_VIEW2];
        }
    }
}

- (void)imputFinish:(NSString *)keyWord
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

- (void)checkAllEvent
{
    [_styleList removeAllObjects];
    if (self.datas.count > 0) {
        for (ListStyleVo *vo in self.datas) {
            vo.isCheck =@"1";
            [_styleList addObject:vo];
        }
    }
    if (_styleList.count > 0) {
        [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        if ([_type isEqualToString:@"1"]) {
            self.titleBox.lblRight.text = @"确认";
        }else{
            self.titleBox.lblRight.text = @"保存";
        }
    }
    
    [self.mainGrid reloadData];
}

- (void)notCheckAllEvent
{
    if (self.datas.count > 0) {
        for (ListStyleVo *vo in self.datas) {
            vo.isCheck =@"0";
        }
    }
    
    [_styleList removeAllObjects];
    
    self.titleBox.lblRight.text = @"筛选";
    [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    
    [self.mainGrid reloadData];
}



- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
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
        
        self.titleBox.lblRight.text = @"筛选";
        [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    }else{
        [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        if ([_type isEqualToString:@"1"]) {
            self.titleBox.lblRight.text = @"确认";
        }else{
            self.titleBox.lblRight.text = @"保存";
        }
    }
    
    [self.mainGrid reloadData];
}

#pragma table部分
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsStyleBatchSelectCell *detailItem = (GoodsStyleBatchSelectCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsStyleBatchSelectCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsStyleBatchSelectCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        ListStyleVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.styleName;
        detailItem.lblStyleNo.text = item.styleCode;
        if ([item.isCheck isEqualToString:@"1"]) {
            detailItem.imgUnCheck.hidden = YES;
            detailItem.imgCheck.hidden = NO;
        }else{
            detailItem.imgUnCheck.hidden = NO;
            detailItem.imgCheck.hidden = YES;
        }
        
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"goods" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

- (void)initGrid
{
    self.mainGrid.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)showView:(int)viewTag;
{
    if (viewTag == STYLE_CHOICE_TOP_VIEW2){
        [self.view bringSubviewToFront:self.styleChoiceTopView2.view];
        [self loadStyleChoiceTopView2];
        [self.styleChoiceTopView2 oper];
        return;
    }
    
    [self hideAllView];
    
    if (viewTag == STYLE_BATCH_CHOICE_VIEW2){
        [self showAllView];
        self.styleChoiceTopView2.view.hidden = YES;
    }
}

#pragma mark - 隐藏module下所有初始化的view
// 隐藏视图
- (void)hideAllView
{
    // 遍历所有子视图
    for (UIView *view in [self.view subviews]) {
        
        // 隐藏所有子视图
        [view setHidden:YES];
    }
}

#pragma mark - 隐藏module下所有初始化的view
// 显示视图
- (void)showAllView
{
    // 遍历所有子视图
    for (UIView *view in [self.view subviews]) {
        
        // 显示所有子视图
        [view setHidden:NO];
    }
}

- (void)loadStyleChoiceTopView2
{
    if (self.styleChoiceTopView2) {
        self.styleChoiceTopView2.view.hidden = NO;
    }else{
        self.styleChoiceTopView2 = [[StyleChoiceTopView2 alloc] initWithNibName:[SystemUtil getXibName:@"StyleChoiceTopView2"] bundle:nil parent:self];
        [self.view addSubview:self.styleChoiceTopView2.view];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self initGrid];
    [self.searchBar initDelagate:self placeholder:@"名称/款号"];
    [self.view addSubview:self.searchBar.view];
    self.searchBar.view.frame = CGRectMake(0, 64, 320, 44);
    [self.footView initDelegate:self];
    
    __weak StyleBatchChoiceView2* weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        _createTime = @"";
        [weakSelf selectStyleList];
    }];
    [weakSelf.mainGrid ls_addFooterWithCallback:^{
        [weakSelf selectStyleList];
    }];
    
    [weakSelf loaddatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
