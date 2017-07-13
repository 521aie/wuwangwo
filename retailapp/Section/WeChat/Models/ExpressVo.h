//
//  ExpressVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/10/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface ExpressVo : Jastor

/**
 * <code>Id</code>.
 */
@property (nonatomic, strong) NSString *id;

/**
 * <code>实体Id</code>.
 */
@property (nonatomic, strong) NSString *entityId;

/**
 * <code>门店ID</code>.
 */
@property (nonatomic, strong) NSString *shopId;

/**
 * <code>配送费用</code>.
 */
@property (nonatomic) double sendCost;

/**
 * <code>配送范围门店ID</code>.
 */
@property (nonatomic, strong) NSString *sendRange;

/**
 * <code>配送时间</code>.
 */
@property (nonatomic, strong) NSString *sendTime;

/**
* <code>预约时间</code>.
*/
@property (nonatomic, strong) NSString *reservationTime;

/**
 * <code>是否允许上门自提</code>.
 */
@property (nonatomic) short isSelfPickUp;

/**
 * <code>配送类型</code>.
 */
@property (nonatomic) short sendType;

/**
 * <code>配送类型名称</code>.
 */
@property (nonatomic, strong) NSString *sendTypeName;

/**
 * <code>快递公司</code>.
 */
@property (nonatomic) int logisticsCompany;

/**
 * <code>快递公司名称</code>.
 */
@property (nonatomic, strong) NSString *logisticsCompanyName;

/**
 * <code>配送策略</code>.
 */
@property (nonatomic) short sendStrategy;

/**
 * <code>配送策略名称</code>.
 */
@property (nonatomic, strong) NSString *sendStrategyName;

/**
 * <code>是否包邮</code>.
 */
@property (nonatomic) short isFreeShipping;

/**
 * <code>是否允许配送到家</code>.
 */
@property (nonatomic) short isSendHome;

/**
 * <code>是否包邮名称</code>.
 */
@property (nonatomic, strong) NSString *isFreeShippingName;

/**
 * <code>包邮条件</code>.
 */
@property (nonatomic) int freeShippingType;

/**
 * <code>包邮条件名称</code>.
 */
@property (nonatomic, strong) NSString *freeShippingTypeName;

/**
 * <code>包邮件数</code>.
 */
@property (nonatomic) int freeShippingCount;

/**
 * <code>包邮金额</code>.
 */
@property (nonatomic) double freeShippingMoney;

/**
 * <code>起送费用</code>.
 */
@property (nonatomic) double sendStartMoney;

/**
 * <code>免费配送</code>.
 */
@property (nonatomic) short isFreeSend;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) long lastVer;

/**
 * <code>操作人</code>.
 */
@property (nonatomic, strong) NSString *opUserId;

@end

