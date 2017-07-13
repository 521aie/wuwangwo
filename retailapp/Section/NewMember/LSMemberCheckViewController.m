//
//  LSMemberElectronicCardStep1ViewController.m
//  retailapp
//
//  Created by byAlex on 16/9/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCheckViewController.h"
#import "LSMemberElectronicCardSendViewController.h"
#import "LSMemberListViewController.h"
#import "LSMemberChangeCardViewController.h"
#import "LSMemberChangePwdViewController.h"
#import "LSMemberRescindCardViewController.h"
#import "LSMemberCardLossHandViewController.h"
#import "LSMemberRechargeViewController.h"
//#import "LSMemberIntegralSetViewController.h"
#import "LSMemberIntegralExchangeViewController.h"
#import "LSMemberBestowIntegralViewController.h"
#import "NavigateTitle2.h"
#import "EditItemText.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "LSAlertHelper.h"
#import "LSMemberCardVo.h"
#import "LSMemberTypeVo.h"
#import "LSMemberInfoVo.h"
#import "LSMemberConst.h"


@interface LSMemberCheckViewController ()<INavigateEvent>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) EditItemText *phoneInputBox;/* <手机号码 输入*/
@property (nonatomic ,strong) UILabel *noticeLabel;/* <提示信息label*/
@property (nonatomic ,strong) UIButton *nextStepButton;/* <下一步*/
@property (nonatomic ,assign) MemberSubModuleType type;/*<查询服务的小模块， 如发卡时的查询或者换卡时的查询>*/
//@property (nonatomic ,strong) NSArray *memberCardTypes;/*<卡类型>*/
//@property (nonatomic ,strong) NSArray *memberCards;/*<已发卡>*/
//@property (nonatomic ,strong) NSArray *memberPackVos;/*<会员>*/
@end

@implementation LSMemberCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configSubViews {
    
    CGFloat topY = 0.0;
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, topY, SCREEN_W, 64.0);
    if (self.type == MBSubModule_SendCard) {
        [self.titleBox initWithName:@"发电子会员卡" backImg:Head_ICON_BACK moreImg:nil];
    }
    else {
        [self.titleBox initWithName:@"会员查询" backImg:Head_ICON_BACK moreImg:nil];
    }
    [self.view addSubview:self.titleBox];
    topY += 64.0;
    
    // 手机号码输入框
    self.phoneInputBox = [[EditItemText alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_W, 48.0)];
    if (self.type == MBSubModule_SendCard) {
       // 手机号， 字数限制
       [self.phoneInputBox initLabel:@"请输入会员手机号码:" withHit:@"" isrequest:YES type:UIKeyboardTypeNumberPad];
       [self.phoneInputBox initMaxNum:11];
    }
    else {
        // 会员号 允许 32位以内
       [self.phoneInputBox initLabel:@"会员查询" withHit:@"" isrequest:YES type:UIKeyboardTypeNamePhonePad];
       self.phoneInputBox.txtVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"会员卡号/手机号" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
       [self.phoneInputBox initMaxNum:32];
    }
    [self.phoneInputBox initData:@""];
    [self.view addSubview:self.phoneInputBox];
    topY += 48.0;
    
    // 提示信息
    if (self.type == MBSubModule_SendCard) {
        self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, self.phoneInputBox.ls_bottom + 10.0, SCREEN_W - 24, 40.0)];
        self.noticeLabel.numberOfLines = 0;
        self.noticeLabel.font = [UIFont systemFontOfSize:14.0];
        self.noticeLabel.textColor = [ColorHelper getTipColor6];
        self.noticeLabel.text = noticeString;
        [self.noticeLabel sizeToFit];
        [self.view addSubview:self.noticeLabel];
        topY += 50.0;
    }

    // button
    self.nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ( self.type == MBSubModule_SendCard) {
        [self.nextStepButton setTitle:@"下一步" forState:0];
    }
    else {
        [self.nextStepButton setTitle:@"确认" forState:0];
    }
    [self.nextStepButton setBackgroundColor:[ColorHelper getGreenColor]];
    [self.nextStepButton.titleLabel setTextColor:RGB(192, 0, 0)];
    [self.nextStepButton addTarget:self action:@selector(buttonTapAction) forControlEvents:UIControlEventTouchUpInside];
    self.nextStepButton.frame = CGRectMake(12, topY + 5.0, SCREEN_W - 24, 44);
    self.nextStepButton.layer.cornerRadius = 4.0;
    [self.view addSubview:self.nextStepButton];
}

#pragma mark - INavigateEvent
//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

// 点击button
- (void)buttonTapAction {
    
    [self.view endEditing:YES];
    if ([self isVaild]) {

        if (self.type == MBSubModule_SendCard || self.type == MBSubModule_ChangeCard || self.type == MBSubModule_ChangePwd || self.type == MBSubModule_ReturnCard || self.type == MBSubModule_CardReport || self.type == MBSubModule_Recharge || self.type == MBSubModule_BestowIntegral || self.type == MBSubModule_Integral) {
//            [self queryMemberInfo];
            [self queryCustomerInfo];
//        }
//        else if (self.type == MBSubModule_SendCard) {
//            [self querySmsNumAndKindCardAndQueryCard];
        }
    }
}


#pragma mark - 网络请求

// 查询短信条数，卡类型，和会员已有会员卡
//- (void)querySmsNumAndKindCardAndQueryCard {
//    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
//    [param setValue:entityId forKey:@"entityId"];
//    [param setValue:self.phoneInputBox.txtVal.text forKey:@"mobile"];
//    [param setValue:@(NO) forKey:@"isNeedAll"];
//    
//    [BaseService getRemoteLSDataWithUrl:@"customer/v1/querySmsNumAndKindCardAndQueryCard" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
//        NSDictionary *dic = json[@"data"];
//        if ([ObjectUtil isNotEmpty:dic]) {
//            
//            if ([ObjectUtil isEmpty:dic[@"cardQueryVo"]] || [ObjectUtil isEmpty:dic[@"cardQueryVo"][@"cards"]]) {
//                [self toSendCardPage:nil];
//            } else {
//                [LSAlertHelper showAlert:@"提示" message:@"该手机用户已是店铺会员！" cancle:@"我知道了" block:nil];
//            }
//        }
//    } errorHandler:^(id json) {
//        [LSAlertHelper showAlert:json block:nil];
//    }];
//}


// 会员接口迁移新增接口
- (void)queryCustomerInfo {
    
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSDictionary *param = @{@"entityId":entityId ,@"keyword":self.phoneInputBox.txtVal.text ,@"isOnlySearchMobile":@(NO)};
    
    [BaseService getRemoteLSOutDataWithUrl:@"card/v2/queryCustomerInfoByMobileOrCode" param:[param mutableCopy] withMessage:@"" show:YES CompletionHandler:^(id json) {
        NSArray *array = [LSMemberPackVo getMemberPackVoList:json[@"data"][@"customerList"]];
        if ([ObjectUtil isNotEmpty:array]) {
            
            if (array.count == 1) {
                
                LSMemberPackVo *memberPackVo = array.firstObject;
                
                // 发卡，已经是会员
                if (self.type == MBSubModule_SendCard && memberPackVo.customer) {
                    
                    if ([ObjectUtil isNotEmpty:memberPackVo.cardNames]) {
                         [LSAlertHelper showAlert:@"提示" message:@"该手机用户已是店铺会员！" cancle:@"我知道了" block:nil];
                    } else {
                        [self toSendCardPage:memberPackVo];
                    }
                     return ;
                }
                
                
                // 存在该会员但未领卡时，弹出提示框(适用于：会员换卡、会员充值、积分兑换、挂失与解挂、会员退卡、改卡密码、会员赠分)
                if (memberPackVo.customer && [ObjectUtil isEmpty:memberPackVo.cardNames]) {
                    
                    if (self.type == MBSubModule_ChangeCard || self.type == MBSubModule_ChangePwd || self.type == MBSubModule_ReturnCard || self.type == MBSubModule_CardReport || self.type == MBSubModule_Recharge || self.type == MBSubModule_Integral || self.type == MBSubModule_BestowIntegral) {
                        
                        [LSAlertHelper showAlert:@"提示" message:@"此会员还没有领本店会员卡，需要为会员发卡吗？" cancle:@"取消" block:nil ensure:@"发卡" block:^{
                            
                            if ([[Platform Instance] lockAct:ACTION_CARD_ADD]) {
                                [LSAlertHelper showAlert:@"您没有[发会员卡]的权限" block:nil];
                            }
                            else {
                                [self toSendCardPage:memberPackVo];
                            }
                        }];
                    }
                    return ;
                }
                
                if (self.type == MBSubModule_ChangeCard) {
                    
                    [self toChangeCardPage:memberPackVo];
                }
                else if (self.type == MBSubModule_ChangePwd) {
                    [self toChangePwdPage:memberPackVo];
                }
                else if (self.type == MBSubModule_ReturnCard) {
                    [self toRescindCardPage:memberPackVo];
                }
                else if (self.type == MBSubModule_CardReport) {
                    [self toLossCardPage:memberPackVo];
                }
                else if (self.type == MBSubModule_Recharge) {
                    [self toMemberRechargePage:memberPackVo];
                }
                else if (self.type == MBSubModule_Integral) {
                    [self toMemberIntegralExchangePage:memberPackVo];
                }
                else if (self.type == MBSubModule_BestowIntegral) {
                    [self toMemberBestowIntegralPage:memberPackVo];
                }
            }
            else if (array.count > 1) {
                
                // 查询到多个会员，进入会员选择页面
                LSMemberListViewController *listVc = [[LSMemberListViewController alloc] init:self.type packVos:array];
                [self pushController:listVc from:kCATransitionFromRight];
            }
        } else {
            
            if (self.type == MBSubModule_SendCard) {
                [self toSendCardPage:nil];
                return;
            }
            
            [LSAlertHelper showAlert:@"没有找到会员信息" block:nil];
        }
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];

}


// 判断
- (BOOL)isVaild {
    
    NSString *phoneString = self.phoneInputBox.txtVal.text;
    if (self.type == MBSubModule_SendCard) {
        
        if ([NSString isBlank:phoneString]) {
            [LSAlertHelper showAlert:@"提示" message:@"会员手机号码不能为空！" cancle:@"我知道了" block:nil];
            return NO;
        }
        else if (![NSString validateMobile:phoneString]) {
            [LSAlertHelper showAlert:@"提示" message:@"请输入正确的手机号码！" cancle:@"我知道了" block:nil];
            return NO;
        }
    }
    else {
        // 会员卡名称
        if ([NSString isBlank:phoneString] || [NSString isNotNumAndLetter:phoneString]) {
            [LSAlertHelper showAlert:@"提示" message:@"请输入会员卡号或手机号码！" cancle:@"我知道了" block:nil];
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - 页面跳转
// 跳转到会员发卡页面
- (void)toSendCardPage:(LSMemberPackVo *)vo {
   
    LSMemberElectronicCardSendViewController *vc = [[LSMemberElectronicCardSendViewController alloc] init:self.phoneInputBox.txtVal.text member:vo fromPage:NO];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到会员换卡页面
- (void)toChangeCardPage:(LSMemberPackVo *)vo {
    
    LSMemberChangeCardViewController *vc = [[LSMemberChangeCardViewController alloc] init:[vo getMemberPhoneNum] member:vo selectCard:nil];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到会员卡更改密码页面
- (void)toChangePwdPage:(LSMemberPackVo *)vo {
    
    LSMemberChangePwdViewController *vc = [[LSMemberChangePwdViewController alloc] init:vo cardId:nil];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到会员卡退卡界面
- (void)toRescindCardPage:(LSMemberPackVo *)vo {
    
    LSMemberRescindCardViewController *vc = [[LSMemberRescindCardViewController alloc] init:vo cardId:nil];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到卡挂失解挂界面
- (void)toLossCardPage:(LSMemberPackVo *)vo {

    LSMemberCardLossHandViewController *vc = [[LSMemberCardLossHandViewController alloc] init:vo];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到会员充值界面
- (void)toMemberRechargePage:(LSMemberPackVo *)vo {
    
    LSMemberRechargeViewController *vc = [[LSMemberRechargeViewController alloc] init:vo phone:[vo getMemberPhoneNum] selectCard:nil];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到积分兑换设置界面
//- (void)toMemberIntegralSetPage:(LSMemberPackVo *)vo {
//    
//    LSMemberIntegralSetViewController *vc = [[LSMemberIntegralSetViewController alloc] init];
//    [self pushController:vc from:kCATransitionFromRight];
//}

// 跳转到积分兑换界面
- (void)toMemberIntegralExchangePage:(LSMemberPackVo *)vo {
    
    LSMemberIntegralExchangeViewController *vc = [[LSMemberIntegralExchangeViewController alloc] init:vo cardId:nil];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到会员赠分界面
- (void)toMemberBestowIntegralPage:(LSMemberPackVo *)vo {
    LSMemberBestowIntegralViewController *vc = [[LSMemberBestowIntegralViewController alloc] init:vo cardId:nil];
    [self pushController:vc from:kCATransitionFromRight];
}
@end
