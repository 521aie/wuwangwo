//
//  LSEditItemMemo.m
//  retailapp
//
//  Created by guozhi on 2017/3/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define kHeight 48
#import "LSEditItemMemo.h"
#import "NSString+Estimate.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "SystemUtil.h"
#import <Masonry/Masonry.h>

@implementation LSEditItemMemo

+ (instancetype)editItemMemo {
    LSEditItemMemo *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    [view setup];
    return view;
}

- (void)setup {
     self.frame = CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 48);
     self.isEdit = YES;
    [self addGestureRecognizer];
}

- (void)initVal:(NSString *)val {
    
    self.lblVal.text = val;
     self.lblVal.textColor = self.isEdit?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
    __weak typeof(self) wself = self;
    if ([NSString isBlank:val]) {//如果没有详情
        self.lblVal.hidden = YES;
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(wself.mas_top).offset(kHeight);
            make.left.equalTo(wself.mas_left).offset(10);
            make.right.equalTo(wself.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];
    } else {//如果有详情
        self.lblVal.hidden = NO;
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wself.lblVal.mas_bottom).offset(10);
            make.left.equalTo(wself.mas_left).offset(10);
            make.right.equalTo(wself.mas_right).offset(-10);
            make.height.equalTo(@1);
            
        }];
    }
    [self layoutIfNeeded];
    self.ls_height = self.line.ls_bottom;
}

- (void)initLabel:(NSString *)label isrequest:(BOOL)req  delegate:(id<IEditItemMemoEvent>)delegate {
    
    self.delegate = delegate;
    self.lblName.text = label;
    self.isReq = req;
    self.lblHit.text = req?@"必填":@"可不填";
    self.lblHit.textColor = req?[UIColor redColor]:[UIColor grayColor];
    [self.lblVal setTextColor:[ColorHelper getBlueColor]];
    [self initVal:nil];
}

- (void)addGestureRecognizer {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
}

- (void)tapClick:(UITapGestureRecognizer *)tagGes {
    [SystemUtil hideKeyboard];
    if ([self.delegate respondsToSelector:@selector(onItemMemoListClick:)]) {
        [self.delegate onItemMemoListClick:self];
    }
}

- (void)initData:(NSString *)data {
    
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    [self changeData:data];
}

- (void)changeData:(NSString *)data {
    
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    self.lblVal.text = self.currentVal;
    self.lblHit.text=[NSString isBlank:data]?(self.isReq?@"必填":@"可不填"):@"";
    [self initVal:data];
    [self changeStatus];
}

- (void)changeStatus {
    [super isChange];
}

- (float)getHeight {
    [self layoutIfNeeded];
    return self.line.ls_bottom;
}

#pragma mark - 得到返回值.
- (NSString *)getStrVal {
    return self.currentVal;
}

- (void)editEnable:(BOOL)enable {
    
    self.isEdit = enable;
    self.lblVal.textColor = enable?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
}
@end
