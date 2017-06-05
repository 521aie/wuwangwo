//
//  GoodsBrandLibraryManageCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsBrandLibraryManageCell.h"

@implementation GoodsBrandLibraryManageCell


-(IBAction) btnDelClick:(id)sender
{
    [self.delegate delCell:self.index];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
