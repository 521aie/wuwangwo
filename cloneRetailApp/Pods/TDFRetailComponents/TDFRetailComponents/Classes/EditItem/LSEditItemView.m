//
//  LSEditItemView.m
//  retailapp
//
//  Created by guozhi on 2017/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define kHeight 48
#import "LSEditItemView.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "NSString+Estimate.h"
#import <Masonry/Masonry.h>

@implementation LSEditItemView
+ (instancetype)editItemView {
    LSEditItemView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    [view setup];
    return view;
}

- (void)setup {
    self.lblName.text = @"";
    self.lblVal.text = @"";
    self.lblDetail.text = @"";
    self.frame = CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, kHeight);
    self.lblVal.textColor = [ColorHelper getTipColor6];
}

- (void)initHit:(NSString *)hit {
    self.lblDetail.text = hit;
    __weak typeof(self) wself = self;
    if ([NSString isBlank:hit]) {//如果没有详情
        self.lblDetail.hidden = YES;
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
    self.ls_height = self.line.ls_bottom;
}

- (void)initLabel:(NSString*)label withHit:(NSString *)_hit
{
    self.lblName.text = label;
    [self initHit:_hit];
}

- (void)initData:(NSString*)data {
    self.currentVal = ([NSString isBlank:data]) ? @"" :data;
    self.lblVal.text = data;
}

- (float)getHeight {
    [self layoutIfNeeded];
    return self.line.ls_bottom;
}
#pragma 得到返回值.
- (NSString*)getStrVal{
    return self.currentVal;
}

@end
