//
//  GridColHead.m
//  RestApp
//
//  Created by zxh on 14-7-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "GridColHead.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"

@implementation GridColHead
+ (instancetype)gridColHead {
    GridColHead *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    return view;
}
- (void)initColHead:(NSString *)col1 col2:(NSString *)col2
{
    self.view.layer.cornerRadius = CELL_HEADER_RADIUS2;
    self.col1=col1;
    self.col2=col2;
    self.lblName.text=[NSString isBlank:col1]?@"":col1;
    self.lblVal.text=[NSString isBlank:col2]?@"":col2;
}

- (void)initColLeft:(int)col1 col2:(int)col2
{
    [self.lblName setLs_left:col1];
    [self.lblVal setLs_left:col2];
}
@end
