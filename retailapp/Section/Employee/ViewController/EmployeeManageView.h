//
//  EmployeeManageView.h
//  retailapp
//
//  Created by qingmei on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//



#import "LSRootViewController.h"


@interface EmployeeManageView : LSRootViewController

//用到的vo字典
@property (nonatomic,strong)NSMutableArray *sexDicList;     //性别
@property (nonatomic,strong)NSMutableArray *identityDicList;//证件类型
@property (nonatomic,strong)NSMutableArray *roleDicList;    //角色

- (void)loadEmployeeList;
@end
