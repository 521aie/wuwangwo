//
//  LSImageCropView.m
//  ScropViewController
//
//  Created by byAlex on 16/7/14.
//  Copyright © 2016年 DIY. All rights reserved.
//

#import "LSImageCropView.h"
#import "LSImageCropOverlayView.h"

#define rad(angle) ((angle) / 180.0 * M_PI)
@interface ScrollView : UIScrollView

@end

@implementation ScrollView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIView *zoomView = [self.delegate viewForZoomingInScrollView:self];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = zoomView.frame;
    
    // 水平居中
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // 垂直居中
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    zoomView.frame = frameToCenter;
    
}

@end


@interface LSImageCropView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) LSImageCropOverlayView *cropOverlayView;
@property (nonatomic, assign) CGFloat xOffset;
@property (nonatomic, assign) CGFloat yOffset;
@end

@implementation LSImageCropView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        self.scrollView = [[ScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.decelerationRate = 0.0;
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.scrollView.frame];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor = [UIColor blackColor];
        [self.scrollView addSubview:self.imageView];
        
        self.scrollView.maximumZoomScale = 5.0;
        [self.scrollView setZoomScale:1.0];
    }
    return self;
}

- (void)setCropSize:(CGSize)cropSize{
    
    if (self.cropOverlayView == nil){
        self.cropOverlayView = [[LSImageCropOverlayView alloc] initWithFrame:self.bounds];
        [self addSubview:self.cropOverlayView];
    }
    self.cropOverlayView.cropSize = cropSize;
}

- (void)setImageToCrop:(UIImage *)imageToCrop {
    _imageToCrop = imageToCrop;
    self.imageView.image = imageToCrop;
}

- (CGSize)cropSize{
    return self.cropOverlayView.cropSize;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.cropSize;
    self.xOffset = floor((CGRectGetWidth(self.bounds) - size.width) * 0.5);
    self.yOffset = floor((CGRectGetHeight(self.bounds) - size.height) * 0.5); //fixed
    
    CGFloat height = self.imageToCrop.size.height;
    CGFloat width = self.imageToCrop.size.width;
    
    CGFloat factor = 0.f, widthFactor = 0.f, heightFactor = 0.f;
    CGFloat factoredHeight = 0.f;
    CGFloat factoredWidth = 0.f;
    
    widthFactor = width / size.width;
    heightFactor = height / size.height;
    factor = MIN(widthFactor, heightFactor);
    factoredWidth = width / factor;
    factoredHeight = height / factor;
    
    self.cropOverlayView.frame = self.bounds;
    self.scrollView.frame = CGRectMake(_xOffset, _yOffset, size.width, size.height);
    self.imageView.frame = CGRectMake(0, floor((size.height - factoredHeight) * 0.5), factoredWidth, factoredHeight);
    
    /* TODO
     implement a feature that allows restricting the zoom scale to the max available
     (based on image's resolution), to prevent pixelation. We simply have to deteremine the
     max zoom scale and place it here
     */
    self.scrollView.minimumZoomScale = CGRectGetWidth(self.scrollView.frame) / CGRectGetWidth(self.imageView.frame);
    // 让图片居中显示
    [self.scrollView setContentOffset:CGPointMake((factoredWidth - size.width) * 0.5, (factoredHeight - size.height) * 0.5)];
    [self.scrollView setContentSize:self.imageView.frame.size];
}


#pragma mark - 交互事件转发
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 发生在self.view的事件，全部指派给scrollView处理
    return self.scrollView;
}


#pragma mark - 获取裁剪的图片
- (UIImage *)croppedImage {
    
    // 计算裁剪区
    CGRect visibleRect = [self calcVisibleRectForCropArea];
    
    // 调整方向
    CGAffineTransform rectTransform = [self orientationTransformedRectOfImage:self.imageToCrop];
    visibleRect = CGRectApplyAffineTransform(visibleRect, rectTransform);
    
    // 生成裁剪图片
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.imageToCrop CGImage], visibleRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.imageToCrop.scale orientation:self.imageToCrop.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

-(CGRect)calcVisibleRectForCropArea {
    //scaled width/height in regards of real width to crop width
    CGFloat scaleWidth = self.imageToCrop.size.width / self.cropSize.width;
    CGFloat scaleHeight = self.imageToCrop.size.height / self.cropSize.height;
    CGFloat scale = 0.0f;
    
    scale = MIN(scaleWidth, scaleHeight);
    
    //extract visible rect from scrollview and scale it
    CGRect rect = [_scrollView convertRect:_scrollView.bounds toView:_imageView];
    return CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
}


- (CGAffineTransform)orientationTransformedRectOfImage:(UIImage *)img
{
    CGAffineTransform rectTransform;
    switch (img.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -img.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -img.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -img.size.width, -img.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    return CGAffineTransformScale(rectTransform, img.scale, img.scale);
}



#pragma UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

@end
