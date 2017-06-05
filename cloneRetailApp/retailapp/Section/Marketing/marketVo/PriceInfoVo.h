//
//  PriceInfoVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface PriceInfoVo : Jastor

/**
 * <code>特价ID</code>.
 */
@property (nonatomic, strong) NSString *priceId;

/**
 * <code>商品名称</code>.
 */
@property (nonatomic, strong) NSString *goodsName;

/**
 * <code>商品图片</code>.
 */
@property (nonatomic, strong) NSString *goodsPic;

/**
 * <code>商品ID</code>.
 */
@property (nonatomic, strong) NSString *goodsId;

/**
 * <code>商品代码</code>.
 */
@property (nonatomic, strong) NSString *innerCode;

/**
 * <code>商品条码</code>.
 */
@property (nonatomic, strong) NSString *barCode;

/**
 * <code>款式ID</code>.
 */
@property (nonatomic, strong) NSString *styleId;

/**
 * <code>款式名称</code>.
 */
@property (nonatomic, strong) NSString *styleName;

/**
 * <code>款号</code>.
 */
@property (nonatomic, strong) NSString *styleCode;

/**
 * <code>款式图片</code>.
 */
@property (nonatomic, strong) NSString *stylePic;

/**
 * <code>特价</code>.
 */
@property (nonatomic) double price;

/**
 * <code>折扣率</code>.
 */
@property (nonatomic) double discount;

/**
 * <code>零售价</code>.
 */
@property (nonatomic) double retailPrice;

/**
 * <code>吊牌价</code>.
 */
@property (nonatomic) double hangTagPrice;

/**
 * <code>商品Sku属性列表</code>.
 */
@property (nonatomic, strong) NSMutableArray *goodsSkuList;

+(PriceInfoVo*)convertToPriceInfoVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(PriceInfoVo *)priceInfoVo;
+ (NSMutableArray *)converToArr:(NSArray*)sourceList;

@end
