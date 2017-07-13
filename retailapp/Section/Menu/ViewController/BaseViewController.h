//
//  BaseViewController.h
//  retailapp
//
//  Created by taihangju on 16/6/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

// 获取当前用户选定的背景图name
- (NSString *)bgImgName;
// pop 到最近的控制器
- (void)popToLatestViewController:(NSString *)direction;
/**
 *  pop 到指定的viewController
 *
 *  @param distance       当行控制器当前栈中： 距离当前显示的vc 的index
 *  @param direction      pop 方向控制
 */
- (void)popToViewController:(NSInteger)distance popDirection:(NSString *)direction;
- (void)pushController:(UIViewController *)vc from:(NSString *)direction;
- (void)popToViewControllerNamed:(NSString *)controllerName popDirection:(NSString *)direction;


/**
 *  从指定的storyboard文件中生成指定ViewController
 *
 *  @param fromStoryboardName Storyboard文件名
 *  @param identifier         指定ViewController在Storyboard中的标识字符串, nil时默认为标识符和类名是一致的
 *
 *  @return 返回生成的ViewController
 */
+ (__kindof UIViewController *)controllerFromStroryboard:(NSString *)fromStoryboardName storyboardId:(NSString *)identifier;
@end
