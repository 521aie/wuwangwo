//
//  XHAnimalUtil.m
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "XHAnimalUtil.h"

@implementation XHAnimalUtil

+ (void)animal:(UIViewController *)controller type:(NSString *)type direction:(NSString *)direction
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type;
    transition.subtype = direction;
//    transition.delegate = (id)controller;
    [controller.view.layer addAnimation:transition forKey:nil];
    [controller.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
}


+ (void)animalPush:(UIViewController *)controller action:(NSInteger)action
{
    if (action==ACTION_CONSTANTS_ADD) {
        [XHAnimalUtil animal:controller type:kCATransitionPush direction:kCATransitionFromTop];
    }else{
        [XHAnimalUtil animal:controller type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

+ (void)animalEdit:(UIViewController *)controller action:(NSInteger)action
{
    if (action==ACTION_CONSTANTS_ADD) {
        [XHAnimalUtil animal:controller type:kCATransitionPush direction:kCATransitionFromBottom];
    }else{
        [XHAnimalUtil animal:controller type:kCATransitionPush direction:kCATransitionFromLeft];
    }
}

+ (void)animationPushUp:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
    
    [view.layer addAnimation:animation forKey:nil];
}

+ (void)animationPushDown:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    
    [view.layer addAnimation:animation forKey:nil];
}

+ (void)animationPushLeft:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    
    [view.layer addAnimation:animation forKey:nil];
}

+ (void)animationPushRight:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  
                                  functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [view.layer addAnimation:animation forKey:nil];
}

// presentModalViewController
+ (void)animationMoveUp:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.4];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromTop];
    [view.layer addAnimation:animation forKey:nil];
}

// dissModalViewController
+ (void)animationMoveDown:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration =0.4;
    transition.timingFunction = [CAMediaTimingFunction
                                 functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [view.layer addAnimation:transition forKey:nil];
}

+ (void)animationMoveLeft:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromLeft];
    
    [view.layer addAnimation:animation forKey:nil];
}

+ (void)animationMoveRight:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromRight];
    [view.layer addAnimation:animation forKey:nil];
}

@end
