//
//  SummaryItem.m
//  retailapp
//
//  Created by hm on 15/9/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SummaryItem.h"

@implementation SummaryItem
+ (SummaryItem*)loadFromNib
{
    SummaryItem* item = [[[NSBundle mainBundle] loadNibNamed:@"SummaryItem" owner:nil options:nil] lastObject];
    return item;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)initWithName:(NSString*)name withVal:(NSString*)value withColor:(UIColor*)color
{
    self.lblName.text = name;
    self.lblVal.text = value;
    self.lblVal.textColor = color;
    self.lblName.textColor = color;
}

@end
