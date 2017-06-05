//
//  ESPShopIntro.m
//  retailapp
//
//  Created by qingmei on 15/12/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ESPShopIntro.h"

@implementation ESPShopIntro
- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}
@end
