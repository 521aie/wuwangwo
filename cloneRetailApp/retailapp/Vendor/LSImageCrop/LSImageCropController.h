//
//  LSImageCropController.h
//  ScropViewController
//
//  Created by byAlex on 16/7/14.
//  Copyright © 2016年 DIY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSImageCropDelegate;
@interface LSImageCropController : UIViewController

@property (nonatomic, assign) CGSize cropSize; //size of the crop rect
@property (nonatomic ,weak) id<LSImageCropDelegate> cropDelegate;/* <<#desc#>*/

- (instancetype)initWithImage:(UIImage *)originImage;
@end

@protocol LSImageCropDelegate <NSObject>

- (void)imageCropController:(LSImageCropController *)imageCropController didFinishWithCroppedImage:(UIImage *)croppedImage;
@end
