//
//  MemberIntegralDetailCellVo.m
//  retailapp
//
//  Created by 叶在义 on 15/10/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberIntegralDetailCellVo.h"

@implementation MemberIntegralDetailCellVo
- (instancetype)initWIthDictionary:(NSDictionary *)json {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
