//
//  LSEditItemRadio.m
//  retailapp
//
//  Created by guozhi on 2017/3/21.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define kHeight 48
#import "LSEditItemRadio.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "SystemUtil.h"
#import <Masonry/Masonry.h>

@implementation LSEditItemRadio
+ (instancetype)editItemRadio {
    LSEditItemRadio *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    [view setup];
    return view;
}

- (void)setup {
    self.frame = CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, kHeight);
}

- (void)initHit:(NSString *)hit {
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
    self.ls_height = self.line.ls_bottom;
}

- (void)initLabel:(NSString *)label withHit:(NSString *)hit
         delegate:(id<IEditItemRadioEvent>)delegate {
    
    self.delegate=delegate;
    [self initLabel:label withHit:hit];
}

- (void)initLabel:(NSString *)label withHit:(NSString *)hit {
    self.lblName.text = label;
    [self initHit:hit];
}

- (float)getHeight {
    [self layoutIfNeeded];
    return self.line.ls_bottom;
}

- (void)initData:(NSString *)data {
    self.oldVal = ([NSString isBlank:data]) ? @"" :data;
    [self changeData:data];
}
- (void)changeData:(NSString *)data {
    self.currentVal = ([NSString isBlank:data]) ? @"" :data;
    BOOL result = [self.currentVal isEqualToString:@"1"];
    NSString *filePath = result ? @"ico_switch_on" : @"ico_switch_off";
    self.imgView.image = [UIImage imageNamed:filePath];
    [self changeStatus];
}

- (void)changeStatus {
    //    BOOL flag=[super isChange];
    [super isChange];
}
- (void)initLabel:(NSString *)label withVal:(NSString *)data withHit:(NSString *)hit {
    [self initLabel:label withVal:data];
    [self initHit:hit];
}

- (void)initLabel:(NSString *)label withVal:(NSString *)data {
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    [self changeLabel:label withVal:data];
}

- (void)changeLabel:(NSString *)label withVal:(NSString *)data {
    self.lblName.text = ([NSString isBlank:label]) ? @"" :label;
    [self changeData:data];
}
- (BOOL)getVal {
    return [self.currentVal isEqualToString:@"1"];
}
- (IBAction)btnClick:(UIButton *)sender {
    [SystemUtil hideKeyboard];
    NSString* val = @"1";
    if ([self.currentVal isEqualToString:@"1"]) {
        val = @"0";
    }
    [self changeData:val];
    if ([self.delegate respondsToSelector:@selector(onItemRadioClick:)]) {
        [self.delegate onItemRadioClick:self];
    }

}

- (NSString *)getStrVal {
    return self.currentVal;
}

- (void)editable:(BOOL)enable {
    self.userInteractionEnabled = enable;
}
@end
