//
//  OnlineChargeVo.m
//  retailapp
//
//  Created by guozhi on 16/6/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OnlineChargeVo.h"

@implementation OnlineChargeVo
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

+ (instancetype)onlineChargeVoWithMap:(NSDictionary *)map {
    OnlineChargeVo *onlineChargeVo = [[OnlineChargeVo alloc] initWithDictionary:map];
    return onlineChargeVo;
}

@end
