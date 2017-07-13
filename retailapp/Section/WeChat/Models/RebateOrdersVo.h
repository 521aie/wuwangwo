//
//  RebateOrdersVo.h
//  retailapp
//
//  Created by diwangxie on 16/5/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderInfoVo.h"

@interface RebateOrdersVo : NSObject

@property (nonatomic) NSInteger id;

@property (nonatomic) double  rebateOrderFee;//列表也要传

@property (nonatomic) short   rebateState; //列表也要传

@property (nonatomic) NSNumber  *marginProfit;//(余利)

@property (nonatomic) NSNumber  *rebateFee;//(返利)

@property (nonatomic) NSNumber  *supplyFee;//(供货)

@property (nonatomic) NSNumber  *returnFee;//(退款)

@property (nonatomic) NSNumber  *weiPlatformFee;//(微平台)

@property (nonatomic) long long createTime;

//订单部分
@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,copy) NSString * orderCode; //(销售订单或供货订单)  列表也要传

@property (nonatomic) short orderState; //列表也要传

@property (nonatomic,strong) NSMutableArray *instances; //订单详情



@property (nonatomic) double orderTotalFee; //订单最终总价

@property (nonatomic) double outFee;//配送费



@property (nonatomic,strong) NSString *outType; //订单来源

@property (nonatomic) short orderKind; //配送方式

@property (nonatomic) short payMode; //支付方式

@property (nonatomic) long long openTime; //订单时间（下单时间）列表也要传


+(RebateOrdersVo *)convertToRebateOrdersVo:(NSDictionary*)dic;

+(NSDictionary*)getDictionaryData:(RebateOrdersVo *)rebateOrdersVo;
@end
