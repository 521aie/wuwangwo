//
//  GoodsSalePackManageEditCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsSalePackManageEditCell.h"

@implementation GoodsSalePackManageEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)delCell:(id)sender
{
    [self.delegate delCell:self.goodsStyleVo];
}

@end
