//
//  RolePermission.h
//  retailapp
//
//  角色一览
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface RolePermissionView : LSRootViewController

/**门店/机构的dicVoList*/
@property (nonatomic, strong) NSMutableArray *roleTypeDicVoList;

- (void)loadData;
@end
