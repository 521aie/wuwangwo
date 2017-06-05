//
//  UIImage+Orientation.h
//  TDFCategories
//
//  Created by tripleCC on 3/21/17.
//  Copyright © 2017 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)
- (UIImage *)tdf_upOrientation;
- (UIImage *)tdf_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;
@end
