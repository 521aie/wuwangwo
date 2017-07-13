//
//  MallTransactionListVo.m
//  retailapp
//
//  Created by guozhi on 16/1/26.
//  Copyright (c) 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "MallTransactionListVo.h"

@implementation MallTransactionListVo
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
