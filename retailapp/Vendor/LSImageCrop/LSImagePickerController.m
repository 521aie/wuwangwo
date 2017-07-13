//
//  LSImagePickerController.m
//  ScropViewController
//
//  Created by byAlex on 16/7/14.
//  Copyright © 2016年 DIY. All rights reserved.
//

#import "LSImagePickerController.h"
#import "LSImageCropController.h"

@interface LSImagePickerController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate ,LSImageCropDelegate>

@property (nonatomic ,weak) UIViewController<LSImagePickerDelegate> *delegate;/* <<#desc#>*/
@property (nonatomic ,strong) UIImagePickerController *imagePickerViewController;/* <<#desc#>*/
@end

@implementation LSImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)initWith:(UIImagePickerControllerSourceType)type {
    self = [super init];
    if (self) {
        _imagePickerViewController = [[UIImagePickerController alloc] init];
        _imagePickerViewController.sourceType = type;
        _imagePickerViewController.delegate = self;
    }
    return self;
}

+ (instancetype)showImagePickerWith:(UIImagePickerControllerSourceType)type presenter:(__kindof UIViewController<LSImagePickerDelegate> *)presentViewController
{
    LSImagePickerController *imagePicker = nil;
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        imagePicker = [[self alloc] initWith:type];
        imagePicker.delegate = presentViewController;
        [presentViewController presentViewController:imagePicker.imagePickerViewController animated:YES completion:nil];
    }else{
        if ([presentViewController respondsToSelector:@selector(imagePickerDidCancel:)]) {
            [presentViewController imagePickerDidCancel:(LSImageMessageType)type];
        }
    }
    return imagePicker;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *rawImage = [self fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
        if (rawImage) {
            LSImageCropController *cropVc = [[LSImageCropController alloc] initWithImage:rawImage];
            cropVc.cropDelegate = self;
            cropVc.cropSize = _cropSize;
            [self.imagePickerViewController pushViewController:cropVc animated:YES];
        }
}

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    if ([self.delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
//        [self.delegate imagePickerDidCancel:LSImageMessageCancel];
//    }
//    [self.imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
//}


#pragma mark - LSImageCropDelegate
- (void)imageCropController:(LSImageCropController *)imageCropController didFinishWithCroppedImage:(UIImage *)croppedImage {
    if ([self.delegate respondsToSelector:@selector(imagePicker:pickerImage:)]) {
        [self.imagePickerViewController dismissViewControllerAnimated:YES completion:^{
             [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }];
        [self.delegate imagePicker:self pickerImage:croppedImage];
    }
}


#pragma mark - 解决IPHONE 竖着拍照最终显示图片却是横图的问题

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    if (aImage==nil || !aImage) {
        
        return nil;
        
    }
    
    // No-op if the orientation is already correct
    
    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    UIImageOrientation orientation=aImage.imageOrientation;
    
    int orientation_=orientation;
    
    switch (orientation_) {
            
        case UIImageOrientationDown:
            
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            
            transform = CGAffineTransformRotate(transform, M_PI);
            
            break;
            
            
            
        case UIImageOrientationLeft:
            
        case UIImageOrientationLeftMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            
            transform = CGAffineTransformRotate(transform, M_PI_2);
            
            break;
            
            
            
        case UIImageOrientationRight:
            
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            
            break;
            
    }
    
    
    switch (orientation_) {
            
        case UIImageOrientationUpMirrored:{
            
        }
            
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
            
        case UIImageOrientationLeftMirrored:
            
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
    }
    
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    
    // calculated above.
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             
                                             CGImageGetColorSpace(aImage.CGImage),
                                             
                                             CGImageGetBitmapInfo(aImage.CGImage));
    
    CGContextConcatCTM(ctx, transform);
    
    
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationLeft:
            
        case UIImageOrientationLeftMirrored:
            
        case UIImageOrientationRight:
            
        case UIImageOrientationRightMirrored:
            
            // Grr...
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            
            break;
            
        default:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            
            break;
            
    }
    
    
    // And now we just create a new UIImage from the drawing context
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGContextRelease(ctx);
    
    CGImageRelease(cgimg);
    
    aImage=img;
    
    img=nil;
    
    return aImage;
    
}

@end
