//
//  SearchBar3.m
//  retailapp
//
//  Created by hm on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SearchBar4.h"
#import "SystemUtil.h"
#import "KeyBoardUtil.h"
#import "UIView+Sizes.h"
#import "AlertBox.h"

@implementation SearchBar4
@synthesize txtKeyWord,panel;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"SearchBar4" owner:self options:nil];
    [self addSubview:self.view];
    [KeyBoardUtil initWithTarget:self.txtKeyWord];
}

- (void)showCondition:(BOOL)isShow
{
    self.pic.hidden = !isShow;
    self.img.hidden = isShow;
    self.lblName.hidden = !isShow;
    self.btnSelect.hidden = !isShow;
    if (isShow) {
        [self.txtKeyWord setLs_left:82];
        [self.txtKeyWord setLs_width:167];
    }else{
        [self.txtKeyWord setLs_left:34];
        [self.txtKeyWord setLs_width:167+34];
    }
}

- (void)initDeleagte:(id<ISearchBarEvent>)delegate withName:(NSString*)title placeholder:(NSString *)placeholder
{
    _delegate = delegate;
    if ([txtKeyWord respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        txtKeyWord.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: RGBA(153.0, 153.0, 153.0, 1)}];
    } else {
        txtKeyWord.placeholder=placeholder;
    }
    self.lblName.text = title;
    [self initView];
    
}

- (void)initView
{
    [panel.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
    [txtKeyWord setDelegate:self];
    txtKeyWord.enablesReturnKeyAutomatically = YES;
//    [txtKeyWord setValue:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3]  forKeyPath:@"_placeholderLabel.textColor"];
//    
//    [KeyBoardUtil initWithTarget:txtKeyWord];
}

- (void)changeLimitCondition:(NSString*)condition
{
    _lblName.text = condition;
}

- (void)changePlaceholder:(NSString*)placeholder {
    if ([txtKeyWord respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        txtKeyWord.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: RGBA(153.0, 153.0, 153.0, 1)}];
    } else {
        txtKeyWord.placeholder=placeholder;
    }
}

- (IBAction)onCancelClick:(id)sender
{
    [self.txtKeyWord resignFirstResponder];
    self.txtKeyWord.text = nil;
    [self hiddenCancelButton];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(imputFinish:)]) {
       // [self.delegate imputFinish:@""];
        [self.delegate imputFinish:self.txtKeyWord.text];
    }
}

- (void)showCancelButton
{
    [UIView animateWithDuration:0.3 animations:^{
        self.panel.frame = CGRectMake(self.panel.ls_origin.x, self.panel.ls_origin.y, self.panel.ls_width, self.panel.ls_height);
        self.panel.frame = CGRectMake(self.panel.ls_origin.x, self.panel.ls_origin.y, self.panel.ls_width-37, self.panel.ls_height);
        self.cancelBtn.frame = CGRectMake(320, self.cancelBtn.ls_origin.y, self.cancelBtn.ls_width, self.cancelBtn.ls_height);
        self.cancelBtn.frame = CGRectMake(280, self.cancelBtn.ls_origin.y, self.cancelBtn.ls_width, self.cancelBtn.ls_height);
    } completion:^(BOOL finished) {
        self.cancelBtn.hidden = NO;
    }];
}

- (void)hiddenCancelButton
{
    [UIView animateWithDuration:0.3 animations:^{
        self.panel.frame = CGRectMake(self.panel.ls_origin.x, self.panel.ls_origin.y, self.panel.ls_width, self.panel.ls_height);
        self.panel.frame = CGRectMake(self.panel.ls_origin.x, self.panel.ls_origin.y, self.panel.ls_width+37, self.panel.ls_height);
        self.cancelBtn.frame = CGRectMake(280, self.cancelBtn.ls_origin.y, self.cancelBtn.ls_width, self.cancelBtn.ls_height);
        self.cancelBtn.frame = CGRectMake(320, self.cancelBtn.ls_origin.y, self.cancelBtn.ls_width, self.cancelBtn.ls_height);
        
        
        
        
        
        
    } completion:^(BOOL finished) {
        self.cancelBtn.hidden = YES;
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.cancelBtn.hidden) {
        [self showCancelButton];
    }
    return YES;
}

// 输入完成触发的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [SystemUtil hideKeyboard];
    NSString *keyword = textField.text;
    [self hiddenCancelButton];
    if ([NSString isNotBlank:keyword]) {
        if (_delegate&&[_delegate respondsToSelector:@selector(imputFinish:)]) {
            [_delegate imputFinish:keyword];
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int max = 50;
    if (range.location >= max) {
        NSString *text = [textField.text substringToIndex:max];
        if (text.length >= max) {
            textField.text = [text substringToIndex:max];
        }
        [AlertBox show:[NSString stringWithFormat:@"字数不能超过%d字",max]];
        return NO;
    }
    return YES;
}

- (IBAction)btnSelectClick:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(selectCondition)]) {
        [_delegate selectCondition];
    }
}

@end
