//
//  OnlineChargeVo.h
//  retailapp
//
//  Created by guozhi on 16/6/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlineChargeVo : NSObject
/**
 * 会员卡编号
 */
@property (nonatomic, copy) NSString *cardNo;
/**
 * 充值流水号
 */
@property (nonatomic, copy) NSString *serialNo;
/**
 * 支付方式
 */
@property (nonatomic, assign) Byte payMode;
/**
 * 充值时间
 */
@property (nonatomic, assign) long long createTime;
/**
 * 支付金额 BigDecimal
 */
@property (nonatomic, assign) NSNumber *pay;
/**
 * 赠送金额 BigDecimal
 */
@property (nonatomic, strong) NSNumber *free_rule;
/**
 * 赠送积分 Integer
 */
@property (nonatomic, strong) NSNumber *free_degree;
/**
 * 充值方式 1=实体 2=微店
 */
@property (nonatomic, strong) NSNumber *channelType;
/**
 * 操作人
 */
@property (nonatomic, copy) NSString *operatorName;
/**
 * 操作人ID
 */
@property (nonatomic, copy) NSString *operatorId;
/**
 * 操作人工号
 */
@property (nonatomic, copy) NSString *operatorNo;
/**
 * 计次服务名称
 */
@property (nonatomic, copy) NSString *accountCardName;

+ (instancetype)onlineChargeVoWithMap:(NSDictionary *)map;

@end
