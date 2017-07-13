//
//  BusinessSummaryVO.h
//  RestApp
//
//  Created by zxh on 14-8-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface BusinessSummaryVO : Jastor

/** 总营业额.  */
@property double totalAmount;
/** 总人数. */
@property int totalNum;
/** 人均消费. */
@property double aveConsume;
/** 账单数(单). */
@property int billingNum;
/** 折扣金额. */
@property double discountAmount;
/** 损益金额. */
@property double profitAmount;
/** 服务费受益. */
@property double serviceAmount;
/** 翻桌率. */
@property double orderDeskRate;
/**到账金额. */
@property double incomeMoney;
/**应收. */
@property double sourceFee;

@end
