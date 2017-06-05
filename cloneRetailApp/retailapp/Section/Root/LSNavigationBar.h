//
//  LSNavigationBar.h
//  retailapp
//
//  Created by guozhi on 2017/3/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
typedef NS_ENUM(NSInteger, LSNavigationBarButtonDirect) {
    LSNavigationBarButtonDirectLeft,     //导航栏左边按钮
    LSNavigationBarButtonDirectRight,   //导航栏右边按钮
};
#import <UIKit/UIKit.h>
@protocol LSNavigationBarDelegate;
@interface LSNavigationBar : UIView

/** 代理 */
@property (nonatomic, weak) id<LSNavigationBarDelegate> delegate;

/**
 自定义导航栏 默认标题显示 左边按钮不显示 右边按钮不显示

 @return 
 */
+ (instancetype)navigationBar;

/**
 设置标题
 
 @param title 比如设置@"123" 则导航栏显示的是@“123”
 */
- (void)configTitle:(NSString *)title;
/**
 设置导航栏及左右按钮的显示
 
 @param title 标题 比如设置@"123" 则导航栏显示的是@“123”
 @param leftPath 左边按钮 只能传定义的宏以后需要优化
 返回按钮 Head_ICON_BACK
 取消按钮 Head_ICON_CANCEL
 @param rightPath 右边按钮 只能传定义的宏以后需要优化
 保存按钮 Head_ICON_OK
 取消按钮 Head_ICON_CANCEL
 */
- (void)configTitle:(NSString *)title leftPath:(NSString *)leftPath rightPath:(NSString *)rightPath;

/**
 设置导航栏按钮
 
 @param direct 设置左边按钮还是右边按钮
 @param title 设置标题
 @param filePath 设置按钮的图片路径
 */
- (void)configNavigationBar:(LSNavigationBarButtonDirect)direct title:(NSString *)title filePath:(NSString *)filePath;

- (void)editTitle:(BOOL)change act:(NSInteger)action;
@end




@protocol LSNavigationBarDelegate <NSObject>

/**
 当导航栏点击左边和右边按钮时调用

 @param navigationBar 谁点击的
 @param event 方向
 */
- (void)navigationBar:(LSNavigationBar *)navigationBar didEndClickedDirect:(LSNavigationBarButtonDirect)event;

@end
