//
//  OrderInputBox.m
//  retailapp
//
//  Created by hm on 15/12/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderInputBox.h"
#import "InputTarget.h"

static OrderInputBox *orderInputBox;

@interface OrderInputBox ()

@end

@implementation OrderInputBox

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)initOrderInputBox
{
    if (orderInputBox==nil) {
        orderInputBox = [[OrderInputBox alloc] init];
        orderInputBox.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        [window addSubview:orderInputBox.view];
        orderInputBox.view.hidden = YES;
    }
}

+ (void)show:(InputTarget *)inputTarget delegate:(id<OrderInputBoxDelegate>)delegate isFloat:(BOOL)isFloat isSymbol:(BOOL)isSymbol
{
    orderInputBox.inputTarget = inputTarget;
    orderInputBox.delegate = delegate;
    orderInputBox.lblVal.text = inputTarget.textField.text;
    orderInputBox.isFloat = isFloat;
    orderInputBox.isSymbol = isSymbol;
    orderInputBox.isFirstTime = YES;
    orderInputBox.btnDot.enabled = isFloat;
    orderInputBox.btnSymbol.enabled = isSymbol;
    orderInputBox.inputNum = @"";
    [orderInputBox.delegate selectTarget:inputTarget];
    [orderInputBox showMoveIn];
}

+ (void)limitInputNumber:(NSInteger)integerLimit digitLimit:(NSInteger)digitLimit
{
    orderInputBox.integerLimit = integerLimit;
    orderInputBox.digitLimit = digitLimit;
}


- (IBAction)btnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *digit = button.titleLabel.text;
    if (self.inputTarget && self.inputTarget.textField) {
        if (self.isSymbol) {
            if ([@"-" isEqualToString:digit]&&[NSString isNotBlank:self.inputNum]) {
                return;
            }
        }
        NSRange range = [self.inputNum rangeOfString:@"."];
        if (self.isFloat) {
            //小数位验证
            if (range.length>0&&[@"." isEqualToString:digit]) {
                return;
            }
            NSArray *subStrings = [self.inputNum componentsSeparatedByString:@"."];
            if ([ObjectUtil isNotEmpty:subStrings] && subStrings.count == 2) {
                NSString *pointStr = subStrings[1];
                if (pointStr.length >= self.digitLimit) {
                    return;
                }
            }
        }
        
        if (range.length==0&&self.integerLimit>0) {
            //整数位验证
            NSRange range =[self.inputNum rangeOfString:@"-"];
            if (range.length>0) {
                if ([self.inputNum length]==(self.integerLimit+1) && ![@"." isEqualToString:digit]) {
                    return;
                }
            }else{
                if ([self.inputNum length]==(self.integerLimit) && ![@"." isEqualToString:digit]) {
                    return;
                }
            }
        }
        
        self.inputNum = [self.inputNum stringByAppendingString:digit];
//        if ([self.inputNum integerValue]==0 && ![digit isEqualToString:@"-"]) {
//            self.lblVal.text = self.inputNum;
//            self.inputNum = @"";
//            return;
//        }
        self.lblVal.text = self.inputNum;
    }
}

- (IBAction)btnBackClick:(id)sender
{
    self.inputNum = self.lblVal.text;
    if ([self.inputNum length]>0) {
        self.lblVal.text = [self.inputNum substringToIndex:([self.inputNum length]-1)];
    }
    self.inputNum = self.lblVal.text;
}

- (IBAction)confirmBtnClick:(id)sender
{
    self.inputNum = [NSString isNotBlank:self.lblVal.text]?([@"-" isEqualToString:self.lblVal.text]?@"0":self.lblVal.text):@"0";
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputOkClick:textField:)]) {
        [self.delegate inputOkClick:self.inputNum textField:self.inputTarget.textField];
    }
    self.inputNum = @"";
    if (self.inputTarget && self.delegate) {
        [self.delegate deSelectTarget:self.inputTarget];
        if (self.inputTarget.nextTarget) {
            self.inputTarget = self.inputTarget.nextTarget;
            self.lblVal.text = self.inputTarget.textField.text;
            [self.delegate selectTarget:self.inputTarget];
        }else{
            [self hideMoveOut];
        }
    }
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self.delegate deSelectTarget:self.inputTarget];
    [self hideMoveOut];
}


@end
