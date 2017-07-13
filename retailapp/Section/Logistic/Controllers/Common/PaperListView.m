//
//  PaperListView.m
//  retailapp
//
//  Created by hm on 15/9/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PaperListView.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "PaperCell.h"
#import "PaperVo.h"
#import "GlobalRender.h"
#import "LRender.h"
#import "DateUtils.h"
#import "ColorHelper.h"
#import "GridColHead.h"
#import "OptionPickerBox.h"
#import "DatePickerBox.h"
#import "DateUtils.h"
#import "ServiceFactory.h"
#import "ViewFactory.h"
#import "AlertBox.h"
#import "LRender.h"
#import "DicItemConstants.h"
#import "SelectShopListView.h"
#import "SelectSupplierListView.h"
#import "SelectShopStoreListView.h"
#import "OrderPaperEditView.h"
#import "PurchasePaperEditView.h"
#import "AllocatePaperEditView.h"
#import "ReturnPaperEditView.h"
#import "SelectOrgShopListView.h"
#import "ExportListSelectViewController.h"
#import "HttpEngine.h"
#import "LSFilterView.h"
#import "LSFilterModel.h"
#import "LSFooterView.h"

@interface PaperListView ()<OptionPickerClient,DatePickerClient, LSFilterViewDelegate, LSFooterViewDelegate, UITableViewDelegate, UITableViewDataSource>
/**section左侧标题*/
@property (nonatomic ,strong) NSString *colLeftName;
/**section右侧标题*/
@property (nonatomic ,strong) NSString *colRightName;
@property (nonatomic ,strong) LogisticService *logisticService;
/**分页*/
@property (nonatomic) NSInteger currentPage;
/**单据状态 检索条件*/
@property (nonatomic ,copy) NSString *billStatus;
/**单据供应商 检索条件*/
@property (nonatomic ,copy) NSString *supplyId;
/**门店仓库id 检索条件*/
@property (nonatomic ,copy) NSString *shopId;
/**调出门店id 检索条件*/
@property (nonatomic ,copy) NSString *outShopId;
/**调入门店id 检索条件*/
@property (nonatomic ,copy) NSString *inShopId;
/**日期 检索条件*/
@property (nonatomic ,copy) NSNumber *sendEndTime;
/**列表数据模型*/
@property (nonatomic ,strong) PaperVo *paper;
/**状态列表*/
@property (nonatomic ,strong) NSMutableArray *statusList;
@property (nonatomic ,assign) NSInteger shopMode;

/** <#注释#> */
@property (nonatomic, strong) LSFilterView *viewFilter;
/** 门店仓库 */
@property (nonatomic, strong) LSFilterModel *modelShop;
/** 状态 */
@property (nonatomic, strong) LSFilterModel *modelStatus;
/** 调出门店 */
@property (nonatomic, strong) LSFilterModel *modelOutShop;
/** 调入门店 */
@property (nonatomic, strong) LSFilterModel *modelInShop;
/** 供应商 */
@property (nonatomic, strong) LSFilterModel *modelSuppiler;
/** 操作人 */
@property (nonatomic, strong) LSFilterModel *modelOperator;
/** 要求到货日期 */
@property (nonatomic, strong) LSFilterModel *modelDate;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isHistory;

@property (nonatomic, strong) NSMutableArray *datas;
/** <#注释#> */
@property (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic, assign) int action;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;
/** <#注释#> */
@property (nonatomic, copy) NSString *titleName;

@end

@implementation PaperListView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.logisticService = [ServiceFactory shareInstance].logisticService;
    [self showPaperType:_paperType isHistory:NO];
    [self configTitle];
    [self configViews];
    [self configFilterView];
    [self loadPaperType:_paperType];
    //初始化筛选项
    self.currentPage = 1;
    self.datas = [NSMutableArray array];
    [self searchByCondition];
}
- (void)configViews {
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, self.view.ls_width, self.view.ls_height - kNavH)];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    self.mainGrid.rowHeight = 88.0f;
    self.mainGrid.sectionHeaderHeight = 40.f;
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf selectPaperList];
    }];
    //上拉加载
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf selectPaperList];
    }];
    [self.view addSubview:self.mainGrid];
    
    self.footView = [LSFooterView footerView];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = self.view.ls_height;
    
}
- (void)showPaperType:(NSInteger)paperType isHistory:(BOOL)isHistory
{
    _type = paperType;
    _isHistory = isHistory;
}

- (void)configFilterView {
    NSString *title = nil;
    NSMutableArray *list = [NSMutableArray array];
    //状态
    NSString *itemName = nil;
    NSString *itemId = nil;
    //机构门店
    if (self.type == STOCK_ADJUST_PAPER_TYPE) {
        title = @"门店/仓库";
    } else {
        title = @"机构/门店";
    }
    self.modelShop = [LSFilterModel filterModel:LSFilterModelTypeRight items:nil selectItem:[LSFilterItem filterItem:@"全部" itemId:@"0"] title:title];
    if (_type  == CLIENT_ORDER_PAPER_TYPE || _type  == CLIENT_RETURN_PAPER_TYPE || (_type  == STOCK_ADJUST_PAPER_TYPE && [[Platform Instance] getShopMode]==3)) {
        [list addObject:self.modelShop];
    }
    
    
    if (self.type == CLIENT_RETURN_PAPER_TYPE || self.type == CLIENT_ORDER_PAPER_TYPE || ((self.type == STOCK_ADJUST_PAPER_TYPE || self.type == ALLOCATE_PAPER_TYPE) && [[Platform Instance] getShopMode]==3 )) {
        itemName = @"待确认";
        if (self.type == ALLOCATE_PAPER_TYPE && [[Platform Instance] getShopMode]==3) {//门店调拨单
            itemId = @"4";
        } else {
            itemId = @"1";
        }
    } else {
        itemName = @"全部";
        itemId = @"0";
    }
    NSMutableArray *vos=[NSMutableArray array];
    if (_type == ORDER_PAPER_TYPE) {//采购单
        LSFilterItem *item = [LSFilterItem filterItem:@"全部" itemId:@"0"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"未提交" itemId:@"4"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"待确认" itemId:@"1"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已确认" itemId:@"2"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已拒绝" itemId:@"3"];
        [vos addObject:item];
    } else if (_type == PURCHASE_PAPER_TYPE) {//收货入库单
        LSFilterItem *item = [LSFilterItem filterItem:@"全部" itemId:@"0"];
        [vos addObject:item];
        
        item = [LSFilterItem filterItem:@"未提交" itemId:@"4"];
        [vos addObject:item];
        
        if ([[Platform Instance] getShopMode] == 1 || [[Platform Instance] isTopOrg]) {
            item = [LSFilterItem filterItem:@"已收货" itemId:@"2"];
            [vos addObject:item];
            // 商超单店没有该项
//            if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == CLOTHESHOES_MODE) {
//                item = [LSFilterItem filterItem:@"已拒绝" itemId:@"3"];
//                [vos addObject:item];
//            }
            
        }else{
            item = [LSFilterItem filterItem:@"配送中" itemId:@"1"];
            [vos addObject:item];
            item = [LSFilterItem filterItem:@"已收货" itemId:@"2"];
            [vos addObject:item];
            item = [LSFilterItem filterItem:@"已拒绝" itemId:@"3"];
            [vos addObject:item];
        }
    } else if (_type == RETURN_PAPER_TYPE) {//退货出库单
        LSFilterItem *item = [LSFilterItem filterItem:@"全部" itemId:@"0"];
        [vos addObject:item];
        
        item = [LSFilterItem filterItem:@"未提交" itemId:@"4"];
        [vos addObject:item];
        
        if ([[Platform Instance] getShopMode]==1 || [[Platform Instance] isTopOrg]) {
            
            item = [LSFilterItem filterItem:@"已退货" itemId:@"2"];
            [vos addObject:item];
            
        } else {
            item = [LSFilterItem filterItem:@"待确认" itemId:@"1"];
            [vos addObject:item];
            item = [LSFilterItem filterItem:@"已退货" itemId:@"2"];
            [vos addObject:item];
            item = [LSFilterItem filterItem:@"已拒绝" itemId:@"3"];
            [vos addObject:item];
        }
    } else if (_type == ALLOCATE_PAPER_TYPE) { //门店调拨单
        LSFilterItem *item = [LSFilterItem filterItem:@"全部" itemId:@"0"];
        [vos addObject:item];
        
        item = [LSFilterItem filterItem:@"未提交" itemId:@"5"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"待确认" itemId:@"4"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"调拨中" itemId:@"1"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已收货" itemId:@"2"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已拒绝" itemId:@"3"];
        [vos addObject:item];
    } else if (_type == CLIENT_ORDER_PAPER_TYPE) {//客户采购单
        LSFilterItem *item = [LSFilterItem filterItem:@"全部" itemId:@"0"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"待确认" itemId:@"1"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已确认" itemId:@"2"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已拒绝" itemId:@"3"];
        [vos addObject:item];
    } else if (self.type == CLIENT_RETURN_PAPER_TYPE) {//客户退货单
        LSFilterItem *item = [LSFilterItem filterItem:@"全部" itemId:@"0"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"待确认" itemId:@"1"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已退货" itemId:@"2"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已拒绝" itemId:@"3"];
        [vos addObject:item];
        
    } else if (self.type == PACK_BOX_PAPER_TYPE) {//装箱单
        LSFilterItem *item = [LSFilterItem filterItem:@"全部" itemId:@"0"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已装箱" itemId:@"1"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"待发货" itemId:@"2"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已发货" itemId:@"3"];
        [vos addObject:item];
        
    }
    self.modelStatus = [LSFilterModel filterModel:LSFilterModelTypeDefult items:vos selectItem:[LSFilterItem filterItem:itemName itemId:itemId] title:@"状态"];
    [list addObject:self.modelStatus];
    
    
    
    //调出门店
    if ([[Platform Instance] getShopMode] == 3) {
        itemName = @"全部";
        itemId = @"0";
    } else {
        itemName = [[Platform Instance] getkey:SHOP_NAME];
        itemId = [[Platform Instance] getkey:SHOP_ID];
    }
    self.modelOutShop = [LSFilterModel filterModel:LSFilterModelTypeRight items:nil selectItem:[LSFilterItem filterItem:itemName itemId:itemId] title:@"调出门店"];
    if (_type == ALLOCATE_PAPER_TYPE) {//门店调拨单
        [list addObject:self.modelOutShop];
    }
    
    //调入门店
    self.modelInShop = [LSFilterModel filterModel:LSFilterModelTypeRight items:nil selectItem:[LSFilterItem filterItem:@"全部" itemId:@"0"] title:@"调入门店"];
    if (_type == ALLOCATE_PAPER_TYPE) {//门店调拨单
        [list addObject:self.modelInShop];
    }
    
    //供应商
    self.modelSuppiler = [LSFilterModel filterModel:LSFilterModelTypeRight items:nil selectItem:[LSFilterItem filterItem:@"全部" itemId:@"0"] title:@"供应商"];
    if (!(self.type == ALLOCATE_PAPER_TYPE || self.type == CLIENT_ORDER_PAPER_TYPE || self.type == CLIENT_RETURN_PAPER_TYPE || self.type == STOCK_ADJUST_PAPER_TYPE || self.type == PACK_BOX_PAPER_TYPE)) {
        [list addObject:self.modelSuppiler];
    }
    
    //操作人
    self.modelOperator = [LSFilterModel filterModel:LSFilterModelTypeRight items:nil selectItem:[LSFilterItem filterItem:@"全部" itemId:@"0"] title:@"操作人"];
    if (self.type == STOCK_ADJUST_PAPER_TYPE) {
        [list addObject:self.modelOperator];
    }
    
    //要求到货日
    if (self.type == ORDER_PAPER_TYPE || self.type == PURCHASE_PAPER_TYPE || self.type == CLIENT_ORDER_PAPER_TYPE) {
        title = @"要求到货日";
    } else if (self.type == RETURN_PAPER_TYPE || self.type == CLIENT_RETURN_PAPER_TYPE) {
        title = @"退货日期";
    } else if (self.type == ALLOCATE_PAPER_TYPE) {
        title = @"调拨日期";
    } else if (self.type == STOCK_ADJUST_PAPER_TYPE) {
        title = @"调整日期";
    } else if (self.type == PACK_BOX_PAPER_TYPE) {
        title = @"装箱日期";
    }
    self.modelDate = [LSFilterModel filterModel:LSFilterModelTypeBottom items:nil selectItem:[LSFilterItem filterItem:@"请选择" itemId:nil] title:title];
    [list addObject:self.modelDate];
    
    
    self.viewFilter = [LSFilterView addFilterViewToView:self.view delegate:self datas:list];
    
    
}


- (void)configTitle {
    [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    } else if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    }
}

#pragma mark - 不同单据类型显示不同的内容
- (void)loadPaperType:(NSInteger)paperType {
    
    BOOL showAdd = YES;
    self.colLeftName = (paperType==ALLOCATE_PAPER_TYPE)?@"调出门店-调入门店":@"供应商";
    self.colRightName = @"状态";
    NSString *title = nil;
    if (paperType == ORDER_PAPER_TYPE) {
        title = @"采购单";
        self.statusList = [LRender listOrderStatus];
    } else if (paperType == PURCHASE_PAPER_TYPE) {
        title = @"收货入库单";
        [self configHelpButton:HELP_OUTIN_RECEIVING_ORDER];
        self.statusList = [LRender listStockInStatus];
    } else if (paperType == RETURN_PAPER_TYPE){
        title = @"退货出库单";
        [self configHelpButton:HELP_OUTIN_RETURN_ORDER];
        self.statusList = [LRender listReturnStatus];
    } else if (paperType == ALLOCATE_PAPER_TYPE) {
        title = @"门店调拨单";
        self.statusList = [LRender listAllocateStatus];
        showAdd = !([[Platform Instance] getShopMode] == 3);
    } else if (paperType == CLIENT_ORDER_PAPER_TYPE) {
        title = @"客户采购单";
        self.statusList = [LRender listClientOrderStatus];
        showAdd = NO;
        self.colLeftName = @"机构/门店";
    } else if (paperType == CLIENT_RETURN_PAPER_TYPE) {
        title = @"客户退货单";
        self.statusList = [LRender listClientReturnStatus];
        showAdd = NO;
        self.colLeftName = @"机构/门店";
    }
    [self configTitle:title];
    self.titleName = title;
    self.shopMode = [[[Platform Instance] getkey:SHOP_MODE] integerValue];
    
    // 商超版添加导出按钮
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
    if (self.shopMode == SUPERMARKET_MODE) {
        [arr addObject:kFootExport];
    }
   
    if (showAdd) {
        [arr addObject:kFootAdd];
    }
    if (arr.count) {
        [self.footView initDelegate:self btnsArray:arr];
    } else {
        self.footView.hidden = YES;
    }
    
    // 收货入库单/退货出库单机构需检查是否有仓库:如果没有供货仓库，隐藏footView添加按钮
    if ((self.paperType == PURCHASE_PAPER_TYPE || self.paperType == RETURN_PAPER_TYPE) && [[Platform Instance] getShopMode] == 3) {
        [self getWareHouse];
    }
}

#pragma mark - 列表条件选择

- (void)filterViewdidClickModel:(LSFilterModel *)filterModel {
    if (filterModel == self.modelShop) {//选择机构门店
        //选择机构门店
        SelectOrgShopListView *orgShopView = [[SelectOrgShopListView alloc] init];
        orgShopView.isAll = YES;
        __weak typeof(self) weakSelf = self;
        [orgShopView loadData:[filterModel getSelectItemId] withModuleType:4 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
            if (item) {
                [filterModel initData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:orgShopView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        orgShopView = nil;

    } else if (filterModel == self.modelOutShop) {//调出门店
        //选择调出门店
        SelectShopListView* selectShopListView = [[SelectShopListView alloc] init];
        selectShopListView.isJunior = YES;
        __weak typeof(self) weakSelf = self;
        [selectShopListView loadShopList:[self.modelOutShop getSelectItemId] withType:1 withViewType:CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
            if (shop) {
                [weakSelf.modelOutShop initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                if ([[Platform Instance] getShopMode] != 3) {
                    if ([[shop obtainItemId] isEqualToString:[[Platform Instance] getkey:SHOP_ID]]) {
                        [weakSelf.modelInShop initData:@"全部" withVal:@"0"];
                    }else{
                        [weakSelf.modelInShop initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
                    }
                }
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:selectShopListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    } else if (filterModel == self.modelInShop) {
        //选择调入门店
        SelectShopListView* selectShopListView = [[SelectShopListView alloc] init];
        selectShopListView.isJunior = YES;
        __weak typeof(self) weakSelf = self;
        [selectShopListView loadShopList:[self.modelInShop getSelectItemId] withType:1 withViewType:CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
            if (shop) {
                [weakSelf.modelInShop initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                if ([[Platform Instance] getShopMode]!=3) {
                    if ([[shop obtainItemId] isEqualToString:[[Platform Instance] getkey:SHOP_ID]]) {
                        [weakSelf.modelOutShop initData:@"全部" withVal:@"0"];
                    }else{
                        [weakSelf.modelOutShop initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
                    }
                }
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:selectShopListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    } else if (filterModel == self.modelSuppiler)
    {
        //选择供应商
        SelectSupplierListView* selectSupplierListView = [[SelectSupplierListView alloc] init];
        selectSupplierListView.isAll = YES;
        __weak typeof(self) weakSelf = self;
        NSString *supplyFlag =nil;
        if (_paperType == ORDER_PAPER_TYPE) {
            //             收货入库单，对于总部没什么用，因为总部没有内部供应商
            supplyFlag = @"self";
        }else {
            //机构和第三方供应商
            supplyFlag = [[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"]?@"third":@"self";
            if ([[Platform Instance] getShopMode] !=1 && ![[Platform Instance] isTopOrg]) {
                selectSupplierListView.isCondition = YES;
            }
        }
        [selectSupplierListView loadDataBySupplyId:[self.modelSuppiler getSelectItemId] supplyFlag:supplyFlag handler:^(id<INameValue> supplier) {
            if (supplier) {
                [weakSelf.modelSuppiler initData:[supplier obtainItemName] withVal:[supplier obtainItemId]];
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:selectSupplierListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        selectSupplierListView = nil;
    } else if (filterModel == self.modelDate) {
        {
            //选择日期
            NSDate *date = [DateUtils parseDateTime4:[filterModel getSelectItemName]];
            [DatePickerBox showClear:filterModel.title clearName:@"清空日期" date:date client:self event:100];
        }
    }

}

- (void)filterViewDidClickComfirmBtn {
    [self searchByCondition];
}


- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> vo = (id<INameItem>)selectObj;
    if (eventType==100) {
        self.modelStatus.selectItem = [LSFilterItem filterItem:[vo obtainItemName] itemId:[vo obtainItemId]];
    }
    return YES;
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString *datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",[DateUtils formateDate2:date]];
    [self.modelDate initData:[DateUtils formateDate2:date] withVal:datsFullStr];
    datsFullStr = nil;
    return YES;
}

- (void)clearDate:(NSInteger)eventType
{
    [self.modelDate initData:@"请选择" withVal:nil];
}

#pragma mark - 获取查询条件（重写父类方法）
- (void)searchByCondition {
    self.billStatus = [self.modelStatus getSelectItemId];
    if ([NSString isNotBlank:[self.modelDate getSelectItemId]]) {
        self.sendEndTime = [NSNumber numberWithLongLong:[DateUtils formateDateTime2:[self.modelDate getSelectItemId]]];
    } else {
        self.sendEndTime = nil;
    }
    self.currentPage = 1;
    if (![[self.modelSuppiler getSelectItemId] isEqualToString:@"0"]) {
        self.supplyId = [self.modelSuppiler getSelectItemId];
    }
    if ([[self.modelShop getSelectItemId] isEqualToString:@"0"]) {
        self.shopId = @"";
    } else {
        self.shopId = [self.modelShop getSelectItemId];
    }
    self.outShopId = [self.modelOutShop getSelectItemId];
    self.inShopId = [self.modelInShop getSelectItemId];
    [self selectPaperList];
}

#pragma mark - 根据单据类型查询
- (void)selectPaperList
{
    if (_paperType == ORDER_PAPER_TYPE) {
        [self selectOrderPaperList:1];
    } else if (_paperType == PURCHASE_PAPER_TYPE) {
        [self selectPurchasePaperList];
    } else if (_paperType == ALLOCATE_PAPER_TYPE) {
        [self selectAllocatePaperList];
    } else if (_paperType == RETURN_PAPER_TYPE) {
        [self selectReturnPaperList:DIC_CHAIN_RETURN_STATUS withType:1];
    } else if (_paperType == CLIENT_RETURN_PAPER_TYPE) {
        [self selectReturnPaperList:DIC_CUSTOMER_RETURN_STATUS withType:2];
    } else if (_paperType == CLIENT_ORDER_PAPER_TYPE) {
        [self selectOrderPaperList:2];
    }
}

#pragma mark - 叫货单列表
- (void)selectOrderPaperList:(short)type
{
    __weak typeof(self) weakSelf = self;
    [_logisticService selectOrderPaperList:self.shopId status:(short)[self.billStatus intValue] supplyId:self.supplyId date:self.sendEndTime page:self.currentPage type:type isNeedDel:nil completionHandler:^(id json) {
        NSMutableArray* orderGoodsList = [PaperVo converToArr:[json objectForKey:@"orderGoodsList"] paperType:weakSelf.paperType];
        [weakSelf reloadMainView:orderGoodsList];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        weakSelf.currentPage--;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma mark - 收货单列表
- (void)selectPurchasePaperList
{
    __weak typeof(self) weakSelf = self;
    [_logisticService selectPurchasePaperList:[[Platform Instance] getkey:SHOP_ID] status:(short)[self.billStatus intValue] supplyId:self.supplyId date:self.sendEndTime page:self.currentPage isHistory:0 completionHandler:^(id json) {
        NSMutableArray* stockInList = [PaperVo converToArr:[json objectForKey:@"stockInList"] paperType:weakSelf.paperType];
        [weakSelf reloadMainView:stockInList];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        weakSelf.currentPage--;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma mark - 退货单列表
- (void)selectReturnPaperList:(NSString *)dicCode withType:(short)type
{
    __weak typeof(self) weakSelf = self;
    [_logisticService selectReturnPaperList:self.supplyId withStatus:(short)[self.billStatus intValue] withShopId:self.shopId withDate:self.sendEndTime withPage:self.currentPage withDicCode:dicCode type:type completionHandler:^(id json) {
        NSMutableArray* returnGoodsList = [PaperVo converToArr:[json objectForKey:@"returnGoodsList"] paperType:weakSelf.paperType];
        [weakSelf reloadMainView:returnGoodsList];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        weakSelf.currentPage--;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma mark - 查询调拨单列表
- (void)selectAllocatePaperList
{
    __weak typeof(self) weakSelf = self;
    [_logisticService selectAllocatePaperList:(short)[self.billStatus intValue] sendEndTime:self.sendEndTime outShopId:self.outShopId inShopId:self.inShopId page:self.currentPage completionHandler:^(id json) {
        NSMutableArray* allocateList = [PaperVo converToArr:[json objectForKey:@"allocateList"] paperType:weakSelf.paperType];
        [weakSelf reloadMainView:allocateList];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        weakSelf.currentPage--;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

//刷新页面
- (void)reloadMainView:(NSMutableArray *)dataArr
{
    if (self.currentPage == 1) {
        [self.datas removeAllObjects];
    }
    [self.datas addObjectsFromArray:dataArr];
    [self.mainGrid reloadData];
    self.mainGrid.ls_show = YES;
    [self.mainGrid headerEndRefreshing];
    [self.mainGrid footerEndRefreshing];
}


#pragma mark -  FooterListEvent
// footerView 点击"添加"按钮
- (void)showAddEvent
{
    [self showEditView:ACTION_CONSTANTS_ADD paperId:nil status:0 isEdit:YES];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

// footerView 点击"导出"按钮
- (void)showExportEvent {
    
    // 整理参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:6];
    if (_paperType == ORDER_PAPER_TYPE) {
        [params setValue:self.shopId forKey:@"shopId"];
        [params setValue:self.billStatus forKey:@"billStatus"];
        [params setValue:self.supplyId forKey:@"supplyId"];
        [params setValue:self.sendEndTime forKey:@"sendEndTime"];
    
    }else if (_paperType == PURCHASE_PAPER_TYPE) {
      
        [params setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
        [params setValue:self.billStatus forKey:@"billStatus"];
        [params setValue:self.supplyId forKey:@"supplyId"];
        [params setValue:self.sendEndTime forKey:@"sendEndTime"];
    
    }else if (_paperType == ALLOCATE_PAPER_TYPE) {
       
        [params setValue:self.billStatus forKey:@"billStatus"];
        [params setValue:self.sendEndTime forKey:@"sendEndTime"];
        [params setValue:self.outShopId forKey:@"outShopId"];
        [params setValue:self.inShopId forKey:@"inShopId"];

    }else if (_paperType == RETURN_PAPER_TYPE) {

        [params setValue:self.supplyId forKey:@"supplyId"];
        [params setValue:self.billStatus forKey:@"billStatus"];
        [params setValue:self.shopId forKey:@"shopId"];
        [params setValue:self.sendEndTime forKey:@"sendEndTime"];
        
    }else if (_paperType == CLIENT_RETURN_PAPER_TYPE) {
       
        [params setValue:self.supplyId forKey:@"supplyId"];
        [params setValue:self.billStatus forKey:@"billStatus"];
        [params setValue:self.shopId forKey:@"shopId"];
        [params setValue:self.sendEndTime forKey:@"sendEndTime"];
        
    }else if (_paperType == CLIENT_ORDER_PAPER_TYPE) {
        
        [params setValue:self.shopId forKey:@"shopId"];
        [params setValue:self.billStatus forKey:@"billStatus"];
        [params setValue:self.supplyId forKey:@"supplyId"];
        [params setValue:self.sendEndTime forKey:@"sendEndTime"];
    }
    
    NSString *title = self.titleName;
    ExportListSelectViewController *exprot = [[ExportListSelectViewController alloc]
                                              initWith:_paperType title:title params:params];
    [self pushController:exprot from:kCATransitionFromTop];
}

#pragma mark UITableView

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* gridColHeadId = @"GridColHead";
    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:gridColHeadId];
    if (!headItem) {
        [tableView registerNib:[UINib nibWithNibName:@"GridColHead" bundle:nil] forCellReuseIdentifier:gridColHeadId];
        headItem = [tableView dequeueReusableCellWithIdentifier:gridColHeadId];
    }
    
    [headItem initColHead:self.colLeftName col2:self.colRightName];
    [headItem initColLeft:15 col2:137];
    return headItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *paperCellId = @"PaperCell";
    PaperCell* cell = [tableView dequeueReusableCellWithIdentifier:paperCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PaperCell" bundle:nil] forCellReuseIdentifier:paperCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:paperCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaperCell *detailItem = (PaperCell *)cell;
    
    if (self.datas.count > 0 && indexPath.row < self.datas.count) {
        _paper = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblPaperNo.text = [NSString stringWithFormat:@"单号:%@",_paper.paperNo];
        // 单子当前状态
        detailItem.lblStatus.text = [GlobalRender obtainItem:self.statusList itemId:[NSString stringWithFormat:@"%tu",_paper.billStatus]];
        if (_paperType == ALLOCATE_PAPER_TYPE) {
            //调拨单
            NSString* outShopName = (_paper.outShopName.length > 5) ? [NSString stringWithFormat:@"%@...",[_paper.outShopName substringToIndex:5]] : _paper.outShopName;
            NSString* inShopName = (_paper.inShopName.length > 5) ? [NSString stringWithFormat:@"%@...",[_paper.inShopName substringToIndex:5]] : _paper.inShopName;
            detailItem.lblSupplier.text = [NSString stringWithFormat:@"%@-%@",outShopName,inShopName];
        }else if(_paperType == CLIENT_ORDER_PAPER_TYPE || _paperType == CLIENT_RETURN_PAPER_TYPE) {
            detailItem.lblSupplier.text = _paper.shopName;
        }else {
            detailItem.lblSupplier.text = _paper.supplyName;
        }
        if (_paperType == ORDER_PAPER_TYPE || _paperType == PURCHASE_PAPER_TYPE || _paperType == CLIENT_ORDER_PAPER_TYPE) {
            detailItem.lblDate.text = [NSString stringWithFormat:@"要求到货日:%@",[DateUtils formateTime2:_paper.sendEndTime]];
        }else if (_paperType == ALLOCATE_PAPER_TYPE) {
            detailItem.lblDate.text = [NSString stringWithFormat:@"调拨日期:%@",[DateUtils formateTime2:_paper.sendEndTime]];
        }else if (_paperType == RETURN_PAPER_TYPE || _paperType == CLIENT_RETURN_PAPER_TYPE) {
            detailItem.lblDate.text = [NSString stringWithFormat:@"退货日期:%@",[DateUtils formateTime2:_paper.sendEndTime]];
        }
        //单据状态显示
        if (_paperType == ALLOCATE_PAPER_TYPE) {
            if (_paper.billStatus == 5) {
                detailItem.lblStatus.textColor = [ColorHelper getBlueColor];
            }else if (_paper.billStatus == 4 || _paper.billStatus == 1) {
                detailItem.lblStatus.textColor = [ColorHelper getGreenColor];
            }else if (_paper.billStatus == 2) {
                detailItem.lblStatus.textColor = [ColorHelper getTipColor6];
            }else {
                detailItem.lblStatus.textColor = [ColorHelper getRedColor];
            }
        }else {
            if (_paper.billStatus == 4) {
                detailItem.lblStatus.textColor = [ColorHelper getBlueColor];
            }else if (_paper.billStatus == 1) {
                detailItem.lblStatus.textColor = [ColorHelper getGreenColor];
            }else if (_paper.billStatus == 2) {
                detailItem.lblStatus.textColor = [ColorHelper getTipColor6];
            }else {
                detailItem.lblStatus.textColor = [ColorHelper getRedColor];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _paper = [self.datas objectAtIndex:indexPath.row];
    BOOL isEdit = NO;
    switch (_paperType) {
        case ORDER_PAPER_TYPE:
            //未提交 可编辑
            isEdit = (_paper.billStatus == 4);
            break;
        case PURCHASE_PAPER_TYPE:
            //未提交 配送中 可编辑
            isEdit = (_paper.billStatus == 1 || _paper.billStatus == 4);
            break;
        case RETURN_PAPER_TYPE:
            //未提交 可编辑
            isEdit = (_paper.billStatus == 4);
            break;
        case ALLOCATE_PAPER_TYPE:
            //未提交 可编辑
            isEdit = (_paper.billStatus == 5);
            break;
        case CLIENT_ORDER_PAPER_TYPE:
            //待确认 可编辑
            isEdit = (_paper.billStatus == 1 && ![[Platform Instance] lockAct:ACTION_STOCK_ORDER_CHECK]);
            break;
        case CLIENT_RETURN_PAPER_TYPE:
            //待确认 可编辑
            isEdit = (_paper.billStatus == 1 && ![[Platform Instance] lockAct:ACTION_STOCK_RETURN_CHECK]);
            break;
        default:
            break;
    }
    [self showEditView:ACTION_CONSTANTS_EDIT paperId:_paper.paperId status:_paper.billStatus isEdit:isEdit];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}

#pragma mark - 单据详情详情
- (void)showEditView:(NSInteger)action paperId:(NSString*)paperId status:(short)billStatus isEdit:(BOOL)isEdit
{
    if (_paperType == ORDER_PAPER_TYPE || _paperType == CLIENT_ORDER_PAPER_TYPE)
    {
        [self showOrderEditView:action paperId:paperId status:billStatus isEdit:isEdit];
    }
    else if (_paperType == PURCHASE_PAPER_TYPE)
    {
        NSString *recordType = (action == ACTION_CONSTANTS_ADD)?@"p":self.paper.recordType;
        [self showPurchaseEditView:action paperId:paperId status:billStatus isEdit:isEdit recordType:recordType];
    }
    else if (_paperType == ALLOCATE_PAPER_TYPE)
    {
        [self showAllocateEditView:action paperId:paperId status:billStatus isEdit:isEdit];
    }
    else if (_paperType == RETURN_PAPER_TYPE || _paperType == CLIENT_RETURN_PAPER_TYPE)
    {
        [self showReturnEditView:action paperId:paperId status:billStatus isEdit:isEdit];
    }
}

#pragma mark - 采购单/客户叫货单详情
- (void)showOrderEditView:(NSInteger)action paperId:(NSString*)paperId status:(short)billStatus isEdit:(BOOL)isEdit
{
    OrderPaperEditView *orderView = [[OrderPaperEditView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [orderView loadPaperId:paperId status:billStatus paperType:_paperType action:action isEdit:isEdit callBack:^(PaperVo *item, NSInteger action) {
        if (ACTION_CONSTANTS_DEL == action) {
            //删除处理
            [weakSelf.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PaperVo* vo = (PaperVo*)obj;
                if ([vo.paperId isEqualToString:item.paperId]) {
                    [weakSelf.datas removeObjectAtIndex:idx];
                    *stop = YES;
                }
            }];
            [weakSelf.mainGrid reloadData];
        }else if (ACTION_CONSTANTS_ADD == action){
            //添加处理
            [weakSelf.mainGrid headerBeginRefreshing];
        }else if (ACTION_CONSTANTS_EDIT == action){
            //编辑处理
            [weakSelf.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PaperVo* vo = (PaperVo*)obj;
                if ([vo.paperId isEqualToString:item.paperId]) {
                    vo.billStatus = item.billStatus;
                    vo.sendEndTime = item.sendEndTime;
                    *stop = YES;
                }
            }];
            [weakSelf.mainGrid reloadData];
        }
        [XHAnimalUtil animalEdit:weakSelf.navigationController action:weakSelf.action];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
    [self.navigationController pushViewController:orderView animated:NO];
    [XHAnimalUtil animalPush:self.navigationController action:action];
    orderView = nil;
}

#pragma mark - 收货单详情
- (void)showPurchaseEditView:(NSInteger)action paperId:(NSString*)paperId status:(short)billStatus isEdit:(BOOL)isEdit recordType:(NSString*)recordType
{
    //收货入库单
    PurchasePaperEditView *purchaseView = [[PurchasePaperEditView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [purchaseView loadPaperId:paperId status:billStatus paperType:self.paperType action:action recordType:recordType isEdit:isEdit callBack:^(PaperVo *item, NSInteger action) {
        if (ACTION_CONSTANTS_DEL == action) {
            //删除处理
            [weakSelf.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PaperVo* vo = (PaperVo*)obj;
                if ([vo.paperId isEqualToString:item.paperId]) {
                    [weakSelf.datas removeObjectAtIndex:idx];
                    *stop = YES;
                }
            }];
            [weakSelf.mainGrid reloadData];
        }else if (ACTION_CONSTANTS_ADD == action){
            //添加处理
            [weakSelf.mainGrid headerBeginRefreshing];
        }else if (ACTION_CONSTANTS_EDIT == action){
            //编辑处理
            [weakSelf.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PaperVo* vo = (PaperVo*)obj;
                if ([vo.paperId isEqualToString:item.paperId]) {
                    vo.billStatus = item.billStatus;
                    vo.sendEndTime = item.sendEndTime;
                    *stop = YES;
                }
            }];
            [weakSelf.mainGrid reloadData];
        }
        if (weakSelf.action == ACTION_CONSTANTS_ADD) {
            [weakSelf popViewControllerDirect:AnimationDirectionV];
        } else {
            [weakSelf popViewController];
        }
    }];
    if (weakSelf.action == ACTION_CONSTANTS_ADD) {
        [weakSelf pushViewController:purchaseView direct:AnimationDirectionV];
    } else {
        [weakSelf pushViewController:purchaseView];
    }
}

#pragma mark - 退货单详情
- (void)showReturnEditView:(NSInteger)action paperId:(NSString*)paperId status:(short)billStatus isEdit:(BOOL)isEdit
{
    ReturnPaperEditView *returnView = [[ReturnPaperEditView alloc] init];
    __weak typeof(self) weakSelf = self;
    [returnView loadPaperId:paperId status:billStatus paperType:self.paperType action:action isEdit:isEdit callBack:^(PaperVo *item, NSInteger action) {
        if (ACTION_CONSTANTS_DEL == action) {
            //删除处理
            [weakSelf.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PaperVo* vo = (PaperVo*)obj;
                if ([vo.paperId isEqualToString:item.paperId]) {
                    [weakSelf.datas removeObjectAtIndex:idx];
                    *stop = YES;
                }
            }];
            [weakSelf.mainGrid reloadData];
        }else if (ACTION_CONSTANTS_ADD == action){
            //刷新列表
            [weakSelf.mainGrid headerBeginRefreshing];
        }else if (ACTION_CONSTANTS_EDIT == action){
            //编辑处理
            [weakSelf.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PaperVo* vo = (PaperVo*)obj;
                if ([vo.paperId isEqualToString:item.paperId]) {
                    vo.billStatus = item.billStatus;
                    vo.sendEndTime = item.sendEndTime;
                    *stop = YES;
                }
            }];
            [weakSelf.mainGrid reloadData];
        }
        [XHAnimalUtil animalEdit:weakSelf.navigationController action:weakSelf.action];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
    [self.navigationController pushViewController:returnView animated:NO];
    [XHAnimalUtil animalPush:self.navigationController action:action];
    returnView = nil;
}


#pragma mark - 调拨单详情
- (void)showAllocateEditView:(NSInteger)action paperId:(NSString*)paperId status:(short)billStatus isEdit:(BOOL)isEdit
{
    AllocatePaperEditView *allocateView = [[AllocatePaperEditView alloc] init];
    __weak typeof(self) weakSelf = self;
    [allocateView loadPaperId:paperId status:billStatus paperType:_paperType action:action isEdit:isEdit callBack:^(PaperVo *item, NSInteger action) {
        if (ACTION_CONSTANTS_DEL == action) {
            //删除处理
            [weakSelf.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PaperVo* vo = (PaperVo*)obj;
                if ([vo.paperId isEqualToString:item.paperId]) {
                    [weakSelf.datas removeObjectAtIndex:idx];
                    *stop = YES;
                }
            }];
            [weakSelf.mainGrid reloadData];
        }else if (ACTION_CONSTANTS_ADD == action){
            //添加时刷新列表
            [weakSelf.mainGrid headerBeginRefreshing];
        }else if (ACTION_CONSTANTS_EDIT == action){
            //编辑处理
            [weakSelf.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PaperVo* vo = (PaperVo*)obj;
                if ([vo.paperId isEqualToString:item.paperId]) {
                    vo.billStatus = item.billStatus;
                    vo.sendEndTime = item.sendEndTime;
                    *stop = YES;
                }
            }];
            [weakSelf.mainGrid reloadData];
        }
        [XHAnimalUtil animalEdit:weakSelf.navigationController action:weakSelf.action];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
    [self.navigationController pushViewController:allocateView animated:NO];
    [XHAnimalUtil animalPush:self.navigationController action:action];
    allocateView = nil;
}

// 获取当前门店(所属机构)、机构下的供货仓库
- (void)getWareHouse {
    NSString *url = @"wareHouse/getOrgWareHouse";
    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:NO CompletionHandler:^(id json) {
        //收入入库单和退货出库单： 若没有供货门店，隐藏"添加"按钮
        if (![json[@"hasWarehouse"] boolValue]) {
            // 商超版添加导出按钮
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
            if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == SUPERMARKET_MODE) {
                [arr addObject:kFootExport];
            }
            
            if (arr.count) {
                [self.footView initDelegate:self btnsArray:arr];
            } else {
                self.footView.hidden = YES;
            }
            
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

@end
