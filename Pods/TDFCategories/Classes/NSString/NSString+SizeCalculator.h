//
//  NSString+SizeCalculator.h
//  TDFCategories
//
//  Created by tripleCC on 3/15/17.
//  Copyright © 2017 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (SizeCalculator)
- (CGFloat)tdf_widthForFont:(UIFont *)font;
- (CGFloat)tdf_heightForFont:(UIFont *)font width:(CGFloat)width;
- (CGSize)tdf_sizeForFont:(UIFont *)font;
- (CGSize)tdf_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
@end
