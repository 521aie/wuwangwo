//
//  BusinessDayVO.h
//  retailapp
//
//  Created by hm on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessDayVO : NSObject
/** 日期 */
@property (nonatomic,strong) NSString * incomeDate;
/** 显示名称 */
@property (nonatomic,strong) NSString *showName;
/** 显示值 */
@property (nonatomic,strong) NSNumber *showValue;


//分账那边的参数
/**到账金额. */
@property (nonatomic,assign)double incomeMoney;

/** 总营业额.  */
@property (nonatomic, assign) double totalAmount;
@property (nonatomic,strong) NSString *currDate;
/**充值金额**/
@property double payTagTotalFee;

- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
