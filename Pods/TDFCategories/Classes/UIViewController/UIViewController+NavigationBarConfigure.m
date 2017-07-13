//
//  TDFRootViewController+NavigationBarConfigure.m
//  Pods
//
//  Created by tripleCC on 1/16/17.
//
//
#import <objc/runtime.h>
#import "UIViewController+NavigationBarConfigure.h"
#import "UIViewController+AlertMessage.h"
#import "NSString+SizeCalculator.h"

#define kTDFNBCButtonFont [UIFont systemFontOfSize:16.0f]

static const CGFloat kTDFNBCMaxButtonWidth = 150.0f;
static const CGFloat kTDFNBCButtonImageWidth = 25.0f;
static NSString *const kTDFNBCButtonAccessibilityValue = @"kTDFNBCButtonAccessibilityValue";

@implementation UIViewController (NavigationBarConfigure)
#pragma mark - Public method
- (void)nbc_setupBackItemType:(TDFBackItemType)type {
    [self nbc_bindListener];
    [self nbc_configureAlertUnsavedWhenCancel];
    
    [self _nbc_setupBackItemWithTitle:[self nbc_backTitleWithBackItemType:type]
                                image:[self nbc_backImageWithBackItemType:type]];
    
    self.nbc_backButton.tag = type;
}

- (void)nbc_setupBackItemWithTitle:(NSString *)title image:(UIImage *)image {
    [self nbc_bindListener];
    
    image = [UIImage imageWithCGImage:image.CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    [self _nbc_setupBackItemWithTitle:title image:image];
}

- (void)nbc_setupSureItemType:(TDFSureItemType)type {
    [self nbc_bindListener];
    
    if (type == TDFSureItemTypeNone) {
        self.nbc_sureButton.hidden = YES;
        return;
    }
    self.nbc_sureButton.hidden = NO;
    
    [self _nbc_setupSureItemWithTitle:[self nbc_sureTitleWithSureItemType:type]
                                image:[self nbc_sureImageWithSureItemType:type]];
    
    
    self.nbc_sureButton.tag = type;
}

- (void)nbc_setupSureItemWithTitle:(NSString *)title image:(UIImage *)image {
    [self nbc_bindListener];
    
    image = [UIImage imageWithCGImage:image.CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    [self _nbc_setupSureItemWithTitle:title image:image];
}

- (void)nbc_setupNavigationBarType:(TDFNavigationBarType)type {
    switch (type) {
        case TDFNavigationBarTypeNormal: {
            [self nbc_setupBackItemType:TDFBackItemTypeBack];
            [self nbc_setupSureItemType:TDFSureItemTypeNone];
        } break;
        case TDFNavigationBarTypeSaved: {
            [self nbc_setupBackItemType:TDFBackItemTypeCancel];
            [self nbc_setupSureItemType:TDFSureItemTypeSaved];
        } break;
        case TDFNavigationBarTypeConfirmed: {
            [self nbc_setupBackItemType:TDFBackItemTypeCancel];
            [self nbc_setupSureItemType:TDFSureItemTypeConfirmed];
        } break;
        default:
            break;
    }
}

#pragma mark - Private method

- (void)_nbc_setupBackItemWithTitle:(NSString *)title image:(UIImage *)image {
    
    if (!self.nbc_backButton || ![self.nbc_backButton.accessibilityValue isEqualToString:kTDFNBCButtonAccessibilityValue]) {
        UIButton *backButton = [self nbc_generateNavigationButtonWithSelector:@selector(nbc_viewControllerDidTriggerLeftClick:)];
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    
    image = [UIImage imageWithCGImage:image.CGImage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
    
    [self nbc_updateNavigationButton:self.nbc_backButton withTitle:title image:image];
}

- (void)_nbc_setupSureItemWithTitle:(NSString *)title image:(UIImage *)image {
    
    if (!self.nbc_sureButton || ![self.nbc_sureButton.accessibilityValue isEqualToString:kTDFNBCButtonAccessibilityValue]) {
        UIButton *sureButton = [self nbc_generateNavigationButtonWithSelector:@selector(nbc_viewControllerDidTriggerRightClick:)];
        sureButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureButton];
    }
    
    [self nbc_updateNavigationButton:self.nbc_sureButton withTitle:title image:image];
}


- (UIImage *)nbc_backImageWithBackItemType:(TDFBackItemType)type {
    CGImageRef cgimage = nil;
    
    switch (type) {
        case TDFBackItemTypeBack: {
            cgimage = [UIImage imageNamed:@"common_nbc_back"].CGImage;
        } break;
        case TDFBackItemTypeCancel: {
            cgimage = [UIImage imageNamed:@"common_nbc_cancel"].CGImage;
        } break;
        default:
            return nil;
    }
    
    return [UIImage imageWithCGImage:cgimage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
}

- (UIImage *)nbc_sureImageWithSureItemType:(TDFSureItemType)type {
    CGImageRef cgimage = nil;
    
    switch (type) {
        case TDFSureItemTypeSaved:
        case TDFSureItemTypeConfirmed: {
            cgimage = [UIImage imageNamed:@"common_nbc_ok"].CGImage;
        } break;
        default:
            return nil;
    }
    
    return [UIImage imageWithCGImage:cgimage scale:64.0f / 22.0f orientation:UIImageOrientationUp];
}

- (NSString *)nbc_backTitleWithBackItemType:(TDFBackItemType)type {
    switch (type) {
        case TDFBackItemTypeBack: {
            return NSLocalizedString(@"返回", nil);
        } break;
        case TDFBackItemTypeCancel: {
            return NSLocalizedString(@"取消", nil);
        } break;
        default:
            return nil;
    }
}

- (NSString *)nbc_sureTitleWithSureItemType:(TDFSureItemType)type {
    switch (type) {
        case TDFSureItemTypeSaved: {
            return NSLocalizedString(@"保存", nil);
        } break;
        case TDFSureItemTypeConfirmed: {
            return NSLocalizedString(@"确定", nil);
        } break;
        default:
            return nil;
    }
}
- (void)nbc_bindListener {
    if (!self.nbc_listener) {
        self.nbc_listener = self;
    }
}

- (void)nbc_configureAlertUnsavedWhenCancel {
    if (!self.nbc_alertUnsavedWhenCancelNumber) {
        self.nbc_alertUnsavedWhenCancelNumber = @YES;
    }
}

- (void)nbc_viewControllerDidTriggerLeftClick:(UIViewController *)viewController {
    if ([self.nbc_listener respondsToSelector:@selector(viewControllerDidTriggerLeftClick:)]) {
        [self.nbc_listener viewControllerDidTriggerLeftClick:self];
    }
    
    if (self.nbc_alertUnsavedWhenCancel && self.nbc_backButton.tag == TDFBackItemTypeCancel) {
        [self nbc_showUnsavedAlert];
    } else {
        [self nbc_popViewController];
    }
}

- (void)nbc_viewControllerDidTriggerRightClick:(UIViewController *)viewController {
    if ([self.nbc_listener respondsToSelector:@selector(viewControllerDidTriggerRightClick:)]) {
        [self.nbc_listener viewControllerDidTriggerRightClick:self];
    }
}

- (void)nbc_showUnsavedAlert {
//    if (self.presentedViewController || [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
//        return;
//    }

    [self showMessage:NSLocalizedString(@"内容有变更尚未保存,确定要退出吗?", nil) confirm: ^{
        [self nbc_popViewController];
    } cancel:nil];
}

- (void)nbc_popViewController {
    if ([self.nbc_listener respondsToSelector:@selector(viewControllerDidTriggerPopAction:)]) {
        [self.nbc_listener viewControllerDidTriggerPopAction:self];
    }
    
    if ([self.navigationController.viewControllers containsObject:self]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)nbc_updateNavigationButton:(UIButton *)button withTitle:(NSString *)title image:(UIImage *)image {
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    CGRect frame = button.frame;
    frame.size.width = MIN(kTDFNBCMaxButtonWidth, [title tdf_sizeForFont:kTDFNBCButtonFont].width + kTDFNBCButtonImageWidth);
    button.frame = frame;
}

- (UIButton *)nbc_generateNavigationButtonWithSelector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, kTDFNBCMaxButtonWidth, 40.0f);
    [button.titleLabel setFont:kTDFNBCButtonFont];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.accessibilityValue = kTDFNBCButtonAccessibilityValue;
    return button;
}

#pragma mark - Getter Setter

- (id<TDFNavigationClickListenerProtocol>)nbc_listener {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNbc_listener:(id<TDFNavigationClickListenerProtocol>)listener {
    objc_setAssociatedObject(self, @selector(nbc_listener), listener, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)nbc_alertUnsavedWhenCancel {
    return self.nbc_alertUnsavedWhenCancelNumber.boolValue;
}

- (void)setNbc_alertUnsavedWhenCancel:(BOOL)nbc_alertUnsavedWhenCancel {
    self.nbc_alertUnsavedWhenCancelNumber = @(nbc_alertUnsavedWhenCancel);
}

- (NSNumber *)nbc_alertUnsavedWhenCancelNumber {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNbc_alertUnsavedWhenCancelNumber:(NSNumber *)nbc_alertUnsavedWhenCancelNumber {
    objc_setAssociatedObject(self, @selector(nbc_alertUnsavedWhenCancelNumber), nbc_alertUnsavedWhenCancelNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)nbc_backButton {
    return (UIButton *)self.navigationItem.leftBarButtonItem.customView;
}

- (UIButton *)nbc_sureButton {
    return (UIButton *)self.navigationItem.rightBarButtonItem.customView;
}
@end
