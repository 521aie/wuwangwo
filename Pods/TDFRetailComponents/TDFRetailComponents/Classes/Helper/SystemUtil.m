//
//  SystemUtil.m
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "sys/utsname.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"

@implementation SystemUtil


+ (void)hideKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


+ (NSString *)getXibName:(NSString *)xibName
{
    if ([ObjectUtil isNotNull:xibName]) {
        NSString *device = [[self class] getDeviceName];
        if ([@"iPhone 5" isEqualToString:device]) {
            return [xibName stringByAppendingFormat:@"5"];
        }
    }
    return xibName;
}

+ (NSString *)getDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *device = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([device hasPrefix:@"iPhone"]) {
        if ([device isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
        if ([device isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
        if ([device isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
        if ([device isEqualToString:@"iPhone4,1"])    return @"iPhone 4";
        if ([device isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone5,3"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone5,4"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone5,5"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone5,6"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone5,7"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone5,8"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone5,9"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone6,1"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone6,2"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone6,3"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone6,4"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone6,5"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone6,6"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone7,1"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone7,2"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone7,3"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone7,4"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone7,5"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone7,6"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone7,7"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone7,8"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone8,1"])    return @"iPhone 5";
        if ([device isEqualToString:@"iPhone8,2"])    return @"iPhone 5";
    } else if ([device hasPrefix:@"iPad"]) {
        return @"iPhone 4";
    }
    return @"iPhone 5";
}

@end
