//
//  UIHelper.h
//  retailapp
//
//  Created by hm on 15/6/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHelper : NSObject

+(void) clearColor:(UIView*) container;
+ (void)refreshPos:(UIView*) container scrollview:(UIScrollView*) scrollView;

//刷新界面.
+ (void)refreshUI:(UIView*)container;

//超出界面滚动，反之则不滚动.
+ (void)refreshView:(UIView*)container scrollView:(UIScrollView*)scrollView;

//界面变动后，刷新界面.
+(void)refreshUI:(UIView*)container scrollview:(UIScrollView*)scrollView;

+(void)initNotification:(UIView*)container event:(NSString*) eventType;

+ (void)alert:(UIView *)view andDelegate:(id)delegate andTitle:(NSString *)title;

+ (void)alert:(UIView *)view andDelegate:(id)delegate andTitle:(NSString *)title event:(int)event;

+(void)clearChange:(UIView*)container;

+(BOOL)currChange:(UIView*)container;

+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;

@end
