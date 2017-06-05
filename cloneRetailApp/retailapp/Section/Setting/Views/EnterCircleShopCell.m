//
//  EnterCircleShopCell.m
//  retailapp
//
//  Created by qingmei on 15/12/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EnterCircleShopCell.h"
#import "ESPShopVo.h"
#import "ESPSettledMallVo.h"
#import "DateUtils.h"
#import "ColorHelper.h"
@implementation EnterCircleShopCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (id)getInstance{
    EnterCircleShopCell *item = [[[NSBundle mainBundle]loadNibNamed:@"EnterCircleShopCell" owner:self options:nil]lastObject];
    return item;
}

- (void)loadCell:(id)obj{
    if ([obj isKindOfClass:[ESPSettledMallVo class]]) {
        ESPSettledMallVo *tempVo = (ESPSettledMallVo *)obj;
        self.lblName.text = tempVo.shopName;
        if ([NSString isBlank:tempVo.linkman]) {
            tempVo.linkman = @"";
        }
        self.lblLinkMan.text = [NSString stringWithFormat:@"联系人:%@",tempVo.linkman];
        self.lblTel.text = [NSString stringWithFormat:@"联系电话:%@",tempVo.phone1];
        self.lblStartTime.text = [NSString stringWithFormat:@"申请日期:%@",[DateUtils formateTime2:tempVo.agreeTime.longLongValue]];
        self.lblDate.text = [NSString stringWithFormat:@"到期日期:%@",[DateUtils formateTime2:tempVo.endTime.longLongValue]];
        if (tempVo.status.integerValue == 0) {
            self.lblStartTime.hidden = YES;
            self.lblDate.text = [NSString stringWithFormat:@"邀请日期:%@",[DateUtils formateTime2:tempVo.createTime.longLongValue]];
            self.lblState.text = @"邀请中";
            self.lblState.backgroundColor = [ColorHelper getOrangeColor];
        }else if (tempVo.status.integerValue == 1) {
            self.lblState.text = @"申请中";
            self.lblState.backgroundColor = [ColorHelper getOrangeColor];
        }else if (tempVo.status.integerValue == 2){
            self.lblState.text = @"已入驻";
            self.lblState.backgroundColor = [ColorHelper getGreenColor];
        }else if (tempVo.status.integerValue == 3){
            self.lblState.text = @"拒绝";
            self.lblState.backgroundColor = [ColorHelper getRedColor];
        }else if (tempVo.status.integerValue == 4){
            self.lblState.text = @"已解除";
            self.lblState.backgroundColor = [ColorHelper getBlueColor];
        }
        self.lblState.layer.cornerRadius = 5;
        self.lblState.layer.masksToBounds = YES;
        
        if([NSString isNotBlank:tempVo.logofileName]){
            [self.imgHead sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:tempVo.logofileName]] placeholderImage:nil];
        }

    }
}

@end
