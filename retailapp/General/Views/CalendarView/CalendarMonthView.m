//
//  CalendarMonthView.m
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CalendarMonthView.h"
#import "CalendarDayView.h"
#import "CalendarRange.h"
#import "NSDate+CalendarView.h"

@interface CalendarMonthView ()

@property (nonatomic, strong) NSMutableDictionary *dayViewsDictionary;

@end

@implementation CalendarMonthView {
    CGFloat _dayViewHeight;
    __strong Class _dayViewClass;
}



- (void)initWithMonth:(NSDateComponents*)month frame:(CGRect)frame dayViewHeight:(CGFloat)dayViewHeight {
    if (self != nil) {
        // Initialise properties
        
        self.frame = frame;

        _month = [month copy];
        _dayViewHeight = dayViewHeight;
        _dayViewsDictionary = [[NSMutableDictionary alloc] init];
        
        [self createDayViews];
    }
  
}

- (void)changeMonth:(NSDateComponents*)month {
    NSArray *keys = [self.dayViewsDictionary allKeys];
    for (NSString *key in keys) {
        CalendarDayView *dayView = [self.dayViewsDictionary objectForKey:key];
        [dayView removeFromSuperview];
    }
    [self.dayViewsDictionary removeAllObjects];
    
    _month = [month copy];
    [self createDayViews];
}

- (void)createDayViews {
    NSInteger const numberOfDaysPerWeek = 7;
    
    NSDateComponents *day = [[NSDateComponents alloc] init];
    day.calendar = self.month.calendar;
    day.day = 1;
    day.month = self.month.month;
    day.year = self.month.year;
    
    NSDate *firstDate = [day.calendar dateFromComponents:day];
    day = [firstDate CalendarView_dayWithCalendar:self.month.calendar];
    
    NSInteger numberOfDaysInMonth = [day.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[day date]].length;
    //计算开始纵列位置
    NSInteger startColumn = day.weekday - day.calendar.firstWeekday;
    if (startColumn < 0) {
        startColumn += numberOfDaysPerWeek;
    }
    //计算每个dayView的宽度
    NSArray *columnWidths = [self calculateColumnWidthsForColumnCount:numberOfDaysPerWeek];
    CGPoint nextDayViewOrigin = CGPointZero;
    for (NSInteger column = 0; column < startColumn; column++) {
        nextDayViewOrigin.x += [[columnWidths objectAtIndex:column] doubleValue];//计算第一天的位置
    }
    
    
    
    while (day.day <= numberOfDaysInMonth)
    {
        for (NSInteger column = startColumn; column < numberOfDaysPerWeek; column++)
        {
            if (day.month == self.month.month) {
                CGRect dayFrame = CGRectZero;
                dayFrame.origin = nextDayViewOrigin;
                dayFrame.size.width = [[columnWidths objectAtIndex:column] doubleValue];
                dayFrame.size.height = _dayViewHeight;
                
                CalendarDayView *dayView = [CalendarDayView getInstanceWithFrame:dayFrame];
                dayView.day = day;
              
                [self.dayViewsDictionary setValue:dayView forKey:[self dayViewKeyForDay:day]];
                [self addSubview:dayView];
            }
            
            day.day = day.day + 1;
            
            nextDayViewOrigin.x += [[columnWidths objectAtIndex:column] doubleValue];
            if (day.day > numberOfDaysInMonth) {
                break;//跳出for循环
            }
        }
        //7天一个循环
        nextDayViewOrigin.x = 0;
        nextDayViewOrigin.y += _dayViewHeight;
        startColumn = 0;
    }
    
    CGRect fullFrame = self.frame;
    fullFrame.size.height = nextDayViewOrigin.y;
    for (NSNumber *width in columnWidths) {
        fullFrame.size.width += width.floatValue;
    }
    self.frame = fullFrame;
}

- (NSArray*)calculateColumnWidthsForColumnCount:(NSInteger)columnCount {
    static NSCache *widthsCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        widthsCache = [[NSCache alloc] init];
    });
    
    NSMutableArray *columnWidths = [widthsCache objectForKey:@(columnCount)];
    if (columnWidths == nil) {
        CGFloat width = floorf(self.bounds.size.width / (CGFloat)columnCount);
        
        columnWidths = [[NSMutableArray alloc] initWithCapacity:columnCount];
        for (NSInteger column = 0; column < columnCount; column++) {
            [columnWidths addObject:@(width)];
        }
        
        CGFloat remainder = self.bounds.size.width - (width * columnCount);
        CGFloat padding = 1;
        if (remainder > columnCount) {
            padding = ceilf(remainder / (CGFloat)columnCount);
        }
        
        for (NSInteger column = 0; column < columnCount; column++) {
            [columnWidths replaceObjectAtIndex:column withObject:@(width + padding)];
            
            remainder -= padding;
            if (remainder < 1) {
                break;
            }
        }
        
        [widthsCache setObject:columnWidths forKey:@(columnCount)];
    }
    
    return columnWidths;
}


//
- (void)setSaleGoal:(NSString *)goal {
    
    NSArray *keys = [self.dayViewsDictionary allKeys];
    NSInteger selectedCount = 0;
    for (NSString *key in keys) {
        CalendarDayView *dayView = [self.dayViewsDictionary objectForKey:key];
        if (dayView.isSelect) {
            selectedCount++;
            if (![dayView isBeforeToday]) {
                [dayView changeGoal:goal];
            }
        }
    }
    
    if (0 == selectedCount) {//没有选中的 且 是今天之后的
        for (NSString *key in keys) {
            CalendarDayView *dayView = [self.dayViewsDictionary objectForKey:key];
            if (![dayView isBeforeToday]) {
                [dayView changeGoal:goal];
            }
        }
    }
    
}

- (void)updateGoalbyList:(NSArray *)goalList {
    if (goalList == nil || goalList.count <= 0) {
        for (NSString *key in self.dayViewsDictionary.allKeys) {
            CalendarDayView *view = [self.dayViewsDictionary objectForKey:key];//找到对应的dayView
            [view clearGoal];
        }
        return;
    }
    
    for (NSDictionary *dicGoal in goalList) {
        NSInteger startDate = 0;
        NSString *saleTargetDay;
        id objectint = [dicGoal objectForKey:@"startDate"];
        if (objectint!=nil) {
            startDate = [objectint integerValue];
        }
        id objectstr = [dicGoal objectForKey:@"saleTargetDay"];
        if (objectstr!=nil) {
            saleTargetDay = [NSString stringWithFormat:@"%@",objectstr];
            if ([saleTargetDay isEqual:@"0"]) {
                saleTargetDay = @"";
            }
        }
        
        NSInteger performanceId = 0;
        id object = [dicGoal objectForKey:@"performanceId"];
        if (object!=nil) {
            performanceId = [object integerValue];
        }
        
        NSInteger lastVer = 0;
        id objectLastVer = [dicGoal objectForKey:@"lastVer"];
        if (object!=nil) {
            lastVer = [objectLastVer integerValue];
        }
        //时间戳转成字典中的key
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:startDate];
        NSDateComponents *dateComponents = [confromTimesp CalendarView_dayWithCalendar:self.month.calendar];
        NSString *strKey = [self dayViewKeyForDay:dateComponents];
        
        //找到对应的dayView,修改业绩目标
        for (NSString *key in self.dayViewsDictionary.allKeys) {
            if ([key isEqualToString:strKey]) {
                CalendarDayView *view = [self.dayViewsDictionary objectForKey:key];//找到对应的dayView
                [view initGoal:saleTargetDay];
                view.performanceId = performanceId;
                view.lastVer = lastVer;
            }
        }
        
    }
}
- (BOOL)isGoalChange {
    NSInteger changeCount = 0;
    for (NSString *key in self.dayViewsDictionary.allKeys) {
        CalendarDayView *view = [self.dayViewsDictionary objectForKey:key];//找到对应的dayView
        if ([view goalIschange]) {
            changeCount += 1;
        }
    }
    if (changeCount > 0) {
        return YES;
    }else{
        return NO;
    }
}
- (NSArray *)getGoal{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *key in self.dayViewsDictionary.allKeys) {
        
        CalendarDayView *view = [self.dayViewsDictionary objectForKey:key];//找到对应的dayView
        if (![view isBeforeToday]) {
            //text不为空 且 数据有变化  ![view.lblGoal.text isEqualToString:@""] && view.lblGoal.text != nil && 
            if ([view goalIschange]) {
               
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                if ([view.lblGoal.text isEqualToString:@""] || view.lblGoal.text == nil) {
                    [dic setValue:@"0" forKey:@"saleTargetDay"];
                }else{
                    [dic setValue:view.lblGoal.text forKey:@"saleTargetDay"];
                }
                [dic setValue:view.day forKey:@"NSDateComponents"];
                [dic setValue:[NSNumber numberWithInteger:view.performanceId] forKey:@"performanceId"];
                [dic setValue:[NSNumber numberWithInteger:view.lastVer] forKey:@"lastVer"];
                [arr addObject:dic];
            }
        }
    }
    return arr;
}

- (NSDictionary *)getEveryDaySameGoal {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *firstDayKey = self.dayViewsDictionary.allKeys[0];
    CalendarDayView *firstDay = [self.dayViewsDictionary objectForKey:firstDayKey];
    [dic setValue:firstDay.lblGoal.text forKey:@"saleTargetDay"];
    [dic setValue:firstDay.day forKey:@"NSDateComponents"];
    [dic setValue:[NSNumber numberWithInteger:firstDay.lastVer] forKey:@"lastVer"];
    return dic;
    
}
- (BOOL)isEveryDaySameGoal{
    
    NSString *firstDayKey = self.dayViewsDictionary.allKeys[0];
    CalendarDayView *firstDay = [self.dayViewsDictionary objectForKey:firstDayKey];
    
    for (NSString *key in self.dayViewsDictionary.allKeys) {
        CalendarDayView *view = [self.dayViewsDictionary objectForKey:key];
        if (![firstDay.lblGoal.text isEqualToString:view.lblGoal.text]) {
            return NO;
        }
    }
    
    return YES;
}
- (NSSet*)dayViews {
    return [NSSet setWithArray:self.dayViewsDictionary.allValues];
}

- (NSString*)dayViewKeyForDay:(NSDateComponents*)day {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
    });
    
    return [formatter stringFromDate:[day date]];
}

- (CalendarDayView*)dayViewForDay:(NSDateComponents*)day{
     return [self.dayViewsDictionary objectForKey:[self dayViewKeyForDay:day]];
}




@end
