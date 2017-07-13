//
//  OrderPayListData.m
//  RestApp
//
//  Created by 果汁 on 15/9/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderPayListData.h"

@implementation OrderPayListData

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
@end
