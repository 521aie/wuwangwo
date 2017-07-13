//
//  UINavigationController+LSAutorotate.m
//  retailapp
//
//  Created by guozhi on 2017/3/3.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "UINavigationController+LSAutorotate.h"

@implementation UINavigationController (LSAutorotate)
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
@end
