//
//  LSMemberSearchBar.m
//  retailapp
//
//  Created by taihangju on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberSearchBar.h"
#import "ColorHelper.h"
#import "KeyBoardUtil.h"

@interface LSMemberSearchBar()<UITextFieldDelegate>

@property (nonatomic ,strong) UIView *bgColorWrapperView;/*<显示背景色的wrapper view>*/
@property (nonatomic ,strong) UIButton *searchButton;/*<>*/
@property (nonatomic ,strong) UITextField *searchTextField;/*<>*/
@property (nonatomic ,copy) void (^searchAction)(NSString *queryString);/*<查询回调>*/
@end

@implementation LSMemberSearchBar


+ (LSMemberSearchBar *)memberSearchBar:(void(^)(NSString *queryString))block {
    
    LSMemberSearchBar *searchBar = [[LSMemberSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 44.0)];
    searchBar.backgroundColor = RGBA(255, 255, 255, 0.2); // #FFFFFF ,透明度0.2
    searchBar.searchAction = block;
    [searchBar configSubViews];
    return searchBar;
}

- (void)configSubViews {
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.frame = CGRectMake(SCREEN_W - 62.0, 7, 62.0, 30.0);
    [self.searchButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.searchButton.titleLabel setShadowColor:RGB(127, 127, 127)];
    [self.searchButton setTitle:@"查询" forState:0];
    self.searchButton.titleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightBold];
    self.searchButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.searchButton];
    [self.searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bgColorWrapperView = [[UIView alloc] initWithFrame:CGRectMake(10, 6, CGRectGetMinX(self.searchButton.frame) - 10.0, 32)];
    self.bgColorWrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.bgColorWrapperView.layer.cornerRadius = 6;
    self.bgColorWrapperView.layer.masksToBounds = YES;
    [self addSubview:self.bgColorWrapperView];
    
    // 🔍 图标
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 5.0, 22.0, 22.0)];
    searchImageView.image = [UIImage imageNamed:@"ico_search"];
    [self.bgColorWrapperView addSubview:searchImageView];
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(26.0, 0, CGRectGetWidth(self.bgColorWrapperView.frame) - 22.0,32.0)];
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.tintColor = [UIColor whiteColor];
    self.searchTextField.borderStyle = UITextBorderStyleNone;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"会员卡号/手机号" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.7],NSFontAttributeName :[UIFont boldSystemFontOfSize:15]}];
    self.searchTextField.textColor = [UIColor whiteColor];
    self.searchTextField.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightBold];
    self.searchTextField.delegate = self;
    [self.bgColorWrapperView addSubview:self.searchTextField];
    [KeyBoardUtil initWithTarget:self.searchTextField];
}

- (void)setSearchWord:(NSString *)keyword {
    self.searchTextField.text = keyword;
}

- (void)search:(UIButton *)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSString *queryString = self.searchTextField.text;
    if (self.searchAction) { // [NSString isNotBlank:queryString] &&
        self.searchAction(queryString);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self search:nil];
    return YES;
}

@end
