//
//  LoginViewController.h
//  retailapp
//
//  Created by taihangju on 16/6/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, OpenShopSucessState) {
    OpenShopSucessStateClose,//点击关闭
    OpenShopSucessStateLogin//点击登陆
};
#import "BaseViewController.h"
@class OpenShopSucessViewController;
@protocol LoginViewDelegate <NSObject>
- (void)loginViewWillDisAppear;
@end
@interface LoginViewController : BaseViewController

@property (nonatomic, weak) id<LoginViewDelegate> delegate;  /*<<#说明#>>*/
/**
 *  开店成功页面使用此方法提供给开店成功页面使用
 *
 *  @param openShopSucessState
 *  @param param               
 */
- (void)openShopSucessViewControllerAtIndex:(OpenShopSucessState)openShopSucessState param:(NSDictionary *)param;
@end
