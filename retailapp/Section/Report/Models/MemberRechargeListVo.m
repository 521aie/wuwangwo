//
//  MemberRechargeListVo.m
//  retailapp
//
//  Created by guozhi on 15/10/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberRechargeListVo.h"

@implementation MemberRechargeListVo
- (instancetype)initWithDictionary:(NSDictionary *)json {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.orderId = value;
    } else {
        [super setValue:value forKey:key];
    }
}
@end
