//
//  PerformanceGoalDetailView.h
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class UserPerformanceTargetVo;
@interface PerformanceGoalDetailView : LSRootViewController

//页面初始化
- (id)initWithParent:(id)parentTemp;

/*详情页面进入时调用*/
- (void)loadDataWithVo:(UserPerformanceTargetVo *)userPerformanceTargetVo
                shopId:(NSString *)shopID
                 month:(NSDate *)month;
/*添加页面进入时调用*/
- (void)initDataInAddType:(NSArray *)userList
                   shopId:(NSString *)shopID
                    month:(NSDate *)month;
@end
