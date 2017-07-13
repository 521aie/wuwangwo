//
//  MultiHeadCell.m
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MultiHeadCell.h"
#import "MultiCheckHandle.h"

@implementation MultiHeadCell

- (void)loadData:(id<INameValueItem>)item delegate:(id<HeadCheckHandle>)delegate
{
    self.delegate=delegate;
    self.item=item;
    self.panel.layer.cornerRadius = CELL_HEADER_RADIUS;
    self.lblName.text=[item obtainItemName];
    
    [self checked:self.checkFlag];
}

- (void)checked:(BOOL)check
{
    self.checkFlag=check;
    [self.imgUnCheck setHidden:self.checkFlag];
    [self.imgCheck setHidden:!self.checkFlag];
}

- (IBAction)btnCheckClick:(id)sender
{
    BOOL result=!self.checkFlag;    
    [self checked:result];
    if (self.delegate) {
        [self.delegate checkHead:result head:self.item];
    }
}

@end
