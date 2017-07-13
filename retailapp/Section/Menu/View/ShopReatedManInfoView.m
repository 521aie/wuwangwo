//
//  ShopReatedManInfoView.m
//  retailapp
//
//  Created by taihangju on 16/6/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopReatedManInfoView.h"

@interface ShopReatedManInfoView()
@property (nonatomic, copy) void(^callBack)();  /*<<#说明#>>*/
@end

@implementation ShopReatedManInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (ShopReatedManInfoView *)userInfoView:(CGFloat)topY user:(NSString *)userName
{
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - 16;
    ShopReatedManInfoView *userView = [[ShopReatedManInfoView alloc] initWithFrame:CGRectMake(8, topY, width, 36)];
    
    UIImageView *avatarImgv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 22, 22)];
    avatarImgv.image = [UIImage imageNamed:@"ico_user"];
    [userView addSubview:avatarImgv];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImgv.frame)+2, 7, 100, 22)];
    nameLabel.text = userName.length?userName:@"管理员";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:13.0];
    [userView addSubview:nameLabel];
    
    //获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 EEEE"];
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+20, 7, width-(CGRectGetMaxX(nameLabel.frame)+20), 22)];
    dateLabel.font = [UIFont systemFontOfSize:10.0];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.text = [NSString stringWithFormat:@"今天是%@", currentTime];
    [userView addSubview:dateLabel];
    
    return userView;
}


+ (ShopReatedManInfoView *)shopSaleInfoView:(CGFloat)topY backBlock:(void(^)())shopSalePerfomance
{
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - 16;
    ShopReatedManInfoView *shopSaleView = [[ShopReatedManInfoView alloc] initWithFrame:CGRectMake(8, topY, width, 36)];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 260, 22)];
    textLabel.font = [UIFont systemFontOfSize:14.0];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.text = @"导购员个人营业信息汇总";
    [shopSaleView addSubview:textLabel];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(width - 22, 7, 22, 22)];
    arrow.image = [UIImage imageNamed:@"ico_next_w"];
    [shopSaleView addSubview:arrow];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = shopSaleView.bounds;
    [button addTarget:shopSaleView action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [shopSaleView addSubview:button];
    
    shopSaleView.layer.masksToBounds = YES;
    shopSaleView.layer.cornerRadius = 4.0;
    shopSaleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    shopSaleView.callBack = shopSalePerfomance;
    return shopSaleView;
}


- (void)buttonAction
{
    if (self.callBack) {
        self.callBack();
    }
}

@end
