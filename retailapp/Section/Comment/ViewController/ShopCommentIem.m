//
//  ShopCommentIem.m
//  retailapp
//
//  Created by 小龙虾 on 2017/4/19.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopCommentIem.h"

@interface ShopCommentIem ()
//提示文字
@property(nonatomic, strong)UILabel *tipTit;
//评分
@property(nonatomic, strong)UILabel *score;
//存放星级的数组
@property(nonatomic, strong)NSMutableArray *iconAry;
@end
@implementation ShopCommentIem

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconAry = [NSMutableArray array];
        [self createViews];
    }
    return self;
}

-(void)createViews
{
    self.tipTit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 11)];
    [self.tipTit setText:@"服务态度"];
    [self.tipTit setTextAlignment:NSTextAlignmentLeft];
    [self.tipTit setFont:[UIFont systemFontOfSize:10.0]];
    [self addSubview:self.tipTit];
    
    for (int i = 0; i < 5; i++) {
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(58+16*i, 0, 11, 11)];
        [icon setImage:[UIImage imageNamed:@"ico_star_grey.png"]];
        [self.iconAry addObject:icon];
        [self addSubview:icon];
    }
    
    self.score = [[UILabel alloc] initWithFrame:CGRectMake(143, 0, 96, 11)];
    [self.score setText:@"0.0分"];
    [self.score setTextAlignment:NSTextAlignmentLeft];
    [self.score setTextColor:[UIColor orangeColor]];
    [self.score setFont:[UIFont systemFontOfSize:10.0]];
    [self addSubview:self.score];
}

-(void)showTip:(NSString *)tip andScore:(float)score
{
    [self.tipTit setText:tip];
    for (int i = 0; i < self.iconAry.count; i++) {
        UIImageView *icon = [self.iconAry objectAtIndex:i];
        if (score > i) {
            if (score - i >= 1) {
                icon.image = [UIImage imageNamed:@"ico_star_yellow.png"];
            }else{
                icon.image = [UIImage imageNamed:@"ico_star_half.png"];
            }
        }else{
            icon.image = [UIImage imageNamed:@"ico_star_grey.png"];
        }
    }
    NSString *scoreTit = [NSString stringWithFormat:@"%.1f",score];
    [self.score setText: [scoreTit stringByAppendingString:@"分"]];
}

@end
