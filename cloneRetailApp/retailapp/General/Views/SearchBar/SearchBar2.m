//
//  SearchBar2.m
//  retailapp
//
//  Created by hm on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SearchBar2.h"
#import "KeyBoardUtil.h"
#import "SystemUtil.h"
#import "UIView+Sizes.h"
#import "AlertBox.h"

@implementation SearchBar2

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[[NSBundle mainBundle] loadNibNamed:@"SearchBar2" owner:self options:nil] lastObject];
    self.view.frame = CGRectMake(0, 0, SCREEN_W, 44);
    [self addSubview:self.view];
    [KeyBoardUtil initWithTarget:self.keyWordTxt];
}

+ (instancetype)searchBar2 {
    SearchBar2 *searchBar = [[SearchBar2 alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 44)];
    [searchBar awakeFromNib];
    searchBar.frame = CGRectMake(0, 0, SCREEN_W, 44);
    return searchBar;
}


- (void)initDelagate:(id<ISearchBarEvent>)delegate placeholder:(NSString *)placeholder
{
    self.searchBarDelegate = delegate;
    if ([self.keyWordTxt respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.keyWordTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: RGBA(153.0, 153.0, 153.0, 1)}];
    } else {
        self.keyWordTxt.placeholder=placeholder;
    }
    [self initView];
}

- (void)initView
{
    [self.keyWordTxt setDelegate:self];
     self.keyWordTxt.enablesReturnKeyAutomatically = YES;
    [self.panel.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
}

- (IBAction)onCancelBtnClick:(id)sender
{
    [self.keyWordTxt resignFirstResponder];
    self.keyWordTxt.text = nil;
    [self hiddenCancelButton];
    if (self.searchBarDelegate&&[self.searchBarDelegate respondsToSelector:@selector(imputFinish:)]) {
        [self.searchBarDelegate imputFinish:@""];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.cancelBtn.hidden) {
        [self showCancelButton];
    }
    return YES;
}

- (void)showCancelButton
{
    self.rightConstraintPanel.constant = -50;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.cancelBtn.hidden = NO;
    }];
}

- (void)hiddenCancelButton
{
    self.rightConstraintPanel.constant = -10;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.cancelBtn.hidden = YES;
    }];
}

- (void)limitKeyWords:(int)number {
    self.number = number;
}

// 输入完成触发的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *keyword = textField.text;
    [SystemUtil hideKeyboard];
    [self hiddenCancelButton];
    if ([NSString isNotBlank:keyword]) {
        if (self.searchBarDelegate&&[self.searchBarDelegate respondsToSelector:@selector(imputFinish:)]) {
            [self.searchBarDelegate imputFinish:keyword];
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

@end
