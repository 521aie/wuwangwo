//
//  LSViewUtils.m
//  retailapp
//
//  Created by guozhi on 16/8/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSViewUtil.h"

@implementation LSViewUtil

//画一条分割线
+ (UIView *)addLine:(UIView *)parent margin:(CGFloat)margin y:(CGFloat)y {

    CGFloat w = parent.frame.size.width - 2 * margin;
    CGFloat lineHeight = 1.0f/[UIScreen mainScreen].scale;
    UILabel *lineView = [[UILabel alloc] initWithFrame:CGRectMake(margin, y, w, lineHeight)];
    lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [parent addSubview:lineView];
    return  lineView;
}

//添加一个标签
+ (UILabel *)addLable:(UIView *)parent font:(UIFont *)font color:(UIColor *)color frame:(CGRect)frame {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = frame;
    lab.numberOfLines = 0;
    lab.textColor = color;
    lab.font = font;
    [parent addSubview:lab];
    return lab;
}

//添加一个标签
+ (UILabel *)addLable:(UIView *)parent font:(UIFont *)font color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.numberOfLines = 0;
    lab.textColor = color;
    lab.font = font;
    [parent addSubview:lab];
    return lab;
}

//添加一个图片
+ (UIImageView *)addImageView:(UIView *)parent imagePath:(NSString *)imagePath frame:(CGRect)frame {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = frame;
    if (imagePath) {
        UIImage *img = [UIImage imageNamed:imagePath];
        imgView.image = img;
    }
    [parent addSubview:imgView];
    return imgView;
}

//添加一个图片
+ (UIImageView *)addImageView:(UIView *)parent {
    UIImageView *imgView = [[UIImageView alloc] init];
    [parent addSubview:imgView];
    return imgView;
}

//添加下一个图片
+ (UIImageView *)addNextImageView:(UIView *)parent {
    UIImageView *imgView = [[UIImageView alloc] init];
    CGFloat w = 22;
    CGFloat x = parent.frame.size.width - 10 - w;
    CGFloat y = (parent.frame.size.height - w)/2;
    imgView.frame = CGRectMake(x, y, w, w);
    UIImage *img = [UIImage imageNamed:@"ico_next"];
    imgView.image = img;
    [parent addSubview:imgView];
    return imgView;
}

//添加商品图片
+ (UIImageView *)addGoodImageView:(UIView *)parent {
    UIImageView *imgView = [[UIImageView alloc] init];
    CGFloat w = 68;
    CGFloat x = 10;
    CGFloat y = (parent.frame.size.height - w)/2;
    imgView.frame = CGRectMake(x, y, w, w);
    imgView.layer.cornerRadius = PANEL_OUTTER_CORNER_RADIUS;
    imgView.layer.masksToBounds = YES;
    [parent addSubview:imgView];
    return imgView;
}

//测量一段文字大小
+ (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font{
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

@end
