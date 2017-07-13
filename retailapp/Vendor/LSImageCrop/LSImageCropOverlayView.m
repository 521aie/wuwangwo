//
//  LSImageCropOverlayView.m
//  ScropViewController
//
//  Created by byAlex on 16/7/14.
//  Copyright © 2016年 DIY. All rights reserved.
//

#import "LSImageCropOverlayView.h"

@implementation LSImageCropOverlayView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat heightSpan = floor(height / 2 - self.cropSize.height / 2);
    CGFloat widthSpan = floor(width / 2 - self.cropSize.width  / 2);
    
    //fill outer rect
    [[UIColor colorWithRed:0. green:0. blue:0. alpha:0.5] set];
    UIRectFill(self.bounds);
    
    //fill inner border
    [[UIColor colorWithRed:1. green:1. blue:1. alpha:0.5] set];
//    UIRectFrame(CGRectMake(widthSpan - 2, heightSpan - 2, self.cropSize.width + 4, self.cropSize.height + 4));
    UIRectFrame(CGRectMake(widthSpan, heightSpan, self.cropSize.width, self.cropSize.height));
    
    //fill inner rect
    [[UIColor clearColor] set];
//    UIRectFill(CGRectMake(widthSpan + 2, heightSpan + 2, self.cropSize.width - 4, self.cropSize.height - 4));
    UIRectFill(CGRectMake(widthSpan + 1, heightSpan + 1, self.cropSize.width - 2, self.cropSize.height - 2));
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
