//
//  LSInfoAlertController.m
//  retailapp
//
//  Created by guozhi on 2016/10/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSInfoAlertController.h"
#import "LSInfoAlertView.h"
@interface LSInfoAlertController ()
@property (nonatomic, strong) LSInfoAlertView *alertView;
@property (strong, nonatomic) UIButton *closeButton;
@end

@implementation LSInfoAlertController
- (instancetype)init {
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    __weak typeof(self) wself = self;
    [self.alertView loadDatas:self.datas callBlcok:^(LSInfoAlertVo *infoAlertVo) {
        if ([wself.delegate respondsToSelector:@selector(infoAlert:)]) {
            [wself.delegate infoAlert:infoAlertVo];
            [wself dismiss];
        }
    }];
    
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    self.alertView = [[LSInfoAlertView alloc] init];
    [self.view addSubview:self.alertView];
    self.closeButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"shop_review_close"] forState:UIControlStateNormal];
    self.closeButton.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    [self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.alertView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wself.view.centerX);
        make.centerY.equalTo(wself.view.centerY).offset(20);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(410);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.right.equalTo(wself.alertView.right).offset(-10);
        make.top.equalTo(wself.alertView.top).offset(-20);
    }];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    CGPoint p = [[touches anyObject] locationInView:self.view];
//    if (!CGRectContainsPoint(self.alertView.frame, p)) {
//        [self dismiss];
//    }
//}


- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
