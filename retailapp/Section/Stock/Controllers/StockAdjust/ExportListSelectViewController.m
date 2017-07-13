//
//  LogisticListExportViewController.m
//  retailapp
//
//  Created by taihangju on 16/8/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ExportListSelectViewController.h"
#import "GridColHead.h"
#import "ExportView.h"
#import "LSFooterView.h"
#import "PackBoxCell.h"
#import "PaperVo.h"
#import "StockAdjustVo.h"
#import "ServiceFactory.h"
#import "DicItemConstants.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "LRender.h"
#import "SRender.h"
#import "LSCostAdjustVo.h"

@interface ExportListSelectViewController ()<LSFooterViewDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) LSFooterView *footerView;/*<底部全选/全部选 footer>*/
@property (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic, assign) NSInteger exportCode;/*<导出表单类型>*/
@property (nonatomic, strong) NSString *navTitle;/*<导航栏title>*/
@property (nonatomic, strong) NSMutableArray<id<ExportListProtocol>> *datas;/*<>*/
@property (nonatomic, strong) NSMutableArray *selectExportList;/*<选出的待导出的列表>*/
@property (nonatomic, strong) LogisticService *logisticService;/*<物流部分网络请求封装>*/
@property (nonatomic,strong) StockService *stockService; /*<库存部分网络请求封装>*/
@property (nonatomic, strong) NSDictionary *params;/*<来至物流相关单子和库存调整单页面列表请求需要的参数>*/
@property (nonatomic, assign) NSInteger currentPage;/*<当前页 刷新相关>*/
@property (nonatomic, strong) NSArray *statusList;/*<单据当前状态>*/
@end

@implementation ExportListSelectViewController

- (instancetype)initWith:(NSInteger)code title:(NSString *)title params:(NSMutableDictionary *)dic {
    self = [super init];
    if (self) {
        self.logisticService = [ServiceFactory shareInstance].logisticService;
        self.stockService = [ServiceFactory shareInstance].stockService;
        self.exportCode = code;
        self.navTitle = title;
        self.params = [dic copy];
        self.datas = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    [self.mainGrid headerBeginRefreshing];
}


- (void)configSubViews {
    
    // 初始化导航栏
    [self configTitle:[NSString stringWithFormat:@"%@导出" ,self.navTitle] leftPath:Head_ICON_BACK rightPath:nil];
   
    
    // 初始化TableViewHeader
    GridColHead *header = [GridColHead gridColHead];
    if ([self.navTitle containsString:@"库存调整单"] || [self.navTitle containsString:@"成本价调整单"]) {
        [header initColHead:@"制单人" col2:@"状态"];
    } else {
        [header initColHead:@"供应商" col2:@"状态"];
    }
    
    
    
    // 初始化mainGrid列表
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)-64.0) style:UITableViewStylePlain];
    self.mainGrid.tableHeaderView = header;
    self.mainGrid.allowsMultipleSelection = YES;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.rowHeight = 88.0f;
    [self.mainGrid registerNib:[UINib nibWithNibName:@"PackBoxCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:36];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainGrid];
    self.currentPage = 1;
    
    // 下拉、上拉刷新
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf selectPaperList];
    }];
    //上拉加载
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage ++ ;
        [weakSelf selectPaperList];
    }];

    
    
    // 初始化底部，批量操作选项view
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootSelectAll,kFootSelectNo]];
    [self.view addSubview:self.footerView];
    self.footerView.frame  =  CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-60.0,
                                    CGRectGetWidth([UIScreen mainScreen].bounds), 60.0);
    self.footerView.hidden = YES;
}


- (NSMutableArray *)selectExportList {
    if (!_selectExportList) {
        _selectExportList = [[NSMutableArray alloc] init];
    }
    return _selectExportList;
}


- (NSString *)getIdFromModel:(id)obj {
    
    if ([obj isKindOfClass:[PaperVo class]]) {
        
        PaperVo *vo = (PaperVo *)obj;
        if (self.exportCode == ORDER_PAPER_TYPE || self.exportCode == CLIENT_ORDER_PAPER_TYPE) {
            return vo.paperNo;
        }
        return vo.paperId;
    }
    else if ([obj isKindOfClass:[StockAdjustVo class]])
    {
        StockAdjustVo *vo = (StockAdjustVo *)obj;
        return [vo adjustCode];
    } else if ([obj isKindOfClass:[LSCostAdjustVo class]]) {//成本价调整
        LSCostAdjustVo *vo = (LSCostAdjustVo *)obj;
        return vo.costPriceOpNo;
    }

    return nil;
}

#pragma mark - 导航栏点击事件
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    
    if (event == LSNavigationBarButtonDirectLeft) {
        
        [self popToLatestViewController:kCATransitionFromBottom];
    
    }else if (event == LSNavigationBarButtonDirectRight) {
       
        if (self.selectExportList.count > 20) {
            [AlertBox show:@"一次只能导出20张单据，请重新选择!"];
            return;
        }
        
        // 导出选择的列表项
        NSMutableArray *keyValues = [NSMutableArray arrayWithCapacity:self.selectExportList.count];
        
        
        [self.selectExportList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // 收货入库单导出参数列表是PaperVo列表，其他的是单子的id或者num
            if (self.exportCode == PURCHASE_PAPER_TYPE) {
                
                PaperVo *vo = (PaperVo *)[self.datas objectAtIndex:[(NSIndexPath *)obj row]];
                [keyValues addObject:[PaperVo converStockInVoToDic:vo]];
            }
            else
            {
                NSString *sId = [self getIdFromModel:[self.datas objectAtIndex:[(NSIndexPath *)obj row]]];
                if ([sId length]) {
                    [keyValues addObject:sId];
                }
            }
        }];
        ExportView *vc = [[ExportView alloc] init];
        [vc exportData:[keyValues copy] type:self.exportCode CallBack:^{
            
                [self popToViewController:1 popDirection:kCATransitionFromBottom];
        }];
        [self pushController:vc from:kCATransitionFromTop];
    }
}

#pragma mark -

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectAll]) {
        [self checkAllEvent];
    } else if ([footerType isEqualToString:kFootSelectNo]) {
        [self notCheckAllEvent];
    }
}
// 选择全部
- (void)checkAllEvent {
    
    [self changeNavigateStatus:YES];
    [self.selectExportList removeAllObjects];
    for (NSInteger i = 0; i < self.datas.count; i ++ ) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.mainGrid selectRowAtIndexPath:indexpath animated:YES scrollPosition:0];
        [self.selectExportList addObject:indexpath];
    }
}

// 全不选
- (void)notCheckAllEvent {
    
    [self changeNavigateStatus:NO];
    [self.selectExportList removeAllObjects];
    for (NSInteger i = 0; i < self.datas.count; i ++ ) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.mainGrid deselectRowAtIndexPath:indexpath animated:YES];
    }
}

/** 根据是否选择了导出单 改变导航栏的状态：showEditStatus == YES 显示保存、取消按钮
 *  showEditStatus == NO 显示一般状态
 */
- (void)changeNavigateStatus:(BOOL)showEditStatus {
    
    [self editTitle:showEditStatus act:ACTION_CONSTANTS_EDIT];
    if (showEditStatus) {
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"完成" filePath:Head_ICON_OK];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PackBoxCell *cell = (PackBoxCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.selectExportList.count == 0) {
        [self changeNavigateStatus:YES];
    }
    
    if (![self.selectExportList containsObject:indexPath]) {
        [self.selectExportList addObject:indexPath];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectExportList.count == 1) {
        [self changeNavigateStatus:NO];
    }
    [self.selectExportList removeObject:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackBoxCell *itemCell = (PackBoxCell *)cell;
    if (self.exportCode == STOCK_ADJUST_PAPER_TYPE) {
    
        StockAdjustVo *vo = (StockAdjustVo *)[self.datas objectAtIndex:indexPath.row];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        NSString *nameStr = [NSString stringWithFormat:@"%@ ",vo.opName];
        NSMutableAttributedString *attrNameString = [[NSMutableAttributedString alloc] initWithString:nameStr];
        [attrNameString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,nameStr.length-1)];
        [attrString appendAttributedString:attrNameString];
        NSString *staffStr = [NSString stringWithFormat:@"(工号:%@)",vo.opStaffid];
        NSMutableAttributedString *attrStaffStr = [[NSMutableAttributedString alloc] initWithString:staffStr];
        [attrStaffStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,staffStr.length)];
        [attrStaffStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:13.0] range:NSMakeRange(0,staffStr.length)];
        [attrString appendAttributedString:attrStaffStr];
        itemCell.lblPaperNo.attributedText = attrString;
        
        attrString = nil;
        attrNameString = nil;
        attrStaffStr = nil;
        itemCell.lblDetail.text = [NSString stringWithFormat:@"单号:%@", vo.adjustCode];
        itemCell.lblStatus.text = [GlobalRender obtainItem:self.statusList
                                                    itemId:[NSString stringWithFormat:@"%ld",vo.billStatus]];
        
        itemCell.lblDate.text = [NSString stringWithFormat:@"调整日期:%@",[DateUtils formateTime2:vo.createTime]];
    
        if (vo.billStatus == 1)
        {
            itemCell.lblStatus.textColor = [ColorHelper getBlueColor];
        }
        else if (vo.billStatus == 2)
        {
            itemCell.lblStatus.textColor = [ColorHelper getGreenColor];
        }
        else if (vo.billStatus == 3)
        {
            itemCell.lblStatus.textColor = [ColorHelper getTipColor6];
        }
        else
        {
            itemCell.lblStatus.textColor = [ColorHelper getRedColor];
        }

    } else if (self.exportCode == COST_ADJUST_PAPER_TYPE) {//成本价调整单
        
        LSCostAdjustVo *vo = (LSCostAdjustVo *)self.datas[indexPath.row];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        NSString *nameStr = [NSString stringWithFormat:@"%@ ",vo.opName];
        NSMutableAttributedString *attrNameString = [[NSMutableAttributedString alloc] initWithString:nameStr];
        [attrNameString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,nameStr.length-1)];
        [attrString appendAttributedString:attrNameString];
        NSString *staffStr = [NSString stringWithFormat:@"(工号:%@)",vo.opStaffId];
        NSMutableAttributedString *attrStaffStr = [[NSMutableAttributedString alloc] initWithString:staffStr];
        [attrStaffStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,staffStr.length)];
        [attrStaffStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:13.0] range:NSMakeRange(0,staffStr.length)];
        [attrString appendAttributedString:attrStaffStr];
        itemCell.lblPaperNo.attributedText = attrString;
        
        attrString = nil;
        attrNameString = nil;
        attrStaffStr = nil;
        itemCell.lblDetail.text = [NSString stringWithFormat:@"单号:%@", vo.costPriceOpNo];
        itemCell.lblStatus.text = vo.billStatusName;
        itemCell.lblStatus.textColor = vo.billStatusColor;
        itemCell.lblDate.text = [NSString stringWithFormat:@"操作日期:%@",[DateUtils formateTime2:vo.createTime.longLongValue]];
        
    }
    else
    {
        id<ExportListProtocol> obj = [self.datas objectAtIndex:indexPath.row];
        NSInteger billStatus = [obj getBillStatus];
        itemCell.lblPaperNo.text = [obj getName];
        itemCell.lblDate.text = [obj getBillDate];
        itemCell.lblStatus.text = [obj getStatus];
        itemCell.lblDetail.text = [obj getBillNum];
        
        itemCell.lblStatus.text = [GlobalRender obtainItem:self.statusList
                                                   itemId:[NSString stringWithFormat:@"%tu",billStatus]];
        
        //单据状态显示
        if (self.exportCode == ALLOCATE_PAPER_TYPE)
        {
            if (billStatus == 5)
            {
                itemCell.lblStatus.textColor = [ColorHelper getBlueColor];
            }
            else if (billStatus == 4 || billStatus == 1)
            {
                itemCell.lblStatus.textColor = [ColorHelper getGreenColor];
            }
            else if (billStatus == 2)
            {
                itemCell.lblStatus.textColor = [ColorHelper getTipColor6];
            }
            else
            {
                itemCell.lblStatus.textColor = [ColorHelper getRedColor];
            }
        }
        else
        {
            if (billStatus == 4)
            {
                itemCell.lblStatus.textColor = [ColorHelper getBlueColor];
            }
            else if (billStatus == 1)
            {
                itemCell.lblStatus.textColor = [ColorHelper getGreenColor];
            }
            else if (billStatus == 2)
            {
                itemCell.lblStatus.textColor = [ColorHelper getTipColor6];
            }
            else
            {
                itemCell.lblStatus.textColor = [ColorHelper getRedColor];
            }
        }
    }
}


#pragma mark - 网络请求
// 根据单据类型查询
- (void)selectPaperList
{
    if (self.exportCode == ORDER_PAPER_TYPE)
    {
        [self selectOrderPaperList:1];
        self.statusList = [LRender listOrderStatus];
    }
    else if (self.exportCode == PURCHASE_PAPER_TYPE)
    {
        [self selectPurchasePaperList];
        self.statusList = [LRender listStockInStatus];
    }
    else if (self.exportCode == ALLOCATE_PAPER_TYPE)
    {
        [self selectAllocatePaperList];
        self.statusList = [LRender listAllocateStatus];
    }
    else if (self.exportCode == RETURN_PAPER_TYPE)
    {
        [self selectReturnPaperList:DIC_CHAIN_RETURN_STATUS withType:1];
        self.statusList = [LRender listReturnStatus];
    }
    else if (self.exportCode == CLIENT_RETURN_PAPER_TYPE)
    {
        [self selectReturnPaperList:DIC_CUSTOMER_RETURN_STATUS withType:2];
        self.statusList = [LRender listClientReturnStatus];
    }
    else if (self.exportCode == CLIENT_ORDER_PAPER_TYPE)
    {
        [self selectOrderPaperList:2];
        self.statusList = [LRender listClientOrderStatus];
    }
    else if (self.exportCode == STOCK_ADJUST_PAPER_TYPE)
    {
        [self selectAdjustPaperList];
        self.statusList = [SRender listStockAdjustStatus];
    } else if (self.exportCode == COST_ADJUST_PAPER_TYPE) {//成本价调整
        [self selectCostAdjustPaperList];
    }
}

//刷新页面
- (void)reloadMainView:(NSArray *)dataArr
{
    if (self.currentPage == 1) {
        [self.datas removeAllObjects];
        if (dataArr.count) {
            self.footerView.hidden = NO;
        }
    }
    [self.datas addObjectsFromArray:dataArr];
    [self.mainGrid reloadData];
    self.mainGrid.ls_show = YES;
    [self.selectExportList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.mainGrid selectRowAtIndexPath:obj animated:YES scrollPosition:0];
    }];
    [self.mainGrid headerEndRefreshing];
    [self.mainGrid footerEndRefreshing];
}

#pragma mark - 叫货单列表
- (void)selectOrderPaperList:(short)type
{
    __weak typeof(self) weakSelf = self;
    [_logisticService selectOrderPaperList:_params[@"shopId"] status:[_params[@"billStatus"] intValue] supplyId:_params[@"supplyId"] date:_params[@"sendEndTime"] page:self.currentPage type:type isNeedDel:nil completionHandler:^(id json) {
        NSMutableArray* orderGoodsList = [PaperVo converToArr:[json objectForKey:@"orderGoodsList"] paperType:weakSelf.exportCode];
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
    [_logisticService selectPurchasePaperList:_params[@"shopId"] status:[_params[@"billStatus"] intValue] supplyId:_params[@"supplyId"] date:_params[@"sendEndTime"] page:self.currentPage isHistory:0 completionHandler:^(id json) {
        
        NSMutableArray *stockInList = [PaperVo converToArr:[json objectForKey:@"stockInList"] paperType:weakSelf.exportCode];
        [self reloadMainView:stockInList];
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
    [_logisticService selectReturnPaperList:_params[@"supplyId"] withStatus:[_params[@"billStatus"] intValue] withShopId:_params[@"shopId"] withDate:_params[@"sendEndTime"] withPage:self.currentPage withDicCode:dicCode type:type completionHandler:^(id json) {
      
        NSMutableArray* returnGoodsList = [PaperVo converToArr:[json objectForKey:@"returnGoodsList"] paperType:weakSelf.exportCode];
        [self reloadMainView:returnGoodsList];
        
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
    [_logisticService selectAllocatePaperList:[_params[@"billStatus"] intValue] sendEndTime:_params[@"sendEndTime"] outShopId:_params[@"outShopId"] inShopId:_params[@"inShopId"] page:self.currentPage completionHandler:^(id json) {
       
        NSMutableArray* allocateList = [PaperVo converToArr:[json objectForKey:@"allocateList"] paperType:weakSelf.exportCode];
        [self reloadMainView:allocateList];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        weakSelf.currentPage--;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}


#pragma mark - 库存调整单一览列表
- (void)selectAdjustPaperList
{
    __weak typeof(self) weakSelf = self;
    [self.stockService selectStockAdjustPaperList:_params[@"shopId"] withStatus:[_params[@"billStatus"] intValue] withOpUserId:_params[@"opUserId"] withAdjustDate:_params[@"adjustDate"] withPage:self.currentPage CompletionHandler:^(id json) {
      
        NSMutableArray *stockAdjustVoList = [StockAdjustVo converToArr:[json objectForKey:@"stockAdjustVoList"]];
        [weakSelf reloadMainView:stockAdjustVoList];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
    
}

#pragma mark - 成本价调整单一览列表
- (void)selectCostAdjustPaperList {
    __weak typeof(self) wself = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:self.params];
    [param setValue:@(self.currentPage) forKey:@"currentPage"];
    NSString *url = @"costPriceOpBills/list";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSArray *list = [LSCostAdjustVo costAdjustVoWithArray:json[@"costPriceOpBillsVoList"]];
        [wself reloadMainView:list];
    } errorHandler:^(id json) {
        [wself.mainGrid headerEndRefreshing];
        [wself.mainGrid footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}


@end
