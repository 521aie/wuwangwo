//
//  CalendarDayView.m
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CalendarDayView.h"
#import "NSDate+CalendarView.h"
#import "ColorHelper.h"

@implementation CalendarDayView{
    __strong NSCalendar *_calendar;
    __strong NSDate *_dayAsDate;
    __strong NSDateComponents *_day;
    __strong NSString *_labelText;
}

+ (id)getInstanceWithFrame:(CGRect)frame{
    CalendarDayView *item = [[[NSBundle mainBundle]loadNibNamed:@"CalendarDayView" owner:self options:nil]lastObject];
    item.frame = frame;
    item.clickDay.frame = item.bounds;
    
    item.oldGoal = @"";
    item.currentGoal = @"";
    return item;
}
- (void)loadDayView:(id)obj{
    
}


#pragma mark Properties
- (void)setDay:(NSDateComponents *)day {
    _calendar = [day calendar];
    _dayAsDate = [day date];
    _day = nil;
    _labelText = [NSString stringWithFormat:@"%ld", (long)day.day];
    _lblDate.text = _labelText;
    _lblGoal.textColor = [ColorHelper getBlueColor];
    if ([self isWeekend]) {
        [self setWeekendColor];
    }
    
    if ([self isBeforeToday]) {
        [self setUnable];
    }
}

- (NSDateComponents*)day {
    if (_day == nil) {
        _day = [_dayAsDate CalendarView_dayWithCalendar:_calendar];
    }
    
    return _day;
}

- (NSDate*)dayAsDate {
    return _dayAsDate;
}

- (void)initGoal:(NSString *)goal{
    self.lblGoal.text = goal;
    self.currentGoal = goal;
    self.oldGoal = goal;
}
- (void)changeGoal:(NSString *)goal{
    self.lblGoal.text = goal;
    self.currentGoal = goal;
}

- (BOOL)goalIschange{
    if ([_oldGoal isEqualToString:self.currentGoal]) {
        return NO;
    }
    if (_oldGoal == nil && _currentGoal == nil) {
        return NO;
    }
    return YES;
}

- (void)clearGoal{
    [self initGoal:nil];
    self.performanceId = 0;
    self.lastVer = 0;
}

//判断是否在今天之前
- (BOOL)isBeforeToday{
    NSDate *today = [NSDate date];
    long long todayInterval = [self getStartTimeOfDate:today];
    long long dayInterval = [self getStartTimeOfDate:_dayAsDate];
  
    if (dayInterval < todayInterval) {
        return YES;
    }
    return NO;
}

//判断是否为周六、周日
- (BOOL)isWeekend{
    
    NSInteger week = [[_calendar components:NSCalendarUnitWeekday fromDate:_dayAsDate] weekday];
    if (1 == week || 7 == week) {
        return YES;
    }
    return NO;
}

- (void)setWeekendColor{
    _lblDate.textColor = [UIColor redColor];
    _lblGoal.textColor = [UIColor redColor];
}

- (IBAction)clickBtn:(id)sender {
    self.isSelect = !self.isSelect;

    [self setUIbySelectState:_isSelect];
}

- (void)setUnable{
    self.lblDate.textColor = [UIColor grayColor];
    self.lblGoal.textColor = [UIColor grayColor];
    self.clickDay.enabled = NO;
}


- (void)setUIbySelectState:(BOOL)isSelect{
    if (isSelect) {
        self.backgroundColor = [UIColor redColor];
        self.lblDate.textColor = [UIColor whiteColor];
        self.lblGoal.textColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = [UIColor clearColor];
        if ([self isWeekend]) {
            [self setWeekendColor];
        }
        else{
        self.lblDate.textColor = [UIColor blackColor];
        self.lblGoal.textColor = [ColorHelper getBlueColor];//[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1];//0,122,255
        }
    }
}

//得到一天的开始时间
- (long long)getStartTimeOfDate:(NSDate *)date{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDate *beginDate = [calender dateFromComponents:dateComponents];
    return  (long long)[beginDate timeIntervalSince1970]*1000;
}
@end
