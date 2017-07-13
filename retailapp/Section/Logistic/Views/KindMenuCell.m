//
//  KindMenuCell.m
//  retailapp
//
//  Created by hm on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindMenuCell.h"
#import "ColorHelper.h"

@implementation KindMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblName.textColor = [ColorHelper getTipColor3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
