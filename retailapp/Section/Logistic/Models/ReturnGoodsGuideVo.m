//
//  ReturnGoodsGuideVo.m
//  retailapp
//
//  Created by guozhi on 15/11/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReturnGoodsGuideVo.h"
#import "ReturnGuideListVo.h"
@implementation ReturnGoodsGuideVo
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
    if ([key isEqualToString:@"returnGoodsGuideVoList"]) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in value) {
            ReturnGuideListVo *returnGuideListVo = [[ReturnGuideListVo alloc] initWithDictionary:obj];
            [arr addObject:returnGuideListVo];
        }
        self.returnGuideListVos = arr;
    } else {
        [super setValue:value forKey:key];
    }
}
@end
