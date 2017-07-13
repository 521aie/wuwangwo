//
//  SelectAssignSupplierListView.h
//  retailapp
//
//  Created by hm on 16/1/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "INameCode.h"
typedef void(^SelectAssignSupplierBlock)(NSMutableArray *selList);

@interface SelectAssignSupplierListView : LSRootViewController

- (void)loadDataByOrgId:(NSString *)orgId completed:(SelectAssignSupplierBlock)completedBlock;
@end
