//
//  MicroRelevancePriceVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface MicroRelevancePriceVo : Jastor

/**
 * <code>商品ID</code>.
 */
@property (nonatomic, strong) NSString *goodsId;

/**
 * <code>最低销售折扣率</code>.
 */
@property (nonatomic, strong) NSNumber *minSaleDiscountRate;

/**
 * <code>最高供货折扣率</code>.
 */
@property (nonatomic, strong) NSNumber *maxSupplyDiscountRate;

/**
 * <code>款式名</code>.
 */
@property (nonatomic, strong) NSString *styleName;

/**
 * <code>款号</code>.
 */
@property (nonatomic, strong) NSString *styleCode;

/**
 * <code>商品店内码</code>.
 */
@property (nonatomic, strong) NSString *innerCode;

+(MicroRelevancePriceVo*)convertToMicroRelevancePriceVo:(NSDictionary*)dic;

@end
