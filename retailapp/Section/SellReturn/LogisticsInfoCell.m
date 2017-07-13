//
//  LogisticsInfoCell.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LogisticsInfoCell.h"

@implementation LogisticsInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tvMessage.font = [UIFont systemFontOfSize:11];
    self.tvMessage.textColor = RGB(102, 102, 102);
}

@end
