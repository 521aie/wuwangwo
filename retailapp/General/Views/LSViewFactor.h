//
//  LSViewFactor.h
//  retailapp
//
//  Created by guozhi on 2017/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSViewFactor : NSObject

/**
 添加红色按钮到指定的view

 @param view 指定的view
 @param title 按钮的文字
 @param y 按钮的y坐标
 @return 返回按钮
 */
+ (UIButton *)addRedButton:(UIView *)view title:(NSString *)title y:(CGFloat)y;
/**
 添加绿色按钮到指定的view
 
 @param view 指定的view
 @param title 按钮的文字
 @param y 按钮的y坐标
 @return 返回按钮
 */
+ (UIButton *)addGreenButton:(UIView *)view title:(NSString *)title y:(CGFloat)y;
/**
 添加一个帮助说明文字到指定的View
 
 @param view 指定的View
 @param text 说明文字
 @param y y
 @return UILable
 */
+ (UILabel *)addExplainText:(UIView *)view text:(NSString *)text y:(CGFloat)y;

/**
 添加指定高度的透明视图到指定View上
 
 @param view 指定View
 @param y y
 @param h 高度
 @return UIView 透明View
 */
+ (UIView *)addClearView:(UIView *)view y:(CGFloat)y h:(CGFloat)h;

/**
 添加line到指定View上
 
 @param view 指定View
 @param y y
 @return UIView 透明View
 */
+ (UIView *)addLine:(UIView *)view y:(CGFloat)y;
@end
