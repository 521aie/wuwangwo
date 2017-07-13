//
//  ReportService.m
//  retailapp
//
//  Created by 果汁 on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReportService.h"

@implementation ReportService

//会员消费记录查询
- (void)customerDealList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customerDeal/dealList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//会员交易流水
- (void)dealDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customerDeal/dealDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//会员充值记录查询
- (void)rechargeList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"RechargeRecord/v1/selectRechargeRecordList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//会员充值记录详情
- (void)rechargeDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"RechargeRecord/selectRechargeRecordDetails"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//会员积分兑换记录查询
- (void)exchangeList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customerExchange/exchangeList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//会员积分兑换记录查询
- (void)exchangeDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customerExchange/exchangeDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//员工交接班一览
- (void)shiftList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"changeShifts/v1/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**交接班明细*/
- (void)shiftDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"changeShifts/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**角色一览*/
- (void)roleList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"roleAction/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**员工提成报表一览*/
- (void)userList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"userRoyalties/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**员工提成报表详情*/
- (void)userDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"userRoyalties/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**员工业绩一览*/
- (void)employeePerformanceList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"employeePerformance/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


/**手动生成员工提成*/
- (void)mannuallyReport:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"userRoyalties/manuallyGeneratedRoyaltiesReport"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}

/**手动生成员工业绩*/
- (void)mannuallyGeneratedEmp:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"employeePerformance/manuallyGeneratedEmpReport"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}

/**手动生成员工提成check*/
- (void)mannuallyReportCheck:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"userRoyalties/manuallyGeneratedRoyaltiesCheck"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**手动生成员工业绩check*/
- (void)mannuallyGeneratedEmpCheck:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"employeePerformance/manuallyGeneratedEmpCheck"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**获取销售方式列表*/
- (void)getSaleDic:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microShop/selectDistributionStrategy"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
/**商品销售明细一览*/
- (void)orderList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderDetailsReport/getOrderList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**商品供货明细一览*/
- (void)orderSupplyList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderSupplyReport/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**商品供货明细详情*/
- (void)orderSupplyDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderSupplyReport/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


/**商品销售明细*/
- (void)orderDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderDetailsReport/getDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


/**查询销售报表汇总*/
- (void)reportTotal:(NSMutableDictionary *)param dayOrMonth:(NSString *)dayOrMonth CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url;
    if ([dayOrMonth isEqualToString:@"day"]) {
        url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"dayReport/v1/getDayReportData"];
    }else if ([dayOrMonth isEqualToString:@"month"]){
        url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"monthReport/getMonthReportData"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
/**查询销售报表手工导出*/
- (void)reportTotalManuallyExport:(NSMutableDictionary *)param dayOrMonth:(NSString *)dayOrMonth CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url;
    if ([dayOrMonth isEqualToString:@"day"]) {
        url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"dayReport/manuallyGeneratedDailyReport"];
    }else if ([dayOrMonth isEqualToString:@"month"]){
        url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"monthReport/manuallyGeneratedMonthlyReport"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}
/**查询销售报表手工导出check*/
- (void)reportTotalManuallyExportCheck:(NSDictionary *)param dayOrMonth:(NSString *)dayOrMonth CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url;
    if ([dayOrMonth isEqualToString:@"day"]) {
        url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"dayReport/manuallyGeneratedDailyCheck"];
    }else if ([dayOrMonth isEqualToString:@"month"]){
        url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"monthReport/manuallyGeneratedMonthlyCheck"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**商品库存一览*/
- (void)stockChangeLogGoods:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockChangeLog/getStockChangeLogGoods"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
/**商品库存变更详情*/
- (void)stockLogGoodsDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockChangeLog/getStockLogGoodsDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**查询门店收款报表列表*/
- (void)selectCashierReport:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"shopCashierReport/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

/**门店收款报表详情*/
- (void)selectCashierReportDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"shopCashierReport/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}
/**商品销售报表列表*/
- (void)selectGoodsRetailReport:(NSDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goodsSalesReport/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

/**获得交易商圈信息*/
- (void)getTransactionMall:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"settledMall/getEntityInfoForShop"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

/**商圈卡交易记录列表*/
- (void)getMallCardTransactionList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customerDeal/mallTransList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

/**查询供货日报表*/
- (void)getSupplyReportData:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"supplyDayReport/getSupplyReportData"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**供货日报表报表手工导出check*/
- (void)supplyDailyExportCheck:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url  = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"supplyDayReport/manuallyGenerateReportCheck"];;
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**供货日报表手工导出*/
- (void)supplyDailyExport:(NSMutableDictionary *)param  CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"supplyDayReport/manuallyGenerateReport"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}



@end
