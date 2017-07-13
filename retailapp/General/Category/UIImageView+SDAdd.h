//
//  UIImageView+SDAdd.h
//  retailapp
//
//  Created by 张鑫 on 16/6/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (SDAdd)

//微店主页设置新增
- (void)sd_setImageWithURL_Angle:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)sd_setImageWithURL_Corner:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;

- (void)ls_setImageWithPath:(NSString *)path placeholderImage:(UIImage *)placeholder;


/**
 圆角设置

 @param radii 圆角半径
 @param bound UIImageView的bounds
 */
- (void)ls_addCornerWithRadii:(CGFloat)radii roundRect:(CGRect)bound;
@end
