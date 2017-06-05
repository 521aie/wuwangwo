//
//  GoodsSkuVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface GoodsSkuVo : Jastor

/**
 * <code>属性名id</code>.
 */
@property (nonatomic, strong) NSString *attributeNameId;

/**
 * <code>属性名</code>.
 */
@property (nonatomic, strong) NSString *attributeName;

/**
 * <code>属性值id</code>.
 */
@property (nonatomic, strong) NSString *attributeValId;

/**
 * <code>属性值code</code>.
 */
@property (nonatomic, strong) NSString *attributeCode;

/**
 * <code>属性值</code>.
 */
@property (nonatomic, strong) NSString *attributeVal;

/**
 * <code>sku值</code>.
 */
@property (nonatomic, strong) NSString *skuVal;

/**
 * <code>属性区分</code>.
 */
@property (nonatomic) short attributeType;

+(GoodsSkuVo*)convertToGoodsSkuVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(GoodsSkuVo *)goodsSkuVo;

+ (NSMutableArray *)convertToDicListFromArr:(NSMutableArray *)array;

@end
