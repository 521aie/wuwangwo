//
//  CellHeadItem.m
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DHHeadItem1.h"
#import "UIView+Sizes.h"

@implementation DHHeadItem1

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
    [self.lblVal2 setLs_left:col3];
}




@end
