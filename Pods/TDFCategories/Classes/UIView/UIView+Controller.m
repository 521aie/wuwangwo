//
//  UIView+Controller.m
//  Pods
//
//  Created by tripleCC on 11/2/16.
//
//

#import "UIView+Controller.h"

@implementation UIView (Controller)
- (UIViewController *)tdf_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
