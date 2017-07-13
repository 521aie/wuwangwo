//
//  NSNumber+Helper.h
//  retailapp
//
//  Created by taihangju on 2016/11/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Extension)


/**
 返回指定最大小数位的百分数字符串

 @param maximumFractionDigits 指定小数点后的最大位数，默认最大小数位：2位
 @return eg 3.3344 -> "333.44%"
 */
- (NSString *)percentageStringWithDecimalDigits:(NSUInteger)maximumFractionDigits;


/**
 返回带货币前缀符号的字符串, 保留两位小数

 @param currencySymbol 货币符号 eg：￥/$
 @return eg 300 -> "￥300.00"
 */
- (NSString *)currencyStringWithSymbol:(NSString *)currencySymbol;


/**
 求两个NSNumber的乘积，并转换为NSString对象

 @param multiplier 乘数对应的NSNumber实例
 @return 返回乘积的NSString 对象
 */
- (NSString *)productStringWithNumber:(NSNumber *)multiplier;


/**
 NSNumber 转换为string，可设置最大小数位数

 @param maximumFractionDigits 指定小数点后的最大位数，默认最大小数位：2位, 不够2位小数不会补零
 @return 返回转换后的NSString 对象
 */
- (NSString *)stringFromNumberWithDecimalDigits:(NSUInteger)maximumFractionDigits;


/**
 NSNumber 转换为指定格式类型的string，
 
 @param format 指定转换参照的格式
 @return 返回转换后的NSString 对象
 */
- (NSString *)convertToStringWithFormat:(NSString *)format;
@end
