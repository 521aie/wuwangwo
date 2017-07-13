//
//  NSString+Estimate.m
//  retailapp
//
//  Created by hm on 15/6/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "NSString+Estimate.h"

@implementation NSString (Estimate)


+ (BOOL)isNotBlank:(NSString *)source {
    
    if(source == nil || [source isEqual:[NSNull null]] || source.length == 0 || [source stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return NO;
    }
    return YES;
}

+ (BOOL)isBlank:(NSString *)source {
    
    if(source == nil || [source isEqual:[NSNull null]] || source.length == 0 || [source stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return YES;
    }
    return NO;
}

//
+ (BOOL)isInvalidatedOrgNum:(NSString *)checkString {
    
    NSString *rule = @".*[a-zA-Z]+.*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    BOOL isInvalidated = ![predicate evaluateWithObject:checkString];
    return isInvalidated;
}

//非0正整数验证.
+ (BOOL)isNumNotZero:(NSString *)source {
    
    if ([NSString isBlank:source]) {
        return NO;
    }
    NSString *rule=@"^[1-9]\\d*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    return [predicate evaluateWithObject:source];
}

//正整数验证(带0).
+ (BOOL)isPositiveNum:(NSString *)source {
    
    if ([NSString isBlank:source]) {
        return NO;
    }
    NSString *rule=@"^[1-9]\\d*|0$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    return [predicate evaluateWithObject:source];
}

//整数验证.
+ (BOOL)isInt:(NSString *)source {
    
    if ([NSString isBlank:source]) {
        return NO;
    }
    NSString* rule=@"^-?[1-9]\\d*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    return [predicate evaluateWithObject:source];
}

//小数正验证.
+ (BOOL)isFloat:(NSString *)source {
    
    if ([NSString isBlank:source]) {
        return NO;
    }
    if ([NSString isPositiveNum:source]) {
        return YES;
    }
    NSString *rule = @"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    return [predicate evaluateWithObject:source];
}

//千分位转换
+(NSString *)numberFormatterWithDouble:(NSNumber *)number{
 
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:number];
    return formattedNumberString;
}


// 是否是纯数字
+ (BOOL)isValidNumber:(NSString *)value {
   
    NSString *num = @"^[0-9]+$";
    NSPredicate *regextestnum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    return [regextestnum evaluateWithObject:value];;
}


//包换不是数字英文字母验证.
+ (BOOL)isNotNumAndLetter:(NSString *)source {
    
    if ([NSString isBlank:source]) {
        return YES;
    }
    NSString *rule = @"[^a-zA-Z0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    return [predicate evaluateWithObject:source];
}


//包换不是数字英文字母 - *验证.
+(BOOL) isNotNumAndLetter1:(NSString*)source
{
    if ([NSString isBlank:source]) {
        return YES;
    }
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:source];
//    source = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    source = [str stringByReplacingOccurrencesOfString:@"*" withString:@""];
    NSString *rule=@"[^a-zA-Z0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    return [predicate evaluateWithObject:source];
}



//日期验证.
+ (BOOL)isDate:(NSString *)source {
    
    if ([NSString isBlank:source]) {
        return NO;
    }
    NSString *rule = @"^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2} CST$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    return [predicate evaluateWithObject:source];
}

//URL路径过滤掉随机数.
+ (NSString *)urlFilterRan:(NSString *)urlPath
{
    NSString *rule = @"(.*)([\\?|&]ran=[^&]+)";
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:rule
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];
   NSString *resultStr = [regExp stringByReplacingMatchesInString:urlPath
                                                 options:NSMatchingReportProgress
                                                   range:NSMakeRange(0, urlPath.length)
                                            withTemplate:@"$1"];
    return resultStr;
}

+ (NSString *)getUniqueStrByUUID {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef= CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *retStr = [NSString stringWithString:(__bridge NSString *)uuidStrRef];
    CFRelease(uuidStrRef);
    retStr=[retStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    retStr=[retStr stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return [retStr lowercaseString];
}

//根据后台给的图片路径获取UDID
+ (NSString *)getUDID:(NSString *)filePath {
    NSArray *arr = [filePath componentsSeparatedByString:@"/"];
    NSUInteger count = arr.count - 2;
    NSString *unid = [arr objectAtIndex:count];
    return unid;
}

//根据后台给的图片路径获取最后面的路径
+ (NSString *)getImagePath:(NSString *)filePath {
    if (filePath == nil) {
        return nil;
    }
    NSArray *arr = [filePath componentsSeparatedByString:@"/"];
    NSUInteger count = arr.count - 1;
    NSString *unid1 = [arr objectAtIndex:count];
    NSString *unid2 = [arr objectAtIndex:(count-1)];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", unid2, unid1];
    return imagePath;
}

//验证Email是否正确.
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"\\w{1,}[@][\\w\\-]{1,}([.]([\\w\\-]{1,})){1,3}$";
    //@"[A-Z0-9a-z_%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//传真验证
+ (BOOL)isValidateFax:(NSString *)fax
{
    NSString *faxRegex = @"^(([0-9]{3})|([0-9]{4}))[-]\\d{6,8}$";
    NSPredicate *faxTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", faxRegex];
    return [faxTest evaluateWithObject:fax];
}

//判断手机号
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：139 138 137 136 135 134 147 150 151 152 157 158 159 178 182 183 184 187 188
     * 联通：130 131 132 155 156 185 186 145 176
     * 电信：133 153 177 180 181 189
     * 卫星通信: 1349
     * 虚拟运营商: 170
     */
    NSString * MOBILE = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//判断手机号及其后四位
+ (BOOL)isValidatePhone:(NSString *)phoneNumber {
   
    if ([NSString isValidNumber:phoneNumber]) {
        if (phoneNumber.length == 11) {
            
            if ([self validateMobile:phoneNumber]) {
                return YES;
            } else {
                return NO;            }
        } else if (phoneNumber.length == 4) {
            return YES;
        } else {
            return NO;
        }
        
    } else {
        return NO;
    }
    return YES;
}
//校验固定电话
+ (BOOL)validateHomeMobile:(NSString *)homeMobileNum;{
    NSString * regex = @"^0\\d{2,3}-\\d{7,8}(-\\d{1,6})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:homeMobileNum];
    return isMatch;
}
#pragma mark - 校验短信内容
+ (BOOL)validateSmsContent:(NSString *)smsContent{
    NSString * regex = @".*[\\[\\]【】]+.*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:smsContent];
    return !isMatch;
}

+ (NSString *)stringForObject:(NSString *)source {
    if (source == nil || [source isEqual:[NSNull null]]) {
        return @"";
    } else {
        return source;
    }
}

// 判断是否有效银行卡号
+ (BOOL)isValidCreditNumber:(NSString *)value {
    
    BOOL result = NO;
    
    NSInteger length = [value length];
    
    if (length >= 13) {
        
        result = [self isValidNumber:value];
        
        if (result)
        {
            int sum = 0;
            int digit = 0;
            int addend = 0;
            BOOL timesTwo = false;
            for (NSInteger i = value.length - 1; i >= 0; i--)
            {
                digit = [value characterAtIndex:i] - '0';
                if (timesTwo) {
                    addend = digit * 2;
                    if (addend > 9) {
                        addend -= 9;
                    }
                } else {
                    addend = digit;
                }
                sum += addend;
                timesTwo = !timesTwo;
            }
            int modulus = sum % 10;
            return modulus == 0;
        }
        
    }else {
        
        result = FALSE;
        
    }
    return result;
}


//身份证验证
+ (BOOL)validateIDCardNumber:(NSString *)value {
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSUInteger length =0;
    
    if (!value) {
        return NO;
    }else {
        
        length = value.length;
        if (length !=15 && length !=18) {
            return NO;
        }
        
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    
    
    NSString *valueStart2 = [value substringToIndex:2];
    
    BOOL areaFlag = NO;
    
    for (NSString *areaCode in areasArray) {
        
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
        
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year =0;
    
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            

            if(numberofMatch >0){
                return YES;
            }else {
                return NO;
            }
            
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            

            if(numberofMatch >0) {
                
                int S = ([value substringWithRange:NSMakeRange(0, 1)].intValue  +
                         [value substringWithRange:NSMakeRange(10,1)].intValue)*7  +
                        ([value substringWithRange:NSMakeRange(1, 1)].intValue  +
                         [value substringWithRange:NSMakeRange(11,1)].intValue)*9  +
                        ([value substringWithRange:NSMakeRange(2, 1)].intValue  +
                         [value substringWithRange:NSMakeRange(12,1)].intValue)*10 +
                        ([value substringWithRange:NSMakeRange(3, 1)].intValue  +
                         [value substringWithRange:NSMakeRange(13,1)].intValue)*5  +
                        ([value substringWithRange:NSMakeRange(4, 1)].intValue  +
                         [value substringWithRange:NSMakeRange(14,1)].intValue)*8  +
                        ([value substringWithRange:NSMakeRange(5, 1)].intValue  +
                         [value substringWithRange:NSMakeRange(15,1)].intValue)*4  +
                        ([value substringWithRange:NSMakeRange(6, 1)].intValue  +
                         [value substringWithRange:NSMakeRange(16,1)].intValue)*2  +
                        [value substringWithRange:NSMakeRange(7,1)].intValue *1 +
                        [value substringWithRange:NSMakeRange(8,1)].intValue *6 +
                        [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S % 11;
                
                NSString *M =@"F";
                
                NSString *JYM =@"10X98765432";
                
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
        default:
            return NO;
            
    }
    
}


//获得简写的单号
+ (NSString *)shortStringForOrderID:(NSString *)orderID {
    
    if (orderID == nil || [orderID isEqual:[NSNull null]]) {
        return @"";
    } else {
        NSString *firstChar = [orderID substringToIndex:1];
        NSString *firstThreeChars = [orderID substringToIndex:3];
        NSString *shortId = orderID;
        if ([firstChar isEqualToString:@"1"]) {
            //实体销售单,取后17位
            if (orderID.length >= 17) {
                shortId = [orderID substringFromIndex:orderID.length - 17];
            }
        }else if ([firstChar isEqualToString:@"2"]){
            //实体退货单,取后15位
            if (orderID.length >= 15) {
                 shortId = [orderID substringFromIndex:orderID.length - 15];
            }
           
        }else if ([firstThreeChars isEqualToString:@"ROW"] || [firstThreeChars isEqualToString:@"RRW"]){
            //微店销售单,去掉前三位
            shortId = [orderID substringFromIndex:3];
            //最新需求不做处理
        }else if ([firstThreeChars isEqualToString:@"RBW"]){
            //微店退货单,去掉前三位
            shortId = [orderID substringFromIndex:3];
        }else if ([firstChar isEqualToString:@"8"]){
            //退货单,取后15位
            if (orderID.length >= 15) {
                shortId = [orderID substringFromIndex:orderID.length - 15];
            }
        } else if ([firstThreeChars isEqualToString:@"ROP"]) {
            shortId = [orderID substringFromIndex:3];

        }
        return shortId;
    }

}

+ (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font{
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

//是否包含表情符号
+ (BOOL)stringContainsEmoji:(NSString * __autoreleasing *)string {
//    __block BOOL returnValue = NO;
//    
//    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
//                               options:NSStringEnumerationByComposedCharacterSequences
//                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//                                const unichar hs = [substring characterAtIndex:0];
//                                if (0xd800 <= hs && hs <= 0xdbff) {
//                                    if (substring.length > 1) {
//                                        const unichar ls = [substring characterAtIndex:1];
//                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
//                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
//                                            returnValue = YES;
//                                        }
//                                    }
//                                } else if (substring.length > 1) {
//                                    const unichar ls = [substring characterAtIndex:1];
//                                    if (ls == 0x20e3) {
//                                        returnValue = YES;
//                                    }
//                                } else {
//                                    if (0x2100 <= hs && hs <= 0x27ff) {
//                                        returnValue = YES;
//                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
//                                        returnValue = YES;
//                                    } else if (0x2934 <= hs && hs <= 0x2935) {
//                                        returnValue = YES;
//                                    } else if (0x3297 <= hs && hs <= 0x3299) {
//                                        returnValue = YES;
//                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
//                                        returnValue = YES;
//                                    }
//                                }
//                            }];
//    
//    return returnValue;

    NSCharacterSet *symbolCharacterSet = [NSCharacterSet symbolCharacterSet];
    NSRange range = [*string rangeOfCharacterFromSet:symbolCharacterSet options:NSLiteralSearch];
    if (range.location != NSNotFound) {
        // the first character int
        NSCharacterSet *exceptCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"$~^=+|¥<>"];
        NSString *subString = [*string substringWithRange:range];
        if ([subString rangeOfCharacterFromSet:exceptCharacterSet].location == NSNotFound) {
            *string = [*string stringByReplacingOccurrencesOfString:subString withString:@""];
            return YES;
        }
    }
    return NO;
}

//判断是否为汉字
+ (BOOL)isChineseCharacter:(NSString *)text
{
    int a = 0;
    for (int i=0; i<text.length; i++) {
        NSRange range=NSMakeRange(i,1);
        NSString *subString=[text substringWithRange:range];
        const char *cString=[subString UTF8String];
        if (strlen(cString)==3)
        {
            a=1;
        }else{
//            a=0;
            return NO;
        }
    }
    if (a == 1) {
        return YES;
    }
    return YES;
}


//截取前几个字节
+ (NSString *)text:(NSString *)text subToIndex:(NSUInteger)index {
    int a = 0;
    for (int i=0; i<text.length; i++) {
        
        NSRange range=NSMakeRange(i,1);
        NSString *subString=[text substringWithRange:range];
        const char *cString=[subString UTF8String];
        if (cString == NULL) {
            a = a+ 1;
        } else if (strlen(cString)==3) {
            a= a + 2;
        }else{
            a = a+ 1;
        }
        if (a > index) {
            text = [text substringToIndex:i];
            text = [text stringByAppendingString:@"..."];
            return text;
            break;
        }
        
        
    }
    return text;
}

/**
 *  计算文本size
 *
 *  @param text    内容
 *  @param font    字体
 *  @param maxSize 最大长度
 *
 *  @return size
 */
+ (CGSize)getTextSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    CGSize size = CGSizeZero;
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}


//////******************************字符串和NSNumber的转换***********************************/////
- (NSNumber *)convertToNumber {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [numberFormatter numberFromString:self];
}

- (NSString *)getNumberStringWithFractionDigits:(NSInteger)maxDigits {
   
    NSString *format = [NSString stringWithFormat:@"%%.%ldf" ,maxDigits];
    if ([self containsString:@"."]) {
        return [NSString stringWithFormat:format ,self.doubleValue];
    }
    return self;
}

- (NSString *)formatWith2FractionDigits {
    
    NSNumber *number = [self convertToNumber];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00"];
    return [numberFormatter stringFromNumber:number];
}

@end
