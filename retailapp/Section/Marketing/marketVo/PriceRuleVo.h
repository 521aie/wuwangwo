//
//  PriceRuleVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface PriceRuleVo : Jastor

/**
 * <code>特价ID</code>.
 */
@property (nonatomic, strong) NSString *priceId;

/**
 * <code>是否会员专享</code>.
 */
@property (nonatomic) short isMember;

/**
 * <code>适用实体门店</code>.
 */
@property (nonatomic) short isShop;

/**
 * <code>适用微店</code>.
 */
@property (nonatomic) short isWeiXin;

/**
 * <code>特价方案</code>.
 */
@property (nonatomic) short saleScheme;

/**
 * <code>价格方案</code>.
 */
@property (nonatomic) short shopPriceScheme;

/**
 * <code>折扣率</code>.
 */
@property (nonatomic) double discountRate;

/**
 * <code>特价</code>.
 */
@property (nonatomic) double salePrice;

/**
 * <code>开始时间</code>.
 */
@property (nonatomic) long long startTime;

/**
 * <code>结束时间</code>.
 */
@property (nonatomic) long long endTime;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

+(PriceRuleVo*)convertToPriceRuleVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(PriceRuleVo *)priceRuleVo;

@end
