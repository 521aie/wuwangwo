//
//  ReportService.h
//  retailapp
//
//  Created by 果汁 on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportService : NSObject
//会员交易信息查询
- (void)customerDealList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员交易流水
- (void)dealDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员充值记录查询
- (void)rechargeList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员充值记录详情
- (void)rechargeDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员积分兑换记录查询
- (void)exchangeList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员积分兑换记录查询
- (void)exchangeDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//员工交接班一览
- (void)shiftList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**交接班明细*/
- (void)shiftDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**角色一览*/
- (void)roleList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**员工提成报表一览*/
- (void)userList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**员工提成报表详情*/
- (void)userDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


/**员工业绩一览*/
- (void)employeePerformanceList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**手动生成员工提成*/
- (void)mannuallyReport:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**手动生成员工业绩*/
- (void)mannuallyGeneratedEmp:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**手动生成员工提成check*/
- (void)mannuallyReportCheck:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**手动生成员工业绩check*/
- (void)mannuallyGeneratedEmpCheck:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//microShop/selectDistributionStrategy

/**获取销售方式列表*/
- (void)getSaleDic:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**商品销售明细一览*/
- (void)orderList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**商品销售明细*/
- (void)orderDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**商品供货明细一览*/
- (void)orderSupplyList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**商品供货明细详情*/
- (void)orderSupplyDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**查询销售报表汇总*/
- (void)reportTotal:(NSMutableDictionary *)param dayOrMonth:(NSString *)dayOrMonth CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**查询销售报表手工导出*/
- (void)reportTotalManuallyExport:(NSMutableDictionary *)param dayOrMonth:(NSString *)dayOrMonth CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**查询销售报表手工导出check*/
- (void)reportTotalManuallyExportCheck:(NSDictionary *)param dayOrMonth:(NSString *)dayOrMonth CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**商品库存一览*/
- (void)stockChangeLogGoods:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**商品库存变更详情*/
- (void)stockLogGoodsDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**获得交易商圈信息*/
- (void)getTransactionMall:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**商圈卡交易记录列表*/
- (void)getMallCardTransactionList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  查询门店收款报表列表
 *
 *  @param param           包含门店id、开始时间、结束时间
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectCashierReport:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  门店收款报表详情
 *
 *  @param param           门店id、日期、结束时间、支付类型id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectCashierReportDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  查询商品销售报表列表
 *
 *  @param param           包含门店id、开始时间、结束时间、当前页
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectGoodsRetailReport:(NSDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**查询供货日报表*/
- (void)getSupplyReportData:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**供货日报表报表手工导出check*/
- (void)supplyDailyExportCheck:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**供货日报表手工导出*/
- (void)supplyDailyExport:(NSMutableDictionary *)param  CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
@end
