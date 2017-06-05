//
//  NSString+BaseFormatter.m
//  Pods
//
//  Created by tripleCC on 11/4/16.
//
//
#import "NSString+BaseFormatter.h"

@implementation NSString (BaseFormatter)
- (NSString *)tdf_leave2Decimal {
    return [NSString stringWithFormat:@"%.2lf", self.doubleValue];
}

- (NSString *)tdf_price {
    return self.tdf_leave2Decimal;
}

- (NSString *)tdf_prefixRMB {
    return [@"¥" tdf_suffix:self];
}

- (NSString *)tdf_suffixYuan {
    return [self tdf_suffix:NSLocalizedString(@"元", nil)];
}

- (NSString *)tdf_prefixJinE {
    return [self tdf_prefix:NSLocalizedString(@"金额", nil)];
}
@end
