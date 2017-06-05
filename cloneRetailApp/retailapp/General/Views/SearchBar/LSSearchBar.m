//
//  LSSearchBar.m
//  retailapp
//
//  Created by guozhi on 16/8/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#define TAG_SCAN_BTN 1
#define TAG_CANCEL_BTN 0

#import "LSSearchBar.h"
#import "KeyBoardUtil.h"
#import "AlertBox.h"
@interface LSSearchBar()<UITextFieldDelegate>
/**
 *  扫一扫背景
 */
@property (nonatomic, weak) UIView *scanView;
/**
 *  搜索框背景
 */
@property (nonatomic, weak) UIView *panel;
/**
 *  取消按钮
 */
@property (nonatomic, weak) UIButton *cancelBtn;

@end
@implementation LSSearchBar

+ (instancetype)searchBar {
    //创建一个view
    LSSearchBar *searchBar = [[LSSearchBar alloc] init];
    return searchBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - 初始化设置
- (void)setup {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = SCREEN_W;
    CGFloat h = 44;
    self.frame = CGRectMake(x, y, w, h);
    
    //创建一个扫描图像的view 上面是扫一扫图片 和按钮
    w = 46;
    h = self.ls_height;
    UIView *scanBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    //创建扫一扫图像
    x = 12;
    w = 22;
    h = w;
    y = 8;
    UIImageView *scanImg = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    scanImg.image = [UIImage imageNamed:@"scan"];
    [scanBgView addSubview:scanImg];
    
    //创建扫一扫按钮
    x = 0;
    y = 0;
    w = scanBgView.ls_width;
    h = scanBgView.ls_height;
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanBtn.frame = CGRectMake(x, y, w, h);
    [scanBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scanBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
    scanBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [scanBtn setTintColor:[UIColor whiteColor]];
    [scanBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    scanBtn.tag = TAG_SCAN_BTN;
    [scanBgView addSubview:scanBtn];
    [self addSubview:scanBgView];
    self.scanView = scanBgView;
    
    //创建搜索输入框背景
    x = scanBgView.ls_right;
    h = 32;
    y = (self.ls_height - h)/2;
    w = SCREEN_W - x - 10;
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    searchBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [searchBgView.layer setCornerRadius:6];
    self.panel = searchBgView;
    
    //创建搜索图片
    x = 5;
    w = h = 22;
    y = (searchBgView.ls_height -h)/2;
    UIImageView *searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    searchImg.image = [UIImage imageNamed:@"ico_search"];
    [searchBgView addSubview:searchImg];
    
    //创建搜索框
    x = searchImg.ls_right + 5;
    w = searchBgView.ls_width - x;
    h = searchBgView.ls_height;
    y = 0;
    self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.txtField.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    self.txtField.font = [UIFont systemFontOfSize:13];
    self.txtField.delegate = self;
    self.txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.txtField.returnKeyType = UIReturnKeySearch;
    [self.txtField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.txtField.enablesReturnKeyAutomatically = YES;
    [searchBgView addSubview:self.txtField];
    [KeyBoardUtil initWithTarget:self.txtField];
    [self addSubview:searchBgView];
    
    //取消按钮默认隐藏
    x = self.ls_right;
    w = 40;
    h = 30;
    y = (self.ls_height - h)/2;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.tag = TAG_CANCEL_BTN;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(x, y, w, h);
    cancelBtn.hidden = YES;
    [self addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
}


#pragma mark - 扫一扫取消按钮点击事件
- (void)btnClick:(UIButton *)btn {
    [SystemUtil hideKeyboard];
    if (btn.tag == TAG_CANCEL_BTN) {
        self.txtField.text = @"";
        if ([self.delegate respondsToSelector:@selector(searchBarImputFinish:)]) {
            [self.delegate searchBarImputFinish:@""];
        }
    } else if(btn.tag == TAG_SCAN_BTN) {
        if ([self.delegate respondsToSelector:@selector(searchBarScanStart)]) {
            [self.delegate searchBarScanStart];
        }
    }
}

#pragma mark - 设置输入框提醒文字
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: RGBA(153.0, 153.0, 153.0, 1)}];
}

#pragma mark - 显示取消按钮
- (void)showCancelButton
{
    if (!self.cancelBtn.hidden) {
        return;
    }
    self.scanView.hidden = YES;
    self.cancelBtn.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.panel.ls_left = self.panel.ls_left - 30;
        self.cancelBtn.ls_left = self.cancelBtn.ls_left - 40;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 隐藏取消按钮
- (void)hiddenCancelButton
{
    if (self.cancelBtn.hidden) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.panel.ls_left = self.panel.ls_left + 30;
        self.cancelBtn.ls_left = self.cancelBtn.ls_left + 40;
    } completion:^(BOOL finished) {
        self.scanView.hidden = NO;
        self.cancelBtn.hidden = YES;
    }];
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self showCancelButton];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self hiddenCancelButton];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hideKeyBoard];
    NSString *keyword = textField.text;
    if ([NSString isNotBlank:keyword]) {
        if ([self.delegate respondsToSelector:@selector(searchBarImputFinish:)]) {
            [self.delegate searchBarImputFinish:keyword];
        }
    }
    
    return YES;
}

#pragma mark - 搜索框值改变时调用
- (void)textFieldDidChange:(UITextField *)textField
{
    int maxlength = self.maxLength == 0 ? 50 : self.maxLength;
    NSString *txt = textField.text;
    if(txt.length>maxlength){
        textField.text = [txt substringToIndex:maxlength];
        [AlertBox show:[NSString stringWithFormat:@"字数限制在%d字以内！", maxlength]];
    }
    
}

#pragma mark - 键盘消失
- (void)hideKeyBoard {
     [self endEditing:YES];
}
@end
