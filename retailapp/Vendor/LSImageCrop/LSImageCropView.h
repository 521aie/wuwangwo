//
//  LSImageCropView.h
//  ScropViewController
//
//  Created by byAlex on 16/7/14.
//  Copyright © 2016年 DIY. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBottomToolBarHeight 54.0f
#define kCropPadding   5.f     // 裁剪框水平距离父view左右边界的距离
@interface LSImageCropView : UIView

@property (nonatomic, strong) UIImage *imageToCrop;
@property (nonatomic, assign) CGSize cropSize;

- (UIImage *)croppedImage;
@end
