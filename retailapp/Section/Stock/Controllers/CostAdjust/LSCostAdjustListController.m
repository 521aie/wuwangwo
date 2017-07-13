//
//  LSCostAdjustListController.m
//  retailapp
//
//  Created by guozhi on 2017/3/24.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCostAdjustListController.h"
#import "SearchBar2.h"
#import "LSFooterView.h"
#import "LSCostAdjustListCell.h"
#import "LSFilterView.h"
#import "SelectShopListView.h"
#import "DateUtils.h"
#import "DatePickerBox.h"
#import "LSCostAdjustVo.h"
#import "ExportListSelectViewController.h"
#import "LSCostAdjustDetailController.h"
#import "GridColHead.h"

@interface LSCostAdjustListController ()<ISearchBarEvent, UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate,LSFilterViewDelegate, DatePickerClient>
@property (nonatomic, strong) UITableView *mainGrid;
/** 搜索框 */
@property (nonatomic, strong) SearchBar2 *searchBar;
@property (nonatomic, strong) LSFooterView *footView;
/**分页码*/
@property (nonatomic) NSInteger currentPage;
/** <#注释#> */
@property (nonatomic, strong) LSFilterView *viewFilter;
/** 门店仓库 */
@property (nonatomic, strong) LSFilterModel *modelShop;
/** 状态 */
@property (nonatomic, strong) LSFilterModel *modelStatus;
/** 操作日期 */
@property (nonatomic, strong) LSFilterModel *modelDate;

/** shopId */
@property (nonatomic,copy) NSString *shopId;
/** 调整单号 */
@property (nonatomic, copy) NSString *adjustCode;
@property (nonatomic,retain) NSMutableArray *datas;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
@end

@implementation LSCostAdjustListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle];
    [self configData];
    [self configViews];
    [self configConstraints];
    [self configFilterView];
    [self loadData];
}
- (void)configData {
    self.datas = [NSMutableArray array];
    self.currentPage = 1;
}
- (void)configTitle {
    [self configTitle:@"成本价调整单" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)configViews {
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
    __weak typeof(self) wself = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        wself.currentPage ++;
        [wself loadData];
    }];
    [self.view addSubview:self.mainGrid];
    
    //底部工具栏
    self.footView = [LSFooterView footerView];
    [self.view addSubview:self.footView];
    
    if ([[Platform Instance] getShopMode]  == 3) {
        [self.footView initDelegate:self btnsArray:@[kFootExport]];
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
#pragma mark - 筛选页面
- (void)configFilterView {
    //机构门店
    NSMutableArray *list = [NSMutableArray array];
    if ([[Platform Instance] getShopMode] == 3) {
        self.modelShop = [LSFilterModel filterModel:LSFilterModelTypeRight items:nil selectItem:[LSFilterItem filterItem:@"全部" itemId:@"0"] title: @"门店"];
        [list addObject:self.modelShop];
    } else {
//        self.selectShopId = [[Platform Instance] getkey:SHOP_ID];
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
        if ([[Platform Instance] getShopMode] == 2) {
            item = [LSFilterItem filterItem:@"未提交" itemId:@"1"];
            [vos addObject:item];
        }
        item = [LSFilterItem filterItem:@"待确认" itemId:@"2"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已调整" itemId:@"3"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已拒绝" itemId:@"4"];
        [vos addObject:item];
    }
    
    self.modelStatus = [LSFilterModel filterModel:LSFilterModelTypeDefult items:vos selectItem:[LSFilterItem filterItem:@"全部" itemId:@"0"] title:@"状态"];
    [list addObject:self.modelStatus];
    
    //要求到货日
    self.modelDate = [LSFilterModel filterModel:LSFilterModelTypeBottom items:nil selectItem:[LSFilterItem filterItem:@"请选择" itemId:nil] title:@"操作日期"];
    [list addObject:self.modelDate];
    
    
    self.viewFilter = [LSFilterView addFilterViewToView:self.view delegate:self datas:list];
}
#pragma mark - 搜索事件
- (void)imputFinish:(NSString *)keyWord {
    self.adjustCode = keyWord;
    self.currentPage = 1;
    [self loadData];
}
#pragma mark - <LSFilterViewDelegate>
- (void)filterViewdidClickModel:(LSFilterModel *)filterModel {
    if (filterModel == self.modelShop) {//选择门店
        __weak typeof(self) wself = self;
        SelectShopListView *vc = [[SelectShopListView alloc] init];
        [vc loadShopList:[self.modelShop getSelectItemId] withType:0 withViewType:CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
            if (shop) {
                [wself.modelShop initData:[shop obtainItemName] withVal:[shop obtainItemId]];
            }
            [wself popViewController];
        }];
        [self pushViewController:vc];
    } else if (filterModel == self.modelDate) {
         NSDate *date = [DateUtils parseDateTime4:[self.modelDate getSelectItemName]];
        [DatePickerBox showClear:self.modelDate.title clearName:@"清空日期" date:date client:self event:100];
    }
    
}

- (void)filterViewDidClickComfirmBtn {
    [self loadData];
}

#pragma mark - 日期选择
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    [self.modelDate initData:[DateUtils formateDate2:date] withVal:[DateUtils formateDate2:date]];
    return YES;
}

- (void)clearDate:(NSInteger)eventType
{
    [self.modelDate initData:@"请选择" withVal:nil];
}
#pragma mark - 请求参数
- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param removeAllObjects];
    NSString *shopId = nil;
    if ([[Platform Instance] getShopMode] == 3) {
        if ([[self.modelShop getSelectItemName] isEqualToString:@"全部"]) {
            shopId = @"";
        } else {
            shopId = [self.modelShop getSelectItemId];
        }
    } else {
        shopId = [[Platform Instance] getkey:SHOP_ID];
    }
    [_param setValue:shopId forKey:@"shopId"];
    
    int status = [[self.modelStatus getSelectItemId] intValue];
    [_param setValue:@(status) forKey:@"billsStatus"];
    
    NSString *adjustDate = [self.modelDate getSelectItemId];
    [_param setValue:adjustDate forKey:@"adjustDate"];
    
    [_param setValue:@(self.currentPage) forKey:@"currentPage"];
    
    [_param setValue:self.adjustCode forKey:@"costPriceOpNo"];
    
    return _param;
}

#pragma mark - 加载数据
- (void)loadData {
    __weak typeof(self) wself = self;
    NSString *url = @"costPriceOpBills/list";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.mainGrid headerEndRefreshing];
        [wself.mainGrid footerEndRefreshing];
        if (wself.currentPage == 1) {
            [wself.datas removeAllObjects];
        }
        NSArray *list = [LSCostAdjustVo costAdjustVoWithArray:json[@"costPriceOpBillsVoList"]];
        [wself.datas addObjectsFromArray:list];
        [wself.mainGrid reloadData];
        wself.mainGrid.ls_show = YES;
    } errorHandler:^(id json) {
        wself.currentPage--;
        [wself.mainGrid headerEndRefreshing];
        [wself.mainGrid footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}


#pragma mark - <LSFooterView>
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    } else if ([footerType isEqualToString:kFootAdd]) {
        [self showAddExport];
    }
}

- (void)showExportEvent {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:self.param];
     NSString *title = @"成本价调整单";
    ExportListSelectViewController *vc = [[ExportListSelectViewController alloc]
                                          initWith:COST_ADJUST_PAPER_TYPE title:title params:param];
    [self pushViewController:vc direct:AnimationDirectionV];
}

- (void)showAddExport {
    [self gotoCostAdjustDetailController:ACTION_CONSTANTS_ADD costAdjustVo:nil];
}

#pragma mark - <UITableView>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSCostAdjustListCell *cell = [LSCostAdjustListCell costAdjustListCellWithTableView:tableView];
    LSCostAdjustVo *obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GridColHead *headItem = [GridColHead gridColHead];
    [headItem initColHead:@"制单人" col2:@"状态"];
    return headItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSCostAdjustVo *obj = self.datas[indexPath.row];
    [self gotoCostAdjustDetailController:ACTION_CONSTANTS_EDIT costAdjustVo:obj];
}

#pragma mark - 前往成本价调整单详情页
- (void)gotoCostAdjustDetailController:(int)action costAdjustVo:(LSCostAdjustVo *)costAdjustVo {
    __weak typeof(self) wself = self;
    LSCostAdjustDetailController *vc = [[LSCostAdjustDetailController alloc] initWithAction:action costAdjustVo:costAdjustVo hasCostAdjust:![[Platform Instance] lockAct: ACTION_COST_PRICE_BILLS_CHECK] CallBlock:^(LSCostAdjustVo *item, NSInteger action) {
        if (action == ACTION_CONSTANTS_DEL) {
            //删除调整单
            [wself.datas removeObject:costAdjustVo];
            [wself.mainGrid reloadData];
        }else if (ACTION_CONSTANTS_EDIT == action){
            //编辑调整单
            costAdjustVo.createTime = item.createTime;
            costAdjustVo.billsStatus = item.billsStatus;
            costAdjustVo.opName = item.opName;
            costAdjustVo.opStaffId = item.opStaffId;
            [wself.mainGrid reloadData];
        }else if (ACTION_CONSTANTS_ADD == action){
            //添加调整单
            wself.currentPage = 1;
            [wself loadData];
        }

    }];
    if (action == ACTION_CONSTANTS_ADD) {
        [self pushViewController:vc direct:AnimationDirectionV];
    } else {
        [self pushViewController:vc];
    }
   

}
@end
