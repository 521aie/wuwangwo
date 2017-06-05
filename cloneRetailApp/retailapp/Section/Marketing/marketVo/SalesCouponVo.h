//
//  SalesCouponVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface SalesCouponVo : Jastor

/**
 * <code>优惠券ID</code>.
 */
@property (nonatomic, strong) NSString *couponRuleId;

/**
 * <code>优惠券名称</code>.
 */
@property (nonatomic, strong) NSString *name;

/**
 * <code>发券数量</code>.
 */
@property (nonatomic) NSInteger number;

/**
 * <code>促销ID</code>.
 */
@property (nonatomic, strong) NSString *salesId;

/**
 * <code>面额</code>.
 */
@property (nonatomic) double worth;

/**
 * <code>出券金额条件</code>.
 */
@property (nonatomic, strong) NSNumber *couponCreateFee;

/**
 * <code>出券数量条件</code>.
 */
@property (nonatomic, strong) NSNumber *couponCreateNumber;

/**
 * <code>使用金额条件</code>.
 */
@property (nonatomic, strong) NSNumber *couponUseFee;

/**
 * <code>使用数量条件</code>.
 */
@property (nonatomic, strong) NSNumber *couponUseNumber;

/**
 * <code>购买组合方式</code>.
 */
@property (nonatomic) short groupType;

/**
 * <code>使用商品范围</code>.
 */
@property (nonatomic) short userGoodsScope;

/**
 * <code>出券商品范围</code>.
 */
@property (nonatomic) short generateGoodsScope;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

/**
 * <code>包含款数</code>.
 */
@property (nonatomic) NSInteger containStyleNum;

/**
 * <code>开始日期</code>.
 */
@property (nonatomic) long long startDate;

/**
 * <code>结束日期</code>.
 */
@property (nonatomic) long long endDate;

/**
 * <code>优惠券说明</code>.
 */
@property (nonatomic, strong) NSString *remark;

/**
 * <code>是否正在进行中</code>.
 */
@property (nonatomic) short isDoingAct;

+(SalesCouponVo*)convertToSalesCouponVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(SalesCouponVo *)salesCouponVo;

+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
