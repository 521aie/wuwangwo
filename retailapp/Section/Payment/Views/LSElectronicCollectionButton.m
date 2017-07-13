//
//  LSElectronicCollectionButton.m
//  retailapp
//
//  Created by guozhi on 2016/12/3.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSElectronicCollectionButton.h"

@implementation LSElectronicCollectionButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonW = self.frame.size.width;
    CGFloat buttonH = self.frame.size.height;
    
    CGFloat imageH = buttonW;
    self.imageView.frame = CGRectMake(0, 0, buttonW, imageH);
    
    self.titleLabel.frame = CGRectMake(-40, imageH, buttonW+80, buttonH - imageH);
}
@end
