//
//  ReturnGuideListVo.m
//  retailapp
//
//  Created by guozhi on 15/11/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReturnGuideListVo.h"

@implementation ReturnGuideListVo
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
