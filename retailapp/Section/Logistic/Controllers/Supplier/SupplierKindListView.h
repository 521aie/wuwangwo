//
//  SupplierKindListView.h
//  retailapp
//
//  Created by hm on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

typedef void(^SupplyTypeHandler)(NSMutableArray *kindList);

@interface SupplierKindListView : LSRootViewController

//设置回调
- (void)loadDataWithCallBack:(SupplyTypeHandler)handler;

@end
