//
//  OrderReportDetailVo.m
//  retailapp
//
//  Created by qingmei on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderReportDetailVo.h"

@implementation OrderReportDetailVo
- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        
    } else {
        [super setValue:value forKey:key];
    }
}


@end
