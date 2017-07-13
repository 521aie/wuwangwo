//
//  NSDictionary+LB.h
//  CardApp
//
//  Created by sheldon on 15/2/5.
//  Copyright (c) 2015年 2dfire.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(LB)

- (BOOL)containKey:(NSString *)key;
- (id)safeObjectForKey:(NSString *)key;


//取返回数据的方法
- (int)cardResultCode;
- (id)cardResultModel;

/**
 *  格式化输出float 类型字符串
 *
 *  @param key     数据Key
 *  @param decimal 小数点后位数
 *
 *  @return 返回格式化字符串
 */
- (NSString *)safeObjectForKeyFloat:(NSString *)key decimal:(int)decimal;

/**
 *  价格格式化字符
 *
 *  @param key 取值的Key
 *
 *  @return 返回格式化字符串
 */
- (NSString *)safeObjectForKeyPrice:(NSString *)key;
- (NSString *)dataTojsonString;
@end
