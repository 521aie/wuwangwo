//
//  StyleAreaCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StyleAreaCell.h"

@implementation StyleAreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)deleteStyle:(id)sender
{
    [self.delegate delObjEvent:@"" obj:self.saleStyleVo];
}

@end
