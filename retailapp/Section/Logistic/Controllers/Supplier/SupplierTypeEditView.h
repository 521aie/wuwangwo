//
//  SupplierTypeEditView.h
//  retailapp
//
//  Created by hm on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

typedef void(^AddTypeHandler)(void);

@class LSEditItemText;
@interface SupplierTypeEditView : LSRootViewController

@property (strong, nonatomic) LSEditItemText *txtName;

- (void)loadDataWithCallBack:(AddTypeHandler)handler;
@end
