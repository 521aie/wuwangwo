//
//  UIViewController+Helper.h
//  Pods
//
//  Created by tripleCC on 12/17/16.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (TopViewController)
/**
 从导航控制器堆栈中移除
 */
- (void)tdf_removeFromNavigationController;

/**
 当前最顶部控制器
 */
- (UIViewController *)tdf_topViewController;
@end
