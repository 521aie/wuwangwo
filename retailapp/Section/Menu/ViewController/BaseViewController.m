//
//  BaseViewController.m
//  retailapp
//
//  Created by taihangju on 16/6/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "ReailAppDefine.h"
#import "Platform.h"
#import "XHAnimalUtil.h"


@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSString *)bgImgName{
    NSString *imageName = [[Platform Instance] getkey:BG_FILE];
    if([NSString isBlank:imageName]) {
        imageName = @"bg_01b.jpg";
    }
    return imageName;
}

////////////////////////// 控制器跳

 /////////////////////////////////////
- (void)popToLatestViewController:(NSString *)direction {
  
    if (self.navigationController) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:direction];
        [self.navigationController popViewControllerAnimated:NO];
    
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)popToViewController:(NSInteger)distance popDirection:(NSString *)direction {
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSInteger selfIndex = [viewControllers indexOfObject:self];
    if (selfIndex - distance >= 0) {
        UIViewController *popToVc = [viewControllers objectAtIndex:selfIndex - distance];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:direction];
        [self.navigationController popToViewController:popToVc animated:NO];
    }
    
}


- (void)pushController:(UIViewController *)vc from:(NSString *)direction {
    if (self.navigationController) {
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:direction];
    }
}

- (void)popToViewControllerNamed:(NSString *)controllerName popDirection:(NSString *)direction {
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(controllerName)]) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:direction];
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
}

////////////////////////////  由storyboard 生成viewController    ///////////////////////////////
+ (__kindof UIViewController *)controllerFromStroryboard:(NSString *)fromStoryboardName storyboardId:(NSString *)identifier
{
    NSString *storyboardId = identifier ? : NSStringFromClass(self);
    UIViewController *vc = [[UIStoryboard storyboardWithName:fromStoryboardName bundle:nil]
                            instantiateViewControllerWithIdentifier:storyboardId];
    return vc;
}

@end
