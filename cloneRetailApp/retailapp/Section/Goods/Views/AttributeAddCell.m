//
//  AttributeAddCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/12/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AttributeAddCell.h"

@implementation AttributeAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutMargins:UIEdgeInsetsZero];
    self.separatorInset = UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
