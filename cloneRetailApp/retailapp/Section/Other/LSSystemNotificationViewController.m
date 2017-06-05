//
//  LSSystemNotificationViewController.m
//  retailapp
//
//  Created by guozhi on 16/10/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSystemNotificationViewController.h"
#import "LSSystemNotificationCell.h"
#import "AlertBox.h"
#import "MJExtension.h"
#import "LSNoticeVo.h"
#import "LSWechatGoodManageViewController.h"
#import "LSWechatStyleManageViewController.h"
#import "GoodsStyleInfoView.h"
#import "LSGoodsInfoSelectViewController.h"
#import "GoodsCategoryListView.h"
#import "PaperListView.h"
#import "LSStockAdjustListController.h"
#import "ReturnPackBoxListView.h"
#import "LSShiftRecordViewController.h"
#import "LSShopCollectionController.h"
#import "LSEmployeePerformanceViewController.h"
#import "LSEmployeeCommissionViewController.h"
#import "LSGoodsTransactionFlowController.h"
#import "LSGoodsSaleViewController.h"
#import "LSSaleProfitViewController.h"
#import "LSMemberConsumeViewController.h"
#import "LSMemberRechargeViewReportController.h"
#import "LSMemberIntergalViewController.h"
#import "LSStockQueryViewController.h"
#import "LSStockSummaryViewController.h"
#import "WeChatReturnMoneyManager.h"
#import "PerformanceGoalView.h"
#import "LSStockChangeViewController.h"
#import "LSMemberQueryViewController.h"
#import "LSMemberCardOperateController.h"
#import "LSStockBalanceViewController.h"
#import "LSGoodsPurchaseViewController.h"
#import "LSSuppilerPurchaseViewController.h"
#import "LSCostChangeRecordViewController.h"
#import "LSDataClearController.h"
@interface LSSystemNotificationViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, strong) NSMutableDictionary *param;
@end

@implementation LSSystemNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    [self addContstraint];
    [self loadData];
}

- (void)initMainView {
    [self configTitle:@"操作通知" leftPath:Head_ICON_BACK rightPath:nil];
    self.datas = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.rowHeight = 78;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __weak typeof(self) wself = self;
    
    [self.tableView ls_addHeaderWithCallback:^{
        wself.createTime = 0;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        [wself loadData];
    }];
    [self.view addSubview:self.tableView];
    self.createTime = [[NSDate date] timeIntervalSince1970] * 1000;
}

- (void)addContstraint {
    __weak typeof(self) wself = self;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(wself.view).offset(kNavH);
    }];
    
}

- (void)loadData {
    NSString *url = @"notice/listUser";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.createTime == 0) {
             [wself.datas removeAllObjects];
        }
        if ([ObjectUtil isNotNull:json[@"noticeList"]]) {
            NSMutableArray *noticeList = [LSNoticeVo mj_objectArrayWithKeyValuesArray:json[@"noticeList"]];
            [wself.datas addObjectsFromArray:noticeList];
            [wself.tableView reloadData];
        }
        
        if ([ObjectUtil isNotNull:json[@"createTime"]]) {
            wself.createTime = [json[@"createTime"] longLongValue];
        }
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
    [_param removeAllObjects];
    [_param setValue:[[Platform Instance] getkey:USER_ID] forKey:@"userId"];
    if (self.createTime != 0) {
        [_param setValue:@(self.createTime) forKey:@"createTime"];
    }
    return _param;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSystemNotificationCell *cell = [LSSystemNotificationCell systemNotificationCellWithTableView:tableView];
    cell.noticeVo = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSNoticeVo *noticeVo = self.datas[indexPath.row];
    if (noticeVo.isJump == 1) {//页面需要跳转
        UIViewController *vc = nil;
        if (noticeVo.businessType == 1) {//一键上架
            if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
                vc = [[LSWechatStyleManageViewController alloc] init];
            } else {
                vc = [[LSWechatGoodManageViewController alloc] init];
            }
        } else if (noticeVo.businessType == 2) {//款式/商品导出
            if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
                vc = [[GoodsStyleInfoView alloc] init];
            } else {
                vc = [[LSGoodsInfoSelectViewController alloc] init];
            }
        } else if (noticeVo.businessType == 3) {//商品品类/分类导出
            vc = [[GoodsCategoryListView alloc] initWithTag:0];
        } else if (noticeVo.businessType == 4) {//会员信息导出
            vc = [[LSMemberQueryViewController alloc] init:@""];
        } else if (noticeVo.businessType == 5) {//采购叫货单导出
            vc = [[PaperListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperSampleListView"] bundle:nil];
            PaperListView *paperVc = (PaperListView *)vc;
            paperVc.paperType = ORDER_PAPER_TYPE;
        } else if (noticeVo.businessType == 6) {//收货入库单导出
            vc = [[PaperListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperSampleListView"] bundle:nil];
            PaperListView *paperVc = (PaperListView *)vc;
            paperVc.paperType = PURCHASE_PAPER_TYPE;
        } else if (noticeVo.businessType == 7) {//退货出库单导出
            vc = [[PaperListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperSampleListView"] bundle:nil];
            PaperListView *paperVc = (PaperListView *)vc;
            paperVc.paperType = RETURN_PAPER_TYPE;
        } else if (noticeVo.businessType == 8) {//门店调拨单导出
            vc = [[PaperListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperSampleListView"] bundle:nil];
            PaperListView *paperVc = (PaperListView *)vc;
            paperVc.paperType = ALLOCATE_PAPER_TYPE;
        } else if (noticeVo.businessType == 9) {//客户采购单导出
            vc = [[PaperListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperSampleListView"] bundle:nil];
            PaperListView *paperVc = (PaperListView *)vc;
            paperVc.paperType = CLIENT_ORDER_PAPER_TYPE;
        } else if (noticeVo.businessType == 10) {//客户退货单导出
            vc = [[PaperListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperSampleListView"] bundle:nil];
            PaperListView *paperVc = (PaperListView *)vc;
            paperVc.paperType = CLIENT_RETURN_PAPER_TYPE;
        } else if (noticeVo.businessType == 11) {//库存调整单导出
            vc = [[LSStockAdjustListController alloc] init];
        } else if (noticeVo.businessType == 12) {//装箱单信息导出
            vc = [[ReturnPackBoxListView alloc] init];
            ReturnPackBoxListView *boxListView = (ReturnPackBoxListView *)vc;
            boxListView.isEdit = YES;
            boxListView.paperType = RETURN_PAPER_TYPE;
        } else if (noticeVo.businessType == 13) {//交接班记录导出
            vc = [[LSShiftRecordViewController alloc] init];
        } else if (noticeVo.businessType == 14) {//收款统计报表导出
            vc = [[LSShopCollectionController alloc] init];
        } else if (noticeVo.businessType == 15) {//员工业绩报表导出
            vc = [[LSEmployeePerformanceViewController alloc] init];
        } else if (noticeVo.businessType == 16) {//员工提成报表导出
            vc = [[LSEmployeeCommissionViewController alloc] init];
        } else if (noticeVo.businessType == 17) {//商品交易流水报表导出
            vc = [[LSGoodsTransactionFlowController alloc] init];
        } else if (noticeVo.businessType == 18) {//商品销售报表导出
            vc = [[LSGoodsSaleViewController alloc] init];
        } else if (noticeVo.businessType == 19) {//销售日报表导出
            vc = [[LSSaleProfitViewController alloc] init];
        } else if (noticeVo.businessType == 22) {//会员交易查询导出
            vc = [[LSMemberConsumeViewController alloc] init];
        } else if (noticeVo.businessType == 23) {//会员充值记录导出
            vc = [[LSMemberRechargeViewReportController alloc] init];
        } else if (noticeVo.businessType == 24) {//会员积分兑换导出
            vc = [[LSMemberIntergalViewController alloc] init];
        } else if (noticeVo.businessType == 25) {//库存查询导出
            vc = [[LSStockQueryViewController alloc] init];
        } else if (noticeVo.businessType == 26) {//库存汇总查询导出
            vc = [[LSStockSummaryViewController alloc] init];
        } else if (noticeVo.businessType == 27) {//退款订单导出
            vc = [[WeChatReturnMoneyManager alloc] initWithNibName:[SystemUtil getXibName:@"WeChatReturnMoneyManager"] bundle:nil];
        } else if (noticeVo.businessType == 28) {//导购员业绩目标导出
            vc = [[PerformanceGoalView alloc] init];
        } else if (noticeVo.businessType == 29) {//商品库存变更报表导出
            vc =[[LSStockChangeViewController alloc] init];
        } else if (noticeVo.businessType == 30) {//盘点记录导出
            return;
//            vc = [[GoodsCategoryListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperSampleListView"] bundle:nil fromViewTag:0];
        } else if (noticeVo.businessType == 31) {//库存盘点导出
            return;
//            vc = [[GoodsCategoryListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperSampleListView"] bundle:nil fromViewTag:0];
        } else if (noticeVo.businessType == 32) {//业绩目标信息导出
            return;
//            vc = [[GoodsCategoryListView alloc] initWithNibName:[SystemUtil getXibName:@"PaperSampleListView"] bundle:nil fromViewTag:0];
        } else if (noticeVo.businessType == 33) {//员工业绩导出
            vc = [[LSEmployeePerformanceViewController alloc] init];
        } else if (noticeVo.businessType == 35) {//会员卡操作记录报表导出
            vc = [[LSMemberCardOperateController alloc] init];
        } else if (noticeVo.businessType == 36) {//库存结存报表导出
            vc = [[LSStockBalanceViewController alloc] init];
        } else if (noticeVo.businessType == 37) {//供应商采购报表
            vc = [[LSSuppilerPurchaseViewController alloc] init];
        } else if (noticeVo.businessType == 38) {//商品采购报表
            vc = [[LSGoodsPurchaseViewController alloc] init];
        } else if (noticeVo.businessType == 39) {//成本价变更记录
            vc = [[LSCostChangeRecordViewController alloc] init];
        } else if (noticeVo.businessType == 42){//营业数据清理
            vc = [[LSDataClearController alloc] init];
        }
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    }

}


@end
