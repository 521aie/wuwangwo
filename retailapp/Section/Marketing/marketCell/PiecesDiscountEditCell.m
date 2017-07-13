//
//  PiecesDiscountEditCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PiecesDiscountEditCell.h"

@implementation PiecesDiscountEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)deleteCell:(id)sender
{
    [self.delegate delObjEvent:@"" obj:self.discountGoodsVo];
}

@end
