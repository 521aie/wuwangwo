//
//  DateAndPerformanceVo.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateAndPerformanceVo : NSObject
/**每月业绩目标开始日期*/
@property (nonatomic, assign) NSInteger startDate;
/**每月业绩目标结束日期*/
@property (nonatomic, assign) NSInteger endDate;
/**日业绩目标*/
@property (nonatomic, strong) NSString *saleTargetDay;
@end
