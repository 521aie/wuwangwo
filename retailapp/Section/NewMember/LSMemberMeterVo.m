//
//  LSMemberMeterVo.m
//  retailapp
//
//  Created by wuwangwo on 2017/3/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberMeterVo.h"

@implementation LSMemberMeterVo
+ (instancetype)meterVoWithDict:(NSDictionary *)dict {
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
    if ([key isEqualToString:@"goodsList"]) {
        self.goodsList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:value]) {
            for (NSDictionary *obj in value) {
                LSMemberMeterGoodsVo *oldVo = [LSMemberMeterGoodsVo meterGoodsVoWithDict:obj];
                [self.goodsList addObject:oldVo];
            }
        }
    } else {
        [super setValue:value forKey:key];
    }
}

@end
