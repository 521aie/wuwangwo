//
//  SymbolNumberInputBox.m
//  RestApp
//
//  Created by hm on 15/3/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SymbolNumberInputBox.h"
#import "SystemUtil.h"

static SymbolNumberInputBox *symbolNumberInputBox;

@implementation SymbolNumberInputBox

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.background.layer setCornerRadius:2.0];
}


+ (void)initNumberInputBox
{
    symbolNumberInputBox = [[SymbolNumberInputBox alloc] init];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    symbolNumberInputBox.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [window addSubview:symbolNumberInputBox.view];
    symbolNumberInputBox.view.hidden = YES;
}

+ (void)show:(NSString *)title client:(id<SymbolNumberInputClient>) client isFloat:(BOOL)isFloat isSymbol:(BOOL)isSymbol event:(NSInteger)event
{
    symbolNumberInputBox->event=event;
    symbolNumberInputBox->symbolNumberInputClient = client;
    [symbolNumberInputBox showMoveIn];
    symbolNumberInputBox.lblTitle.text=title;
    symbolNumberInputBox.isFirstTime=YES;
    symbolNumberInputBox.symbol = isSymbol;
    symbolNumberInputBox.isFloat = isFloat;
    symbolNumberInputBox.btnDot.enabled=isFloat;
    symbolNumberInputBox.btnSymbol.enabled = isSymbol;
}


+ (void)limitInputNumber:(NSInteger)integerLimit digitLimit:(NSInteger)digitLimit
{
    symbolNumberInputBox->integerLimit = integerLimit;
    symbolNumberInputBox->digitLimit = digitLimit;
}

+ (void)hide
{
    [symbolNumberInputBox hideMoveOut];
}


+ (void)initData:(NSString *)data
{
    symbolNumberInputBox.lblVal.text=data;
}

- (IBAction)confirmBtnClick:(id)sender
{
    NSString* val=self.lblVal.text;
    [symbolNumberInputClient numberClientInput:val event:event];
    [self hideMoveOut];
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self hideMoveOut];
}


- (IBAction)btnClick:(id)sender
{
    UIButton* btn =(UIButton*)sender;
    if (symbolNumberInputBox.isFirstTime) {
        symbolNumberInputBox.lblVal.text=btn.titleLabel.text;
        symbolNumberInputBox.isFirstTime=NO;
        return;
    }
    
    NSRange symbolRange = [symbolNumberInputBox.lblVal.text rangeOfString:@"-"];
    if (symbolNumberInputBox.symbol) {
        if ([@"-" isEqualToString:btn.titleLabel.text]&&[NSString isNotBlank:symbolNumberInputBox.lblVal.text]) {
            return;
        }
    }
    
    NSRange pointRange = [symbolNumberInputBox.lblVal.text rangeOfString:@"."];
    if (symbolNumberInputBox.isFloat) {
        if (pointRange.length>0&&[@"." isEqualToString:btn.titleLabel.text]) {
            return;
        }
    }
    
    if (pointRange.length>0 && digitLimit>0) {
        //带小数点时，限制小数位
        NSArray *subStrings = [symbolNumberInputBox.lblVal.text componentsSeparatedByString:@"."];
        if ([ObjectUtil isNotEmpty:subStrings] && subStrings.count == 2) {
            NSString *pointStr = subStrings[1];
            if (pointStr.length >= digitLimit) {
                return;
            }
        }
    }
    
    if (pointRange.length==0&&integerLimit>0) {
        //不带小数点，限制整数位
        if (symbolRange.length>0) {
            if ([symbolNumberInputBox.lblVal.text length] == (integerLimit+1) && ![@"." isEqualToString:btn.titleLabel.text]) {
                return;
            }
        }else{
            if ([symbolNumberInputBox.lblVal.text length] == (integerLimit) && ![@"." isEqualToString:btn.titleLabel.text]) {
                return;
            }
        }
    }

    NSMutableString* str=[[NSMutableString alloc] init];
    [str appendString:symbolNumberInputBox.lblVal.text];
    [str appendString:btn.titleLabel.text];
    symbolNumberInputBox.lblVal.text=str;
    str = nil;
}

- (IBAction)btnBackClick:(id)sender
{
    NSString* str=symbolNumberInputBox.lblVal.text;
    if ([str length]>0) {
        symbolNumberInputBox.lblVal.text=[str substringToIndex:([str length]-1)];
    }
}


@end
