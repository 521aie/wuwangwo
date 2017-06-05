//
//  OpenShopSucessViewController.m
//  retailapp
//
//  Created by guozhi on 16/8/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OpenShopSucessViewController.h"
#import "XHAnimalUtil.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "SignUtil.h"
#import "LSScreenShot.h"

@interface OpenShopSucessViewController ()<UIAlertViewDelegate>
/*
 * 数据源
 */
@property (nonatomic, strong) NSDictionary *json;
/*
 * 手机号
 */
@property (nonatomic, copy) NSString *mobile;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UILabel *lblShopCode;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (nonatomic, weak) LoginViewController *loginVc;
@end

@implementation OpenShopSucessViewController

- (instancetype)initWithJson:(NSDictionary *)json mobile:(NSString *)mobile {
    if ( self = [super init]) {
        self.json = json;
        self.mobile = mobile;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initMainView];
    [LSScreenShot screenShot:self.view];
}

- (void)initNavigate {
    [self configTitle:@"开店成功"];
    [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"关闭" filePath:Head_ICON_CANCEL];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)direct {
    if (direct == LSNavigationBarButtonDirectLeft) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开店成功页面已保存到手机相册，如忘记账号信息可在相册中查看！为了安全起见，建议您尽快修改管理员密码！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        alert.tag = 2;
        [alert show];
        
    }
    
}
- (void)initMainView {
    self.lblTip.text = [NSString stringWithFormat:@"提示：以上账号信息已经发送到手机：%@，请妥善保管好您的账号！开店成功页面已保存到手机相册，如忘记账号信息可在相册中查看！为了安全起见，建议您尽快修改管理员密码！", self.mobile];
    NSDictionary *dict = self.json[@"activationCodeVo"];
    self.lblShopCode.text = dict[@"shopCode"];
    self.lblUserName.text = dict[@"name"];
    self.lblPassword.text = dict[@"password"];
    __weak typeof(self) wself = self;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[HomeViewController class]]) {
            HomeViewController *homeVc = (HomeViewController *)obj;
            wself.loginVc = homeVc.loginVc;
        }
    }];
}

//使用管理员账号登录二维火掌柜，点击后用管理员账号完成登录，页面跳转到店家首页
- (IBAction)btnClick:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开店成功页面已保存到手机相册，如忘记账号信息可在相册中查看！为了安全起见，建议您尽快修改管理员密码！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    alert.tag = 1;
    [alert show];
    
}

- (void)understand {
    [self.loginVc openShopSucessViewControllerAtIndex:OpenShopSucessStateLogin param:self.json[@"activationCodeVo"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        __weak typeof(self) wself = self;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[HomeViewController class]]) {
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                [wself.navigationController popToViewController:obj animated:NO];
            }
        }];
        if (alertView.tag == 1) {//使用管理员账号登录二维火掌柜，点击后用管理员账号完成登录，页面跳转到店家首页
            [self.loginVc openShopSucessViewControllerAtIndex:OpenShopSucessStateLogin param:self.json[@"activationCodeVo"]];
        } else if (alertView.tag == 2) {//点击关闭
            [self.loginVc openShopSucessViewControllerAtIndex:OpenShopSucessStateClose param:self.json[@"activationCodeVo"]];
        }
    }
    
}

@end
