//
//  LSViewUtils.h
//  retailapp
//
//  Created by guozhi on 16/8/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSViewUtil : NSObject
/**
 *  添加一条分割线
 *
 *  @param parent   分割线的父视图
 *  @param margin   分割线的距离父view两边的距离
 *  @param y        分割线的y
 *  @return 分割线
 */
+ (UIView *)addLine:(UIView *)parent margin:(CGFloat)margin y:(CGFloat)y;


/**
 *  添加一个标签
 *
 *  @param parent 标签的父视图
 *  @param frame  标签的frame
 *  @param color  标签的颜色
 *  @param font   标签的大小
 *
 *  @return 标签
 */
+ (UILabel *)addLable:(UIView *)parent font:(UIFont *)font color:(UIColor *)color  frame:(CGRect)frame;
+ (UILabel *)addLable:(UIView *)parent font:(UIFont *)font color:(UIColor *)color;
//添加一个图片
+ (UIImageView *)addImageView:(UIView *)parent;
/**
 *  添加一个图片
 *
 *  @param parent    图片的父视图
 *  @param imagePath 图片的路径
 *  @param frame     图片的大小
 *
 *  @return 图片
 */
+ (UIImageView *)addImageView:(UIView *)parent imagePath:(NSString *)imagePath frame:(CGRect)frame;


/**
 *  添加下一个图片
 *
 *  @param parent 图片的父视图
 *
 *  @return 图片
 */
+ (UIImageView *)addNextImageView:(UIView *)parent;

/**
 *  添加商品图片
 *
 *  @param parent 图片的父视图
 *
 *  @return 图片
 */
+ (UIImageView *)addGoodImageView:(UIView *)parent;

/**
 *  测试一段文本大小
 *
 *  @param text    衡量的文本
 *  @param maxSize 文本的最大尺寸
 *  @param font    文本的字体
 *
 *  @return 文本的最佳大小
 */
+ (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font;
@end
