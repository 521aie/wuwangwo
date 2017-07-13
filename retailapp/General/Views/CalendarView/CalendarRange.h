//
//  CalendarRange.h
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarRange : NSObject

@property (nonatomic, copy) NSDateComponents *startDay;
@property (nonatomic, copy) NSDateComponents *endDay;

// Designated initialiser
- (id)initWithStartDay:(NSDateComponents*)start endDay:(NSDateComponents*)end;

- (BOOL)containsDay:(NSDateComponents*)day;
- (BOOL)containsDate:(NSDate*)date;


@end
