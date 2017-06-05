//
//  LSSyetemNotificationView.m
//  retailapp
//
//  Created by guozhi on 2016/11/3.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSyetemNotificationView.h"

@interface LSSyetemNotificationView()
/** 点击进入下一个图片 */
@property (nonatomic, strong) UIImageView *imgNext;

@end

@implementation LSSyetemNotificationView
+ (instancetype)systemNotificationView:(CGFloat)y {
    CGFloat margin = 8;
    CGFloat x = margin;
    CGFloat w = SCREEN_W - 2*margin;
    CGFloat h = 40;
    LSSyetemNotificationView *view = [[LSSyetemNotificationView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        self.layer.cornerRadius = 4;
        [self configViews];
        [self configConstraints];
        [self addTapGesture];
    }
    return self;
}

- (void)configViews {
    //小喇叭
    self.imgSmallHorn = [[UIImageView alloc] init];
    self.imgSmallHorn.image = [UIImage imageNamed:@"ico_notice_small_horn"];
    [self addSubview:self.imgSmallHorn];
    //通知标题
    self.lblTitle = [[UILabel alloc] init];
    self.lblTitle.textColor = [UIColor whiteColor];
    self.lblTitle.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.lblTitle];
    
    //下一个图标
    self.imgNext = [[UIImageView alloc] init];
    self.imgNext.image = [UIImage imageNamed:@"ico_next_w"];
    [self addSubview:self.imgNext];
    
    //配置新消息标志
    self.imgNewsStatus = [[UIImageView alloc] init];
    self.imgNewsStatus.image = [UIImage imageNamed:@"ico_notice_new"];
    self.imgNewsStatus.hidden = YES;
    [self addSubview:self.imgNewsStatus];

}

- (void)configConstraints {
    //配置小喇叭
    __weak typeof(self) wself = self;
    [self.imgSmallHorn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(10);
        make.centerY.equalTo(wself.centerY);
        make.size.equalTo(CGSizeMake(19, 18));
    }];
    //配置通知标题
    [self.lblTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgSmallHorn.right).offset(5);
        make.right.equalTo(wself.imgNext.left).offset(-10);
        make.height.equalTo(wself.height);
        make.top.equalTo(wself.top);
    }];
    //配置下一个图标
    [self.imgNext makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.right);
        make.centerY.equalTo(wself.centerY);
        make.size.equalTo(CGSizeMake(22, 22));
    }];
    //配置新消息标志
    [self.imgNewsStatus makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(33, 12));
        make.right.equalTo(wself.imgNext.left).offset(5);
        make.centerY.equalTo(wself.centerY).offset(-5);
    }];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapGesture:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(systemNotificationViewDidEndClick:)]) {
        [self.delegate systemNotificationViewDidEndClick:self];
    }
    
}
@end
