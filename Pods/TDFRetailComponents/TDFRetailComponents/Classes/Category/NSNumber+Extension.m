//
//  NSNumber+Helper.m
//  retailapp
//
//  Created by taihangju on 2016/11/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "NSNumber+Extension.h"

@implementation NSNumber (Extension)

- (NSString *)percentageStringWithDecimalDigits:(NSUInteger)maximumFractionDigits {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    [formatter setMaximumFractionDigits:maximumFractionDigits >= 1? maximumFractionDigits : 2];
    return [formatter stringFromNumber:self];
}

- (NSString *)currencyStringWithSymbol:(NSString *)currencySymbol {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    if (currencySymbol.length > 0) {
        [formatter setPositivePrefix:currencySymbol];
        [formatter setNegativePrefix:currencySymbol];
    }
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    return [formatter stringFromNumber:self];
}

- (NSString *)productStringWithNumber:(NSNumber *)multiplier {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMultiplier:multiplier];
    return [formatter stringFromNumber:self];
}

- (NSString *)stringFromNumberWithDecimalDigits:(NSUInteger)maximumFractionDigits {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:maximumFractionDigits >= 1? maximumFractionDigits : 2];
    return [formatter stringFromNumber:self];
}

- (NSString *)convertToStringWithFormat:(NSString *)format {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setPositiveFormat:format];
    return [numberFormatter stringFromNumber:self];
}
@end
