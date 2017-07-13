//
//  LSModuleInfoController.h
//  retailapp
//
//  Created by guozhi on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class ModuleVo;
@class RoleVo;
@interface LSModuleInfoController : LSRootViewController
/** <#注释#> */
@property (nonatomic, strong) ModuleVo *obj;
@property (nonatomic, assign) BOOL isOrg;
/** 存放系统信息列表*/
@property (nonatomic, strong) NSMutableArray *systemInfoList;
/** 系统id(key)与系统对象的关系map*/
@property (nonatomic, strong) NSMutableDictionary *systemInfoMap;
@property (nonatomic, strong) RoleVo *roleVo;  //保存的RoleVo
@property (nonatomic, assign) NSInteger action;
@end
