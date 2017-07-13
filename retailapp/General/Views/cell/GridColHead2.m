//
//  GridColHead2.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GridColHead2.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"

@implementation GridColHead2

-(void) initColHead:(NSString*)col1 col2:(NSString*)col2 col3:(NSString*)col3
{
    self.view.layer.cornerRadius = CELL_HEADER_RADIUS2;
    self.col1=col1;
    self.col2=col2;
    self.col3=col3;
    self.lblName.text=[NSString isBlank:col1]?@"":col1;
    self.lblVal1.text=[NSString isBlank:col2]?@"":col2;
    self.lblVal2.text=[NSString isBlank:col3]?@"":col3;
}

-(void) initColLeft:(int)col1 col2:(int)col2 col3:(int)col3
{
    [self.lblName setLs_left:col1];
    [self.lblVal1 setLs_left:col2];
    [self.lblVal2 setLs_left:col2];
}

@end
