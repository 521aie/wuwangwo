//
//  UIViewController+Animation.h
//  retailapp
//
//  Created by guozhi on 2017/2/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    AnimationDirectionH,//水平动画
    AnimationDirectionV//垂直动画
}AnimationDirection;
@interface UIViewController (Animation)
/**
 导航控制器push vc 视图页面动画默认从右到左
 
 @param vc 控制器
 */
- (void)pushViewController:(UIViewController *)vc;

/**
 导航控制器push vc 视图切换页面动画
 
 @param vc 控制器
 @param direct 动画是水平的还是垂直的
 */
- (void)pushViewController:(UIViewController *)vc direct:(AnimationDirection)direct;

/**
 导航控制器pop vc 动画默认从右到左
 */
- (void)popViewController;

/**
 导航控制器pop vc
 
 @param direct 动画方向
 */
- (void)popViewControllerDirect:(AnimationDirection)direct;

/**
 导航控制器pop 到指定的vc
 
 @param vc 控制器
 */
- (void)popToViewController:(UIViewController *)vc;

@end
