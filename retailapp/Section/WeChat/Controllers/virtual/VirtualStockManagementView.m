//
//  StockQueryView.m
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "VirtualStockManagementView.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
//#import "GoodsFooterListView.h"
#import "UIView+Sizes.h"
//#import "EditItemList.h"
//#import "Platform.h"
#import "UIHelper.h"
//#import "SelectMicShopList.h"
#import "SearchBar.h"
#import "ScanViewController.h"
#import "ServiceFactory.h"
#import "LSAlertHelper.h"
#import "VirtualStockCell.h"
#import "DHHeadItem.h"
#import "VirtualStockManagementDetail.h"
#import "LSWechatGoodSortController.h"
#import "VirtualStockSort.h"
#import "SearchBar2.h"
#import "VirtualStockClothesDetail.h"
//#import "Platform.h"
//#import "MJRefresh.h"
#import "StockInfoVo.h"
#import "NSString+Estimate.h"
//#import "UIView+Sizes.h"
#import "GoodsChoiceView.h"
//#import "NSString+Estimate.h"
#import "GoodsVo.h"
#import "VirtualStockBatchView.h"
#import "ViewFactory.h"
#import "GoodsBatchChoiceView1.h"
//#import "FooterListEvent.h"
//#import "SelectView.h"
#import "IEditItemListEvent.h"
#import "ISearchBarEvent.h"
#import "ColorHelper.h"
#import "JsonHelper.h"
#import "TreeNode.h"
#import "TDFComplexConditionFilter.h"
#import "LSWeChatFilterModelFactory.h"
#import "LSFooterView.h"
#import "SymbolNumberInputBox.h"
//#import "OptionPickerBox.h"
#import "NameItemVO.h"
#import "CategoryVo.h"


@interface VirtualStockManagementView ()<INavigateEvent, ISearchBarEvent, LSFooterViewDelegate, UITableViewDataSource, UITableViewDelegate, LSScanViewDelegate, TDFConditionFilterDelegate, SymbolNumberInputClient> {
    /**网络请求*/
    StockService *service;
    NSArray *microCateArray;
}

@property (nonatomic ,assign) NSInteger isClothMode;/**<服鞋>*/
@property (nonatomic ,strong) NavigateTitle2 *titleBox;
/**服鞋扫一扫*/
@property (nonatomic, strong) SearchBar2 *searchBar2;
@property (nonatomic, weak) DHHeadItem *headItem;/**<section Header>*/
/**商超扫一扫*/
@property (nonatomic, strong) SearchBar *searchBar;
@property (nonatomic ,strong) LSFooterView *footerView;/**<footerView>*/
@property (nonatomic ,strong) TDFComplexConditionFilter *filterView;/**<右侧筛选界面>*/
@property (nonatomic ,strong) NSArray *filterModels;/**<筛选界面需要的数据>*/
/**数据源*/
@property (nonatomic, strong) NSMutableArray *stockInfoVos;

/**款式*/
@property (nonatomic, copy) NSString *styleId;
/**扫一扫返回的code*/
@property (nonatomic, copy) NSString *code;
/**搜索框的内容*/
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) int sumVirtualStore;
/**当前页*/
@property (nonatomic, assign) int currentPage;
/**网络请求参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/**详情页参数*/
@property (nonatomic, strong) NSMutableDictionary *paramDetail;
@end


@implementation VirtualStockManagementView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    service = [ServiceFactory shareInstance].stockService;
    _stockInfoVos = [[NSMutableArray alloc] init];
    self.isClothMode = [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101;
    [self configSubviews];
    if (!([[Platform Instance] getShopMode] == 3 && ![[Platform Instance] isTopOrg])) {
        [self loadVirtualListAndVirtualCount];
    }
    [self configHelpButton:HELP_WECHAT_SALE_COUNT];
    if (self.isClothMode) {
        [self loadSeasonList];
    }
}


- (void)configSubviews {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"微店可销售数量" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
    // 服鞋
    if (self.isClothMode) {
        self.searchBar2 = [SearchBar2 searchBar2];
        self.searchBar2.ls_top = self.titleBox.ls_bottom;
        [self.searchBar2 initDelagate:self placeholder:@"名称/款号"];
        [self.view addSubview:self.searchBar2];
    } else {
        self.searchBar = [SearchBar searchBar];
        self.searchBar.ls_top = self.titleBox.ls_bottom;
        [self.searchBar initDeleagte:self placeholder:@"条形码/简码/拼音码"];
        [self.view addSubview:self.searchBar];
    }
    
    // UITableView
    CGFloat topY = self.searchBar?self.searchBar.ls_bottom:self.searchBar2.ls_bottom;
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, topY, SCREEN_W, SCREEN_H-topY) style:UITableViewStylePlain];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:64];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.tableFooterView = [UIView new];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.mainGrid registerNib:[UINib nibWithNibName:@"VirtualStockCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.mainGrid];
    self.mainGrid.estimatedRowHeight = 88.0;
    __weak VirtualStockManagementView *weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage ++;
        [weakSelf loadData];
    }];
    
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) {
        self.footerView = [LSFooterView footerView];
        [self.footerView initDelegate:self btnsArray:@[kFootScan,kFootBatch]];
        [self.view addSubview:self.footerView];
    }
    
    self.filterView = [[TDFComplexConditionFilter alloc] initFilter:@"筛选条件" image:@"ico_filter_normal" highlightImage:@"ico_filter_highlighted"];
    self.filterView.delegate = self;
    self.filterModels = [LSWeChatFilterModelFactory wechatVirtualStockSetListViewFilterModels];
    [self.filterView addToView:self.view withDatas:self.filterModels];
}


#pragma mark - 相关代理方法
//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord {
    self.currentPage = 1;
    self.keyword = keyWord;
    [self loadVirtualListAndVirtualCount];
}

- (void)scanStart {
    [self showScanView];
}


// LSFooterViewDelegate
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    
    if ([footerType isEqualToString:kFootScan]) {
        [self showScanView];
    } else if ([footerType isEqualToString:kFootBatch]) {
//        if (self.stockInfoVos.count < 1) {
//            [LSAlertHelper showAlert:@"请至少添加一条内容，才能进行批量。"];
//            return;
//        }
        NSString *shopId = [[Platform Instance] getkey:SHOP_ID];
        VirtualStockSort *vc = [[VirtualStockSort alloc] initWith:shopId param:self.param filterModels:self.filterModels];
        [self pushController:vc from:kCATransitionFromTop];
    }
}

// TDFConditionFilterDelegate
- (void)tdf_filter:(TDFComplexConditionFilter *)filter actionWithCellModel:(TDFFilterMoel *)model {
    
    if (model.type == TDF_IntervalFilterCell) {
        
        TDFInterValCellModel *interValModel = (TDFInterValCellModel *)model;
        NSString *title = [interValModel noticeTitle];
        NSString *rawNumString = [interValModel currentNumberString];
        [SymbolNumberInputBox initData:rawNumString];
        [SymbolNumberInputBox show:title client:self isFloat:NO isSymbol:NO event:11];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
   
    } else if (model.type == TDF_TwiceFilterCellOneLine) {
       
        TDFTwiceCellModel *cellModel = (TDFTwiceCellModel *)model;
        if ([_filterModels indexOfObject:model] == 0) {
            
            __block TDFTwiceCellModel *model = cellModel;
            LSWechatGoodSortController *sortVc = [[LSWechatGoodSortController alloc] initWith:model.currentName sortNameType:LSWechatGoodSortMicroname block:^(CategoryVo *vo) {
                model.currentName = vo.microname;
                model.currentValue = vo.categoryId;
            }];
            [self pushController:sortVc from:kCATransitionFromRight];
            
        } else {
            if([cellModel.currentName isEqualToString:cellModel.restName]){
                [SymbolNumberInputBox initData:@""];
            } else {
                [SymbolNumberInputBox initData:cellModel.currentName];
            }
            [SymbolNumberInputBox show:@"当前年度" client:self isFloat:NO isSymbol:NO event:13];
            [SymbolNumberInputBox limitInputNumber:4 digitLimit:0];
        }
    }
}

- (void)tdf_filterCompleted {
    self.searchBar.keyWordTxt.text = @"";
    self.searchBar2.keyWordTxt.text = @"";
    self.currentPage = 1;
    [self loadVirtualListAndVirtualCount];
}

// 判断区间的合法性
//- (BOOL)tdf_filterShouldHide {
//    
//    TDFInterValCellModel *model = self.filterModels.lastObject;
//    // 微店可销售数量区间校验
//    if ([NSString isNotBlank:model.lowRange] && [NSString isNotBlank:model.highRange]) {
//        if (model.highRange.integerValue < model.lowRange.integerValue) {
//            [LSAlertHelper showAlert:@"可兑换数量上限小于下限!"];
//            return NO;
//        }
//    }
//    
//    return YES;
//}

// SymbolNumberInputClient
- (void)numberClientInput:(NSString*)val event:(NSInteger)eventType {
    if (eventType == 11) {
        TDFInterValCellModel *model = self.filterModels.lastObject;
        if (model.currentAction == TDF_Action_EditLowRange) {
            model.lowRange = val;
        } else if (model.currentAction == TDF_Action_EditHighRange) {
            model.highRange = val;
        }
    } else if (eventType == 13) {
        TDFTwiceCellModel *year = [self.filterModels objectAtIndex:2];
        year.currentName = val;
        year.currentValue = [val convertToNumber];
    }
}

// OptionPickerClient
//- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
//    id<INameItem> item = (id<INameItem>)selectObj;
//    TDFTwiceCellModel *cateModel = self.filterModels.firstObject;
//    cateModel.currentName = [item obtainItemName];
//    cateModel.currentValue = [item obtainItemId];
//    return YES;
//}

//获得数据的参数
- (NSMutableDictionary *)param {
    
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param removeAllObjects];
     [_param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    [_param setValue:[NSNumber numberWithInt:self.currentPage] forKey:@"currentPage"];
    
    if ([NSString isNotBlank:self.code]) {
        [_param setValue:self.code forKey:@"scanCode"];
    }
    if (self.isClothMode) {
        
        if ([NSString isNotBlank:self.searchBar2.keyWordTxt.text]) {
            [_param setValue:self.searchBar2.keyWordTxt.text forKey:@"keywords"];
        }
        
        // 性别：1.男 2.女 3.中性
        TDFRegularCellModel *sex = self.filterModels[1];
        if ([sex.currentValue integerValue] != 0) {
            [_param setValue:sex.currentValue forKey:@"applySex"];
        }
        
        // 年份
        TDFTwiceCellModel *yearModel = [self.filterModels objectAtIndex:2];
        if (![yearModel.currentName isEqualToString:yearModel.restName]) {
            id year = [ObjectUtil isNotNull:yearModel.currentValue]?yearModel.currentValue:[NSNull null];
            [_param setValue:year forKey:@"year"];
        }
        
        // 季节
        TDFRegularCellModel *season = [self.filterModels objectAtIndex:3];
        if (season.currentValue != nil) {
            [_param setValue:season.currentValue forKey:@"seasonId"];
        }
    
    } else {//商超
        if ([NSString isNotBlank:self.searchBar.keyWordTxt.text]) {
            [_param setValue:self.searchBar.keyWordTxt.text forKey:@"keywords"];
        }
    }
    
    TDFTwiceCellModel *twiceModel = self.filterModels.firstObject;
    if (twiceModel.currentName) {
        [_param setValue:twiceModel.currentValue forKey:@"categoryId"];
    }
    
    // 可销售数量区间
    TDFInterValCellModel *interValModel = self.filterModels.lastObject;
    if ([NSString isBlank:interValModel.lowRange]) {
        [_param setValue:[NSNull null] forKey:@"minVirtualStore"];
    } else {
        [_param setValue:[NSNumber numberWithDouble:[interValModel.lowRange doubleValue]] forKey:@"minVirtualStore"];
    }
    if ([NSString isBlank:interValModel.highRange]) {
        [_param setValue:[NSNull null] forKey:@"maxVirtualStore"];
    } else {
         [_param setValue:[NSNumber numberWithDouble:[interValModel.highRange doubleValue]] forKey:@"maxVirtualStore"];
    }
    return _param;
}

// 详情页的网络请求参数
- (NSMutableDictionary *)paramDetail {
    if (_paramDetail == nil) {
        _paramDetail = [[NSMutableDictionary alloc] init];
    }
    [_paramDetail removeAllObjects];
    if (self.isClothMode) {
        if ([[Platform Instance] getShopMode] == 3) {
        }
        else if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102 ){
            [_paramDetail setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
        }
    }
    return _paramDetail;
}

#pragma mark - 显示扫一扫
- (void)showScanView {
    
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [LSAlertHelper showAlert:message];
}

- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
        self.searchBar2.keyWordTxt.text = scanString;
    } else {//商超
        self.searchBar.keyWordTxt.text= scanString;
    }
    self.code = scanString;
    self.currentPage = 1;
    [self loadVirtualListAndVirtualCount];
    self.code = nil;
}


//#pragma mark - 点击批量按钮
//- (void)showBatchEvent {
//    if (self.stockInfoVos.count < 1) {
//        [LSAlertHelper showAlert:@"请至少添加一条内容，才能进行批量。"];
//        return;
//    }
//    VirtualStockSort *vc = [[VirtualStockSort alloc] initWith:@"" param:self.param];
//    [self.navigationController pushViewController:vc animated:NO];
//    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
//}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stockInfoVos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VirtualStockCell *cell = [VirtualStockCell virtualStockCellWithTableView:tableView optional:NO];
    StockInfoVo *stockInfoVo = self.stockInfoVos[indexPath.row];
    [cell initWithStockInfoVo:stockInfoVo shopMode:1];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!_headItem) {
        _headItem = [[[NSBundle mainBundle]loadNibNamed:@"DHHeadItem" owner:self options:nil] lastObject];
    }
    [_headItem initWithTitle:[NSString stringWithFormat:@"可销售%d件",self.sumVirtualStore]];
    return _headItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.stockInfoVos.count == 0 ? 0 : 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *shopId = [[Platform Instance] getkey:SHOP_ID];
    if (self.isClothMode) { //服鞋
        StockInfoVo *stockInfoVo = self.stockInfoVos[indexPath.row];
        self.styleId = stockInfoVo.styleId;
        VirtualStockClothesDetail *vc = [[VirtualStockClothesDetail alloc] initWithNibName:[SystemUtil getXibName:@"VirtualStockClothesDetail"] bundle:nil param:self.paramDetail stockInfoVo:stockInfoVo shopId:shopId action:ACTION_CONSTANTS_EDIT edit:YES];
        [self.navigationController pushViewController:vc animated:NO];
    } else { //商超
        StockInfoVo *stockInfoVo = self.stockInfoVos[indexPath.row];
        VirtualStockManagementDetail *vc = [[VirtualStockManagementDetail alloc] initWithShopId:shopId goodsId:stockInfoVo.goodsId action:ACTION_CONSTANTS_EDIT edit:YES];
        vc.iconPath = stockInfoVo.fileName;
        [self.navigationController pushViewController:vc animated:NO];
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma mark - 网络请求

// 同时获取可销售数量和可销售商品列表
- (void)loadVirtualListAndVirtualCount {
    [self loadVirtualStoreCount];
    [self loadData];
}

/**是否点击了完成按钮*/
- (void)loadData {
    
    __typeof(self)weakSelf = self;
    [service virtualStoreList:self.param CompletionHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        if (weakSelf.currentPage == 1) {
            [weakSelf.stockInfoVos removeAllObjects];
        }
        if ([ObjectUtil isNotNull:json[@"virtualStoreList"]]) {
            for (NSDictionary *obj in json[@"virtualStoreList"]) {
                StockInfoVo *stockInfoVo = [[StockInfoVo alloc] initWithDictionary:obj];
                [weakSelf.stockInfoVos addObject:stockInfoVo];
            }
        }
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
    } errorHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}

// 获取虚拟库存数
- (void)loadVirtualStoreCount {
    
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:@"stockInfo/virtualStoreCount" param:self.param withMessage:@"" show:YES CompletionHandler:^(id json) {
        
        id sumVirtualStore = [json objectForKey:@"sumVirtualStore"];
        if (sumVirtualStore != nil || sumVirtualStore != [NSNull null]) {
            wself.sumVirtualStore = [sumVirtualStore intValue];
        }
        [wself.headItem initWithTitle:[NSString stringWithFormat:@"可销售%d件",self.sumVirtualStore]];
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

// 微店分类信息: 商超->微店分类 服鞋->微店中品类
//- (void)loadWeChatCategoryInfo {
//    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setValue:@"1" forKey:@"hasNoCategory"];
//    [BaseService getRemoteLSDataWithUrl:@"category/lastCategoryInfo" param:param withMessage:nil show:NO CompletionHandler:^(id json) {
//        NSMutableArray* list = [JsonHelper transList:[json objectForKey:@"categoryList"] objName:@"CategoryVo"];
//        NSMutableArray *categoryList = [[NSMutableArray alloc] init];
//        NameItemVO *itemVo = [[NameItemVO alloc] initWithVal:@"全部" andId:@""];
//        [categoryList addObject:itemVo];
//        for (CategoryVo* vo in list) {
//            itemVo = [[NameItemVO alloc] initWithVal:vo.name andId:vo.categoryId];
//            [categoryList addObject:itemVo];
//        }
//        microCateArray = [categoryList copy];
//        NSString *title = self.isClothMode ? @"中品类" : @"分类";
//        [OptionPickerBox initData:categoryList itemId:@""];
//        [OptionPickerBox show:title client:self event:13];
//    } errorHandler:^(id json) {
//        [LSAlertHelper showAlert:json];
//    }];
//}

// 获取季节列表
- (void)loadSeasonList {
    
    __weak typeof(self) wself = self;
    NSString* url = @"attribute/baseVal/list";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:@"2" forKey:@"baseAttributeType"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        TDFFilterItem *item0 = [TDFFilterItem filterItem:@"全部" itemValue:[NSNull null]];
        [array addObject:item0];
        
        NSArray *list = [json objectForKey:@"attributeValList"];
        if ([ObjectUtil isNotEmpty:list]) {
            NSInteger count = list.count;
            count = count <= 100?list.count:100;
            for (NSInteger i= 0; i < count; i++) {
                NSDictionary *dic = [list objectAtIndex:i];
                [array addObject:[TDFFilterItem filterItem:dic[@"attributeVal"] itemValue:dic[@"attributeValId"]]];
            }
        }
        
        TDFRegularCellModel *season = [wself.filterModels objectAtIndex:3];
        season.optionItems = [array copy];
        season.updateOption = YES;
        season.currentHideStatus = NO;
        [wself.filterView renewListViewWithDatas:wself.filterModels];
       
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

@end
