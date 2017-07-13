//
//  StockQueryView.m
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "VirtualStockSort.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
//#import "VirtualStockBatchCell.h"
#import "ServiceFactory.h"
#import "StockInfoVo.h"
#import "VirtualStockManagementView.h"
#import "VirtualStockBatchView.h"
#import "JsonHelper.h"
#import "GoodsVo.h"
#import "NameItemVO.h"
#import "VirtualStockCell.h"
#import "LSFooterView.h"
#import "SearchBar.h"
#import "TDFComplexConditionFilter.h"
//#import "OptionPickerBox.h"
#import "ScanViewController.h"
#import "SymbolNumberInputBox.h"
#import "LSWechatGoodSortController.h"

@interface VirtualStockSort ()<INavigateEvent, ISearchBarEvent, LSFooterViewDelegate,UITableViewDataSource, UITableViewDelegate ,TDFConditionFilterDelegate ,SymbolNumberInputClient,LSScanViewDelegate>
{
    StockService *service;
    NSMutableArray *microCateArray;
}
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic, strong) TDFComplexConditionFilter *filterView;/**<筛选页>*/
@property (nonatomic, strong) NSArray *filterModels;/**<筛选页需要的数据>*/
@property (nonatomic, weak)  NSArray *tempFilterModels;/**<上个界面传过来的filter models>*/
@property (nonatomic, strong) SearchBar *searchBar;/**<搜索框>*/
@property (nonatomic, strong) LSFooterView *footerView;/**<底部工具栏(全选/全不选)>*/
@property (nonatomic, strong) NSString *keyword;/**<搜索关键字>*/
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSMutableArray *stockInfoVos;
@property (nonatomic, assign) int currentPage; //当前页
@end


@implementation VirtualStockSort

- (instancetype)initWith:(NSString *)shopId param:(NSDictionary *)params filterModels:(NSArray *)models {
    self = [super init];
    if (self) {
        service = [ServiceFactory shareInstance].stockService;
        self.currentPage = 1;
        self.shopId = shopId;
        self.param = [[NSMutableDictionary alloc] initWithDictionary:params];
        self.tempFilterModels = models;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    [self loadData];
}

- (NSArray *)filterModels {
    
    if (!_filterModels) {
        TDFTwiceCellModel *cateModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellOneLine optionName:@"微店分类" hideStatus:NO];
        cateModel.restName = @"全部";
        cateModel.arrowImageName = @"ico_next";
        
        TDFInterValCellModel *interValModel = [[TDFInterValCellModel alloc] initWithOptionName:@"可销售数量区间" hideStatus:NO];
        interValModel.lowPlaceholder =  @"最低数";
        interValModel.highPlaceholder = @"最高数";
        
        // 把上个界面的筛选值作为当前页的初始选中值
        if (_tempFilterModels) {
            
            TDFTwiceCellModel *model1 = [_tempFilterModels firstObject];
            cateModel.currentName = model1.currentName;
            cateModel.currentValue = model1.currentValue;
            
            TDFInterValCellModel *model2 = [_tempFilterModels lastObject];
            interValModel.lowRange = model2.lowRange;
            interValModel.highRange = model2.highRange;
        }
        
        _filterModels = @[cateModel,interValModel];
    }
    return _filterModels;
}

- (void)configSubViews {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择微店商品" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text = @"操作";
    [self.view addSubview:self.titleBox];
    
    self.searchBar = [SearchBar searchBar];
    self.searchBar.ls_top = self.titleBox.ls_bottom;
    [self.searchBar initDeleagte:self placeholder:@"条形码/简码/拼音码"];
    [self.view addSubview:self.searchBar];
    
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.ls_bottom, SCREEN_W, SCREEN_H-self.searchBar.ls_bottom) style:UITableViewStylePlain];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:64.0];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.tableFooterView = [UIView new];
    self.mainGrid.estimatedRowHeight = 88.0;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.allowsMultipleSelection = YES;
    [self.view addSubview:self.mainGrid];
    __weak typeof(self) wself = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        wself.currentPage ++;
        [wself loadData];
    }];
    
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootSelectAll,kFootSelectNo]];
    [self.view addSubview:self.footerView];
    
    self.filterView = [[TDFComplexConditionFilter alloc] initFilter:@"筛选条件" image:@"ico_filter_normal" highlightImage:@"ico_filter_highlighted"];
    self.filterView.delegate = self;
    [self.filterView addToView:self.view withDatas:self.filterModels];
}

#pragma mark - 相关代理方法 -
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[VirtualStockManagementView class]]) {
                VirtualStockManagementView *list= (VirtualStockManagementView *)vc;
                [list loadVirtualListAndVirtualCount];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        int count = 0;
        for (StockInfoVo *stockInfoVo in self.stockInfoVos) {
            if (stockInfoVo.isSelected) {
                count ++;
            }
        }
        if (count == 0) {
            [LSAlertHelper showAlert:@"请先选择商品！"];
            return;
        }
        [LSAlertHelper showSheet:@"请选择批量操作" cancle:@"取消" cancleBlock:^{
            
        } selectItems:@[@"设置可销售数量"] selectdblock:^(NSInteger index) {
            
//            NSInteger minStore = 0; // 最小可销售数量
            NSMutableArray *goodsVos = [[NSMutableArray alloc] init];
            for (StockInfoVo *stockInfoVo in self.stockInfoVos) {
                if (stockInfoVo.isSelected) {
//                    if ([_stockInfoVos indexOfObject:stockInfoVo] == 0) {
//                        minStore = stockInfoVo.nowStore.integerValue;
//                    } else if (minStore > stockInfoVo.nowStore.integerValue) {
//                        minStore = stockInfoVo.nowStore.integerValue;
//                    }
                    GoodsVo *goodsVo = [[GoodsVo alloc] init];
                    goodsVo.goodsId = stockInfoVo.goodsId;
                    [goodsVos addObject:goodsVo];
                    
                }
            }
            
            VirtualStockBatchView *vc = [[VirtualStockBatchView alloc] initWithNibName:[SystemUtil getXibName:@"VirtualStockBatchView"] bundle:nil shopId:self.shopId goodsVos:goodsVos action:ACTION_CONSTANTS_ADD];
//            vc.maxStore = @(minStore);
            [self.navigationController pushViewController:vc animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }];
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
        
       __block TDFTwiceCellModel *cateModel = (TDFTwiceCellModel *)model;
        LSWechatGoodSortController *sortVc = [[LSWechatGoodSortController alloc] initWith:cateModel.currentName sortNameType:LSWechatGoodSortMicroname block:^(CategoryVo *vo) {
            cateModel.currentName = vo.microname;
            cateModel.currentValue = vo.categoryId;
        }];
        [self pushController:sortVc from:kCATransitionFromRight];
    }
}

- (void)tdf_filterCompleted {
    self.searchBar.keyWordTxt.text = @"";
    self.currentPage = 1;
    [self loadData];
}

// SymbolNumberInputClient
- (void)numberClientInput:(NSString*)val event:(NSInteger)eventType {
    if (eventType == 11) {
        TDFInterValCellModel *model = self.filterModels.lastObject;
        if (model.currentAction == TDF_Action_EditLowRange) {
            model.lowRange = val;
        } else if (model.currentAction == TDF_Action_EditHighRange) {
            model.highRange = val;
        }
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

// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord {
    self.currentPage = 1;
    self.keyword = keyWord;
    [self loadData];
}

- (void)scanStart {
    [self showScanView];
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

    self.searchBar.keyWordTxt.text= scanString;
    self.keyword = scanString;
    self.currentPage = 1;
    [self loadData];
}


- (NSMutableArray *)stockInfoVos {
    if (_stockInfoVos == nil) {
        _stockInfoVos = [[NSMutableArray alloc] init];
    }
    return _stockInfoVos;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stockInfoVos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    VirtualStockCell *cell = [VirtualStockCell virtualStockCellWithTableView:tableView optional:YES];
    StockInfoVo *stockInfoVo = self.stockInfoVos[indexPath.row];
    [cell initWithStockInfoVo:stockInfoVo shopMode:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StockInfoVo *stockInfoVo = self.stockInfoVos[indexPath.row];
    stockInfoVo.isSelected = !stockInfoVo.isSelected;
    [self.mainGrid reloadData];
    
}

// LSFooterViewDelegate
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectNo]) {
        for (StockInfoVo *stockInfoVo in self.stockInfoVos) {
            stockInfoVo.isSelected = NO;
        }
    } else if ([footerType isEqualToString:kFootSelectAll]) {
        for (StockInfoVo *stockInfoVo in self.stockInfoVos) {
            stockInfoVo.isSelected = YES;
        }
    }
    [self.mainGrid reloadData];
}


#pragma mark - 网络请求 - 

- (void)loadData {
    
    [self.param setValue:[NSNumber numberWithInt:self.currentPage] forKey:@"currentPage"];
    if ([NSString isNotBlank:_keyword]) {
        [self.param setValue:_keyword forKey:@"keywords"];
    }
    
    // 分类Id
    TDFTwiceCellModel *cateModel = [self.filterModels objectAtIndex:0];
    [self.param setValue:cateModel.currentValue forKey:@"categoryId"];
    
    // 可兑换数量区间
    TDFInterValCellModel *interValModel = self.filterModels.lastObject;
    if ([NSString isNotBlank:interValModel.lowRange]) {
        [self.param setValue:interValModel.lowRange forKey:@"minVirtualStore"];
    } else {
        [self.param setValue:[NSNull null] forKey:@"minVirtualStore"];
    }
    
    if ([NSString isNotBlank:interValModel.highRange]) {
        [self.param setValue:interValModel.highRange forKey:@"maxVirtualStore"];
    } else {
        [self.param setValue:[NSNull null] forKey:@"maxVirtualStore"];
    }
    
    
    
    [service virtualStoreList:self.param CompletionHandler:^(id json) {
        [self.mainGrid footerEndRefreshing];
        [self.mainGrid headerEndRefreshing];
        if (self.currentPage == 1) {
            [self.stockInfoVos removeAllObjects];
        }
        
        for (NSDictionary *obj in json[@"virtualStoreList"]) {
            StockInfoVo *stockInfoVo = [[StockInfoVo alloc] initWithDictionary:obj];
            [self.stockInfoVos addObject:stockInfoVo];
        }
        [self.mainGrid reloadData];
        self.mainGrid.ls_show = YES;
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
//        [OptionPickerBox initData:categoryList itemId:@""];
//        [OptionPickerBox show:@"分类" client:self event:13];
//    } errorHandler:^(id json) {
//        [LSAlertHelper showAlert:json];
//    }];
//}

@end
