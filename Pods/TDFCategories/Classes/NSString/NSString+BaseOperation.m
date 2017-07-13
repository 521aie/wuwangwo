//
//  NSString+BaseOperation.m
//  Pods
//
//  Created by tripleCC on 11/4/16.
//
//

#import "NSString+BaseOperation.h"

@implementation NSString (BaseOperation)
- (NSString *)tdf_suffix:(NSString *)string {
    if (!string) return self;
    return [self stringByAppendingString:string];
}

- (NSString *)tdf_prefix:(NSString *)aString {
    return [aString tdf_suffix:self];
}

- (NSString *)tdf_wrapLeft:(NSString *)lString right:(NSString *)rString {
    return [[self tdf_prefix:lString] tdf_suffix:rString];
}

- (NSString *)tdf_wrap:(NSString *)aString {
    return [self tdf_wrapLeft:aString right:aString];
}

- (BOOL)tdf_notEmpty {
    NSString *result = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return result.length > 0;
}
@end
