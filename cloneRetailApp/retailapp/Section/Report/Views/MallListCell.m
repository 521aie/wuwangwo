//
//  MemberTransactionListCell.m
//  retailapp
//
//  Created by 果汁 on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MallListCell.h"
#import "MallTransactionListVo.h"
#import "ColorHelper.h"

@implementation MallListCell
- (void)initDataWithMallTransactionListVo:(MallTransactionListVo *)item mallCard:(NSString *)mallCard {
    self.lblName.text = item.name;
    self.lblName.textColor = [ColorHelper getBlackColor];
    self.lblCard.text = mallCard;
    self.lblCard.textColor = [ColorHelper getTipColor6];
    self.lblMobile.text = item.mobile;
    self.lblMobile.textColor = [ColorHelper getTipColor6];
    self.lblAmount.text = [NSString stringWithFormat:@"%.2f",[item.costAmount floatValue]];
    self.lblAmount.textColor = [ColorHelper getBlueColor];
}

@end
