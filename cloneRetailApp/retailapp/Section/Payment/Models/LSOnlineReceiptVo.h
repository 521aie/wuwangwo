//
//  OnlineReceiptVo.h
//  retailapp
//
//  Created by guozhi on 16/5/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSOnlineReceiptVo : NSObject
/**
 *付款人会员ID
 */
@property (nonatomic, copy) NSString *customerId;
/**
 *第三方会员ID
 */
@property (nonatomic, copy) NSString *customerRegisterId;
/**
 *订单ID
 */
@property (nonatomic, copy) NSString *orderId;
/**
 *付款人
 */
@property (nonatomic, copy) NSString *payName;
/**
 *订单编号
 */
@property (nonatomic, copy) NSString *orderCode;
/**
 *实体ID
 */
@property (nonatomic, copy) NSString *entityId;
/**
 *付款时间
 */
@property (nonatomic, assign) long long payTime;
/**
 *付款人手机号
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *微信账单号
 */
@property (nonatomic, copy) NSString *weixinPayNo;
/**
 *分账状态 已到账/未到账
 */
@property (nonatomic, copy) NSString *statusMsg;
/**
 *支付金额 Double
 */
@property (nonatomic, assign) double payWx;
/**
 *  支付来源 String pay_for_order订单；pay_for_charge充值
 */
@property (nonatomic, copy) NSString *payFor;
/**
 * 充值方式 1=实体 2=微店
 */
@property (nonatomic, strong) NSNumber *channelType;

+ (instancetype)onlineReceiptVoWithMap:(NSDictionary *)map;
@end
