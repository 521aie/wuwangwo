//
//  LSSegmentedView.m
//  retailapp
//
//  Created by taihangju on 16/10/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSegmentedView.h"

@interface LSSegmentedView()

@property (nonatomic ,copy) SegmentSelectedBlock block;/*<>*/
@property (nonatomic ,strong) UIButton *dayButton;/*<>*/
@property (nonatomic ,strong) UIButton *monthButton;/*<>*/
@end

@implementation LSSegmentedView

+ (LSSegmentedView *)segmentedView:(SegmentSelectedBlock)block {
    
    LSSegmentedView *segmentView = [[LSSegmentedView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 44.0)];
    segmentView.clipsToBounds = YES;
    segmentView.block = block;
    return segmentView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubViews];
        [self buttonTap:self.dayButton];
    }
    return self;
}

- (void)setLeftButtonTitle:(NSString *)title1 rightButtonTitle:(NSString *)title2 {
    
    if (title1.length) {
        [self.dayButton setTitle:title1 forState:0];
    }
    if (title2.length) {
        [self.monthButton setTitle:title2 forState:0];
    }
}

- (void)configSubViews {
    
    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(7.0, 0, CGRectGetWidth(self.frame)-14.0, CGRectGetHeight(self.frame)-14.0)];
    wrapper.layer.masksToBounds = YES;
    wrapper.layer.cornerRadius = 4.0;
    wrapper.layer.borderWidth = 1.0;
    wrapper.layer.borderColor = RGBA(255, 255, 255, 0.5).CGColor;
    [self addSubview:wrapper];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(7.0 ,CGRectGetHeight(self.frame)-0.6, CGRectGetWidth(self.frame)-14.0, 0.7)];
    line.backgroundColor = [ColorHelper getTipColor9];
    [self addSubview:line];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame)/2, 30.0);
    [leftButton setTitle:@"昨日" forState:0];
    [leftButton setTitleColor:[ColorHelper getWhiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[ColorHelper getRedColor] forState:UIControlStateSelected];
    [leftButton setTitleShadowColor:RGB(127, 127, 127) forState:0];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    leftButton.tag = 1;
    [leftButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [wrapper addSubview:leftButton];
    self.dayButton = leftButton;
    

    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(CGRectGetMaxX(leftButton.frame), 0, CGRectGetWidth(self.frame)/2, 30.0);
    [rightButton setTitleColor:[ColorHelper getWhiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[ColorHelper getRedColor] forState:UIControlStateSelected];
    [rightButton setTitleShadowColor:RGB(127, 127, 127) forState:0];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightButton setTitle:@"本月" forState:0];
    rightButton.tag = 2;
    [rightButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [wrapper addSubview:rightButton];
    self.monthButton = rightButton;
}

- (void)buttonTap:(UIButton *)sender {
    
    if ([sender isEqual:self.dayButton]) {
        self.dayButton.selected = YES;
        self.monthButton.selected = NO;
        self.dayButton.backgroundColor = RGBA(255.0, 255.0, 255.0, 0.3);
        self.monthButton.backgroundColor = [UIColor clearColor];
    }
    else if ([sender isEqual:self.monthButton]) {
        self.dayButton.selected = NO;
        self.monthButton.selected = YES;
        self.dayButton.backgroundColor = [UIColor clearColor];
        self.monthButton.backgroundColor = RGBA(255.0, 255.0, 255.0, 0.3);
    }
    if (self.block) {
        self.block(sender.tag);
    }
}

@end
