//
//  GoodsSearchBarView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsSearchBarView.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "KeyBoardUtil.h"
#import "ISearchBarEvent.h"

@implementation GoodsSearchBarView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"GoodsSearchBarView" owner:self options:nil];
    
    [self addSubview:self.view];
    
    self.txtKey.text = @"";
}

- (void)initDelegate:(id<ISearchBarEvent>)delegateTmp
{
    self.saleSearchBarEvent = delegateTmp;
    
    self.event = nil;
    
    [self initView];
}

- (void)initEvent:(NSString*)event
{
    self.event = event;
}

- (void)initView
{
    [self.txtKey setDelegate:self];
    
    [self.panel.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
    
    [self.txtKey setValue:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3]  forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.txtKey addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEvents];
    
    [KeyBoardUtil initWithTarget:self.txtKey];
    
    CGRect frame = self.frame;
    
    frame.origin.y = 0 - frame.size.height;
    
    self.frame = frame;
}

- (void)requestFocus
{
    [self.txtKey becomeFirstResponder];
}

// 输入完成触发的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [SystemUtil hideKeyboard];
    
    NSString *keyword = textField.text;
    
    if ([NSString isNotBlank:keyword]) {
        
        [self.saleSearchBarEvent imputFinish:keyword];
    }
    
    return YES;
}

// 隐藏键盘触发的方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *keyword = textField.text;
    
    if ([NSString isBlank:keyword]) {
        
        [self.saleSearchBarEvent imputFinish:@""];
    }
}

- (void)valueChange:(UITextField *)textField
{
    NSString *keyword = textField.text;
    
    if ([self.event isEqualToString:@"STOCK_QUERY"]) {
        
        [self.saleSearchBarEvent imputFinish:keyword];
    }
}

- (IBAction)sweepBtnClick:(id)sender
{
    [self.saleSearchBarEvent scanStart];
}

@end

