//
//  LSSaleRevenueSummaryVo.h
//  retailapp
//
//  Created by guozhi on 2016/12/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSaleRevenueSummaryVo : NSObject
/** 日期 */
@property (nonatomic, copy) NSString *currDate;
/** 门店编号 */
@property (nonatomic, copy) NSString *shopCode;
/** 门店名称 */
@property (nonatomic, copy) NSString *shopName;
/** 销售数量 */
@property (nonatomic, strong) NSNumber *saleNum;
/** 销售单数 */
@property (nonatomic, strong) NSNumber *saleCount;
/** 销售金额 */
@property (nonatomic, strong) NSNumber *saleAmount;
/** 退货数量 */
@property (nonatomic, strong) NSNumber *returnNum;
/** 退货单数 */
@property (nonatomic, strong) NSNumber *returnCount;
/** 退货金额 */
@property (nonatomic, strong) NSNumber *returnAmount;
/** 配送费 */
@property (nonatomic, strong) NSNumber *outFee;
/** 净销售额 */
@property (nonatomic, strong) NSNumber *netSales;
/** 销售成本 */
@property (nonatomic, strong) NSNumber *sellCost;
/** 销售毛利 */
@property (nonatomic, strong) NSNumber *sellProfit;
/** 毛利率 */
@property (nonatomic, strong) NSNumber *profit;

@end
