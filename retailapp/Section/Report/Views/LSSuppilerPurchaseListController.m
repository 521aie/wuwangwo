//
//  LSSuppilerPurchaseListController.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSuppilerPurchaseListController.h"
#import "LSFooterView.h"
#import "XHAnimalUtil.h"
#import "LSStockBalanceDetailController.h"
#import "ExportView.h"
#import "HeaderItem.h"
#import "DateUtils.h"
#import "LSSuppilerPurchaseListCell.h"
#import "LSSuppilerPurchaseVo.h"
#import "LSSuppilerPurchaseDetailController.h"

@interface LSSuppilerPurchaseListController ()<UITableViewDataSource,UITableViewDelegate, LSFooterViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LSFooterView *footView;
/**<数据源>*/
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
/** 总金额 */
@property (nonatomic, strong) NSNumber *totalAmount;
/** 总件数 */
@property (nonatomic, strong) NSNumber *totalNum;
@end

@implementation LSSuppilerPurchaseListController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDatas];
    [self configSubViews];
    [self configConstraints];
    [self loadData];
}

- (void)configDatas {
    self.datas = [NSMutableArray array];
    self.currentPage = 1;
}

- (void)configSubViews {
    [self configTitle:@"供应商采购报表" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __strong typeof(self) wself = self;
    self.tableView.rowHeight = 88.0f;
    self.tableView.sectionHeaderHeight = 44.0;
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
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootExport]];
    [self.view addSubview:self.footView];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
}


- (void)loadData {
    __weak typeof(self) wself = self;
    [self.param setValue:@(self.currentPage) forKey:@"currPage"];
    NSString *url = @"supplierPurchase/list";
    
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.currentPage == 1) {
            wself.totalNum = json[@"totalNum"];
            wself.totalAmount = json[@"totalAmount"];
            [wself.datas removeAllObjects];
        }
        NSArray *list = json[@"supplierPurchaseList"];
        if ([ObjectUtil isNotNull:list]) {
            NSArray *objs = [LSSuppilerPurchaseVo mj_objectArrayWithKeyValuesArray:list];
            LSSuppilerPurchaseVo *obj = [objs objectAtIndex:0];
            if (obj != nil) {
                //单店登录,有数据时
                if (self.entityIdExport == nil) {
                    self.shopIdExport = obj.shopId;
                    self.entityIdExport = obj.shopEntityId;
                }
            }
            [wself.datas addObjectsFromArray:objs];
        }
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        wself.currentPage--;
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}

#pragma mark - 导出事件
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {
        //导出
        [self showExportEvent];
    }
}

- (void)showExportEvent {    
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [self.param removeObjectForKey:@"currPage"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param = self.param;
    
    //连锁登录时
    if ((self.shopTypeExport == 2)) {
        //2连锁登录的仓库
        [param setValue:@(2) forKey:@"type"];
        [param setValue:self.shopIdExport forKey:@"shopId"];
    }else{
        //连锁登录的门店/单店登录
        [param setValue:@(1) forKey:@"type"];
        if(self.entityIdExport != nil){
            //单店登录,有数据
            [param setValue:self.shopIdExport forKey:@"shopId"];
            [param setValue:self.entityIdExport forKey:@"shopEntityId"];
        }else{
            //单店登录,没数据
        }
    }
    
    [vc loadData:param withPath:@"supplierPurchase/export" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSuppilerPurchaseListCell *cell = [LSSuppilerPurchaseListCell suppilerPurchaseDetailCellWithTableView:tableView];
    LSSuppilerPurchaseVo *obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderItem *headItem = [HeaderItem headerItem];
    NSString *totalAmount = nil;
    if ([ObjectUtil isNotNull:self.totalAmount] && [ObjectUtil isNotNull:self.totalNum]) {
        if ([self.totalNum.stringValue containsString:@"."]) {
            if (self.totalAmount.doubleValue >= 0) {
                totalAmount = [NSString stringWithFormat:@"合计：%.3f件 ¥%.2f", self.totalNum.doubleValue, self.totalAmount.doubleValue];
            }else{
                totalAmount = [NSString stringWithFormat:@"合计：%.3f件 -¥%.2f", self.totalNum.doubleValue, -self.totalAmount.doubleValue];
            }
        } else {
            if (self.totalAmount.doubleValue >= 0) {
                totalAmount = [NSString stringWithFormat:@"合计：%.f件 ¥%.2f", self.totalNum.doubleValue, self.totalAmount.doubleValue];
            } else {
                totalAmount = [NSString stringWithFormat:@"合计：%.f件 -¥%.2f", self.totalNum.doubleValue, -self.totalAmount.doubleValue];
            }
        }
    }else{
        totalAmount = @"合计：0件 ¥0.00";
    }
    [headItem initWithName:totalAmount];
    return headItem;    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSuppilerPurchaseVo *obj = self.datas[indexPath.row];
    
    NSNumber *startTime = self.param[@"startTime"];
    NSNumber *endTime = self.param[@"endTime"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:startTime forKey:@"startTime"];
    [param setValue:endTime forKey:@"endTime"];
    [param setValue:obj.shopId forKey:@"shopId"];
    
    NSString *supplier = obj.supplierId;
    if ([NSString isNotBlank:supplier]) {
        [param setValue:obj.supplierId forKey:@"supplierId"];
    }
   
    LSSuppilerPurchaseDetailController *vc = [[LSSuppilerPurchaseDetailController alloc] init];
    vc.param = param;
    vc.obj = obj;
    vc.time = [NSString stringWithFormat:@"%@~%@", [DateUtils formateTime2:startTime.longLongValue * 1000], [DateUtils formateTime2:endTime.longLongValue * 1000]];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

@end
