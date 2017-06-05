//
//  GoodsRetailCell.m
//  retailapp
//
//  Created by zhangzhiliang on 16/1/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsRetailCell.h"

@implementation GoodsRetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)visibleArrowImageView:(BOOL)visible {
    if (visible) {
        self.arrowImageView.hidden = NO;
        self.lblPrice.ls_right = self.arrowImageView.ls_left - 3.0;
        self.lblNetAmount.ls_right = self.arrowImageView.ls_left - 3.0;
    } else {
        self.arrowImageView.hidden = YES;
        self.lblPrice.ls_right = 310.0;
        self.lblNetAmount.ls_right = 310.0;
    }
}

@end
