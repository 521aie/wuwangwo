//
//  NavigateTitle.m
//  RestApp
//
//  Created by zxh on 14-3-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIView+Sizes.h"
#import <UIKit/UIKit.h>

@implementation UIView (Sizes)

- (CGFloat)ls_left {
    return self.frame.origin.x;
}

- (void)setLs_left:(CGFloat)ls_left {
    CGRect frame = self.frame;
    frame.origin.x = ls_left;
    self.frame = frame;
}

- (CGFloat)ls_top {
    return self.frame.origin.y;
}

- (void)setLs_top:(CGFloat)ls_top {
    CGRect frame = self.frame;
    frame.origin.y = ls_top;
    self.frame = frame;
}

- (CGFloat)ls_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setLs_right:(CGFloat)ls_right {
    CGRect frame = self.frame;
    frame.origin.x = ls_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ls_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLs_bottom:(CGFloat)ls_bottom {
    CGRect frame = self.frame;
    frame.origin.y = ls_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)ls_width {
    return self.frame.size.width;
}

- (void)setLs_width:(CGFloat)ls_width {
    CGRect frame = self.frame;
    frame.size.width = ls_width;
    self.frame = frame;
}

- (CGFloat)ls_height {
    return self.frame.size.height;
}

- (void)setLs_height:(CGFloat)ls_height {
    CGRect frame = self.frame;
    frame.size.height = ls_height;
    self.frame = frame;
}

- (CGPoint)ls_origin {
    return self.frame.origin;
}

- (void)setLs_origin:(CGPoint)ls_origin {
    CGRect frame = self.frame;
    frame.origin = ls_origin;
    self.frame = frame;
}

- (CGSize)ls_size {
    return self.frame.size;
}

- (void)setLs_size:(CGSize)ls_size {
    CGRect frame = self.frame;
    frame.size = ls_size;
    self.frame = frame;
}

- (void)setLs_centerX:(CGFloat)ls_centerX {
    CGPoint center = self.center;
    center.x = ls_centerX;
    self.center = center;
}

- (CGFloat)ls_centerX {
    return self.center.x;
}

- (void)setLs_centerY:(CGFloat)ls_centerY {
    CGPoint center = self.center;
    center.y = ls_centerY;
    self.center = center;
}

- (CGFloat)ls_centerY {
    return self.center.y;
}

- (void)ls_addCornerWithRadii:(CGFloat)radii roundRect:(CGRect)bound {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bound byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = bound;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
