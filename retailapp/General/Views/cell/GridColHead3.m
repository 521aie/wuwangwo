//
//  GridColHead3.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GridColHead3.h"

@implementation GridColHead3


-(IBAction)leftButton:(id)sender
{
    [self changeStatus:LEFT];
    [self.delegate pressLeftButton];
}

-(IBAction)rightButton:(id)sender
{
    [self changeStatus:RIGHT];
    [self.delegate pressRightButton];
}

- (void)changeStatus:(short)type
{
    if (type == LEFT) {
        self.leftImgView.hidden = NO;
        self.rightImgView.hidden = YES;
        [self.btnGoods setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [self.btnStyle setTitleColor:[UIColor darkGrayColor]forState:UIControlStateNormal];
    }else if (type == RIGHT){
        self.leftImgView.hidden = YES;
        self.rightImgView.hidden = NO;
        [self.btnGoods setTitleColor:[UIColor darkGrayColor]forState:UIControlStateNormal];
        [self.btnStyle setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
