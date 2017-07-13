//
//  LSViewFactor.m
//  retailapp
//
//  Created by guozhi on 2017/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSViewFactor.h"

@implementation LSViewFactor
/**
 添加红色按钮到指定的view
 
 @param view 指定的view
 @param title 按钮的文字
 @param y 按钮的y坐标
 @return 返回按钮
 */
+ (UIButton *)addRedButton:(UIView *)view title:(NSString *)title y:(CGFloat)y {
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, y, view.ls_width, 64)];
    [view addSubview:viewBg];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnX = 10;
    CGFloat btnY = 10;
    CGFloat btnW = view.ls_width - 2*btnX;
    CGFloat btnH = 44;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_full_r"] forState:UIControlStateNormal];
    [viewBg addSubview:btn];
    return btn;
    
}
/**
 添加绿色按钮到指定的view
 
 @param view 指定的view
 @param title 按钮的文字
 @param y 按钮的y坐标
 @return 返回按钮
 */
+ (UIButton *)addGreenButton:(UIView *)view title:(NSString *)title y:(CGFloat)y {
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, y, view.ls_width, 64)];
    [view addSubview:viewBg];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    CGFloat btnX = 10;
    CGFloat btnY = 10;
    CGFloat btnW = view.ls_width - 2*btnX;
    CGFloat btnH = 44;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_full_g"] forState:UIControlStateNormal];
    [viewBg addSubview:btn];
    return btn;
    
}

/**
 添加一个帮助说明文字到指定的View

 @param view 指定的View
 @param text 说明文字
 @param y y
 @return UILable
 */
+ (UILabel *)addExplainText:(UIView *)view text:(NSString *)text y:(CGFloat)y {
    UILabel *lbl = [[UILabel alloc] init];
    UIFont *font = [UIFont systemFontOfSize:12];
    lbl.font = font;
    lbl.textColor = [ColorHelper getTipColor6];
    lbl.numberOfLines = 0;
    CGFloat margin = 10;
    CGSize maxSize = CGSizeMake(SCREEN_W - 2*margin, MAXFLOAT);
    CGSize size = [NSString sizeWithText:text maxSize:maxSize font:font];
    lbl.text = text;
    lbl.frame =CGRectMake(margin, y, maxSize.width, size.height);
    [view addSubview:lbl];
    return lbl;
}


/**
 添加指定高度的透明视图到指定View上

 @param view 指定View
 @param y y
 @param h 高度
 @return UIView 透明View
 */
+ (UIView *)addClearView:(UIView *)view y:(CGFloat)y h:(CGFloat)h {
    UIView *clearView = [[UIView alloc] init];
    clearView.bounds = CGRectMake(0, 0, view.ls_width, h);
    [view addSubview:clearView];
    return clearView;
}

/**
 添加line到指定View上
 
 @param view 指定View
 @param y y
 @return UIView 透明View
 */
+ (UIView *)addLine:(UIView *)view y:(CGFloat)y {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    line.frame = CGRectMake(10, 0, view.ls_width - 20, 1);
    [view addSubview:line];
    return line;
}

@end
