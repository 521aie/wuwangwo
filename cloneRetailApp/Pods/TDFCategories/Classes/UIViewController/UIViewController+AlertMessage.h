//
//  UIViewController+UIViewController_Message.h
//  RestApp
//
//  Created by Octree on 19/10/16.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (AlertMessage)
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;
@end

@interface UIViewController (AlertMessage)
- (UIAlertController *)showTipAlertWithMessage:(NSString *)message;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirm:(void(^)(void))confirmBlock cancel:(void (^)(void))cancelBlock;

/// 用来替换 AlertBox 的 show Alert
- (void)showAlert:(NSString *)message confirm:(void(^)(void))code;
- (void)showAlert:(NSString *)message buttonTitle:(NSString *)title confirm:(void(^)(void))code;

/// 用来替换 AlertBox 的 show message
- (void)showMessage:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirm:(void(^)(void))confirmBlock cancel:(void (^)(void))cancelBlock;
- (void)showMessage:(NSString *)message confirm:(void(^)(void))confirmBlock cancel:(void (^)(void))cancelBlock;
- (void)showMessage:(NSString *)message buttonTitle:(NSString *)title confirm:(void(^)(void))confirmBlock cancel:(void (^)(void))cancelBlock;

@end
