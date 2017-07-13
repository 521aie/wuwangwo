//
//  RetailTableCell2.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RetailTableCell2.h"

@implementation RetailTableCell2

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp event:(NSString*)event
{
    self.delegate=temp;
    self.obj=objTemp;
    self.event=event;
    [self loadItem:self.obj];
}

-(void) loadItem:(id<INameValueItem>)item
{
    self.lblName.text= [item obtainItemName];
    self.lblVal.text=[item obtainItemValue];
    //    if (self.itemMode==ITEM_MODE_NO) {
    //        [self showBtn:NO];
    //    } else if (self.itemMode==ITEM_MODE_DEL) {
    //        [self showBtn:YES];
    //        UIImage *delImg=[UIImage imageNamed:@"ico_block.png"];
    //        self.imgAct.image=delImg;
    //    } else if (self.itemMode==ITEM_MODE_EDIT) {
    //        [self showBtn:YES];
    //        UIImage *editImg=[UIImage imageNamed:@"ico_next.png"];
    //        self.imgAct.image=editImg;
    //    }
}

-(void) showBtn:(BOOL)visibal
{
    //    [self.btnAct setHidden:!visibal];
    //    [self.imgAct setHidden:!visibal];
}

-(IBAction)delButton:(id)sender
{
    [self.delegate delObjEvent:@"" obj:self.obj];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
