//
//  EmployeeService.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpEngine.h"

#import "RoleVo.h"
#import "ActionVo.h"
#import "EmployeeUserVo.h"
#import "RoleCommissionVo.h"
#import "RoleCommissionDetailVo.h"
#import "ShowTypeVo.h"
#import "PerformanceDetailVo.h"


@interface EmployeeService : NSObject
#pragma mark - 角色权限
//角色一览
- (void)roleListByRoleName:(NSString *)roleName
                  roleType:(NSInteger)roleType
     WithCompletionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock;
//角色权限详情
- (void)detailByRoleId:(NSString *)roleId
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock;

//角色权限新增修改
- (void)saveRole:(RoleVo *)role
      actionList:(NSArray *)actionList
     operateType:(NSString *)operateType
completionHandler:(HttpResponseBlock) completionBlock
    errorHandler:(HttpErrorBlock) errorBlock;

//角色初始化
- (void)roleInitWithCompletionHandler:(HttpResponseBlock) completionBlock
                         errorHandler:(HttpErrorBlock) errorBlock;

//角色信息删除
- (void)deleteRoleByRoleId:(NSString *)roleId
         completionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock;

#pragma mark - 员工管理
//选择员工
- (void)selectEmployee:(NSString *)keyWord
                shopId:(NSString *)shopId
                roleId:(NSString *)roleId
           currentPage:(NSInteger )currentPage
              shopType:(NSInteger )shopType
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock;

//员工详情
- (void)userInfoByUserId:(NSString *)userId
       completionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock;
//删除员工
- (void)deleteUserByUserId:(NSString *)userId
         completionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock;
//重置密码
- (void)changePwd:(NSString* )userId
              pwd:(NSString *)pwd
completionHandler:(HttpResponseBlock) completionBlock
     errorHandler:(HttpErrorBlock) errorBlock;

//员工添加更新初始化
- (void)employeeInitWithCompletionHandler:(HttpResponseBlock) completionBlock
                             errorHandler:(HttpErrorBlock) errorBlock;

//员工新增更新
- (void)saveEmployee:(EmployeeUserVo *)role
         operateType:(NSString *)operateType
            shopType:(NSInteger)shopType
   completionHandler:(HttpResponseBlock) completionBlock
        errorHandler:(HttpErrorBlock) errorBlock;

//附件上传
- (void)uploadAttachment:(NSString *)entityId
                  userId:(NSString *)userId
              entityCode:(NSString *)entityCode
                    kind:(NSString *)kind
       completionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock;
//删除附件
- (void)deleteAttachment:(NSString *)entityId
                  userId:(NSString *)userId
            attachmentId:(NSString *)attachmentId
       completionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock;

#pragma mark - 角色提成设置
//角色提成信息一览
- (void)roleCommissionListByRoleName:(NSString *)roleName
                            roleType:(NSInteger)roleType
                              shopId:(NSString *) shopId
                   completionHandler:(HttpResponseBlock) completionBlock
                        errorHandler:(HttpErrorBlock) errorBlock;

//查询单个角色提成信息
- (void)roleCommissionByRoleCommissionId:(NSString *)roleCommissionId
                       completionHandler:(HttpResponseBlock) completionBlock
                            errorHandler:(HttpErrorBlock) errorBlock;

//角色提成信息操作
- (void)saveRoleCommission:(RoleCommissionVo *)roleCommission
      roleCommissionDetail:(NSArray *)roleCommissionDetailList
         completionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock;

#pragma mark - 业绩目标管理
//业绩目标员工一览
- (void)performanceTargetByShopId:(NSString *)shopId
                        startDate:(NSInteger )startDate
                          endDate:(NSInteger )endDate
                          keyword:(NSString *)keyword
                     lastDateTime:(NSInteger )lastDateTime
                completionHandler:(HttpResponseBlock) completionBlock
                     errorHandler:(HttpErrorBlock) errorBlock;


//保存业绩目标*按日
- (void)performanceTargetAdd:(NSString *)userId
                      shopId:(NSString *)shopId
      dateAndPerformanceList:(NSArray  *)performanceDetailVoList
                 operateType:(NSString *)operateType
           completionHandler:(HttpResponseBlock) completionBlock
                errorHandler:(HttpErrorBlock) errorBlock;
//保存业绩目标*按月
- (void)performanceTargetAdd:(NSString *)userId
                      shopId:(NSString *)shopId
         performanceDetailVo:(PerformanceDetailVo  *)performanceDetailVo
                 operateType:(NSString *)operateType
           completionHandler:(HttpResponseBlock) completionBlock
                errorHandler:(HttpErrorBlock) errorBlock;

//业绩目标详情
- (void)performanceTargetDetail:(NSString *)userId
                         shopId:(NSString *)shopId
                      startDate:(NSInteger )startDate
                        endDate:(NSInteger )endDate
              completionHandler:(HttpResponseBlock) completionBlock
                   errorHandler:(HttpErrorBlock) errorBlock;

//业绩目标导出
- (void)exportPerformanceTargetExcel:(NSString *)shopId
                           startDate:(NSInteger )startDate
                             endDate:(NSInteger )endDate
                             keyword:(NSString *)keyword
                        lastDateTime:(NSInteger )lastDateTime
                          userIdList:(NSArray  *)userIdList
                   completionHandler:(HttpResponseBlock) completionBlock
                        errorHandler:(HttpErrorBlock) errorBlock;

#pragma mark - 主页显示设置
//主页显示角色一览
- (void)homepageRoleListByRoleName:(NSString *)roleName
                          roleType:(NSInteger)roleType
                 completionHandler:(HttpResponseBlock) completionBlock
                      errorHandler:(HttpErrorBlock) errorBlock;

//主页显示详情
- (void)homepageDetailByRoleId:(NSString *)roleId
                        shopId:(NSString *)shopId
             completionHandler:(HttpResponseBlock) completionBlock
                  errorHandler:(HttpErrorBlock) errorBlock;

//主页显示保存
- (void)homepageSettingSaveByRoleId:(NSString *)roleId
                             shopId:(NSString *)shopId
                     showTypeVoList:(NSArray *)showTypeVoList
                  completionHandler:(HttpResponseBlock) completionBlock
                       errorHandler:(HttpErrorBlock) errorBlock;

//主页显示或排序设置
- (void)homepageSettingSortByRoleId:(NSString *)roleId
                             shopId:(NSString *)shopId
                     showTypeVoList:(NSArray *)showTypeVoList
                  completionHandler:(HttpResponseBlock) completionBlock
                       errorHandler:(HttpErrorBlock) errorBlock;
//主页排序设置初始化
- (void)homepageSettingInitWithCompletionHandler:(HttpResponseBlock) completionBlock
                                    errorHandler:(HttpErrorBlock) errorBlock;

//新加：根据shopID获取上级shopcode
- (void)selectOrgByShopId:(NSString *)shopId
        completionHandler:(HttpResponseBlock) completionBlock
             errorHandler:(HttpErrorBlock) errorBlock;
@end
