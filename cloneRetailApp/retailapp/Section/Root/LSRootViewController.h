//
//  LSRootViewController.h
//  retailapp
//
//  Created by guozhi on 2017/2/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "LSNavigationBar.h"
@interface LSRootViewController : BaseViewController


#pragma mark - 导航栏事件
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

/**
 设置导航按钮的状态
 
 @param change 当前页面信息是否改变
 @param action 添加还是编辑
 */
- (void)editTitle:(BOOL)change act:(NSInteger)action;

/**
 导航按钮点击事件需要子类来重用
 
 @param event 左边按钮和右边按钮区分
 */
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)direct;

@end
