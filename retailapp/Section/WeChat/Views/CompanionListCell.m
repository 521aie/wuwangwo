//
//  CompanionListCell.m
//  retailapp
//
//  Created by yumingdong on 15/12/27.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CompanionListCell.h"
#import "DateUtils.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"

@implementation CompanionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lblType.layer.borderColor = RGB(204, 0, 0).CGColor;
    self.lblType.layer.borderWidth = 1.0;
    self.lblType.layer.cornerRadius = 4.0;
    
    CGFloat _w = 0;
    if ([self.lblName.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        
        CGRect rect = [self.lblName.text boundingRectWithSize:CGSizeMake(320, 22) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.lblName.font} context:nil];
        _w = rect.size.width;
    } else {
        CGSize size = [NSString getTextSizeWithText:self.lblName.text font:self.lblName.font maxSize:CGSizeMake(320, 22)];
        _w = size.width;
    }
    CGRect rect = self.lblName.frame;
    rect.size.width = MIN(_w + 10, 320-125);
    self.lblName.frame = rect;
    
    rect = self.lblType.frame;
    rect.origin.x = self.lblName.frame.origin.x + self.lblName.frame.size.width;
    self.lblType.frame = rect;
}


//- (void)initData:(Companion *)companion {
//    if (companion) {
//        self.lblName.text = companion.name;
//        self.lblType.text = companion.companionType == 1?@"大伙伴":@"小伙伴";
//        if (companion.activeStatus == 1) {
//            self.lblStatus.text = @"激活";
//            self.lblStatus.textColor = RGB(0, 170, 34);
//        } else {
//            self.lblStatus.text = @"冻结";
//            self.lblStatus.textColor = RGB(204, 0, 0);
//        }
//        self.lblMobile.text = companion.mobile;
//        self.lblTime.text = companion.registerDate;
//    }
//}

- (void)initWithdrawData:(WithdrawCheckVo *)withdrawCheckVo {
    if(withdrawCheckVo.userName.length>4){
        self.lblName.text = [NSString text:withdrawCheckVo.userName subToIndex:8];
    }else{
        self.lblName.text = withdrawCheckVo.userName;
    }
    
    if (withdrawCheckVo.proposerType == 1 || withdrawCheckVo.proposerType == 12) {
        self.lblType.text = @"门店";
    }
//    else if (withdrawCheckVo.proposerType == 2 || withdrawCheckVo.proposerType == 21) {
//        if (withdrawCheckVo.parentId == 0){
//            self.lblType.text = @"大伙伴";
//        }else{
//            self.lblType.text = @"小伙伴";
//        }
//    }
    else if (withdrawCheckVo.proposerType == 3) {
        self.lblType.text = @"机构";
    } else {
        self.lblType.text = @"";
    }
    
    //1：未审核，2：审核不通过，3：审核通过
    if (withdrawCheckVo.checkResult == 1) {
        self.lblStatus.text = @"未审核";
        self.lblStatus.textColor = RGB(0, 136, 204);
    } else if (withdrawCheckVo.checkResult == 2) {
        self.lblStatus.text = @"审核不通过";
        self.lblStatus.textColor = RGB(204, 0, 0);
    } else if (withdrawCheckVo.checkResult == 3) {
        self.lblStatus.text = @"审核通过";
        self.lblStatus.textColor = RGB(0, 170, 34);
    } else {
        self.lblStatus.text = @"取消";
        self.lblStatus.textColor = [ColorHelper getRedColor];
    }
    self.lblMobile.text = withdrawCheckVo.mobile;
    self.lblTime.text = [DateUtils formateTime1:withdrawCheckVo.createTime];
}

@end
