//
//  PayBillSummaryOfMonthVO.m
//  RestApp
//
//  Created by 刘红琳 on 15/10/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PayBillSummaryOfMonthVO.h"
#import "BusinessDayVO.h"

@implementation PayBillSummaryOfMonthVO
-(BusinessDayVO*) convertVo
{
    BusinessDayVO* vo=[BusinessDayVO new];
    vo.currDate=self.date;
    vo.totalAmount=self.totalFee;
    vo.incomeMoney=self.shareIncome;
    vo.payTagTotalFee = self.payTagTotalFee;
    return vo;
}

@end
