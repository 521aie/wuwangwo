//
//  SignUtil.h
//  retailapp
//
//  Created by hm on 15/6/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUtil : NSObject
+ (NSString*)convertPassword:(NSString*)password;
+ (NSString*)convertSign:(NSMutableDictionary*)params;
+ (NSString*)convertOutSign:(NSString *)time;
@end
