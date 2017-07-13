//
//  LSDateSelectItem.m
//  retailapp
//
//  Created by taihangju on 2016/10/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSDateSelectItem.h"
#import "Masonry.h"
#import "DatePickerBox.h"

@implementation LSDateSelectItem

+ (LSDateSelectItem *)dateSelectItem:(id)target selecter:(SEL)method {
    
    LSDateSelectItem *item = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 32.0)];
    [item configTapGesture:target action:method];
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self configSubviews];
//        self.backgroundColor = RGBA(255, 255, 255, 0.5);
    }
    return self;
}

- (void)configSubviews {
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [ColorHelper getWhiteColor];
    self.label.font = [UIFont systemFontOfSize:13.0];
    self.label.text = @"2016年10月";
    [self addSubview:self.label];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrow.image = [UIImage imageNamed:@"ico_next_down_w"];
    [self addSubview:arrow];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [ColorHelper getTipColor9];
    [self addSubview:line];
    

    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(-11.0);
        make.height.equalTo(@22.0);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label.mas_right);
        make.width.and.height.equalTo(@22.0);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8.0);
        make.right.equalTo(self.mas_right).offset(-8.0);
        make.height.equalTo(1.0);
        make.bottom.equalTo(self.mas_bottom).offset(0.5);
    }];
}

- (void)configTapGesture:(id)target action:(SEL)action {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

@end
