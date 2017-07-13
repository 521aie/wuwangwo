//
//  NumberUtil.h
//  CardApp
//
//  Created by 邵建青 on 14-1-17.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberUtil : NSObject

+ (BOOL)isZero:(double)num;

+ (BOOL)isNotZero:(double)num;

+ (BOOL)isEqualNum:(double)num1 num2:(double)num2;

+ (BOOL)isNotEqualNum:(double)num1 num2:(double)num2;

@end
