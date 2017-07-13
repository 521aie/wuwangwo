//
//  UIImageView+SDAdd.m
//  retailapp
//
//  Created by 张鑫 on 16/6/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIImageView+SDAdd.h"

@implementation UIImageView (SDAdd)
- (void)sd_setImageWithURL_Angle:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    if (placeholder == nil) {
        placeholder = [UIImage imageNamed:@"img_default_angle"];
    }
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:nil completed:nil];
}

- (void)sd_setImageWithURL_Corner:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    if (placeholder == nil) {
        placeholder = [UIImage imageNamed:@"img_default_corner"];
    }
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)ls_setImageWithPath:(NSString *)path placeholderImage:(UIImage *)placeholder {
    if (!path || !path.length || ![path hasPrefix:@"http"]) {
        self.image = placeholder; return;
    }
    NSURL *imageUrl = [NSURL URLWithString:[path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self sd_setImageWithURL:imageUrl placeholderImage:placeholder options:SDWebImageRetryFailed progress:nil completed:nil];
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
