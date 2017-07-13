//
//  NSArray+Extension.m
//  retailapp
//
//  Created by byAlex on 16/9/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

- (NSArray *)filterWithFormatString:(NSString *)format {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
    if (predicate) {
        NSArray *resultArray = [self filteredArrayUsingPredicate:predicate];
        if (resultArray.count) {
             return resultArray;
        }
    }
    return nil;
}
@end
