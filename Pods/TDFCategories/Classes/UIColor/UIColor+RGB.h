//
//  UIColor+Factory.h
//  DHTTableViewManager
//
//  Created by tripleCC on 12/9/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGB)

/**
 根据rgb构建颜色

 @param rgbValue rgb   （0x333333）
 @return 颜色
 */
+ (UIColor *)tdf_colorWithRGB:(uint32_t)rgbValue;
+ (UIColor *)tdf_colorWithRGBA:(uint32_t)rgbaValue;
+ (UIColor *)tdf_colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;
@end
