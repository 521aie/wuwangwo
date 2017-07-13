//
//  LSStockAdjustListController.m
//  retailapp
//
//  Created by guozhi on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockAdjustListController.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "DateUtils.h"
#import "OptionPickerBox.h"
#import "DatePickerBox.h"
#import "GridColHead.h"
#import "LSStockAdjustListCell.h"
#import "StockAdjustVo.h"
#import "SRender.h"
#import "GlobalRender.h"
#import "StockAdjustEditView.h"
#import "SelectShopStoreListView.h"
#import "SelectStaffListView.h"
#import "SelectStoreListView.h"
#import "EmlpoyeeUserIntroVo.h"
#import "ExportListSelectViewController.h"
#import "LSFooterView.h"
#import "LSFilterView.h"
#import "LSFilterModel.h"
#import "NameItemVO.h"
#import "INameItem.h"
#import "SearchBar2.h"
@interface LSStockAdjustListController ()<OptionPickerClient,DatePickerClient, LSFooterViewDelegate, UITableViewDelegate, UITableViewDataSource, LSFilterViewDelegate, ISearchBarEvent>
/**分页码*/
@property (nonatomic) NSInteger currentPage;
/**调整状态值*/
@property (nonatomic,copy) NSString* billStatus;
/**门店|仓库id*/
@property (nonatomic,copy) NSString* shopId;
/**店铺名称*/
@property (nonatomic,copy) NSString* shopName;
/**操作者*/
@property (nonatomic,copy) NSString* opUserId;
/**调整日期*/
@property (nonatomic,copy) NSString* adjustDate;
/**状态列表*/
@property (nonatomic,strong) NSMutableArray* statusList;
/**登录的机构是否有仓库*/
@property (nonatomic,assign) BOOL hasWarehouse;
/**|1 单店|2 门店|3 机构|*/
@property (nonatomic,assign) NSInteger shopMode;
@property (nonatomic, strong) StockAdjustVo *stockAdjustVo;
/**|1 门店|2 机构|*/
@property (nonatomic,assign) NSInteger roleType;
/**筛选条件中的门店或仓库所属机构id*/
@property (nonatomic,copy) NSString* selectShopId;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;
@property (nonatomic,retain) NSMutableArray *datas;    //原始数据集
/** <#注释#> */
@property (nonatomic, strong) UITableView *mainGrid;
/** <#注释#> */
@property (nonatomic, strong) LSFilterView *viewFilter;
/** 门店仓库 */
@property (nonatomic, strong) LSFilterModel *modelShop;
/** 状态 */
@property (nonatomic, strong) LSFilterModel *modelStatus;
/** 操作人 */
@property (nonatomic, strong) LSFilterModel *modelOperator;
/** 要求到货日期 */
@property (nonatomic, strong) LSFilterModel *modelDate;
/** 搜索框 */
@property (nonatomic, strong) SearchBar2 *searchBar;
/** 调整单号 */
@property (nonatomic, copy) NSString *adjustCode;
@end

@implementation LSStockAdjustListController



- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[Platform Instance] getShopMode] == 1) {
        self.shopMode = 1;
        self.selectShopId = [[Platform Instance] getkey:SHOP_ID];
        self.roleType = 1;
    }
    self.datas = [NSMutableArray array];
    [self configViews];
    [self configConstraints];
    [self configFilterView];
    self.statusList = [SRender listStockAdjustStatus];
    self.shopMode = [[Platform Instance] getShopMode];
    [self searchByCondition];
    [self configHelpButton:HELP_STOCK_ADJUST];
}

- (void)configViews {
    //标题
    [self configTitle:@"库存调整单" leftPath:Head_ICON_BACK rightPath:nil];
    CGFloat y = kNavH;
    //搜索框
    self.searchBar = [SearchBar2 searchBar2];
    [self.searchBar initDelagate:self placeholder:@"单号"];
    [self.view addSubview:self.searchBar];
    y = y + self.searchBar.ls_height;
    //表格
    self.mainGrid = [[UITableView alloc] init];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.sectionHeaderHeight = 40.0f;
    self.mainGrid.rowHeight = 88.0f;
    self.currentPage = 1;
    __weak typeof(self) weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf selectAdjustPaperList];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf selectAdjustPaperList];
    }];
    [self.view addSubview:self.mainGrid];
    
    //底部工具栏
    self.footView = [LSFooterView footerView];
    [self.view addSubview:self.footView];
    
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == CLOTHESHOES_MODE) {
        [self.footView initDelegate:self btnsArray:@[kFootAdd]];
    } else {
        [self.footView initDelegate:self btnsArray:@[kFootExport, kFootAdd]];
       
    }
    
}



- (void)configConstraints {
    //配置约束
    __weak typeof(self) wself = self;
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
        make.height.equalTo(44);
    }];
    [wself.mainGrid makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.searchBar.bottom);
        make.bottom.equalTo(wself.view.bottom);
    }];
    [wself.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.bottom.equalTo(wself.view.bottom);
        make.height.equalTo(60);
    }];
    
    
}

- (void)configFilterView {
    //机构门店
    NSMutableArray *list = [NSMutableArray array];
    if ([[Platform Instance] getShopMode] == 3) {
        self.modelShop = [LSFilterModel filterModel:LSFilterModelTypeRight items:nil selectItem:[LSFilterItem filterItem:@"全部" itemId:@"0"] title: @"门店/仓库"];
        [list addObject:self.modelShop];
    } else {
        self.selectShopId = [[Platform Instance] getkey:SHOP_ID];
    }
    //状态
    NSMutableArray *vos=[NSMutableArray array];
    LSFilterItem *item = [LSFilterItem filterItem:@"全部" itemId:@"0"];
    [vos addObject:item];
    if ([[Platform Instance] getShopMode] == 1) {
        item = [LSFilterItem filterItem:@"未提交" itemId:@"1"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已调整" itemId:@"3"];
        [vos addObject:item];
    }else{
        item = [LSFilterItem filterItem:@"未提交" itemId:@"1"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"待确认" itemId:@"2"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已调整" itemId:@"3"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已拒绝" itemId:@"4"];
        [vos addObject:item];
    }

    self.modelStatus = [LSFilterModel filterModel:LSFilterModelTypeDefult items:vos selectItem:[LSFilterItem filterItem:@"全部" itemId:@"0"] title:@"状态"];
    [list addObject:self.modelStatus];
    
    
    //操作人
  // self.modelOperator = [LSFilterModel filterModel:LSFilterModelTypeRight items:nil selectItem:[LSFilterItem filterItem:@"全部" itemId:@"0"] title:@"操作人"];
  // [list addObject:self.modelOperator];
    
    //要求到货日
    self.modelDate = [LSFilterModel filterModel:LSFilterModelTypeBottom items:nil selectItem:[LSFilterItem filterItem:@"请选择" itemId:nil] title:@"调整日期"];
    [list addObject:self.modelDate];
    
    
    self.viewFilter = [LSFilterView addFilterViewToView:self.view delegate:self datas:list];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    }
}

#pragma mark - 搜索事件
- (void)imputFinish:(NSString *)keyWord {
    self.adjustCode = keyWord;
    self.currentPage = 1;
    [self selectAdjustPaperList];
}

#pragma mark -onItemListEvent协议

- (void)filterViewdidClickModel:(LSFilterModel *)filterModel {
    if (filterModel == self.modelShop) {
        //选择门店|仓库
        SelectShopStoreListView* shopStoreListView = [[SelectShopStoreListView alloc] init];
        __weak typeof(self) weakSelf = self;
        shopStoreListView.isAdjust = YES;
        [shopStoreListView loadData:[filterModel getSelectItemId] checkMode:SINGLE_CHECK isPush:YES callBack:^(id<INameCode> item) {
            if (item && ![[item obtainItemId] isEqualToString:weakSelf.modelShop.selectItem.itemId]) {
                [weakSelf.modelOperator initData:@"请选择" withVal:nil];
            }
            if (item) {
                if ([item obtainItemType]==1) {
                    weakSelf.roleType = 1;
                    weakSelf.selectShopId = [item obtainItemId];
                }else{
                    weakSelf.roleType = 2;
                    weakSelf.selectShopId = [item obtainOrgId];
                }
                [filterModel initData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:shopStoreListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    } else if (filterModel == self.modelOperator) {
        //选择员工页面
        if (self.shopMode==3&&[self.modelShop.selectItem.itemId isEqualToString:@"0"]) {
            [AlertBox show:@"请选择门店/仓库!"];
            return;
        }
        SelectStaffListView *staffListView = [[SelectStaffListView alloc] init];
        __weak typeof(self) weakSelf = self;
        [staffListView loadDataById:self.selectShopId selectId:[filterModel getSelectItemId] roleType:self.roleType callBack:^(EmlpoyeeUserIntroVo *employeeVo) {
            NSString *operator = [NSString stringWithFormat:@"%@(工号: %@)",employeeVo.name,employeeVo.staffId];
            [weakSelf.modelOperator initData:operator withVal:employeeVo.userId];
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:staffListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        staffListView = nil;
    }else if (filterModel == self.modelDate ) {
        NSDate* date = nil;
        date = [DateUtils parseDateTime4:[self.modelDate getSelectItemName]];
        [DatePickerBox showClear:self.modelDate.title clearName:@"清空日期" date:date client:self event:100];
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
    NSString* datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",[DateUtils formateDate2:date]];
    [self.modelDate initData:[DateUtils formateDate2:date] withVal:datsFullStr];
    datsFullStr = nil;
    return YES;
}

- (void)clearDate:(NSInteger)eventType
{
    [self.modelDate initData:@"请选择" withVal:nil];
}

#pragma mark - 获取一览筛选条件参数
- (void)searchByCondition
{
    if ([[Platform Instance] getShopMode]==3) {
        if ([[self.modelShop getSelectItemId] isEqualToString:@"0"]) {
            self.shopId = @"";
        }else{
            self.shopId = [self.modelShop getSelectItemId];
        }
    }else{
        self.shopId = [[Platform Instance] getkey:SHOP_ID];
    }
    if ([[self.modelOperator getSelectItemId] isEqualToString:@"0"]) {
        self.opUserId = @"";
    }else{
        self.opUserId = [self.modelOperator getSelectItemId];
    }
    self.billStatus = [self.modelStatus getSelectItemId];
    if ([NSString isNotBlank:[self.modelDate getSelectItemId]]) {
        self.adjustDate = [self.modelDate getSelectItemId];
    }else{
        self.adjustDate = nil;
    }
    [self selectAdjustPaperList];
}

#pragma mark - 调整单一览列表
- (void)selectAdjustPaperList
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setValue:self.shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithShort:self.billStatus.integerValue] forKey:@"billStatus"];
    [param setValue:self.opUserId forKey:@"opUserId"];
    [param setValue:self.adjustDate forKey:@"adjustDate"];
    [param setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPage"];
    [param setValue:self.adjustCode forKey:@"adjustCode"];
    NSString *url = @"stockAdjust/list";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray *stockAdjustVoList = [StockAdjustVo converToArr:[json objectForKey:@"stockAdjustVoList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.datas removeAllObjects];
        }
        [weakSelf.datas addObjectsFromArray:stockAdjustVoList];
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
    
}

#pragma mark - add
- (void)showAddEvent
{
    self.stockAdjustVo = nil;
    [self showEditView:nil withAction:ACTION_CONSTANTS_ADD withIsEdit:YES];
}


- (void)showExportEvent {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:6];
    [params setValue:self.shopId forKey:@"shopId"];
    [params setValue:self.billStatus forKey:@"billStatus"];
    [params setValue:self.opUserId forKey:@"opUserId"];
    [params setValue:self.adjustDate forKey:@"adjustDate"];
    
    NSString *title = @"库存调整单";
    ExportListSelectViewController *vc = [[ExportListSelectViewController alloc]
                                              initWith:STOCK_ADJUST_PAPER_TYPE title:title params:params];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}


#pragma mark - tableview

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GridColHead *headItem = [GridColHead gridColHead];
    [headItem initColHead:@"制单人" col2:@"状态"];
    return headItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSStockAdjustListCell *cell = [LSStockAdjustListCell stockAdjustListCellWithTableView:tableView];
    StockAdjustVo *obj = [self.datas objectAtIndex:indexPath.row];
    [cell setObj:obj statusList:self.statusList];
 
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.stockAdjustVo = [self.datas objectAtIndex:indexPath.row];
    [self showEditView:self.stockAdjustVo.adjustCode withAction:ACTION_CONSTANTS_EDIT withIsEdit:(self.stockAdjustVo.billStatus==1||(self.stockAdjustVo.billStatus==2&&self.shopMode==3&&![[Platform Instance] lockAct:ACTION_STOCK_ADJUST_CHECK]))];
}

#pragma mark - 调整单详情页面传参
- (void)showEditView:(NSString *)adjustCode withAction:(NSInteger)action withIsEdit:(BOOL)isEdit
{
    StockAdjustEditView *editView = [[StockAdjustEditView alloc] init];
    //hasStockAdjust必须在这里面写 因为showDetail：这个方法有用到这个变量不能写在viewDidLoad里面
    editView.hasStockAdjust = ![[Platform Instance] lockAct:ACTION_STOCK_ADJUST_CHECK];
    __weak typeof(self) weakSelf = self;
    
    [editView showDetail:self.stockAdjustVo withEditable:isEdit withAction:action callBack:^(StockAdjustVo *item, NSInteger action) {
        if (action==ACTION_CONSTANTS_DEL) {
            //删除调整单
            [weakSelf.datas removeObject:self.stockAdjustVo];
            [weakSelf.mainGrid reloadData];
        }else if (ACTION_CONSTANTS_EDIT==action){
            //编辑调整单
            weakSelf.stockAdjustVo.createTime = item.createTime;
            weakSelf.stockAdjustVo.billStatus = item.billStatus;
            weakSelf.stockAdjustVo.opName = item.opName;
            weakSelf.stockAdjustVo.opStaffid = item.opStaffid;
            [weakSelf.mainGrid reloadData];
        }else if (ACTION_CONSTANTS_ADD==action){
            //添加调整单
            [weakSelf.mainGrid headerBeginRefreshing];
        }
    }];
    [self.navigationController pushViewController:editView animated:NO];
    [XHAnimalUtil animalPush:self.navigationController action:action];
    editView = nil;
}

@end
