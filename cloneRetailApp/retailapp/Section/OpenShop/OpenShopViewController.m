//
//  OpenShopViewController.m
//  retailapp
//
//  Created by guozhi on 16/8/15.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OpenShopViewController.h"
#import "EditItemText.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "OpenShopSucessViewController.h"
@interface OpenShopViewController ()<UITextFieldDelegate>

/**
 *  容器用来刷新子控件
 */
@property (weak, nonatomic) IBOutlet UIView *container;
/**
 *  店名
 */
@property (weak, nonatomic) IBOutlet EditItemText *txtShopName;
/**
 *  手机号码
 */
@property (weak, nonatomic) IBOutlet EditItemText *txtTelPhone;
/**
 *  激活码
 */
@property (weak, nonatomic) IBOutlet EditItemText *txtActivationCode;
@end

@implementation OpenShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initMainView];
}

- (void)initNavigate {
    [self configTitle:@"我要开店" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)initMainView {
    [self.txtShopName initLabel:@"店名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtShopName.txtVal addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.txtTelPhone initLabel:@"手机号码" withHit:@"开店成功后，账号信息将以短信形式发送到您的手机上" isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtActivationCode initLabel:@"激活码" withHit:@"购买二维火收银机后，激活码附在收银机包装盒内的使用指南上" isrequest:YES type:UIKeyboardTypeNumberPad];
    self.txtActivationCode.txtVal.delegate = self;
    [UIHelper refreshUI:self.container];
}



- (IBAction)btnClock:(UIButton *)sender {
    [self.view endEditing:YES];
    __weak typeof(self) wself = self;
    if ([self isVaild]) {
        NSString *url = @"selfSetShop/v2/active_code";
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSString *mobile = self.txtTelPhone.txtVal.text;
        [param setValue:self.txtShopName.txtVal.text forKey:@"shopName"];
        [param setValue:mobile forKey:@"telephone"];
        [param setValue:[self.txtActivationCode.txtVal.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"code"];
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:@"正在验证" show:YES CompletionHandler:^(id json) {
            OpenShopSucessViewController *vc = [[OpenShopSucessViewController alloc] initWithJson:json mobile:mobile];
            [wself.navigationController pushViewController:vc animated:NO];
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
    
    
    
}

- (BOOL)isVaild {
    if ([NSString isBlank:self.txtShopName.txtVal.text]) {
        [AlertBox show:@"店名不能为空！"];
        return NO;
    } else if ([NSString isBlank:self.txtTelPhone.txtVal.text]) {
        [AlertBox show:@"手机号码不能为空！"];
        return NO;
    } else if (![NSString validateMobile:self.txtTelPhone.txtVal.text]) {
        [AlertBox show:@"请输入正确的手机号码！"];
        return NO;
    } else if ([NSString isBlank:self.txtActivationCode.txtVal.text]) {
        [AlertBox show:@"激活码不能为空！"];
        return NO;
    }else if ([self.txtActivationCode.txtVal.text stringByReplacingOccurrencesOfString:@" " withString:@""].length != 16) {
        [AlertBox show:@"请输入正确的激活码！"];
        return NO;
    }
    return YES;
}


- (void)textFieldDidChange:(UITextField *)textField {
    int maxlength = 0;
    NSString *txt = nil;
    if (textField == self.txtShopName.txtVal) {
        maxlength = 50;
        txt = textField.text;
        if (txt.length > maxlength) {
            textField.text=[txt substringToIndex:maxlength];
            [AlertBox show:@"店家名称请控制在50个字以内！"];
        }
    } 
}

//检测是否为纯数字
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//在UITextField的代理方法中
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    //检测是否为纯数字
    if ([self isPureInt:string]) {
        //添加空格，每4位之后
        if (textField.text.length % 5 == 4) {
            textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
        }
        //只要30位数字
        if ([toBeString length] > 19)
        {
            toBeString = [toBeString substringToIndex:19];
            textField.text = toBeString;
            return NO;
        }
    }
    else if ([string isEqualToString:@""]) { // 删除字符
        if ((textField.text.length - 2) % 5 == 4) {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }
        return YES;
    }
    else{
        return NO;
    }
    return YES;
}



@end
