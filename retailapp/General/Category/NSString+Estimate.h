//
//  NSString+Estimate.h
//  retailapp
//
//  Created by hm on 15/6/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Estimate)

+ (BOOL)isNotBlank:(NSString*)source;

+ (BOOL)isBlank:(NSString*)source;

//正整数验证(带0).
+(BOOL) isPositiveNum:(NSString*)source;
//非0正整数验证.
+(BOOL) isNumNotZero:(NSString*)source;
//不是数字英文字母验证.
+(BOOL) isNotNumAndLetter:(NSString*)source;

//整数验证.
+(BOOL) isInt:(NSString*)source;
//小数正验证.
+(BOOL) isFloat:(NSString*)source;

//日期验证.
+(BOOL) isDate:(NSString*)source;
// 是否是纯数字
+ (BOOL)isValidNumber:(NSString*)value;
//包换不是数字英文字母 - 验证.
+(BOOL) isNotNumAndLetter1:(NSString*)source;
//根据后台给的图片路径获取UDID
+ (NSString *)getUDID:(NSString *)filePath;
//根据后台给的图片路径获取最后面的路径
+ (NSString *)getImagePath:(NSString *)filePath;
//根据后台给的图片路径获取最后面的路径
+ (NSString *)getImageLastPath:(NSString *)filePath;
//URL路径过滤掉随机数.
+(NSString*) urlFilterRan:(NSString*)urlPath;

+(NSString *)getUniqueStrByUUID;
#pragma mark - 校验短信内容
+ (BOOL)validateSmsContent:(NSString *)smsContent;
//验证Email是否正确.
+ (BOOL)isValidateEmail:(NSString *)email;

//传真验证
+ (BOOL)isValidateFax:(NSString *)fax;

//验证手机号
+ (BOOL)validateMobile:(NSString *)mobileNum;
+ (BOOL)validateHomeMobile:(NSString *)homeMobileNum;
//判断手机号及其后四位
+ (BOOL)isValidatePhone:(NSString *)phoneNumber;

+ (NSString *)stringForObject:(NSString *)source;

//有效银行卡号验证
+ (BOOL)isValidCreditNumber:(NSString*)value;

//身份证验证
+ (BOOL)validateIDCardNumber:(NSString *)value;

/**
 *  连锁添加机构或者门店时，机构或门店编号校验（1~16的字符串，必须包含字母）
 *
 *  @param checkString <#checkString description#>
 *
 *  @return YES 标示不合法
 */

+ (BOOL)isInvalidatedOrgNum:(NSString *)checkString;

//获得简写的单号
+ (NSString *)shortStringForOrderID:(NSString *)orderID;

//获得最大尺寸
+ (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font;

//是否包含表情符号
+ (BOOL)stringContainsEmoji:(inout NSString **)string;
//千分位转换
+(NSString *)numberFormatterWithDouble:(NSNumber *)number;
//判断是否为汉字
+ (BOOL)isChineseCharacter:(NSString *)text;
//截取前几个字节
+ (NSString *)text:(NSString *)text subToIndex:(NSUInteger)index;
// 计算文本的size
+ (CGSize)getTextSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

//////******************************字符串和NSNumber的转换***********************************/////
- (NSNumber *)convertToNumber;


/**
 转换为数字类型的字符串，返回最大指定小数位的字符串或者整数

 @param maxDigits 指定最大允许显示小数位,
 @return 整数型字符串直接返回; 小数返回最大允许小数位内的小数
 */
- (NSString *)getNumberStringWithFractionDigits:(NSInteger)maxDigits;


/**
 字符串格式化(类似金钱的显示格式,固定2位小数位显示)：eg：@"100" -> @"100.00" , @"58.99" -> @"58.99"

 @return 格式化后的string
 */
- (NSString *)formatWith2FractionDigits;
@end
