//
//  BalanceLogCell.m
//  retailapp
//
//  Created by qingmei on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "BalanceLogCell.h"
#import "DateUtils.h"
#import "ColorHelper.h"

@implementation BalanceLogCell
- (void)initWithBalanceLogVo:(BalanceLogVo *)balanceLogVo {
    self.labTitle.text = balanceLogVo.opName;
    self.labTime.text = balanceLogVo.opTime;
    if (balanceLogVo.action == 1) {
        if (balanceLogVo.fee<0) {
            self.labFee.text = [NSString stringWithFormat:@"%.2f",balanceLogVo.fee];
            self.labFee.textColor = [ColorHelper getGreenColor];
        }else{
            self.labFee.text = [NSString stringWithFormat:@"+%.2f",balanceLogVo.fee];
            self.labFee.textColor = [ColorHelper getRedColor];
        }
        
    }
    if (balanceLogVo.action == 2) {
        self.labFee.text = [NSString stringWithFormat:@"%.2f",balanceLogVo.fee];
        self.labFee.textColor = [ColorHelper getGreenColor];
    }
}
@end
