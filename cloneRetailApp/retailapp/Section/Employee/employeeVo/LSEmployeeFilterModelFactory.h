//
//  LSEmployeeFilterModelFactory.h
//  retailapp
//
//  Created by taihangju on 2017/2/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDFFilterMoel;
@interface LSEmployeeFilterModelFactory : NSObject


/**
 员工信息管理列表页(EmployeeManageView)筛选数据
 */
+ (NSArray<TDFFilterMoel *> *)employeeListViewFilterModels;
@end
