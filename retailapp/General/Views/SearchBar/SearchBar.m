//
//  SearchBar.m
//  retailapp
//
//  Created by hm on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SearchBar.h"
#import "KeyBoardUtil.h"
#import "SystemUtil.h"
#import "UIView+Sizes.h"
#import "AlertBox.h"

@implementation SearchBar
@synthesize searchBarDelegate,keyWordTxt,panel;
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"SearchBar" owner:self options:nil];
    self.view.ls_width = SCREEN_W;
    self.ls_width = SCREEN_W;
    [self addSubview:self.view];
    [KeyBoardUtil initWithTarget:keyWordTxt];
}

- (void)initDeleagte:(id<ISearchBarEvent>)delegate placeholder:(NSString *)placeholder
{
    searchBarDelegate = delegate;
    if ([keyWordTxt respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        keyWordTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: RGBA(153.0, 153.0, 153.0, 1)}];
    } else {
        keyWordTxt.placeholder=placeholder;
    }
    [self initView];
}

+ (instancetype)searchBar {
    SearchBar *searchBar = [[SearchBar alloc] init];
    [searchBar awakeFromNib];
    searchBar.frame = CGRectMake(0, 0, SCREEN_W, 44);
    return searchBar;
}
- (void)initView
{
    [keyWordTxt setDelegate:self];
    self.keyWordTxt.enablesReturnKeyAutomatically = YES;
    [panel.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
    
//    [keyWordTxt setValue:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3]  forKeyPath:@"_placeholderLabel.textColor"];
//    [KeyBoardUtil initWithTarget:keyWordTxt];
}

- (IBAction)onCancelClick:(id)sender
{
    [self.keyWordTxt resignFirstResponder];
    self.keyWordTxt.text = nil;
    [self hiddenCancelButton];
    if (self.searchBarDelegate&&[self.searchBarDelegate respondsToSelector:@selector(imputFinish:)]) {
        [self.searchBarDelegate imputFinish:@""];
    }
}

- (void)showCancelButton
{
    self.scanView.hidden = YES;
    self.scanViewLeftConstrint.constant = -40;
    self.panelRightConstraint.constant = -50;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
//        self.panel.frame = CGRectMake(self.panel.ls_origin.x, self.panel.ls_origin.y, self.panel.ls_width, self.panel.ls_height);
//        self.panel.frame = CGRectMake(self.panel.ls_origin.x-37, self.panel.ls_origin.y, self.panel.ls_width+12, self.panel.ls_height);
//        self.cancelBtn.frame = CGRectMake(SCREEN_W, self.cancelBtn.ls_origin.y, self.cancelBtn.ls_width, self.cancelBtn.ls_height);
//        self.cancelBtn.frame = CGRectMake(SCREEN_W - 40, self.cancelBtn.ls_origin.y, self.cancelBtn.ls_width, self.cancelBtn.ls_height);
    } completion:^(BOOL finished) {
        self.cancelBtn.hidden = NO;
    }];
}

- (void)hiddenCancelButton
{
    self.scanViewLeftConstrint.constant = 0;
    self.panelRightConstraint.constant = -10;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
//        self.panel.frame = CGRectMake(self.panel.ls_origin.x, self.panel.ls_origin.y, self.panel.ls_width, self.panel.ls_height);
//        self.panel.frame = CGRectMake(self.panel.ls_origin.x+37, self.panel.ls_origin.y, self.panel.ls_width-12, self.panel.ls_height);
//        self.cancelBtn.frame = CGRectMake(SCREEN_W - 40, self.cancelBtn.ls_origin.y, self.cancelBtn.ls_width, self.cancelBtn.ls_height);
//        self.cancelBtn.frame = CGRectMake(SCREEN_W, self.cancelBtn.ls_origin.y, self.cancelBtn.ls_width, self.cancelBtn.ls_height);
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
        if (searchBarDelegate&&[searchBarDelegate respondsToSelector:@selector(imputFinish:)]) {
            [searchBarDelegate imputFinish:keyword];
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
//        if (searchBarDelegate&&[searchBarDelegate respondsToSelector:@selector(imputFinish:)]) {
//            [searchBarDelegate imputFinish:keyword];
//        }
//    }
//}
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
- (IBAction)scanBtnClick:(id)sender
{
    if (searchBarDelegate&&[searchBarDelegate respondsToSelector:@selector(scanStart)]) {
        [searchBarDelegate scanStart];
    }
}

@end
