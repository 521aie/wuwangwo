//
//  UIViewController+Helper.m
//  Pods
//
//  Created by tripleCC on 12/17/16.
//
//
#import "UIViewController+TopViewController.h"

@implementation UIViewController (TopViewController)
- (void)tdf_removeFromNavigationController {
    NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;

    [viewControllers removeObject:self];
    self.navigationController.viewControllers = viewControllers;
}

- (UIViewController *)tdf_topViewController{
    return [self tdf_topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)tdf_topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self tdf_topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self tdf_topViewController:presentedViewController];
}

@end
