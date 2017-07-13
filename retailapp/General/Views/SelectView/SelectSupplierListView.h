//
//  SelectSupplierListView.h
//  retailapp
//
//  Created by hm on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectSampleListView.h"
#import "INameValue.h"

typedef void(^SelectSupplierHandler)(id<INameValue> supplier);

@interface SelectSupplierListView : SelectSampleListView
//是否显示全部
@property (nonatomic, assign) BOOL isAll;
//是否显示供应商类型选择框
@property (nonatomic, assign) BOOL isCondition;
@property (nonatomic ,strong) NSString *shopId;/* <指定门店，单店，仓库的id*/


/*
 * @supplyFlag 标示供应商类型，"self"标示只显示内部供应商，"third"标示只显示第三方供应商， isAll == YES 标示显示所有供应商
 */
- (void)loadDataBySupplyId:(NSString*)supplierId supplyFlag:(NSString *)supplyFlag handler:(SelectSupplierHandler)handler;
@end
