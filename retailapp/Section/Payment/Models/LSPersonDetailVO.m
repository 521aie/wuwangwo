//
//  LSPersonDetailVO.m
//  retailapp
//
//  Created by guozhi on 16/5/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPersonDetailVO.h"


@implementation LSPersonDetailVO

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

+ (instancetype)personDetailVOWithMap:(NSDictionary *)map {
    LSPersonDetailVO *personDetailVO = [[LSPersonDetailVO alloc] initWithDictionary:map];
    return personDetailVO;
}


@end
