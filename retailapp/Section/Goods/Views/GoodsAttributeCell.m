//
//  GoodsAttributeCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsAttributeCell.h"

@implementation GoodsAttributeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)delClick:(id)sender
{
    [self.delegate delObjEvent:self.event obj:self.attributeValVo];
}

@end
