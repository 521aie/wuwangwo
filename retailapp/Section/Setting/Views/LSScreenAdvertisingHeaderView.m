//
//  LSScreenAdvertisingHeaderView.m
//  retailapp
//
//  Created by guozhi on 2016/11/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSScreenAdvertisingHeaderView.h"
#import "ColorHelper.h"
@interface LSScreenAdvertisingHeaderView()
/** logo */
@property (nonatomic, strong) UIImageView *imgLogo;
/** 注释 */
@property (nonatomic, strong) UILabel *lblNote;
/** 背景View */
@property (nonatomic, strong) UIView *bgView;
@end

@implementation LSScreenAdvertisingHeaderView
+ (instancetype)screenAdvertisingHeaderView {
    LSScreenAdvertisingHeaderView *view = [[LSScreenAdvertisingHeaderView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (instancetype)init {
    if (self = [super init]) {
        [self configViews];
        [self configConstraints];
    }
    return self;
}
- (void)configViews {
    //配置背景View
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.bgView];
    //logo
    self.imgLogo = [[UIImageView alloc] init];
    self.imgLogo.image = [UIImage imageNamed:@"ico_screen_advertising_green"];
    [self addSubview:self.imgLogo];
    //说明
    self.lblNote = [[UILabel alloc] init];
    self.lblNote.textColor = [ColorHelper getTipColor6];
    self.lblNote.numberOfLines = 0;
    self.lblNote.text = @"店内屏幕广告，店家在此处设置图片广告，上传的图片将以轮播的形式通过二维火收银机客显应用在店内屏幕上进行展示。";
    self.lblNote.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.lblNote];
    
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
     self.ls_width = SCREEN_W;
    CGFloat margin = 10;
    //配置logo
    [self.imgLogo makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(65);
        make.top.equalTo(wself.top).offset(margin);
        make.centerX.equalTo(wself.centerX);
    }];
    //配置说明
    [self.lblNote makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.imgLogo.bottom).offset(margin);
        make.left.equalTo(wself.left).offset(margin);
        make.right.equalTo(wself.right).offset(-margin);
    }];
    
    [self.bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(wself);
        make.bottom.equalTo(wself.lblNote.bottom).offset(9);
    }];
    [self layoutIfNeeded];
    self.ls_height = self.bgView.ls_bottom + 1;
    
}
@end
