//
//  ModuleVo.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModuleVo : NSObject

/**模块ID*/
@property (nonatomic, assign) NSInteger moduleId;               //模块ID
/**模块名*/
@property (nonatomic, strong) NSString *moduleName;             //模块名
/**模块CODE*/
@property (nonatomic, strong) NSString *moduleCode;             //模块CODE
/**该模块下的权限数*/
@property (nonatomic, assign) NSInteger count;                  //该模块下的权限数
/**该模块下的权限名称*/
@property (nonatomic, strong) NSString *actionNameOfModule;     //该模块下的权限名称
/**该模块下权限列表*/
@property (nonatomic, strong) NSMutableArray *actionList;       //该模块下权限列表

/**模块下权限是否发生变化*/
@property (nonatomic, assign) BOOL isActionChange;

+ (ModuleVo *)convertToUser:(NSDictionary*)dic;
- (id)copy;

@end
