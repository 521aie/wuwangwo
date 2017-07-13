//
//  SalesMatchRuleSendVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface SalesMatchRuleSendVo : Jastor

/**
 * <code>满送换购ID</code>.
 */
@property (nonatomic, strong) NSString *fullSendId;

/**
 * <code>促销ID</code>.
 */
@property (nonatomic, strong) NSString *salesId;

/**
 * <code>促销名称</code>.
 */
@property (nonatomic, strong) NSString *name;

/**
 * <code>购买金额</code>.
 */
@property (nonatomic, strong) NSNumber *amountCondition;

/**
 * <code>购买商品数量</code>.
 */
@property (nonatomic, strong) NSNumber *goodsNumber;

/**
 * <code>购买组合方式</code>.
 */
@property (nonatomic) NSInteger groupType;

/**
 * <code>附加金额</code>.
 */
@property (nonatomic) double additionAmount;

/**
 * <code>商品使用范围</code>.
 */
@property (nonatomic) short goodsScope;

/**
 * <code>赠送数量</code>.
 */
@property (nonatomic) NSInteger giveNumber;

/**
 * <code>最多赠送数量</code>.
 */
@property (nonatomic, strong) NSNumber *maxGiveNumber;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

/**
 * <code>包含款数</code>.
 */
@property (nonatomic) NSInteger containStyleNum;

+(SalesMatchRuleSendVo*)convertToSalesMatchRuleSendVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(SalesMatchRuleSendVo *)salesMatchRuleSendVo;

+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
