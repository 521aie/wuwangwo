//
//  LSEmployeePerformanceListController.m
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSEmployeePerformanceListController.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SVProgressHUD.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "FooterListView5.h"
#import "ExportView.h"
#import "LSShitfRecordDetailController.h"
#import "LSEmployeeCommissionDetailController.h"
#import "DatePickerBox.h"
#import "LSEmployeePerformanceVo.h"
#import "LSGoodsTransactionFlowListController.h"
#import "LSFooterView.h"
#import "LSEmployeePerformanceListCell.h"
#import "HeaderItem.h"
@interface LSEmployeePerformanceListController ()< UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate>
/** 表格 */
@property (nonatomic, strong)  UITableView *tableView;
/** 底部工具栏 */
@property (nonatomic, strong) LSFooterView *footerView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
/** 分页标志 */
@property (nonatomic, strong) NSNumber *lastSortId;
/** 总金额 */
@property (nonatomic, strong) NSNumber *totalSaleAmount;

@end

@implementation LSEmployeePerformanceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConatraints];
    [self loadData];
}

- (void)configViews {
    self.datas = [NSMutableArray array];
    self.view.backgroundColor = [UIColor clearColor];
    //数据源
    self.datas = [NSMutableArray array];
    //标题
    [self configTitle:[NSString stringWithFormat:@"%@报表",self.title1] leftPath:Head_ICON_BACK rightPath:nil];
    //表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 88;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.lastSortId = nil;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        [wself loadData];
    }];
    [self.view addSubview:self.tableView];
    
    //底部工具栏
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootExport]];
    [self.view addSubview:self.footerView];
}

- (void)configConatraints {
    __weak typeof(self) wself = self;
    //配置标
    //配置表格
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    //配置底部工具栏
    [self.footerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
}

#pragma mark - 加载数据
- (void)loadData {
    NSString *url = @"employeePerformance/v1/list";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.lastSortId == nil) {
            [wself.datas removeAllObjects];
        }
        if ([ObjectUtil isNotNull:json[@"totalSaleAmount"]]) {
            wself.totalSaleAmount = json[@"totalSaleAmount"];
        }
        NSArray *map = [json objectForKey:@"performanceVos"];
        if ([ObjectUtil isNotNull:map]) {
            wself.datas = [LSEmployeePerformanceVo mj_objectArrayWithKeyValuesArray:map];
        }
        [wself.tableView reloadData];
        wself.lastSortId = json[@"lastSortId"];
        wself.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
    
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    if (self.lastSortId == nil) {
        [_param removeObjectForKey:@"lastSortId"];
    } else {
        [_param setValue:self.lastSortId forKey:@"lastSortId"];
    }
    return _param;
}


#pragma mark - 导出事件
-(void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    }
}
- (void)showExportEvent {
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [vc loadData:self.exportParam withPath:@"employeePerformance/v1/export" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSEmployeePerformanceListCell *cell = [LSEmployeePerformanceListCell employeePerformanceListCellWithTableView:tableView];
    cell.employeePerformanceVo = self.datas[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderItem *headItem = [HeaderItem headerItem];
    NSString *titleVal = [NSString stringWithFormat:@"合计：￥%.2f",  self.totalSaleAmount.doubleValue];
    [headItem initWithName:titleVal];
    return headItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    LSEmployeePerformanceVo *vo = self.datas[indexPath.row];
    [param setValue:vo.userId forKey:@"userId"];
    [param setValue:self.param[@"shopId"] forKey:@"shopId"];
    long long startTime = [self.param[@"startTime"] longLongValue] * 1000;
    [param setValue:@(startTime) forKey:@"startTime"];
    long long endTime = [self.param[@"endTime"] longLongValue] * 1000;
    [param setValue:@(endTime) forKey:@"endTime"];
    [param setValue:self.param[@"optType"] forKey:@"optType"];
    [param setValue:self.param[@"shopEntityId"] forKey:@"shopEntityId"];
    [param setValue:self.param[@"entityId"] forKey:@"entityId"];
    [param setValue:@"1" forKey:@"searchType"];
    NSString *url = @"orderDetailsReport/v1/getSellerOrderList";
    LSGoodsTransactionFlowListController *vc = [[LSGoodsTransactionFlowListController alloc] init];
    vc.param = param;
    vc.url = url;
    vc.showExport = NO;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}


@end
