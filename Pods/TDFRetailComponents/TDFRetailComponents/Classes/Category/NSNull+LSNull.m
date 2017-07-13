//
//  NSNull+LSNull.m
//  retailapp
//
//  Created by guozhi on 2017/4/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "NSNull+LSNull.h"

@implementation NSNull (LSNull)
- (double)doubleValue {
    NSLog(@"%s", __func__);
    return 0;
}

- (double)intValue {
    NSLog(@"%s", __func__);
    return 0;
}

- (BOOL)isEqualToString:(NSString *)aString {
    NSLog(@"%s", __func__);
    if ((NSNull *)aString == [NSNull null]) {
        return YES;
    } else if (aString == nil) {
        return YES;
    } else {
        return NO;
    }
}

@end
