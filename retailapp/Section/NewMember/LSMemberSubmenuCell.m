//
//  LSMemberSubmenuCell.m
//  retailapp
//
//  Created by taihangju on 16/9/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberSubmenuCell.h"

@implementation LSMemberSubmenuCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGFloat height = frame.size.height;
        CGFloat width = frame.size.width;
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 19.0, width, 19.0)];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor = [UIColor whiteColor];
        self.title.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:self.title];
        
        CGFloat sideLong = MIN(width-8.0, height-6.0-19.0);
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((width-sideLong)/2, 4.0, sideLong, sideLong)];
        self.iconImageView.layer.cornerRadius = sideLong/2;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.image = [UIImage imageNamed:@"ico_nav_xitongcanshu"];
        [self.contentView addSubview:self.iconImageView];
        
        self.lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) - 8.0, 6.0, 18.0, 18.0)];
        self.lockImageView.image = [UIImage imageNamed:@"ico_pw_w"];
        [self.contentView addSubview:self.lockImageView];
        self.lockImageView.hidden = YES;
        
    }
    
    return self;
}

- (void)fill:(NSString *)image title:(NSString *)title action:(NSString *)actionCode {
    
    self.title.text = title;
    self.iconImageView.image = [UIImage imageNamed:image];
    if ([[Platform Instance] lockAct:actionCode]) {
        self.lockImageView.hidden = NO;
    }
    else {
        self.lockImageView.hidden = YES;
    }
}

@end
