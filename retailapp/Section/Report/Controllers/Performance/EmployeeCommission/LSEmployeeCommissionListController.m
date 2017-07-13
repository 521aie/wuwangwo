//
//  LSEmployeeCommissionListController.m
//  retailapp
//
//  Created by guozhi on 2016/11/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSEmployeeCommissionListController.h"
#import "XHAnimalUtil.h"
#import "LSFooterView.h"
#import "ExportView.h"
#import "AlertBox.h"
#import "LSEmployeeCommissionDetailController.h"
#import "HeaderItem.h"
#import "LSEmployeeCommissionVo.h"
#import "LSEmployeeCommissionListCell.h"
@interface LSEmployeeCommissionListController ()< UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate>
/** 表格 */
@property (nonatomic, strong)  UITableView *tableView;
/** 分页标志 */
@property (nonatomic, strong) NSNumber *lastTime;
/** 底部工具栏 */
@property (nonatomic, strong) LSFooterView *footerView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
/** 合计提成金额 */
@property (nonatomic, assign) double totalCommissionAmount;
@end

@implementation LSEmployeeCommissionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self loadData];
}

- (void)configViews {
    self.datas = [NSMutableArray array];
    self.view.backgroundColor = [UIColor clearColor];
    //数据源
    self.datas = [NSMutableArray array];
    //标题
    [self configTitle:@"员工提成报表" leftPath:Head_ICON_BACK rightPath:nil];
    //表格
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 88;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    [self.view addSubview:self.tableView];
    
    //底部工具栏
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootExport]];
    self.footerView.ls_bottom = SCREEN_H;
    [self.view addSubview:self.footerView];
}




#pragma mark - 加载数据
- (void)loadData {
    NSString *url = @"userRoyalties/v1/list";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray *map = json[@"selectList"];
        if ([ObjectUtil isNotNull:map]) {
            wself.datas = [LSEmployeeCommissionVo mj_objectArrayWithKeyValuesArray:map];
            [wself.datas enumerateObjectsUsingBlock:^(LSEmployeeCommissionVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                wself.totalCommissionAmount = wself.totalCommissionAmount + [obj.commissionAmount doubleValue];
            }];
            [wself.tableView reloadData];
            wself.tableView.ls_show = YES;
        }
    } errorHandler:^(id json) {
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
    [vc loadData:self.exportParam withPath:@"userRoyalties/v1/export" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    
}

#pragma mark - UITableView^(NSString *email)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSEmployeeCommissionListCell *cell = [LSEmployeeCommissionListCell employeeCommissionListCellWithTableView:tableView];
    cell.employeeCommissionVo = self.datas[indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSEmployeeCommissionDetailController *vc = [[LSEmployeeCommissionDetailController alloc] init];
    vc.shopName = self.shopName;
    vc.employeeCommissionVo = self.datas[indexPath.row];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderItem *headItem = [HeaderItem headerItem];
    NSString *totalAmount = [NSString stringWithFormat:@"合计：¥%.2f", self.totalCommissionAmount];
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
