//
//  LSInfoAlertViewItem.m
//  retailapp
//
//  Created by guozhi on 2016/10/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSInfoAlertViewItem.h"
@interface LSInfoAlertViewItem ()
@property (strong, nonatomic) UIImageView *imgViewTop;
@property (strong, nonatomic) UIImageView *imgViewCenter;
@property (strong, nonatomic) UIImageView *imgViewBottom;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *lblTitle;
@property (strong, nonatomic) UILabel *lblTip;
@property (strong, nonatomic) UIButton *btn;
@property (nonatomic,copy) CallBlock block;
@property (nonatomic, strong) LSInfoAlertVo *infoAlertVo;
@end
@implementation LSInfoAlertViewItem
- (instancetype)init {
    if (self = [super init]) {
        [self configViews];
        [self configConstraints];
    }
    return self;
}

- (void)infoAlertView:(LSInfoAlertVo *)infoAlertVo callBlock:(CallBlock)callBlock {
    self.block = callBlock;
    self.infoAlertVo = infoAlertVo;
    self.imgView.image = [UIImage imageNamed:infoAlertVo.imagePath];
    self.lblTitle.text = infoAlertVo.title;
    self.lblTip.text = infoAlertVo.content;
    [self.btn setTitle:infoAlertVo.buttonTitle forState:UIControlStateNormal];
}

- (void)configViews {
    self.imgViewTop = [[UIImageView alloc] init];
    self.imgViewTop.image = [UIImage imageNamed:@"shop_status_img_top"];
    [self addSubview:self.imgViewTop];
    
    self.imgViewCenter = [[UIImageView alloc] init];
    self.imgViewCenter.image = [UIImage imageNamed:@"shop_review_img_center"];
    [self addSubview:self.imgViewCenter];
    
    self.imgViewBottom = [[UIImageView alloc] init];
    self.imgViewBottom.image = [UIImage imageNamed:@"shop_review_img_bottom"];
    [self addSubview:self.imgViewBottom];
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imgView];
    
    self.lblTitle = [[UILabel alloc] init];
    self.lblTitle.textAlignment = NSTextAlignmentCenter;
    self.lblTitle.font = [UIFont systemFontOfSize:14];
    self.lblTitle.textColor = [UIColor colorWithWhite:51.0/255 alpha:1.0];
    [self addSubview:self.lblTitle];
    
    self.lblTip = [[UILabel alloc] init];
    self.lblTip.font = [UIFont systemFontOfSize: 11];
    self.lblTip.textColor = [UIColor colorWithWhite:136.0 / 255 alpha:1.0];
    self.lblTip.numberOfLines = 0;
    [self addSubview:self.lblTip];
    
    self.btn = [UIButton buttonWithType: UIButtonTypeSystem];
    [self addSubview:self.btn];
    CALayer *layer = self.btn.layer;
    layer.cornerRadius = 15;
    layer.masksToBounds = YES;
    
    UIColor *color = [UIColor colorWithRed:219.0 / 255
                                     green:84.0 / 255
                                      blue:72.0 / 255
                                     alpha:1.0];
    layer.borderColor = color.CGColor;
    layer.borderWidth = 1;
    self.btn.backgroundColor = [UIColor whiteColor];
    [self.btn setTitleColor:color forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)button {
    if (self.block) {
        self.block(self.infoAlertVo);
    }
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.imgViewTop makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(wself);
        make.height.equalTo(40);
        
    }];
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself.imgViewTop.bottom);
        make.height.equalTo(160);
    }];
    [self.imgViewBottom makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself);
        make.height.equalTo(60);
    }];
    [self.imgViewCenter makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself.imgViewTop.bottom);
        make.bottom.equalTo(wself.imgViewBottom.top);
    }];
    
    [self.lblTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself.imgView.mas_bottom).offset(10);
    }];
    
    [self.lblTip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(35);
        make.top.equalTo(wself.lblTitle.bottom).offset(10);
        make.right.equalTo(wself.right).offset(-30);
    }];
    
    [self.btn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wself.centerX);
        make.centerY.equalTo(wself.imgViewBottom.top).offset(-5);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(30);
    }];
}
@end
