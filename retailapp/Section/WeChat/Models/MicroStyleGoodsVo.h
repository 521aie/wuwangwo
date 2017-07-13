//
//  MicroStyleGoodsVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface MicroStyleGoodsVo : Jastor

/**
 * <code>商品id</code>.
 */
@property (nonatomic, strong) NSString *goodsId;

/**
 * <code>微店售价</code>.
 */
@property (nonatomic) double microPrice;

/**
 * <code>颜色</code>.
 */
@property (nonatomic, strong) NSString *color;

/**
 * <code>尺寸</code>.
 */
@property (nonatomic, strong) NSString *size;

/**
 * <code>店内码</code>.
 */
@property (nonatomic, strong) NSString *innerCode;

+(MicroStyleGoodsVo*)convertToMicroStyleGoodsVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(MicroStyleGoodsVo *)microStyleGoodsVo;

@end
