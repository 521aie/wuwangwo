//
//  LSNavBtn.m
//  retailapp
//
//  Created by guozhi on 2017/2/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

//按钮图片的宽度
#define kImageWidth 22
#import "LSNavBtn.h"


@implementation LSNavBtn

+ (instancetype)navBtn:(LSNavBtnDirect)direct {
    LSNavBtn *btn = [LSNavBtn buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.direct = direct;
    return btn;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    //计算按钮字体的长度
    CGSize size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    //按钮文字的宽度
    CGFloat textW = size.width;
    //按钮图片的宽度
    CGFloat w = kImageWidth;
    CGFloat h = kImageWidth;
    //按钮在导航左侧和右侧时显示不一样需要区分
    CGFloat x = self.direct == LSNavBtnDirectLeft ? 10 : (self.frame.size.width - textW - w - 10);
    CGFloat y = (self.frame.size.height - h)/2;
    //重新布局
    self.imageView.frame = CGRectMake(x, y, w, h);
    x = x + self.imageView.frame.size.width;
    y = 0;
    w = textW;
    h = self.frame.size.height;
    
    self.titleLabel.frame = CGRectMake(x, y, w, h);
    
    
}

@end
