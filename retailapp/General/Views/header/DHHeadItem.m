//
//  CellHeadItem.m
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DHHeadItem.h"

@implementation DHHeadItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWithData:(id<INameValueItem>)itemTemp
{
    self.item = itemTemp;
    [self.panel.layer setMasksToBounds:YES];
    self.panel.layer.cornerRadius = CELL_HEADER_RADIUS;
    self.lblName.text = [itemTemp obtainItemName];
}
- (void)initWithTitle:(NSString *)itemTemp
{
    self.panel.frame = CGRectMake(20, 8, 280, 24);
    [self.panel.layer setMasksToBounds:YES];
    self.panel.layer.cornerRadius = CELL_HEADER_RADIUS;
    self.lblName.frame = self.panel.frame;
    self.lblName.text = itemTemp;
}


@end
