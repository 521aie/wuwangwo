//
//  LSShiftRecordListController.m
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSShiftRecordListController.h"
#import "XHAnimalUtil.h"
#import "HeaderItem.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SVProgressHUD.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "ExportView.h"
#import "LSShiftRecordListCell.h"
#import "LSShitfRecordDetailController.h"
#import "LSFooterView.h"
#import "LSUserHandoverVo.h"
@interface LSShiftRecordListController ()< UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate>
/** 表格 */
@property (nonatomic, strong)  UITableView *tableView;
/** 分页标志 */
@property (nonatomic, strong) NSNumber *lastTime;
/** 底部工具栏 */
@property (nonatomic, strong) LSFooterView *footerView;
/** 合计净销售额 */
@property (nonatomic, strong) NSNumber *totalAmount;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
/** 合计总额 */
@property (nonatomic, strong) NSNumber *totalRecieveAmount;

@end

@implementation LSShiftRecordListController

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
    [self configTitle:@"交接班记录" leftPath:Head_ICON_BACK rightPath:nil];
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
        wself.lastTime = nil;
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
    NSString *url = @"changeShifts/v1/list";
    __weak typeof(self) wself = self;
    if ([ObjectUtil isNotNull:self.lastTime]) {
        [self.param setValue:self.lastTime forKey:@"lastTime"];
    } else {
        [self.param removeObjectForKey:@"lastTime"];
    }
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if ([ObjectUtil isNotNull:json[@"allTotalRcvAmnt"]]) {
            wself.totalRecieveAmount = json[@"allTotalRcvAmnt"];
        }
        if (wself.lastTime == nil) {
            [wself.datas removeAllObjects];
        }
        NSMutableArray *map = json[@"userHandoverVos"];
        if ([ObjectUtil isNotNull:map]) {
            NSMutableArray *list = [LSUserHandoverVo mj_objectArrayWithKeyValuesArray:map];
            [self.datas addObjectsFromArray:list];
        }
        wself.lastTime = json[@"lastTime"];
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
    
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
    [vc loadData:self.exportParam withPath:@"changeShifts/v1/exportExcel" withIsPush:YES callBack:^{
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
    LSShiftRecordListCell *cell = [LSShiftRecordListCell shiftRecordListCellWithTableView:tableView];
    cell.userHangoverVo = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSShitfRecordDetailController *vc = [[LSShitfRecordDetailController alloc] init];
    vc.shopName = self.shopName;
    vc.userHandoverVo = self.datas[indexPath.row];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderItem *headItem = [HeaderItem headerItem];
    NSString *totalAmount = [NSString stringWithFormat:@"合计：¥%.2f", self.totalRecieveAmount.doubleValue];

    [headItem initWithName:totalAmount];
    return headItem;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}


@end
