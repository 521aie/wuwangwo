//
//  ColumnHead.m
//  RestApp
//
//  Created by zxh on 14-7-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ColumnHead.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"

@implementation ColumnHead

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"ColumnHead" owner:self options:nil];
    [self addSubview:self.view];
    self.lblVal.text=@"";
    self.lblName.text=@"";
}

-(void) initColHead:(NSString*)col1 col2:(NSString*)col2
{
    self.col1=col1;
    self.col2=col2;
    self.lblName.text=[NSString isBlank:col1]?@"":col1;
    self.lblVal.text=[NSString isBlank:col2]?@"":col2;
}

-(void) initColLeft:(int)col1 col2:(int)col2
{
    [self.lblName setLs_left:col1];
    [self.lblVal setLs_left:col2];
}

-(void) visibal:(BOOL)visibal
{
    [self setLs_height:visibal?40:0];
    [self setHidden:!visibal];
}

@end
