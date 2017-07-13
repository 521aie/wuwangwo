//
//  NSDate+CalendarView.h
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CalendarView)

- (NSDateComponents*)CalendarView_dayWithCalendar:(NSCalendar*)calendar;
- (NSDateComponents*)CalendarView_monthWithCalendar:(NSCalendar*)calendar;

- (NSDate *)GetFirstDayInThisMonth;
- (NSDate *)GetLastDayInThisMonth;

- (NSDate *)GetlocaleDate;
@end
