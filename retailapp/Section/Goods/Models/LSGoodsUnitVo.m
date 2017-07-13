//
//  LSGoodsUnitVo.m
//  retailapp
//
//  Created by guozhi on 16/7/15.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsUnitVo.h"

@implementation LSGoodsUnitVo
- (id)initWithDictionary:(NSDictionary *)jsonObject
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:jsonObject];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (instancetype)goodsUnitVoWithMap:(NSDictionary *)map {
    LSGoodsUnitVo *goodsUnitVo = [[LSGoodsUnitVo alloc] initWithDictionary:map];
    return goodsUnitVo;
}
@end
