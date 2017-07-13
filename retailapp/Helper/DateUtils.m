//
//  DateUtils.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DateUtils.h"
#import "NSString+Estimate.h"
#import "AlertBox.h"

static DateUtils *dateUtils;

@implementation DateUtils

- (id)init
{
    self = [super init];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc]init];
    }
    return self;
}

+ (NSString *)formateDate:(NSDate *)date
{
    [self build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd EEEE"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)formateDate2:(NSDate *)date
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)formateDate3:(NSDate *)date
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)formateDate4:(NSDate *)date
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)formateDate5:(NSDate *)date{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)formateDate6:(NSDate *)date{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"dd"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}
+ (NSString *)formateDate7:(NSDate *)date{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}


+ (NSString *)formateDateTime:(NSDate *)date
{
    [self build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)formateLongDateTime:(NSDate *)date
{
    [self build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss+ffff"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)formateShortChineseDate:(NSDate *)date
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)formateShortChineseDate1:(NSDate *)date
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy年MM月"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}


+ (NSString *)formateLongChineseDate:(NSDate *)date
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)formateLongChineseTime:(long long)time
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    return [dateUtils->dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0]];
}

+ (NSString *)formateChineseDate:(NSDate *)date
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy年MM月dd日 EEEE"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)formateChineseDate2:(NSDate *)date
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)formateChineseTime:(NSDate *)date;
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"HH:mm"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)formateTime:(long long)time
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateUtils->dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0]];
}

+ (NSString *)formateTime1:(long long)time
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateUtils->dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}

+ (NSString *)formateTime2:(long long)time
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateUtils->dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0]];
}

+ (NSString *)formateTime3:(long long)time
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy.MM.dd"];
    return [dateUtils->dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0]];
}

+ (NSString *)formateTime4:(long long)time
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateUtils->dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0]];
}

+ (NSString *)formateTime5:(long long)time
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateUtils->dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}

+ (NSString *)formateChineseTime3:(long long)time
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    return [dateUtils->dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0]];
}

+ (NSString *)formateChineseTime4:(long long)time
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy年MM月"];
    return [dateUtils->dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0]];
}

+ (NSString *)formateChineseTime2:(long long)time
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy年MM月dd日 EEEE"];
    return [dateUtils->dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0]];
}

+ (NSString *)formateShortTime2:(long long)time
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"HH:mm"];
    return [dateUtils->dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0]];
}

+ (NSString *)formateShortTime:(NSInteger)time
{
    return [NSString stringWithFormat:@"%.2li:%.2li", time/60, time%60];
}

+ (NSString *)formateChineseShortDate:(long long)time
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    return [dateUtils->dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0]];
}

+ (NSString *)formateChineseShortDate2:(NSDate *)date
{
    if ([ObjectUtil isNotNull:date]) {
        [DateUtils build];
        [dateUtils->dateFormatter setDateFormat:@"MM月dd日"];
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return @"";
}

+ (NSInteger)getMinuteOfDate:(NSDate *)date
{
    if ([ObjectUtil isNotNull:date]) {
        NSString *timeStr = [DateUtils formateChineseTime:date];
        NSArray *times = [timeStr componentsSeparatedByString:@":"];
        if (times.count==2) {
            NSString *time1 = [times objectAtIndex:0];
            NSString *time2 = [times objectAtIndex:1];
            return time1.integerValue*60 + time2.integerValue;
        }
    }
    return 0;
}

+ (NSDate *)getDate:(NSString *)dateString format:(NSString *)formatting {
    
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:formatting];
    return [dateUtils->dateFormatter dateFromString:dateString];
}

+ (NSDate *)parseDateTime:(NSString *)datetime
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateUtils->dateFormatter dateFromString:datetime];
}

+ (NSDate *)parseDateTime2:(NSString *)datetime
{
    [DateUtils build];
    if ([NSString isNotBlank:datetime]) {
        [dateUtils->dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm:ss a"];
        [dateUtils->dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        return [dateUtils->dateFormatter dateFromString:datetime];
    }
    return nil;
}

+ (NSDate *)parseDateTime3:(NSString *)datetime
{
    [DateUtils build];
    datetime=[datetime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateUtils->dateFormatter dateFromString:datetime];
}

+ (NSDate *)parseDateTime4:(NSString *)datetime
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateUtils->dateFormatter dateFromString:datetime];
}

+ (NSDate *)parseDateTime5:(NSString *)datetime
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy"];
    return [dateUtils->dateFormatter dateFromString:datetime];
}

+ (NSDate *)parseDateTime6:(NSString *)datetime
{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"HH:mm"];
    return [dateUtils->dateFormatter dateFromString:datetime];
}

+ (NSDate *)parseDateTime7:(NSString *)datetime{
    [DateUtils build];
    [dateUtils->dateFormatter setDateFormat:@"yyyy-MM"];
    return [dateUtils->dateFormatter dateFromString:datetime];
}

+ (NSDate *)getTodayLastTime
{
    NSString *dateTime = [[DateUtils formateDate2:[NSDate date]] stringByAppendingString:@"23:59"];
    return [DateUtils parseDateTime:dateTime];
}

+ (NSDate *)parseTodayTime:(NSInteger)time
{
    NSString *timeStr = [DateUtils formateShortTime:time];
    NSString *dateStr = [DateUtils formateDate2:[NSDate date]];
    return [DateUtils parseDateTime:[dateStr stringByAppendingFormat:@" %@", timeStr]];
}

+ (NSDate *)getTimeSinceNow:(NSTimeInterval)interval
{
    return [NSDate dateWithTimeIntervalSinceNow:interval];
}

+ (NSString *)getWeeKName:(NSInteger)week
{
    if (week==1) {
        return @"星期日";
    } else if (week==2){
        return @"星期一";
    } else if (week==3){
        return @"星期二";
    } else if (week==4){
        return @"星期三";
    } else if (week==5){
        return @"星期四";
    } else if (week==6){
        return @"星期五";
    } else {
        return @"星期六";
    }
}

+ (NSString *)getCurrentDate
{
    NSDate* date = [NSDate date];
    [DateUtils build];
    [dateUtils->dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateUtils->dateFormatter setDateFormat:@"yyyy年MM月dd日 EEEE"];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

//供应链新增日期时间转时间戳
+ (long long)formateDateTime2:(NSString*)datetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:datetime];
    return  (long long)[date timeIntervalSince1970]*1000;
}

+ (long long)formateDateTime3:(NSString*)datetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate* date = [formatter dateFromString:datetime];
    return  (long long)[date timeIntervalSince1970]*1000;
}

+ (long long)formateDateTime4:(NSString*)datetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate* date = [formatter dateFromString:datetime];
    return  (long long)[date timeIntervalSince1970]*1000;
}

+ (long long)formateDateTime5:(NSString*)datetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    NSDate* date = [formatter dateFromString:datetime];
    return  (long long)[date timeIntervalSince1970]*1000;
}

+ (void)build
{
    if (dateUtils == nil) {
        dateUtils = [[DateUtils alloc]init];
    }
}

+(NSArray *)getFirstAndLastDayOfThisMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDay;
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDay interval:nil forDate:[NSDate date]];
    NSDateComponents *lastDateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitDay fromDate:firstDay];
    NSUInteger dayNumberOfMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]].length;
    NSInteger day = [lastDateComponents day];
    [lastDateComponents setDay:day+dayNumberOfMonth-1];
    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    return [NSArray arrayWithObjects:firstDay,lastDay, nil];
}

+(NSArray *)getFirstAndLastDayOfThisWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger weekday = [dateComponents weekday];   //第几天(从sunday开始)
    NSInteger firstDiff,lastDiff;
    if (weekday == 1) {
        firstDiff = -6;
        lastDiff = 0;
    }else {
        firstDiff = 2 - weekday;
        lastDiff = 8 - weekday;
    }
    NSInteger day = [dateComponents day];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [firstComponents setDay:day+firstDiff];
    NSDate *firstDay = [calendar dateFromComponents:firstComponents];
    NSDateComponents *lastComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [lastComponents setDay:day+lastDiff];
    NSDate *lastDay = [calendar dateFromComponents:lastComponents];
    return [NSArray arrayWithObjects:firstDay,lastDay, nil];
}
//获取本月的第一天
+ (NSDate *)getFirstDayOfThisMonth {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:[NSDate date]];
    [dateComponents setDay:1];
    NSDate *date = [calender dateFromComponents:dateComponents];
    return date;
}
//获得本周的第一天
+ (NSDate *)getThisWeekFirstDay {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:[NSDate date]];
    NSInteger weekday = dateComponents.weekday;
    NSInteger firstDay;
    if (weekday == 1) {
        firstDay = -6;
    } else {
        firstDay = -weekday + 2;
    }
    NSInteger day = dateComponents.day;
    NSDateComponents *firstComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:[NSDate date]];
    [firstComponents setDay:day + firstDay];
    NSDate *firstDate = [calender dateFromComponents:firstComponents];
    return firstDate;
}
#pragma mark - 获得上周的第一天
+ (NSDate *)getLastWeekFirstDay {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:[NSDate date]];
    NSInteger weekday = dateComponents.weekday;
    NSInteger firstDay;
    if (weekday == 1) {
        firstDay = -6;
    } else {
        firstDay = -weekday + 2;
    }
    NSInteger day = dateComponents.day;
    NSDateComponents *firstComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:[NSDate date]];
    [firstComponents setDay:day + firstDay - 7];
    NSDate *firstDate = [calender dateFromComponents:firstComponents];
    return firstDate;
}

#pragma mark - 获得上周的最后一天
+ (NSDate *)getLastWeekLastDay {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:[NSDate date]];
    NSInteger weekday = dateComponents.weekday;
    NSInteger firstDay;
    if (weekday == 1) {
        firstDay = -6;
    } else {
        firstDay = -weekday + 2;
    }
    NSInteger day = dateComponents.day;
    NSDateComponents *firstComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:[NSDate date]];
    [firstComponents setDay:day + firstDay - 1];
    NSDate *firstDate = [calender dateFromComponents:firstComponents];
    return firstDate;
}

#pragma mark - 获得上月的第一天
+ (NSDate *)getLastMonthFirstDay {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:[NSDate date]];
    dateComponents.day = 1;
    dateComponents.month = dateComponents.month - 1;
    NSDate *date = [calender dateFromComponents:dateComponents];
    return date;
}
#pragma mark - 获得上月的最后一天
+ (NSDate *)getLastMonthLastDay {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:[NSDate date]];
    dateComponents.day = 0;
    NSDate *date = [calender dateFromComponents:dateComponents];
    return date;
}
// 今天 昨天 最近三天 本周 本月 自定义时间 转为字符串
+ (long long)converStartTime:(NSString *)time {
    if ([time isEqualToString:@"今天"]) {
        return [self formateDateTime3:[self formateDate2:[NSDate date]]];
    } else if ([time isEqualToString:@"昨天"]) {
         return [self formateDateTime3:[self formateDate2:[NSDate dateWithTimeIntervalSinceNow:-(24*60*60)]]];
    } else if ([time isEqualToString:@"最近三天"]) {
         return [self formateDateTime3:[self formateDate2:[NSDate dateWithTimeIntervalSinceNow:-(24*60*60*2)]]];
    } else if ([time isEqualToString:@"本周"]) {
        return [self formateDateTime3:[self formateDate2:[self getThisWeekFirstDay]]];
    } else if ([time isEqualToString:@"上周"]) {
        return [self formateDateTime3:[self formateDate2:[self getLastWeekFirstDay]]];
    } else if ([time isEqualToString:@"本月"]) {
        return [self formateDateTime3:[self formateDate2:[self getFirstDayOfThisMonth]]];
    } else if ([time isEqualToString:@"上月"]) {
        return [self formateDateTime3:[self formateDate2:[self getLastMonthFirstDay]]];
    } else {//自定义
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        return [self formateDateTime3:[self formateDate2:[formater dateFromString:time]]];
    }
}
+ (long long)converEndTime:(NSString *)time {
    if ([time isEqualToString:@"今天"]) {
        return [self formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59",[self formateDate2:[NSDate date]]]];
    } else if ([time isEqualToString:@"昨天"]) {
        return [self formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59",[self formateDate2:[NSDate dateWithTimeIntervalSinceNow:-(24*60*60)]]]];
    }else if ([time isEqualToString:@"最近三天"]) {
         return [self formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59",[self formateDate2:[NSDate date]]]];
    } else if ([time isEqualToString:@"本周"]) {
         return [self formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59",[self formateDate2:[NSDate date]]]];
    } else if ([time isEqualToString:@"上周"]) {
        return [self formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59",[self formateDate2:[self getLastWeekLastDay]]]];
    } else if ([time isEqualToString:@"本月"]) {
        return [self formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59",[self formateDate2:[NSDate date]]]];
    } else if ([time isEqualToString:@"上月"]) {
        return [self formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59",[self formateDate2:[self getLastMonthLastDay]]]];
    } else {//自定义
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        return [self formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59",[self formateDate2:[formater dateFromString:time]]]];
    }
}

// 今天 昨天 最近三天 本周 本月 自定义时间 转为字符串
+ (long long)converStartTime1:(NSString *)time {
    if ([time isEqualToString:@"今天"]) {
        return [self formateDateTime3:[self formateDate2:[NSDate date]]];
    } else if ([time isEqualToString:@"昨天"]) {
        return [self formateDateTime3:[self formateDate2:[NSDate dateWithTimeIntervalSinceNow:-(24*60*60)]]];
    } else if ([time isEqualToString:@"最近三天"]) {
        return [self formateDateTime3:[self formateDate2:[NSDate dateWithTimeIntervalSinceNow:-(24*60*60*2)]]];
    } else if ([time isEqualToString:@"本周"]) {
        return [self formateDateTime3:[self formateDate2:[self getThisWeekFirstDay]]];
    } else if ([time isEqualToString:@"上周"]) {
        return [self formateDateTime3:[self formateDate2:[self getLastWeekFirstDay]]];
    } else if ([time isEqualToString:@"本月"]) {
        return [self formateDateTime3:[self formateDate2:[self getFirstDayOfThisMonth]]];
    } else if ([time isEqualToString:@"上月"]) {
        return [self formateDateTime3:[self formateDate2:[self getLastMonthFirstDay]]];
    } else {//自定义
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [self formateDateTime2:[self formateDate3:[formater dateFromString:time]]];
    }
}



//得到一天的开始时间
+ (long long)getStartTimeOfDate:(NSDate *)date{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDate *beginDate = [calender dateFromComponents:dateComponents];
    return  (long long)[beginDate timeIntervalSince1970]*1000;
}
//得到一天的结束时间
+ (long long)getEndTimeOfDate:(NSDate *)date{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    dateComponents.hour = 23;
    dateComponents.minute = 59;
    dateComponents.second = 59;
    NSDate *beginDate = [calender dateFromComponents:dateComponents];
    return  (long long)[beginDate timeIntervalSince1970]*1000;
}

//得到一天的开始时间
+ (long long)getStartTimeOfDate1:(NSDate *)date{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDate *beginDate = [calender dateFromComponents:dateComponents];
    return  (long long)[beginDate timeIntervalSince1970];
}
//得到一天的结束时间
+ (long long)getEndTimeOfDate1:(NSDate *)date{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    dateComponents.hour = 23;
    dateComponents.minute = 59;
    dateComponents.second = 59;
    NSDate *beginDate = [calender dateFromComponents:dateComponents];
    return  (long long)[beginDate timeIntervalSince1970];
}

+ (BOOL)getMonthFromStartDate:(NSString *)startDate toEndDate:(NSString *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[self parseDateTime4:startDate] toDate:[self parseDateTime4:endDate] options:0];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
   return (year>=1&&(month>0||day>0));
}
+ (BOOL)getDayFromStartDate:(NSString *)startDate toEndDate:(NSString *)endDate withLimitDay:(NSInteger)day
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitDay fromDate:[self parseDateTime4:startDate] toDate:[self parseDateTime4:endDate] options:0];
    return [comps day] >= day;
}
//取一年前的日期
+ (NSDate *)getYearAgoDate:(NSDate *)date {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:-1];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    
    return [calendar dateByAddingComponents:adcomps toDate:date options:0];
}

//判断一个时间距离当天3个月天
+ (BOOL)daysToNow:(NSDate *)date {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *comps = nil;
//    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-3];
    [adcomps setDay:0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * lastDate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    //转化为字符串
    NSString * startDate = [dateFormatter stringFromDate:lastDate];
    
    //最早只能选择三个月前的日期，如今天是2015-11-02，那最早只能选择2014-11-02
    NSString* dateStr=[DateUtils formateDate2:date];
    
    if ([dateStr compare:startDate] == NSOrderedAscending) {
        [AlertBox show:@"开始日期只能选择最近三个月的日期！"];
        return NO;
    }
    return YES;
}
/**
 date距离现在日期是否在一年内

 @param date 判断的日期

 @return YES 一年内 NO 不在一年内
 */
+ (BOOL)daysToNowOneYear:(NSDate *)date {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //    NSDateComponents *comps = nil;
    //    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:-1];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * lastDate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    //转化为字符串
    NSString * startDate = [dateFormatter stringFromDate:lastDate];
    
    //最早只能选择三个月前的日期，如今天是2015-11-02，那最早只能选择2014-11-02
    NSString* dateStr=[DateUtils formateDate2:date];
    
    if ([dateStr compare:startDate] == NSOrderedAscending) {
        [AlertBox show:@"开始日期只能选择最近一年的日期！"];
        return NO;
    }
    return YES;
}


+ (NSString *)currentDateWith:(NSString *)formatting {
    
    NSDate* date = [NSDate date];
    [DateUtils build];
    [dateUtils->dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateUtils->dateFormatter setDateFormat:formatting];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

+ (NSString *)getDateString:(NSDate *)date format:(NSString *)formatting {
    [DateUtils build];
    [dateUtils->dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateUtils->dateFormatter setDateFormat:formatting];
    if ([ObjectUtil isNotNull:date]) {
        return [dateUtils->dateFormatter stringFromDate:date];
    }
    return nil;
}

// 获取某月的天数
+ (NSInteger)getNumberOfDaysInMonth:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit:NSCalendarUnitMonth
                                  forDate:date];
    return range.length;
}

//@"yyyy-MM-dd HH:mm:ss"
+ (NSString *)getTimeStringFromCreaateTime:(NSString *)createTime format:(NSString *)format {
    NSDate *date = [DateUtils getDate:createTime format:@"yyyyMMddHHmmss"];
    return [DateUtils getDateString:date format:format];
}

#pragma mark - 获取2017-01-01 00:00:00
+ (long long)getStartTime:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [formatter dateFromString:time];
    return [date timeIntervalSince1970] * 1000;
}

+ (long long)getEndTime:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    time = [time stringByAppendingString:@" 23:59:59"];
    NSDate *date = [formatter dateFromString:time];
    return [date timeIntervalSince1970] * 1000;
}

@end
