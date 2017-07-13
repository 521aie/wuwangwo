//
//  LSAlertHelper.m
//  LSScanner
//
//  Created by taihangju on 2016/12/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSAlertHelper.h"
#import <UIKit/UIKit.h>

static LSAlertHelper *alertClient;
@interface LSAlertHelper ()

@property (nonatomic ,strong) UIAlertController *alertController;/*<>*/
@end

@implementation LSAlertHelper

+ (instancetype)sharedInstance {
    
    static dispatch_once_t token ;
    dispatch_once(&token, ^{
        alertClient = [[LSAlertHelper alloc] init];
    });
    return alertClient;
}

+ (void)showStatus:(NSString *)status afterDeny:(NSTimeInterval)seconds block:(void(^)())block {
    if (!status || status.length == 0) {
        return;
    }
    [[LSAlertHelper sharedInstance] dismiss:nil];
    [alertClient performSelector:@selector(dismiss:) withObject:block afterDelay:seconds];
    alertClient.alertController = [UIAlertController alertControllerWithTitle:@"提示" message:status preferredStyle:UIAlertControllerStyleAlert];
    [alertClient present];;
}

+ (void)showAlert:(NSString *)alertString  {
    [self showAlert:@"提示" message:alertString cancle:@"我知道了" block:nil];
}

+ (void)showAlert:(NSString *)alertString block:(void(^)())block {
    [self showAlert:@"提示" message:alertString cancle:@"我知道了" block:block];
}

+ (void)showAlert:(NSString *)title message:(NSString *)alertString cancle:(NSString *)cancleStr block:(void(^)())block {
    if (!alertString || alertString.length == 0) {
        return;
    }
    [[LSAlertHelper sharedInstance] dismiss:nil];
    alertClient.alertController = [UIAlertController alertControllerWithTitle:title message:alertString preferredStyle:UIAlertControllerStyleAlert];
    [alertClient.alertController addAction:[UIAlertAction actionWithTitle:cancleStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            //解决动画冲突
            dispatch_time_t timeWhen = dispatch_time(DISPATCH_TIME_NOW, 0.05*NSEC_PER_SEC);
            dispatch_after(timeWhen, dispatch_get_main_queue(), block);
        }
    }]];
    [alertClient present];
}

+ (void)showAlertTextInput:(NSString *)title message:(NSString *)message block:(void(^)(NSString *text))ensureBlcok {
     [[LSAlertHelper sharedInstance] dismiss:nil];
    
    alertClient.alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertClient.alertController addTextFieldWithConfigurationHandler:nil];
    [alertClient.alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertClient.alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (ensureBlcok) {
            UITextField *textField = alertClient.alertController.textFields[0];
            ensureBlcok(textField.text);
        }
    }]];
    [alertClient present];
}


+ (void)showAlert:(NSString *)alertString block:(void(^)())cancleBlock block:(void(^)())ensureBlcok {
    [self showAlert:@"提示" message:alertString cancle:@"取消" block:cancleBlock ensure:@"确认" block:ensureBlcok];
}

+ (void)showAlert:(NSString *)title message:(NSString *)alertString cancle:(NSString *)cancleStr block:(void (^)())cancleBlock
           ensure:(NSString *)ensureStr block:(void(^)())ensureBlock {
    if (!alertString || alertString.length == 0) {
        return;
    }
    [[LSAlertHelper sharedInstance] dismiss:nil];
    alertClient.alertController = [UIAlertController alertControllerWithTitle:title message:alertString preferredStyle:UIAlertControllerStyleAlert];
    [alertClient.alertController addAction:[UIAlertAction actionWithTitle:cancleStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancleBlock) {
            dispatch_time_t timeWhen = dispatch_time(DISPATCH_TIME_NOW, 0.25*NSEC_PER_SEC);
            dispatch_after(timeWhen, dispatch_get_main_queue(), cancleBlock);
//            cancleBlock();
        }
    }]];
    
    [alertClient.alertController addAction:[UIAlertAction actionWithTitle:ensureStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (ensureBlock) {
            dispatch_time_t timeWhen = dispatch_time(DISPATCH_TIME_NOW, 0.25*NSEC_PER_SEC);
            dispatch_after(timeWhen, dispatch_get_main_queue(), ensureBlock);
//            ensureBlock();
        }
    }]];
    [alertClient present];
}

+ (void)showSheet:(NSString *)title cancle:(NSString *)cancle cancleBlock:(void(^)())cancleBlock selectItems:(NSArray<NSString *> *)options selectdblock:(void(^)(NSInteger index))selectBlock {
    if (options.count == 0) {
        return;
    }
    [[LSAlertHelper sharedInstance] dismiss:nil];
    alertClient.alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [alertClient.alertController addAction:[UIAlertAction actionWithTitle:cancle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancleBlock) {
            dispatch_time_t timeWhen = dispatch_time(DISPATCH_TIME_NOW, 0.05*NSEC_PER_SEC);
            dispatch_after(timeWhen, dispatch_get_main_queue(), cancleBlock);
        }
    }]];
    for (NSString *actionName in options) {
        [alertClient.alertController addAction:[UIAlertAction actionWithTitle:actionName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (selectBlock) {
                dispatch_time_t timeWhen = dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC);
                dispatch_after(timeWhen, dispatch_get_main_queue(), ^{
                    selectBlock([options indexOfObject:action.title]);
                });
            }
        }]];
    }
    [alertClient present];
}

// 隐藏AlertView
- (void)dismiss:(void(^)())block {
    if (self.alertController) {
        [self.alertController dismissViewControllerAnimated:YES completion:nil];
        self.alertController = nil;
        if (block) {
            block();
        }
    }
}

// 显示AlertView
- (void)present {
    if (self.alertController) {
        [[self topShowViewController] presentViewController:alertClient.alertController animated:YES completion:nil];
    }
}


#pragma mark - 获取最顶层 UIViewController
- (UIViewController *)topShowViewController {
    return [self topViewControllerWithRootViewController:[[UIApplication sharedApplication].delegate window].rootViewController];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
 
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
