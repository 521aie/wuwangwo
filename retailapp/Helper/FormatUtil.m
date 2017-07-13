//
//  FormatUtil.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-26.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import "NumberUtil.h"
#import "FormatUtil.h"
#import "RegexKitLite.h"

static NSDateFormatter *dateFormatter;

@implementation FormatUtil

+ (NSString *)formatInt:(double)value
{
    return [NSString stringWithFormat:@"%0.0f",value];
}

+ (NSString *)formatDouble:(double)value
{
    return [NSString stringWithFormat:@"%2.0f",value];
}

+ (NSString *)formatDouble2:(double)value
{
    return [NSString stringWithFormat:@"%8.2f",value];
}

+ (NSString *)formatDouble3:(double)value
{
    return [NSString stringWithFormat:@"%0.2f",value];
}

+ (NSString *)formatDouble4:(double)value
{
    NSString* temp= [NSString stringWithFormat:@"%0.0f",value];
    if (temp.doubleValue==value) {
        return temp;
    }else{
        return [NSString stringWithFormat:@"%0.2f",value];
    }
}

+ (NSString *)formatDouble5:(double)value
{
    return [NSString stringWithFormat:@"%0.2f",value];
}

+ (NSString *)formatDouble6:(double)value
{
    return [NSString stringWithFormat:@"%0.1f",value];
}

+ (NSString *)formatNumber:(double)value
{
    if ([NumberUtil isNotZero:value]) {
        return [NSString stringWithFormat:@"%0.2f",value];
    }
    return @"-";
}

+ (NSString *)formatDoubleWithSeperator:(double)value
{
    
    NSString* oldValue=[NSString stringWithFormat:@"%.2f",value];
    NSString *regex = @"([0-9])(?=([0-9]{3})+\\.)";
    return [oldValue stringByReplacingOccurrencesOfRegex:regex withString:@"$1,"];
}

+ (NSString *)formatIntWithSeperator:(int)value
{
    NSString* oldValue=[NSString stringWithFormat:@"%d",value];
    NSString *regex = @"([0-9])(?=([0-9]{3}))";
    return [oldValue stringByReplacingOccurrencesOfRegex:regex withString:@"$1,"];
}


+ (NSString *)formatDistance:(double)value
{
    if ([NumberUtil isNotZero:value]) {
        if (value < 1.0){
            value*=1000;
            return [NSString stringWithFormat:@"%0.0fm",value];
        } else {
            return [NSString stringWithFormat:@"%0.2fkm",value];
        }
    }
    return @"";
}

@end
