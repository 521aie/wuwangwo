//
//  LSReportModuleController.m
//  retailapp
//
//  Created by guozhi on 2016/11/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#define REPORT_TYPE1 @"业绩报表"
#define REPORT_TYPE2 @"销售报表"
#define REPORT_TYPE3 @"会员报表"
//#define REPORT_TYPE4 @"库存报表"
#define REPORT_TYPE5 @"出入库报表"
#import "LSReportModuleController.h"
#import "NavigateTitle2.h"
#import "UIMenuAction.h"
#import "ActionConstants.h"
#import "AlertBox.h"
#import "LSMemberConsumeViewController.h"
#import "XHAnimalUtil.h"
#import "LSMemberRechargeViewReportController.h"
#import "LSMemberIntergalViewController.h"
#import "LSGoodsTransactionFlowController.h"
#import "LSSaleProfitViewController.h"
#import "LSStockChangeViewController.h"
#import "LSShiftRecordViewController.h"
#import "LSEmployeeCommissionViewController.h"
#import "HeaderItem.h"
#import "LSEmployeePerformanceViewController.h"
#import "LSShopCollectionController.h"
#import "LSGoodsSaleViewController.h"
#import "LSGoodsCategorySaleController.h"
#import "LSStockBalanceViewController.h"
#import "LSMemberCardOperateController.h"
#import "LSGoodsPurchaseViewController.h"
#import "LSSuppilerPurchaseViewController.h"
#import "LSMemberMeterCardController.h"

@interface LSReportModuleController ()

@end

@implementation LSReportModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"报表中心"];
    [self createDatas];
}

- (void)createDatas {
    self.map = [NSMutableDictionary dictionary];
    self.datas = [NSMutableArray array];
    [self.datas addObject:REPORT_TYPE1];
    [self.datas addObject:REPORT_TYPE2];
    [self.datas addObject:REPORT_TYPE3];
//    [self.datas addObject:REPORT_TYPE4];
    [self.datas addObject:REPORT_TYPE5];
    
    NSMutableArray *list = [NSMutableArray array];
    LSModuleModel *model = [LSModuleModel moduleModelWithName:@"交接班记录" detail:@"查询交接班记录" path:@"ico_nav_jiaojiebanjilu" code:ACTION_HANDOVER_SEARCH];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"收款统计报表" detail:@"查询收款统计明细" path:@"ico_nav_yuangongyejichaxun" code:ACTION_SHOP_RECEIPT_REPORT];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"员工业绩报表" detail:@"查询员工详细业绩" path:@"ico_nav_yuangongyejichaxun" code:ACTION_ACHIEVEMENT_REPORT];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"员工提成报表" detail:@"查询员工业绩提成" path:@"ico_nav_yuangongyejichaxun" code:ACTION_PERFORMANCE_SEARCH];
    [list addObject:model];
    [self.map setValue:list forKey:REPORT_TYPE1];
    
    list = [NSMutableArray array];
    model = [LSModuleModel moduleModelWithName:@"商品交易流水报表" detail:@"实时查询商品交易流水" path:@"ico_report_goodSale" code:ACTION_SELL_SEARCH];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"商品分类销售报表" detail:@"实时查询商品分类销售统计" path:@"ico_report_goodSale" code:ACTION_GOODS_CATEGORY_SALE];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"商品销售报表" detail:@"查询商品销售统计及收益" path:@"ico_report_goodSale" code:ACTION_GOODS_SELL_REPORT];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"销售收益报表" detail:@"查询店铺销售收益汇总" path:@"ico_report_dayReport" code:ACTION_REPORT_DAILY];
    [list addObject:model];
    [self.map setValue:list forKey:REPORT_TYPE2];    
    
    list = [NSMutableArray array];
    model = [LSModuleModel moduleModelWithName:@"会员消费记录" detail:@"查询会员交易信息" path:@"ico_report_huiyuanjiaoyi" code:ACTION_MEMBER_CONSUMPTION_SEARCH];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"储值充值记录" detail:@"查询储值充值记录" path:@"ico_nav_huiyuanchongzhi" code:ACTION_CARD_CHARGE_SEARCH];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"会员积分兑换记录" detail:@"查询会员积分兑换记录" path:@"ico_nav_jifenduihuan" code:ACTION_MEMBER_EXCHANGE_SEARCH];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"会员卡操作记录" detail:@"查询会员卡操作记录" path:@"report_member_card_operate" code:ACTION_CARD_OPERATE];
    [list addObject:model];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102 && [[Platform Instance] getShopMode] == 1) {
        model = [LSModuleModel moduleModelWithName:@"计次充值记录" detail:@"查询计次充值记录" path:@"ico_report_meterRecharge" code:ACTION_ACCOUNTCARD_CHARGE_SEARCH];
        [list addObject:model];
    }
    
    [self.map setObject:list forKey:REPORT_TYPE3];
    
//    list = [NSMutableArray array];
//    [self.map setValue:list forKey:REPORT_TYPE4];
    list = [NSMutableArray array];
    model = [LSModuleModel moduleModelWithName:@"商品采购报表" detail:@"查询商品的采购记录" path:@"report_goods_purchase" code:ACTION_STOCK_ORDER_REPORT];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"供应商采购报表" detail:@"查询供应商的采购记录" path:@"report_suppiler_purchase" code:ACTION_SUPPLY_ORDER_REPORT];
    [list addObject:model];

    model = [LSModuleModel moduleModelWithName:@"库存结存报表" detail:@"查询商品的库存结存情况" path:@"report_stock_balance" code:ACTION_STOCK_BALANCE_REPORT];
    [list addObject:model];
    
    [self.map setValue:list forKey:REPORT_TYPE5];
}

//点击单元格调用
- (void)showActionCode:(NSString *)code {
    UIViewController *vc;
    if ([code isEqualToString:ACTION_HANDOVER_SEARCH]) { //交接班记录
        vc = [[LSShiftRecordViewController alloc] init];
    } else if ([code isEqualToString:ACTION_SHOP_RECEIPT_REPORT]) {
        vc = [[LSShopCollectionController alloc] init];
    } else if ([code isEqualToString:ACTION_PERFORMANCE_SEARCH]) {//员工提成报表
        vc = [[LSEmployeeCommissionViewController alloc] init];
    }  else if ([code isEqualToString:ACTION_ACHIEVEMENT_REPORT]) {//员工业绩报表
        vc = [[LSEmployeePerformanceViewController alloc] init];
    } else if ([code isEqualToString:ACTION_MEMBER_CONSUMPTION_SEARCH]) { //会员消费记录
        vc = [[LSMemberConsumeViewController alloc] init];
    } else if ([code isEqualToString:ACTION_CARD_CHARGE_SEARCH]) { //储值充值记录
        vc = [[LSMemberRechargeViewReportController alloc] init];
    } else if ([code isEqualToString:ACTION_SELL_SEARCH]){ //商品交易流水报表
        vc = [[LSGoodsTransactionFlowController alloc] init];
    } else if ([code isEqualToString:ACTION_GOODS_CATEGORY_SALE]){ //商品分类销售报表
        vc = [[LSGoodsCategorySaleController alloc] init];
    } else if ([code isEqualToString:ACTION_GOODS_SELL_REPORT]){ //商品销售报表
        vc = [[LSGoodsSaleViewController alloc] init];
    } else if ([code isEqualToString:ACTION_REPORT_DAILY]){
        vc = [[LSSaleProfitViewController alloc] init];
    } else if([code isEqualToString:ACTION_MEMBER_EXCHANGE_SEARCH]) { //会员积分兑换
        vc = [[LSMemberIntergalViewController alloc] init];
    } else if([code isEqualToString:ACTION_CARD_OPERATE]) { //会员卡操作
        vc = [[LSMemberCardOperateController alloc] init];
    } else if([code isEqualToString:ACTION_STOCK_BALANCE_REPORT]) { //库存结存报表
        vc = [[LSStockBalanceViewController alloc] init];
    } else if([code isEqualToString:ACTION_STOCK_ORDER_REPORT]) { //商品采购报表
        vc = [[LSGoodsPurchaseViewController alloc] init];
    } else if([code isEqualToString:ACTION_SUPPLY_ORDER_REPORT]) { //供应商采购报表
        vc = [[LSSuppilerPurchaseViewController alloc] init];
    }else if([code isEqualToString:ACTION_ACCOUNTCARD_CHARGE_SEARCH]) { //计次充值记录
        vc = [[LSMemberMeterCardController alloc] init];
    }
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

@end
