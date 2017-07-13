//
//  CustomTypeCell.m
//  RestApp
//
//  Created by zhangzhiliang on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberTypeCell.h"

@implementation MemberTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutMargins:UIEdgeInsetsZero];
    self.separatorInset = UIEdgeInsetsZero;
}

- (void)setCardName:(NSString *)name primedRate:(NSString *)rate {
    
    self.lblMemberTypeName.text = name;
    self.lblMemberTypeDiscount.text = rate;
    self.lblMemberTypeDiscount.textColor = [ColorHelper getBlueColor];
}

@end
