//
//  ShareBtn.m
//  retailapp
//
//  Created by 小龙虾 on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShareBtn.h"

@interface ShareBtn ()
@property(nonatomic, strong)UIImageView *icon;
@property(nonatomic, strong)UILabel *tip;
@property(nonatomic, strong)UIButton *btnClick;
@end
@implementation ShareBtn

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
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 54, 54)];
    [self addSubview:self.icon];
    
    self.tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, self.frame.size.width, 21)];
    [self.tip setTextAlignment:NSTextAlignmentCenter];
    [self.tip setFont:[UIFont systemFontOfSize:12.0]];
    self.tip.alpha = 0.75;
    [self addSubview:self.tip];
    
    self.btnClick = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.btnClick addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnClick];
    
}

-(void)upDataImgName:(NSString *)name andTip:(NSString *)tip andTag:(NSInteger)tag
{
    [self.icon setImage:[UIImage imageNamed:name]];
    [self.tip setText:tip];
    [self.btnClick setTag:tag];
}

-(void)clickBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shareType" object:sender];
}


@end
