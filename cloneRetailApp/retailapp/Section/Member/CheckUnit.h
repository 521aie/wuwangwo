//
//  CheckUnit.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckUnit : NSObject

+ (BOOL)validateIDCardNumber:(NSString *)value;

+ (BOOL) validateEmail:(NSString *)email;

//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;

//车型
+ (BOOL) validateCarType:(NSString *)CarType;

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;

//固定电话验证
+ (BOOL) validateTel:(NSString *)tel;

@end
