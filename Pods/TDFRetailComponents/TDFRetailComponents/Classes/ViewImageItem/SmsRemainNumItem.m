//
//  SmsExistItem.m
//  RestApp
//
//  Created by zxh on 14-11-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//
#define kHeight 48
#import "SmsRemainNumItem.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import <Masonry/Masonry.h>

@implementation SmsRemainNumItem

+ (instancetype)smsRetainNumItem {
    SmsRemainNumItem *item = [[NSBundle mainBundle] loadNibNamed:@"SmsRemainNumItem" owner:self options:nil].lastObject;
    item.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 48);
    item.btn.layer.cornerRadius = 5;
    item.btn.layer.masksToBounds=YES;
    return item;
}
#pragma  initHit.
- (void)initHit:(NSString *)hit
{
    self.lblDetail.text = hit;
    __weak typeof(self) wself = self;
    if ([NSString isBlank:hit]) {//如果没有详情
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(wself.mas_top).offset(kHeight);
            make.left.equalTo(wself.mas_left).offset(10);
            make.right.equalTo(wself.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];
    } else {//如果有详情
        self.lblDetail.hidden = NO;
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wself.lblDetail.mas_bottom).offset(10);
            make.left.equalTo(wself.mas_left).offset(10);
            make.right.equalTo(wself.mas_right).offset(-10);
            make.height.equalTo(@1);

        }];
    }
    [self layoutIfNeeded];
    self.ls_height = self.line.ls_bottom;}

- (void)initLabel:(NSString*)label withHit:(NSString *)_hit delegate:(id<ISmsDelegate>)delegate
{
    smsDelegate=delegate;
    self.lblName.text=label;
    [self.lblVal setTextColor:[ColorHelper getTipColor3]];
    [self initHit:_hit];
}

- (float) getHeight
{
    [self layoutIfNeeded];
    return self.line.ls_bottom;
}

#pragma initUI
- (void) initData:(NSString*)dataLabel withVal:(NSString *)data
{
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    self.lblVal.text=dataLabel;
}

- (NSString*) getStrVal
{
    return self.currentVal;
}

- (void)showChargeBtn:(BOOL)isShow {
    self.btn.hidden = !isShow;
    __weak typeof(self) wself = self;
    [self.lblVal mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(isShow ? wself.btn.mas_left : wself.mas_right).offset(-10);
    }];
}

- (IBAction)btnMoney:(id)sender
{
    NSString* remainNum=self.currentVal==nil?@"0":self.currentVal;
    [smsDelegate startCharge:[remainNum intValue]];
}

@end
