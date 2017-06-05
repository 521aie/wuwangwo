//
//  XHAnimalUtil.h
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHAnimalUtil : NSObject
+ (void)animal:(UIViewController *)controller type:(NSString *)type
     direction:(NSString *)direction;
+ (void)animalEdit:(UIViewController *)controller action:(NSInteger)action;
+ (void)animalPush:(UIViewController *)controller action:(NSInteger)action;

+ (void)animationPushUp:(UIView *)view;
+ (void)animationPushDown:(UIView *)view;
+ (void)animationPushLeft:(UIView *)view;
+ (void)animationPushRight:(UIView *)view;

// move
+ (void)animationMoveUp:(UIView *)view;
+ (void)animationMoveDown:(UIView *)view;
+ (void)animationMoveLeft:(UIView *)view;
+ (void)animationMoveRight:(UIView *)view;
@end
