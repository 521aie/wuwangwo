//
//  WeChatAppBottomView.m
//  retailapp
//
//  Created by 小龙虾 on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "WeChatAppBottomView.h"


@interface WeChatAppBottomView ()
//分享方式提示
@property (nonatomic, strong)UILabel *sharelbl;
//提示一
@property (nonatomic, strong)UILabel *tip1;
//提示二
@property (nonatomic, strong)UILabel *tip2;
//提示三
@property (nonatomic, strong)UILabel *tip3;
@end
@implementation WeChatAppBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

-(void)createViews
{
    self.sharelbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, SCREEN_W-20, 20)];
    [self.sharelbl setTextAlignment:NSTextAlignmentLeft];
    [self.sharelbl setTextColor:[UIColor blackColor]];
    [self.sharelbl setText:@"如何分享店铺主页?"];
    [self.sharelbl setFont:[UIFont systemFontOfSize:15.0]];
    [self addSubview:self.sharelbl];
    
    self.tip1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, SCREEN_W-20, 50)];
    [self.tip1 setFont:[UIFont systemFontOfSize:13.0]];
    [self.tip1 setText:@"方式一：发送给微信好友或分享到朋友圈，顾客点击链接即可进入店铺主页。"];
    self.tip1.numberOfLines = 0;
    [self.tip1 setTextAlignment:NSTextAlignmentLeft];
    [self.tip1 setTextColor:[UIColor blackColor]];
    self.tip1.alpha = 0.75;
    [self addSubview:self.tip1];
    
    self.tip2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, SCREEN_W-20, 50)];
    [self.tip2 setFont:[UIFont systemFontOfSize:12.0]];
    [self.tip2 setText:@"方式二：下载二维码，制作海报或名片，顾客可以直接扫描二维码进入店铺主页。"];
    self.tip2.numberOfLines = 0;
    [self.tip2 setTextAlignment:NSTextAlignmentLeft];
    [self.tip2 setTextColor:[UIColor blackColor]];
    self.tip2.alpha = 0.75;
    [self addSubview:self.tip2];
    
    self.tip3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, SCREEN_W-20, 50)];
    [self.tip3 setFont:[UIFont systemFontOfSize:12.0]];
    [self.tip3 setText:@"方式三：复制链接，与二维码一起发布到微信公众号进行宣传。"];
    self.tip3.numberOfLines = 0;
    [self.tip3 setTextAlignment:NSTextAlignmentLeft];
    [self.tip3 setTextColor:[UIColor blackColor]];
    self.tip3.alpha = 0.75;
    [self addSubview:self.tip3];
    
}

@end
