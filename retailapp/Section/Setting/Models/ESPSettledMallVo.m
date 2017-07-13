//
//  SettledMallVo.m
//  retailapp
//
//  Created by qingmei on 15/12/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ESPSettledMallVo.h"

@implementation ESPSettledMallVo
- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

//特殊字段处理
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.Id = (NSNumber *)value;
    }else if ([key isEqualToString:@"imageVoList"]){
//        self.imageVoList = [[NSMutableArray alloc]init];
        self.imageVoList = (NSMutableArray *)value;
    }
    else{
        [super setValue:value forKey:key];
    }
    
}
//防止有找不到的字段导致闪退
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end
