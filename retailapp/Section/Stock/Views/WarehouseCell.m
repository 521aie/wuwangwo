//
//  WarehouseCell.m
//  retailapp
//
//  Created by hm on 15/12/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WarehouseCell.h"

@implementation WarehouseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
