//
//  MainViewController.h
//  retailapp
//
//  Created by taihangju on 16/6/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

//typedef NS_ENUM(NSInteger ,MenuVcType){
//    MenuStoreVc, /*<抽屉-左边栏>*/
//    MenuMyVc,   /*<抽屉-右边栏>*/
//    MenuHome,   /*<抽屉-主页面>*/
//};
//
//@protocol MenuDelegate <NSObject>
//@required
//- (void)showChildViewController:(MenuVcType)type;
//
//@end
@class LoginViewController;
@interface HomeViewController : BaseViewController
// 配置主页面子模块
//点击申请开通微店时微店是(单店)是立即开通的这时需要刷新主页模块 把顾客评价显示出来
- (void)configSubviewModules;
@property (nonatomic, weak) LoginViewController *loginVc;
@end
