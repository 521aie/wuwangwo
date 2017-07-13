//
//  SignUtil.m
//  retailapp
//
//  Created by hm on 15/6/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignUtil.h"
#import "MyMD5.h"
#import "RetailConstants.h"

@implementation SignUtil

+ (NSString*)convertPassword:(NSString*)password
{
    return [MyMD5 md5:password];
}

+ (NSString*)convertSign:(NSMutableDictionary*)params
{
    NSMutableString *ns = [NSMutableString string];
    
    if ([ObjectUtil isNotEmpty:params]) {
        NSString *val;
        NSArray *keys=[params allKeys];
        NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *key in sortedKeys) {
            val=(NSString *)[params objectForKey:key];
            if ([key isEqualToString:@"sign"] || [key isEqualToString:@"method"] || [key isEqualToString:@"appKey"] || [key isEqualToString:@"v"] || [key isEqualToString:@"format"] || [key isEqualToString:@"timestamp"]) {
                continue;
            }
            if ([NSString isNotBlank:val]) {
                [ns appendString:key];
                [ns appendString:val];
            }
        }
    }
    [ns appendString:APP_CY_API_SECRET];
    return [MyMD5 md5:ns];
}

+ (NSString*)convertOutSign:(NSString *)time
{
    
    NSMutableString *ns = [NSMutableString stringWithFormat:@""];
    NSString *appSecert = APP_API_OUT_SECRET;
#if DEBUG || DAILY
    appSecert = [[Platform Instance] getkey:SERVER_API_OUT_SECERT];
#endif
    [ns appendString:appSecert];
    [ns appendString:time];
    return [MyMD5 md5:ns];
}

@end
