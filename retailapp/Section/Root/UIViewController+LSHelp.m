//
//  UIViewController+LSHelp.m
//  retailapp
//
//  Created by guozhi on 2017/3/7.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIViewController+LSHelp.h"
#import "LSHelpListController.h"
static const void *kCode = "helpCode";

@implementation UIViewController (LSHelp)
/**
 帮助按钮
 */
- (void)configHelpButton:(NSString *)helpCode {
    if (!([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102 && [[Platform Instance] getShopMode] == 1)) {
        return;//只有商超单点支付帮助功能
    }
    self.helpCode = helpCode;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"ico_help"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"ico_help"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(helpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    __weak typeof(self) wself = self;
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.view.left).offset(5);
        make.bottom.equalTo(wself.view.bottom).offset(-5);
        make.size.equalTo(32);
    }];
}

- (void)helpButtonClick:(UIButton *)btn {
    LSHelpListController *vc = [[LSHelpListController alloc] init];
    vc.code = self.helpCode;
    
    [self pushViewController:vc];
}

#pragma mark - 字符串类型的动态绑定
- (NSString *)helpCode {
    return objc_getAssociatedObject(self, kCode);
}

- (void)setHelpCode:(NSString *)helpCode {
    objc_setAssociatedObject(self, kCode, helpCode, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
