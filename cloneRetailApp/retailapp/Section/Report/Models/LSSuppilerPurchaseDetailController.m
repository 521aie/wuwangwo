//
//  LSSuppilerPurchaseDetailController.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSuppilerPurchaseDetailController.h"
#import "XHAnimalUtil.h"
#import "LSSuppilerPurchaseVo.h"
#import "LSSuppilerPurchaseDetailHeaderView.h"
#import "LSSuppilerPurchaseDetailCell.h"
#import "LSSuppilerPurchaseRecordController.h"
#import "LSSuppilerPurchaseVo.h"

@interface LSSuppilerPurchaseDetailController ()< UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/**<数据源>*/
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) LSSuppilerPurchaseDetailHeaderView *viewHeader;
@end

@implementation LSSuppilerPurchaseDetailController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDatas];
    [self configViews];
    [self configConstraints];
    [self loadData];
}

- (void)configDatas {
    self.currentPage = 1;
    self.datas = [NSMutableArray array];
}

- (void)configViews {
    [self configTitle:@"供应商采购流水" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __strong typeof(self) wself = self;
    self.tableView.rowHeight = 88.0f;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.currentPage++;
        [wself loadData];
    }];
    self.tableView.tableFooterView = [ViewFactory generateFooter:60.0];
    [self.view addSubview:self.tableView];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
}

- (void)loadData {
    __weak typeof(self) wself = self;
    NSString *url = @"supplierPurchase/detail";
    [self.param setValue:@(self.currentPage) forKey:@"currPage"];
    
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.currentPage == 1) {
            [wself.datas removeAllObjects];
        }
        NSArray *list = json[@"supplierPurchaseDetail"];
        if ([ObjectUtil isNotNull:list]) {
            NSArray *objs = [LSSuppilerPurchaseVo objectArrayFromKeyValueArray:list];
            [wself.datas addObjectsFromArray:objs];
        }
        wself.tableView.tableHeaderView = wself.viewHeader;
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
        
    } errorHandler:^(id json) {
        wself.currentPage--;
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}

- (LSSuppilerPurchaseDetailHeaderView *)viewHeader {
    if (_viewHeader == nil) {
        _viewHeader = [LSSuppilerPurchaseDetailHeaderView suppilerPurchaseDetailHeaderView];
        [_viewHeader setObj:self.obj time:self.time];
    }
    return _viewHeader;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSuppilerPurchaseDetailCell *cell = [LSSuppilerPurchaseDetailCell suppilerPurchaseDetailCellWithTableView:tableView];
    LSSuppilerPurchaseVo *obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSuppilerPurchaseVo *obj = self.datas[indexPath.row];
    
    NSNumber *startTime = self.param[@"startTime"];
    NSNumber *endTime = self.param[@"endTime"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:startTime forKey:@"startTime"];
    [param setValue:endTime forKey:@"endTime"];
    [param setValue:obj.shopId forKey:@"shopId"];
    [param setValue:obj.supplierId forKey:@"supplierId"];
    [param setValue:obj.invoiceCode forKey:@"invoiceCode"];
    
    LSSuppilerPurchaseRecordController *vc = [[LSSuppilerPurchaseRecordController alloc] init];
    vc.param = param;
    vc.obj = obj;
    if ([ObjectUtil isNotNull:self.obj.invoiceFlag]) {
        if (self.obj.invoiceFlag.intValue == 1) {
            //进货
            vc.totalNum = self.obj.stockNum;
            vc.totalAmount = self.obj.stockAmount;
        } else {
            //退货
            vc.totalNum = self.obj.returnNum;
            vc.totalAmount = self.obj.returnAmount;
        }
    }
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

@end
