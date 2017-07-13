//
//  DiscountGoodsVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface DiscountGoodsVo : Jastor

/**
 * <code>第N件折扣ID</code>.
 */
@property (nonatomic, strong) NSString *discountId;

/**
 * <code>所属实体</code>.
 */
@property (nonatomic, strong) NSString *npiecesDiscountId;

/**
 * <code>折扣率</code>.
 */
@property (nonatomic) double rate;

/**
 * <code>购买商品数量</code>.
 */
@property (nonatomic) NSInteger count;

/**
 * <code>顺序码</code>.
 */
@property (nonatomic) NSInteger sortCode;

+(DiscountGoodsVo*)convertToDiscountGoodsVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(DiscountGoodsVo *)discountGoodsVo;

+ (NSMutableArray*)converToDicArr:(NSArray*)voList;

@end
