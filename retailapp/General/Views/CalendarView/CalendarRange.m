//
//  CalendarRange.m
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CalendarRange.h"
@interface CalendarRange ()
@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *endDate;
@end

@implementation CalendarRange
#pragma mark - Initialisation

// Designated initialiser
- (id)initWithStartDay:(NSDateComponents *)start endDay:(NSDateComponents *)end {
    NSParameterAssert(start);
    NSParameterAssert(end);
    
    self = [super init];
    if (self != nil) {
        // Initialise properties
        _startDay = [start copy];
        _startDate = [start date];
        _endDay = [end copy];
        _endDate = [end date];
    }
    
    return self;
}


#pragma mark - Properties

- (void)setStartDay:(NSDateComponents *)startDay {
    NSParameterAssert(startDay);
    _startDay = [startDay copy];
}

- (void)setEndDay:(NSDateComponents *)endDay {
    NSParameterAssert(endDay);
    _endDay = [endDay copy];
}


#pragma mark

- (BOOL)containsDay:(NSDateComponents*)day {
    return [self containsDate:day.date];
}

- (BOOL)containsDate:(NSDate*)date {
    if ([_startDate compare:date] == NSOrderedDescending) {
        return NO;
    }
    else if ([_endDate compare:date] == NSOrderedAscending) {
        return NO;
    }
    
    return YES;
}

@end
