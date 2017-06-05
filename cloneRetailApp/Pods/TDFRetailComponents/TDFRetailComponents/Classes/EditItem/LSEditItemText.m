//
//  LSEditItemText.m
//  retailapp
//
//  Created by guozhi on 2017/3/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define kHeight 48
#import "LSEditItemText.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "KeyBoardUtil.h"
#import "LSAlertHelper.h"
#import "ColorHelper.h"
#import <Masonry/Masonry.h>

@implementation LSEditItemText
+ (instancetype)editItemText {
    LSEditItemText *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    [view setup];
    return view;
}

- (void)setup {
    self.txtVal.borderStyle = UITextBorderStyleNone;
    self.frame = CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 100);
    [self showStatus:YES];
    [self initHit:nil];
    [self initData:nil];
    self.txtVal.delegate = self;
    [KeyBoardUtil initWithTarget:self.txtVal];
     [self.txtVal addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)showStatus:(BOOL)showSatus {
    self.isShowStatus = showSatus;
}

- (void)initHit:(NSString *)hit {
    self.lblDetail.text = hit;
    __weak typeof(self) wself = self;
    if ([NSString isBlank:hit]) {//如果没有详情
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(wself.mas_top).offset(kHeight);
            make.left.equalTo(wself.mas_left).offset(10);
            make.right.equalTo(wself.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];
    } else {//如果有详情
        self.lblDetail.hidden = NO;
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wself.lblDetail.mas_bottom).offset(10);
            make.left.equalTo(wself.mas_left).offset(10);
            make.right.equalTo(wself.mas_right).offset(-10);
            make.height.equalTo(@1);
            
        }];
    }
    [self layoutIfNeeded];
    self.ls_height = self.line.ls_bottom;
}

- (void)initMaxNum:(int)num {
    self.num = num;
}

- (void)initLabel:(NSString *)label withHit:(NSString *)_hit isrequest:(BOOL)req type:(UIKeyboardType)keyboardType{
    
    self.lblName.text = label;
    [self initHit:_hit];
    UIColor *color = req?[UIColor redColor]:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    NSString *hitStr = req?@"必填":@"可不填";
    self.txtVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hitStr attributes:@{NSForegroundColorAttributeName: color}];
   self.txtVal.keyboardType = keyboardType;
}

#pragma mark - textfield.delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //    printf("===>%s\n" ,string.UTF8String);
    NSString *tfContent = textField.text;
    if ([NSString stringContainsEmoji:&tfContent]) {
        
        [LSAlertHelper showAlert:@"暂不支持表情符！"];
        textField.text = tfContent;
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (!self.isShowStatus) {
        [self initData:self.txtVal.text];
    } else {
        [self changeData:self.txtVal.text];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    int maxlength = self.num == 0 ? 50 : self.num;
    maxlength = maxlength < 0 ? 0 : maxlength;//加这句话是为了控制输入字数为0的情况
    NSString *txt = textField.text;
    if(txt.length>maxlength){
        textField.text=[txt substringToIndex:maxlength];
        NSString *str = self.txtTip ? self.txtTip :[NSString stringWithFormat:@"字数限制在%d字以内！", maxlength];
        [LSAlertHelper showAlert:str];
    }
    self.currentVal = textField.text;
    if (self.isShowStatus) {
        [super isChange];
    }
    if ([self.delegate respondsToSelector:@selector(editItemText:textFieldDidChange:)]) {
        [self.delegate editItemText:self textFieldDidChange:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    // 控制输入长度，默认50
    if (self.num == 0) {
        if (textField.text.length > 50) {
            textField.text = [textField.text substringToIndex:50];
        }
    }
    else {
        if (textField.text.length > self.num) {
            textField.text = [textField.text substringToIndex:self.num];
        }
    }
    
    //结束编辑 回调
    if ([self.delegate respondsToSelector:@selector(editItemTextEndEditing:currentVal:)]) {
        [self.delegate editItemTextEndEditing:self currentVal:self.txtVal.text];
    }
}
- (void)initData:(NSString *)data {
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    [self changeData:data];
}

- (void)changeData:(NSString *)data {
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    self.txtVal.text=self.currentVal;
    [self changeStatus];
    
}

- (NSString *)getStrVal {
    return self.currentVal;
}


-(void) changeStatus {
    [super isChange];
    
}

- (float)getHeight {
    [self layoutIfNeeded];
    return self.line.ls_bottom;
}

- (void)editEnabled:(BOOL)enable {
    self.txtVal.enabled = enable;
    self.txtVal.textColor = enable?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
}

#pragma  ui is changing.

@end
