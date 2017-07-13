//
//  NSDate+CalendarView.m
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "NSDate+CalendarView.h"

@implementation NSDate (CalendarView)
- (NSDateComponents*)CalendarView_dayWithCalendar:(NSCalendar*)calendar {
    return [calendar components:NSCalendarUnitCalendar | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
}

- (NSDateComponents*)CalendarView_monthWithCalendar:(NSCalendar*)calendar {
    return [calendar components:NSCalendarUnitCalendar | NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
}

- (NSDate *)GetFirstDayInThisMonth{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:self];
    [dateComponents setDay:1];
    NSDate *date = [calender dateFromComponents:dateComponents];
    return date;
}

- (NSDate *)GetLastDayInThisMonth{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:self];
    
    NSInteger numberOfDaysInMonth = [calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
    [dateComponents setDay:numberOfDaysInMonth];
    NSDate *date = [calender dateFromComponents:dateComponents];
    return date;
}

- (NSDate *)GetlocaleDate{
    
    NSDate *date = self;
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval =[zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    return localeDate;
}

@end
