//
//  SalesBindDiscountVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface SalesBindDiscountVo : Jastor

/**
 * <code>第N件折扣ID</code>.
 */
@property (nonatomic, strong) NSString *bindDiscountId;

/**
 * <code>促销ID</code>.
 */
@property (nonatomic, strong) NSString *salesId;

/**
 * <code>促销名称</code>.
 */
@property (nonatomic, strong) NSString *name;

/**
 * <code>折扣的商品件数</code>.
 */
@property (nonatomic) NSInteger goodsCount;

/**
 * <code>购买组合方式</code>.
 */
@property (nonatomic) NSInteger groupType;

/**
 * <code>商品使用范围</code>.
 */
@property (nonatomic) short goodsScope;

/**
 * <code>商品折扣信息vo列表</code>.
 */
@property (nonatomic, strong) NSMutableArray *discountVoList;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

/**
 * <code>包含款数</code>.
 */
@property (nonatomic) NSInteger containStyleNum;

+(SalesBindDiscountVo*)convertToSalesBindDiscountVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(SalesBindDiscountVo *)salesBindDiscountVo;

+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
