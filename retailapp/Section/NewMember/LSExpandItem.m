//
//  LSExpandItem.m
//  retailapp
//
//  Created by taihangju on 2016/10/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSExpandItem.h"

@implementation LSExpandItem

+ (instancetype)expandItem:(id)targert selector:(SEL)method {
    
    LSExpandItem *item = [[LSExpandItem alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W - 20, 32.0)];
    [item configTapGesture:targert selector:method];
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubviews];
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        self.layer.cornerRadius = 4.0;
    }
    return self;
}

- (void)configTapGesture:(id)targert selector:(SEL)method  {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:targert action:method];
    [self addGestureRecognizer:tap];
}

- (void)configSubviews {
    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    self.leftLabel.textColor = [ColorHelper getWhiteColor];
    self.leftLabel.font = [UIFont systemFontOfSize:13.0];
    self.leftLabel.text = @"当日新增会员";
    [self addSubview:self.leftLabel];
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.textColor = [ColorHelper getWhiteColor];
    self.rightLabel.font = [UIFont systemFontOfSize:13.0];
    self.rightLabel.text = @"展开";
    [self addSubview:self.rightLabel];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrow.image = [UIImage imageNamed:@"ico_next_down_w"];
    [self addSubview:arrow];
    self.arrowImageView = arrow;
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
//    line.backgroundColor = [ColorHelper getTipColor9];
//    [self addSubview:line];
    
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10.0);
        make.height.equalTo(@22.0);
        make.centerY.equalTo(self.mas_centerY);
    }];

    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10.0);
        make.width.and.height.equalTo(@22.0);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow.mas_left);
        make.height.equalTo(@22.0);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(8.0);
//        make.right.equalTo(self.mas_right).offset(-8.0);
//        make.height.equalTo(1.0);
//        make.bottom.equalTo(self.mas_bottom).offset(0.5);
//    }];

}
@end
