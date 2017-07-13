//
//  GridCell.m
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GridCell.h"

@implementation GridCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)delBtnClick:(id)sender {

    if (self.delegate&&[self.delegate respondsToSelector:@selector(deleteGridCell:)]) {
        [self.delegate deleteGridCell:self];
    }
}

@end
