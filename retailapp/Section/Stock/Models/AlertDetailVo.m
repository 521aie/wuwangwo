//
//  AlertDetailVo.m
//  retailapp
//
//  Created by guozhi on 15/11/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertDetailVo.h"

@implementation AlertDetailVo
- (instancetype)initWithDictionary:(NSDictionary *)json {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
