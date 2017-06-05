//
//  DateUtils.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject
{
    NSDateFormatter *dateFormatter;
}

+ (NSString *)formateDate:(NSDate *)date;

+ (NSString *)formateDate2:(NSDate *)date;

+ (NSString *)formateDate3:(NSDate *)date;

+ (NSString *)formateDate4:(NSDate *)date;

+ (NSString *)formateDate5:(NSDate *)date;

+ (NSString *)formateDate6:(NSDate *)date;

+ (NSString *)formateDate7:(NSDate *)date;

+ (NSString *)formateDateTime:(NSDate *)date;

+ (NSString *)formateLongDateTime:(NSDate *)date;

+ (NSString *)formateShortChineseDate:(NSDate *)date;

+ (NSString *)formateShortChineseDate1:(NSDate *)date;

+ (NSString *)formateLongChineseDate:(NSDate *)date;

+ (NSString *)formateLongChineseTime:(long long)time;

+ (NSString *)formateChineseDate:(NSDate *)date;

+ (NSString *)formateChineseDate2:(NSDate *)date;

+ (NSString *)formateChineseTime:(NSDate *)date;

+ (NSString *)formateChineseTime4:(long long)time;

+ (NSString *)formateTime:(long long)time;

+ (NSString *)formateTime1:(long long)time;

+ (NSString *)formateTime2:(long long)time;

+ (NSString *)formateTime3:(long long)time;

+ (NSString *)formateTime4:(long long)time;

+ (NSString *)formateTime5:(long long)time;

+ (NSString *)formateChineseTime3:(long long)time;

+ (NSString *)formateShortTime2:(long long)time;

+ (NSString *)formateShortTime:(NSInteger)time;

+ (NSString *)formateChineseTime2:(long long)time;

+ (NSString *)formateChineseShortDate:(long long)time;

+ (NSString *)formateChineseShortDate2:(NSDate *)date;

+ (NSInteger)getMinuteOfDate:(NSDate *)date;

+ (NSDate *)parseDateTime:(NSString *)datetime;

+ (NSDate *)parseDateTime2:(NSString *)datetime;

+ (NSDate *)parseDateTime3:(NSString *)datetime;

+ (NSDate *)parseDateTime4:(NSString *)datetime;

+ (NSDate *)parseDateTime5:(NSString *)datetime;

+ (NSDate *)parseDateTime6:(NSString *)datetime;

+ (NSDate *)parseDateTime7:(NSString *)datetime;

+ (NSDate *)getDate:(NSString *)dateString format:(NSString *)formatting;

+ (NSDate *)parseTodayTime:(NSInteger)time;

+ (NSDate *)getTodayLastTime;

+ (NSDate *)getTimeSinceNow:(NSTimeInterval)interval;

+ (NSString *)getWeeKName:(NSInteger)week;

+ (NSString *)getCurrentDate;

// 根据传入的formattering  生成指定格式的时间
+ (NSString *)currentDateWith:(NSString *)formatting;

//供应链添加转换日期格式
+ (long long)formateDateTime2:(NSString*)datetime;

+ (long long)formateDateTime3:(NSString*)datetime;

+ (long long)formateDateTime4:(NSString*)datetime;

+ (long long)formateDateTime5:(NSString*)datetime;

//获取本月的第一天和最后一天
+(NSArray *)getFirstAndLastDayOfThisMonth;

//获取本周的第一天和最后一天
+(NSArray *)getFirstAndLastDayOfThisWeek;

// 今天 昨天 最近三天 本周 本月 自定义时间 转为字符串
+ (long long)converStartTime:(NSString *)time;

+ (long long)converEndTime:(NSString *)time;

+ (long long)converStartTime1:(NSString *)time;


//得到一天的开始时间 ms
+ (long long)getStartTimeOfDate:(NSDate *)date;
//得到一天的结束时间 ms
+ (long long)getEndTimeOfDate:(NSDate *)date;
//得到一天的开始时间 s
+ (long long)getStartTimeOfDate1:(NSDate *)date;
//得到一天的结束时间 s
+ (long long)getEndTimeOfDate1:(NSDate *)date;

//是否1年内
+ (BOOL)getMonthFromStartDate:(NSString *)startDate toEndDate:(NSString *)endDate;
//限制在day天内
+ (BOOL)getDayFromStartDate:(NSString *)startDate toEndDate:(NSString *)endDate withLimitDay:(NSInteger)day;

//取一年前的日期
+ (NSDate *)getYearAgoDate:(NSDate *)date;
//判断一个时间距离当天3个月天
+ (BOOL)daysToNow:(NSDate *)date;

// 将date 转换为指定格式的时间串
+ (NSString *)getDateString:(NSDate *)date format:(NSString *)formatting;
// 某月的天数
+ (NSInteger)getNumberOfDaysInMonth:(NSDate *)date;

/* 后台返回时间 返回指定的时间格式类型，由format指定输出格式 eg：format = @"yyyy-MM-dd HH:mm:ss"
 * 输入时间是long型的 格式默认是yyyyMMddHHmmss
 */
+ (NSString *)getTimeStringFromCreaateTime:(NSString *)createTime format:(NSString *)format;

/**
 date距离现在日期是否在一年内
 
 @param date 判断的日期
 
 @return YES 一年内 NO 不在一年内
 */
+ (BOOL)daysToNowOneYear:(NSDate *)date;



/**
 获取某一天（2017-03-18）的开始时间精确到毫秒

 @param time 2017-03-18
 @return 20170318 00:00:00
 */
+ (long long)getStartTime:(NSString *)time;

/**
 获取某一天（2017-03-18）的结束时间精确到毫秒
 
 @param time 2017-03-18
 @return 20170318 23:59:59
 */
+ (long long)getEndTime:(NSString *)time;

@end
