//
//  CashRecordCell.m
//  retailapp
//
//  Created by qingmei on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CashRecordCell.h"
#import "DateUtils.h"
#import "ColorHelper.h"
@implementation CashRecordCell

- (void)initWithdrawCheckVo:(WithdrawCheckVo *)withdrawCheckVo {
    self.lblCashTitle.text = [NSString stringWithFormat:@"提现%.2f元",withdrawCheckVo.actionAmount];
    self.lblTime.text = [DateUtils formateTime:1000 *withdrawCheckVo.createTime];
    if (withdrawCheckVo.checkResult == 1) {
        self.lblApplyState.text = @"未审核";
        self.lblApplyState.textColor = [ColorHelper getBlueColor];
    }
    if (withdrawCheckVo.checkResult == 2) {
        self.lblApplyState.text = @"审核不通过";
        self.lblApplyState.textColor = [ColorHelper getRedColor];
    }
    if (withdrawCheckVo.checkResult == 3) {
        self.lblApplyState.text = @"审核通过";
        self.lblApplyState.textColor = [ColorHelper getGreenColor];
    }
    if (withdrawCheckVo.checkResult == 4) {
        self.lblApplyState.text = @"取消";
        self.lblApplyState.textColor = [ColorHelper getRedColor];
    }
    
}

@end
