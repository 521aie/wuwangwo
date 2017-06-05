//
//  AppDelegate.h
//  retailapp
//
//  Created by hm on 15/7/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong) UIImageView *bgImageView;/* <共用的背景图*/
@property (nonatomic, strong) UINavigationController *navigationController;
@end

