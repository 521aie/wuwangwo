//
//  GridColHead5.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GridColHead5.h"
#import "ColorHelper.h"

@implementation GridColHead5

-(void) initColHead:(NSString*)val
{
    self.lblVal.text = val;
    self.lblTip.backgroundColor = [ColorHelper getRedColor];
    self.lblTip.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
