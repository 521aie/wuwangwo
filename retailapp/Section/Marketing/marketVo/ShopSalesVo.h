//
//  ShopSalesVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface ShopSalesVo : Jastor

/**
 * <code>商户促销关联ID</code>.
 */
@property (nonatomic, strong) NSString *shopSaleId;

/**
 * <code>促销D</code>.
 */
@property (nonatomic, strong) NSString *salesId;

/**
 * <code>商户D</code>.
 */
@property (nonatomic, strong) NSString *shopId;

/**
 * <code>商户名称</code>.
 */
@property (nonatomic, strong) NSString *shopName;

/**
 * <code>商户促编码</code>.
 */
@property (nonatomic, strong) NSString *shopCode;

+(ShopSalesVo*)convertToShopSalesVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(ShopSalesVo *)shopSalesVo;

+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
