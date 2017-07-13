//
//  NSMutableArray+DeepCopy.m
//  RestApp
//
//  Created by zxh on 14-4-25.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "NSMutableArray+DeepCopy.h"

@implementation NSMutableArray (DeepCopy)

-(NSMutableArray*) deepCopy
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (id value in self) {
        id oneCopy = nil;
        oneCopy = [value copy];
        [ret addObject: oneCopy];
    }
    return ret;
}

@end
