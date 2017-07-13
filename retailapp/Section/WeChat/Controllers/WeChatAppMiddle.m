//
//  WeChatAppMiddle.m
//  retailapp
//
//  Created by 小龙虾 on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "WeChatAppMiddle.h"
#import "ShareBtn.h"

@interface WeChatAppMiddle ()
@property (nonatomic, strong)NSArray *iconAry;
@property (nonatomic, strong)NSArray *tipAry;
//分享提示
@property (nonatomic, strong)UILabel *shareTip;
//分享下划线
@property (nonatomic, strong)UIView *lineShare;
@end
@implementation WeChatAppMiddle

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconAry = [NSArray arrayWithObjects:@"icon_weixin.png",@"icon_pengyouquan.png",@"download.png",@"link.png", nil];
        self.tipAry = [NSArray arrayWithObjects:@"微信好友",@"微信朋友圈",@"下载二维码",@"链接", nil];
        [self createViews];
        
    }
    return self;
}

-(void)createViews
{
    self.shareTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, SCREEN_W-20, 20)];
    [self.shareTip setText:@"店铺主页分享"];
    [self.shareTip setTextColor:[UIColor blackColor]];
    [self.shareTip setTextAlignment:NSTextAlignmentLeft];
    [self.shareTip setFont:[UIFont systemFontOfSize:17.0]];
    [self addSubview:self.shareTip];
    CGFloat btnW = 70;
    CGFloat margin = 10;
    CGFloat w = (SCREEN_W - margin * 2 - btnW * 4 )/3;
    for (int i = 0; i <4; i++) {
        ShareBtn *btn = [[ShareBtn alloc] initWithFrame:CGRectMake(12+(btnW + w) * i, 36, btnW, 80)];
        [btn upDataImgName:[self.iconAry objectAtIndex:i] andTip:[self.tipAry objectAtIndex:i] andTag:i+2000];
        [self addSubview:btn];
    }
    
    self.lineShare = [[UIView alloc] initWithFrame:CGRectMake(10, 116, SCREEN_W-20, 1)];
    self.lineShare.alpha = 0.1;
    self.lineShare.backgroundColor = [UIColor blackColor];
    [self addSubview:self.lineShare];
    
}

@end
