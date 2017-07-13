//
//  EditItemText2.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemText2.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "KeyBoardUtil.h"
#import "LSAlertHelper.h"
#import <Masonry/Masonry.h>

@implementation EditItemText2
@synthesize view;

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemText2" owner:self options:nil];
    self.view.frame = CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 48);
    [self addSubview:self.view];
    self.txtVal.returnKeyType=UIReturnKeyDone;
    self.txtVal.delegate=self;
    self.txtVal.text=@"";
    [KeyBoardUtil initWithTarget:self.txtVal];
}

+ (instancetype)editItemText {
    EditItemText2 *view = [[EditItemText2 alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 48)];
    [view awakeFromNib];
    return view;
}


- (void)initPosition:(NSUInteger)num {
    __weak typeof(self) wself = self;
    if (num == 0) {
        [self.btnButton setHidden:YES];
        [self.txtVal mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wself.view.mas_right).offset(-10);
        }];
    }else{
        [self.btnButton setHidden:NO];
        [self.txtVal mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wself.btnButton.mas_left).offset(-10);
        }];
        [self.btnButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(19 + num * 15));
        }];
    }
}

- (void)initMaxNum:(int)num {
    self.num = num;
}

- (void)initLabel:(NSString *)label withHit:(NSString *)hit withType:(NSString *)typeName showTag:(int)tag delegate:(id<EditItemText2Delegate>)delegate {
    
    self.lblName.text=label;
    [self initHit:hit];
    self.btnButton.tag = tag;
    self.delegate = delegate;
    self.btnButton.clipsToBounds = YES;
    self.btnButton.layer.cornerRadius = 2.0;
    [self.btnButton setTitle:typeName forState:normal];
    [self initPosition:typeName.length];
}

- (void)initLabel:(NSString *)label withHit:(NSString *)hit isrequest:(BOOL)req type:(UIKeyboardType)keyboardType withType:(NSString *) typeName showTag:(int)tag delegate:(id<EditItemText2Delegate>)delegate {
    
    self.lblName.text=label;
    [self initHit:hit];
    self.btnButton.tag = tag;
    self.delegate = delegate;
    self.btnButton.clipsToBounds = YES;
    self.btnButton.layer.cornerRadius = 2.0;
    
    self.keyboardType=keyboardType;
    UIColor *color = req?[UIColor redColor]:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    NSString* hitStr=req?@"必填":@"可不填";
    if ([self.txtVal respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.txtVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hitStr attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        self.txtVal.placeholder=hitStr;
    }
    if (keyboardType) {
        self.txtVal.keyboardType=keyboardType;
    }
    
    [self.btnButton setTitle:typeName forState:normal];
    [self initPosition:typeName.length];
}


#pragma  initHit.
- (void)initHit:(NSString *)hit {
    self.lblDetail.text = hit;
    __weak typeof(self) wself = self;
    if ([NSString isBlank:hit]) {//如果没有详情
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(wself.mas_top).offset(48);
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
    self.view.ls_height = self.line.ls_bottom;
    self.ls_height = self.line.ls_bottom;
}


- (float)getHeight {
    [self layoutIfNeeded];
    return self.line.ls_bottom;
}


#pragma mark-textfield.delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 先进性字数判断
    if (self.num == 0) {
        if (range.location>=32) {
            [LSAlertHelper showAlert:@"字数限制在50字以内！"];
            return  NO;
        }
    } else {
        if (range.location>=self.num) {
            [LSAlertHelper showAlert:[NSString stringWithFormat:@"字数限制在%d字以内！", self.num]];
            return  NO;
        }
    }
    
    // 特殊字符判断
    NSString *tfContent = textField.text;
    if ([NSString stringContainsEmoji:&tfContent]) {
        [LSAlertHelper showAlert:[NSString stringWithFormat:@"%@存在特殊字符！" ,self.lblName.text]];
        textField.text = tfContent;
        return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self changeData:self.txtVal.text];
    return YES;
}


- (IBAction)onFocusClick:(UIButton *)sender {
    [self.delegate showButtonTag:sender.tag];
}

#pragma initUI
- (void)initLabel:(NSString *)label withVal:(NSString *)data {
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    [self changeLabel:label withVal:data];
}

- (void)initData:(NSString *)data {
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    [self changeData:data];
}

#pragma  ui is changing.
- (void)changeLabel:(NSString *)label withVal:(NSString *)data {
    self.lblName.text=([NSString isBlank:label]) ? @"" :label;
    [self changeData:data];
}

- (void)changeData:(NSString *)data {
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    self.txtVal.text=self.currentVal;
    [self changeStatus];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.num>0&&self.txtVal.text.length>self.num) {
        textField.text = [textField.text substringToIndex:self.num+1];
    }
}

#pragma data

- (NSString *)getStrVal {
    return self.currentVal;
}


#pragma change status
- (void)changeStatus {
    [super isChange];
}

- (void)editEnabled:(BOOL)enable {
    [self initPosition:enable];//是否显示扫一扫商品详情用到
    self.txtVal.enabled = enable;
    self.txtVal.textColor = enable?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
}

- (void)clearChange {
    self.oldVal=self.currentVal;
    [self changeStatus];
}

@end
