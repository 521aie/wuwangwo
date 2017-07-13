//
//  GoodsBrandVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface GoodsBrandVo : Jastor

/**
 * <code>主键</code>.
 */
@property (nonatomic, strong) NSString *goodsBrandId;

/**
 * <code>品牌编码</code>.
 */
@property (nonatomic, strong) NSString *code;

/**
 * <code>顺序码</code>.
 */
@property (nonatomic) NSInteger sortCode;

/**
 * <code>品牌名称</code>.
 */
@property (nonatomic, strong) NSString *name;

/**
 * <code>品牌拼音</code>.
 */
@property (nonatomic, strong) NSString *spell;

/**
 * <code>备注</code>.
 */
@property (nonatomic, strong) NSString *memo;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

+(GoodsBrandVo*)convertToGoodsBrandVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(GoodsBrandVo *)goodsBrandVo;

@end
