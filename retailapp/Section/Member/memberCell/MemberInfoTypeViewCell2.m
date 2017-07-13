//
//  MemberInfoTypeViewCell2.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberInfoTypeViewCell2.h"
#import "CustomerCardVo.h"

@implementation MemberInfoTypeViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillMemberInfo:(CustomerCardVo *)item {
    
    self.lblCustomerName.text = item.customerName;
    self.lblMobile.text = [NSString stringWithFormat:@"手机:%@", item.mobile];
    self.lblMemberType.text = item.kindCardName;
    if ([item.cardStatus isEqualToString:@"2"]) {
        self.btnStatus.hidden = NO;
        [self.btnStatus setTitle:@"挂失" forState:UIControlStateNormal];
    }else if ([item.cardStatus isEqualToString:@"3"]) {
        self.btnStatus.hidden = NO;
        [self.btnStatus setTitle:@"注销" forState:UIControlStateNormal];
    }else if ([item.cardStatus isEqualToString:@"4"]) {
        self.btnStatus.hidden = NO;
        [self.btnStatus setTitle:@"异常" forState:UIControlStateNormal];
    }else{
        self.btnStatus.hidden = YES;
    }
    
    //暂无图片
    UIImage *placeholder = nil;
    if (item.sex.integerValue == 2) {
        [self.imgMember setImage:[UIImage imageNamed:@"img_employee_cellbg_female.png"]];
        placeholder = [UIImage imageNamed:@"img_employee_cellbg_female.png"];
    } else {
        [self.imgMember setImage:[UIImage imageNamed:@"img_employee_cellbg_male.png"]];
        placeholder = [UIImage imageNamed:@"img_employee_cellbg_male.png"];
    }
    
    //        [detailItem.imgMember.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
    self.imgMember.layer.masksToBounds = YES;
    self.imgMember.layer.cornerRadius = 4.0;
    
    if (item.picture != nil && ![item.picture isEqualToString:@""]) {
        
        NSURL *url = [NSURL URLWithString:[NSString urlFilterRan:item.picture]];
        [self.imgMember sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed|SDWebImageRefreshCached];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
