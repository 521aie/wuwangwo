//
//  SearchBar3.m
//  retailapp
//
//  Created by hm on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SearchBar3.h"
#import "SystemUtil.h"
#import "KeyBoardUtil.h"
#import "UIView+Sizes.h"
#import "AlertBox.h"
#import "ColorHelper.h"

@implementation SearchBar3
@synthesize txtKeyWord,panel;

+ (instancetype)searchBar3 {
    SearchBar3 *searchBar3 = [[NSBundle mainBundle] loadNibNamed:@"SearchBar3" owner:nil options:nil][0];
    return searchBar3;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [[NSBundle mainBundle] loadNibNamed:@"SearchBar3" owner:self options:nil];
//    [self addSubview:self.view];
    self.lblName.textColor = [ColorHelper getWhiteColor];
    self.lblName.alpha = 0.4;
    txtKeyWord.textColor = [ColorHelper getWhiteColor];
    txtKeyWord.alpha = 0.4;
    [KeyBoardUtil initWithTarget:self.txtKeyWord];
}

//+ (instancetype)searchBar3 {
//    SearchBar3 *searchBar = [[SearchBar3 alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 44)];
//    [searchBar awakeFromNib];
//    return searchBar;
//}

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
    self.scanView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.panel.frame = CGRectMake(self.panel.ls_origin.x, self.panel.ls_origin.y, self.panel.ls_width, self.panel.ls_height);
        self.panel.frame = CGRectMake(self.panel.ls_origin.x-37, self.panel.ls_origin.y, self.panel.ls_width+12, self.panel.ls_height);
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
        self.panel.frame = CGRectMake(self.panel.ls_origin.x+37, self.panel.ls_origin.y, self.panel.ls_width-12, self.panel.ls_height);
        self.cancelBtn.frame = CGRectMake(280, self.cancelBtn.ls_origin.y, self.cancelBtn.ls_width, self.cancelBtn.ls_height);
        self.cancelBtn.frame = CGRectMake(320, self.cancelBtn.ls_origin.y, self.cancelBtn.ls_width, self.cancelBtn.ls_height);
        
        
        
        
        
        
    } completion:^(BOOL finished) {
        self.scanView.hidden = NO;
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

// 隐藏键盘触发的方法
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSString *keyword = textField.text;
//    
//    if ([NSString isBlank:keyword]) {
//        if (_delegate&&[_delegate respondsToSelector:@selector(imputFinish:)]) {
//            [_delegate imputFinish:keyword];
//        }
//    }
//}

- (IBAction)btnScanClick:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(scanStart)]) {
        [_delegate scanStart];
    }

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
