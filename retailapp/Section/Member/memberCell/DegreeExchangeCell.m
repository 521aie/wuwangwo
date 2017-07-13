//
//  DegreeExchangeCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DegreeExchangeCell.h"
#import "TextStepperField.h"
#import "GoodsGiftVo.h"
@implementation DegreeExchangeCell


- (IBAction)didDisplayButton:(id)sender
{
    if (self.checkImg.isHidden) {
        [self.checkImg setHidden:NO];
        [self.uncheckImg setHidden:YES];
        [self.textStepperField setHidden:NO];
        self.textStepperField.lbVal.text = @"1";
        _vo.isCheck = @"1";
        [self.delegate initGoodsNum:1 item:_vo];
    }else if (self.uncheckImg.isHidden){
        [self.uncheckImg setHidden:NO];
        [self.checkImg setHidden:YES];
        [self.textStepperField setHidden:YES];
        _vo.isCheck = @"0";
        [self.delegate initGoodsNum:-self.textStepperField.lbVal.text.intValue item:_vo];
    }
}

-(void) setPointLocation:(int) type
{
    if (type == 102) {
        [self.lblNeedPoint setLs_left:50];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
