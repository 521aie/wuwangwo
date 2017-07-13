//
//  PayBillSummaryOfMonthVO.h
//  RestApp
//
//  Created by 刘红琳 on 15/10/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@class BusinessDayVO;
@interface PayBillSummaryOfMonthVO : Jastor
@property (nonatomic,retain) NSString *date;
@property double totalFee;//微信收款收入
@property double shareIncome;//已到账金额
@property (nonatomic,assign)NSInteger payType;//支付类型
@property (nonatomic,assign)double payTagTotalFee;//充值金额
-(BusinessDayVO *) convertVo;
@end
