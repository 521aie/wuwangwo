//
//  布局使用的类.
//  RestApp
//
//  Created by zxh on 14-3-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#import <UIKit/UIView.h>

@interface UIView (Sizes)

@property (nonatomic) CGFloat ls_left;

@property (nonatomic) CGFloat ls_top;

@property (nonatomic) CGFloat ls_right;

@property (nonatomic) CGFloat ls_bottom;

@property (nonatomic) CGFloat ls_width;

@property (nonatomic) CGFloat ls_height;

@property (nonatomic) CGPoint ls_origin;

@property (nonatomic) CGSize ls_size;

@property (nonatomic) CGFloat ls_centerX;

@property (nonatomic) CGFloat ls_centerY;


/**
 设置圆角

 @param radii 圆角半径
 @param bound 设置圆角view的bounds，因为有的view调用该方法时的bounds不一定是最终显示的bounds
 */
- (void)ls_addCornerWithRadii:(CGFloat)radii roundRect:(CGRect)bound;
@end
