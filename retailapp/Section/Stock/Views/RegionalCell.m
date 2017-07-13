//
//  RegionalCell.m
//  retailapp
//
//  Created by hm on 15/9/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RegionalCell.h"

@implementation RegionalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    self.lblTip.layer.backgroundColor=[UIColor redColor].CGColor;
    self.lblTip.textColor=[UIColor whiteColor];
    self.lblTip.text=@"未保存";
    self.lblTip.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
