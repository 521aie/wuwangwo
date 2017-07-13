//
//  LSPaymentButton.m
//  retailapp
//
//  Created by guozhi on 2017/2/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPaymentButton.h"

@implementation LSPaymentButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat w = 68;
    CGFloat x = (contentRect.size.width - w)/2;
    CGFloat y = 10;
    CGFloat h = w;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat h = 15;
    CGFloat x = -10;
    CGFloat y = contentRect.size.height - h;
    CGFloat w = contentRect.size.width + 20;
    return CGRectMake(x, y, w, h);
}


@end
