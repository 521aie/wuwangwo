//
//  LSGoodsHandleVo.m
//  retailapp
//
//  Created by guozhi on 16/2/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsHandleVo.h"
@implementation LSOldGoodsVo
+ (instancetype)oldGoodsVoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end



@implementation LSGoodsHandleVo

+ (instancetype)goodsHandleVoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"newGoodsId"]) {
        self.goodsId = value;
    } else if ([key isEqualToString:@"newGoodsNum"]) {
        self.goodsNum = value;
    } else if ([key isEqualToString:@"newGoodsBarCode"]) {
        self.goodsBarCode = value;
    } else if ([key isEqualToString:@"newGoodsName"]) {
        self.goodsName = value;
    } else if ([key isEqualToString:@"oldGoodsList"]) {
        self.oldGoodsList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:value]) {
            for (NSDictionary *obj in value) {
                LSOldGoodsVo *oldVo = [LSOldGoodsVo oldGoodsVoWithDict:obj];
                [self.oldGoodsList addObject:oldVo];
            }
        }
    } else {
        [super setValue:value forKey:key];
    }
}
@end
