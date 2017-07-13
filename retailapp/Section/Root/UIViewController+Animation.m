//
//  UIViewController+Animation.m
//  retailapp
//
//  Created by guozhi on 2017/2/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIViewController+Animation.h"

@implementation UIViewController (Animation)
#pragma mark - 页面切换
- (void)pushViewController:(UIViewController *)vc {
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (void)pushViewController:(UIViewController *)vc direct:(AnimationDirection)direct {
    if (direct == AnimationDirectionH) {
        [self pushViewController:vc];
    } else {
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    }
}

- (void)popViewController {
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)popViewControllerDirect:(AnimationDirection)direct {
    if (direct == AnimationDirectionH) {
        [self popViewController];
    } else {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
        
    }
}

- (void)popToViewController:(UIViewController *)vc {
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popToViewController:vc animated:NO];
}

@end
