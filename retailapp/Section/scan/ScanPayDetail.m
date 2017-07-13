//
//  ScanPayView.m
//  retailapp
//
//  Created by guozhi on 16/1/21.
//  Copyright (c) 2016年 杭州迪火科技有限公司. All rights reserved.
//

#define TAG_TXT_AMOUNT 1
#define TAG_TXT_MEMO 2
#import "ScanPayDetail.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "ObjectUtil.h"
#import "ColorHelper.h"
#import "KeyBoardUtil.h"
#import "ScanPayView.h"
#import "SymbolNumberInputBox.h"
#import "DateUtils.h"
#import "UIView+Sizes.h"


@implementation ScanPayDetail

- (id)initWithCode:(NSString *)code
{
    self = [super init];
    if (self) {
        /**
         99925580前8为代表entiyID
         150571162790 中间11为代表手机号
         6  是校验码
         99925580150571627906
         */
        if (code.length == 20) {
            service = [ServiceFactory shareInstance].scanService;
            self.entityId = [code substringToIndex:8];
            self.mobile = [code substringWithRange:NSMakeRange(8, 11)];
        } else {
            [self showMessage];
        }
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    if ([self isVaild]) {
        [self loadData];
    }
}

- (void)initNavigate {
    [self configTitle:@"向顾客收款" leftPath:Head_ICON_BACK rightPath:nil];
}


- (BOOL)isVaild {
    if ([NSString isBlank:self.entityId]) {
        [self showMessage];
        return NO;
    }
    if ([NSString isBlank:self.mobile]) {
        [self showMessage];
        return NO;
    }
    return YES;

}


- (void)showMessage {
      [AlertBox show:@"收款码无效,请重新扫描。" client:self];
}

- (void)showScanView {
    ScanPayView *payView;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ScanPayView class]]) {
            payView = (ScanPayView *)vc;
        }
    }
    [self.navigationController popToViewController:payView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [payView loadScanView];
}




- (void)loadData {
    __weak typeof(self) weakself = self;
    [service getCustomerInfo:self.param CompletionHandler:^(id json) {
        
        NSDictionary *customerInfo = [json objectForKey:@"customerInfo"];
        if ([ObjectUtil isNull:customerInfo]) {
            [self showMessage];
            return ;
        }
//        NSString *name = [customerInfo objectForKey:@"name"];
//        NSString *mobile = [customerInfo objectForKey:@"mobile"];
//        if ([NSString isBlank:name] || [NSString isBlank:mobile]) {
//            [self showMessage];
//            return ;
//
//        }
        [weakself initData:customerInfo];
    } errorHandler:^(id json) {
        [AlertBox show:json client:self];
    }];
    
}

- (void)initData:(NSDictionary *)customerInfo {
    NSString *urlStr = [customerInfo objectForKey:@"url"];
    if ([NSString isNotBlank:urlStr]) {
        NSURL *url = [NSURL URLWithString:urlStr];
        [self.userIcon sd_setImageWithURL:url placeholderImage:nil];
    }
    
    self.userIcon.layer.cornerRadius = self.userIcon.ls_width/2;
    self.userIcon.layer.masksToBounds = YES;
    NSString *name = [customerInfo objectForKey:@"name"];
    if ([NSString isNotBlank:name]) {
        self.userName.text = name;
        self.userName.textColor = [ColorHelper getTipColor3];

    }
    NSString *mobile = [customerInfo objectForKey:@"mobile"];
    if ([NSString isNotBlank:mobile]) {
        self.userPhone.text = mobile;
        self.userPhone.textColor = [ColorHelper getTipColor3];
    }
    
    self.amount.textColor = [ColorHelper getTipColor3];
    self.memo.textColor = [ColorHelper getTipColor3];
    self.txtAmount.tag = TAG_TXT_AMOUNT;
    self.txtAmount.placeholder = @"每笔最高1万";
    self.txtMeno.tag = TAG_TXT_MEMO;
    self.txtMeno.placeholder = @"20个字以内";
    [KeyBoardUtil initWithTarget:self.txtAmount];
    [KeyBoardUtil initWithTarget:self.txtMeno];
    self.cardId = [customerInfo objectForKey:@"cardId"];
    self.customerId = [customerInfo objectForKey:@"customerId"];
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    if ([NSString isNotBlank:self.entityId]) {
         [_param setValue:self.entityId forKey:@"entityId"];
    }
    if ([NSString isNotBlank:self.mobile]) {
        [_param setValue:self.mobile forKey:@"mobile"];
    }
    return _param;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == TAG_TXT_AMOUNT) {
        [self.txtMeno resignFirstResponder];
        [SymbolNumberInputBox initData:self.txtAmount.text];
        [SymbolNumberInputBox show:@"" client:self isFloat:YES isSymbol:NO event:textField.tag];
        [SymbolNumberInputBox limitInputNumber:5 digitLimit:2];
        return NO;
    }
        [UIView animateWithDuration:0.25 animations:^{
            self.view.ls_top = -40;
        }];
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.ls_top = 0;
        }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
        if (textField.tag == TAG_TXT_MEMO) {
        if (range.location >= 20) {
            NSString *txt=textField.text;
            if(txt.length>=20){
                textField.text=[txt substringToIndex:20];
            }
            return NO;
        }
    }
    return YES;
    
}



- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    if ([val floatValue] > 10000) {
        [AlertBox show:@"收款金额不能超过1万"];
        return;
    }
    self.txtAmount.text = val;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == TAG_TXT_AMOUNT) {
        [textField resignFirstResponder];
        [self.txtMeno becomeFirstResponder];
    }
    if (textField.tag == TAG_TXT_MEMO) {
        [textField resignFirstResponder];
    }
    return YES;
}


- (IBAction)onClick:(UIButton *)sender {
    if ([NSString isBlank:self.txtAmount.text]) {
        [AlertBox show:@"收款金额不能为空"];
        return;
    }
    float fee = [self.txtAmount.text floatValue];
    if (fee == 0) {
        [AlertBox show:@"请正确输入收款金额"];
        return;
    }
    if ([self.txtAmount.text isEqualToString:@"."]) {
        [AlertBox show:@"请正确输入收款金额"];
        return;
    }
    NSString *memo = self.txtMeno.text;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([NSString isNotBlank:self.entityId]) {
         [param setValue:self.entityId forKey:@"entityId"];
    }
    [param setValue:self.cardId forKey:@"cardId"];
    [param setValue:self.customerId forKey:@"customerId"];
    if ([NSString isNotBlank:memo]) {
         [param setValue:memo forKey:@"memo"];
    }
    [param setValue:self.mobile forKey:@"mobile"];
    NSString *entiyId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    [param setValue:entiyId forKey:@"shopEntityId"];
    [param setValue:[NSNumber numberWithFloat:fee] forKey:@"fee"];
    [service getPayInfo:param CompletionHandler:^(id json) {
        [AlertBox show:@"收款成功" client:self];
            } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtAmount resignFirstResponder];
    [self.txtMeno resignFirstResponder];

}

- (void)understand {
    [self showScanView];
}



@end
