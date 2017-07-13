//
//  EmployeeService.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EmployeeService.h"
#import "ObjectUtil.h"
#import "JsonHelper.h"
#import "SignUtil.h"

#define ROLEACTION_LIST @"roleAction/list"
#define ROLEACTION_DETAIL @"roleAction/detail"
#define ROLEACTION_SAVE @"roleAction/v1/save"
#define ROLEACTION_INIT @"roleAction/init"
#define ROLEACTION_DELETE @"roleAction/delete"

#define USER_LIST @"user/list"
#define USER_DETAILE @"user/detail"
#define USER_INIT @"user/init"
#define USER_SAVE @"user/save"
#define USER_DELETE @"user/delete"
#define USER_CHANGE_PWD @"user/changePwd"

#define ROLECOMMISSION_SELECT @"roleCommission/list"
#define ROLECOMMISSION_FIND @"roleCommission/find"
#define ROLECOMMISSION_SAVE @"roleCommission/v1/save"

#define PERFORMANCETARGET_SEARCH @"performanceTarget/list"
#define PERFORMANCETARGET_SAVE @"performanceTarget/saveByDate"
#define PERFORMANCETARGET_SAVE_MONTH @"performanceTarget/saveByMonth"
#define PERFORMANCETARGET_DETAIL @"performanceTarget/detail"
#define PERFORMANCETARGET_EXPORT @"performanceTarget/exportExcel"

#define HOMEPAGESET_SEARCH @"homePage/list"
#define HOMEPAGESET_DETAIL @"homePage/detail"
#define HOMEPAGESET_SAVE @"homePage/save"
#define HOMEPAGESET_SORT @"homePage/sort"
#define HOMEPAGESET_INIT @"homePage/init"


@implementation EmployeeService

#pragma mark - 角色权限
//角色一览
- (void)roleListByRoleName:(NSString *)roleName
                  roleType:(NSInteger)roleType
     WithCompletionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,ROLEACTION_LIST];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([NSString isNotBlank:roleName]) {
        [param setValue:roleName forKey:@"roleName"];
    }
    if (0 != roleType) {
        [param setValue:[NSNumber numberWithInteger:roleType] forKey:@"roleType"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//角色权限详情
- (void)detailByRoleId:(NSString*)roleId
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,ROLEACTION_DETAIL];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([ObjectUtil isNotNull:roleId]) {
        [param setValue:roleId forKey:@"roleId"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//角色权限新增修改
- (void)saveRole:(RoleVo *)role
      actionList:(NSArray *)actionList
     operateType:(NSString *)operateType
completionHandler:(HttpResponseBlock) completionBlock
    errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,ROLEACTION_SAVE];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    if ([ObjectUtil isNotNull:role]) {
        
        [param setValue:[role getDic:role] forKey:@"role"];
    }
    if ([ObjectUtil isNotEmpty:actionList]) {
        NSMutableArray *list = [[NSMutableArray alloc]init];
        for (ActionVo *action in actionList) {
            [list addObject:[action getDic:action]];
        }
        [param setValue:list forKey:@"actionList"];
    }
    if ([ObjectUtil isNotNull:operateType]) {
        [param setValue:operateType forKey:@"operateType"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//角色初始化
- (void)roleInitWithCompletionHandler:(HttpResponseBlock) completionBlock
                         errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,ROLEACTION_INIT];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//角色信息删除
- (void)deleteRoleByRoleId:(NSString *)roleId
         completionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,ROLEACTION_DELETE];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([ObjectUtil isNotNull:roleId]) {
        [param setValue:roleId forKey:@"roleId"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

#pragma mark - 员工管理
//选择员工
- (void)selectEmployee:(NSString *)keyWord
                shopId:(NSString *)shopId
                roleId:(NSString *)roleId
           currentPage:(NSInteger )currentPage
              shopType:(NSInteger)shopType
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,USER_LIST];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    if ([ObjectUtil isNotNull:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if ([ObjectUtil isNotNull:roleId]) {
        [param setValue:roleId forKey:@"roleId"];
    }
    if (0 != currentPage) {
        [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    }
    if (0 != shopType) {
        [param setValue:[NSNumber numberWithInteger:shopType] forKey:@"shopType"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//员工详情
- (void)userInfoByUserId:(NSString *)userId
       completionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,USER_DETAILE];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([ObjectUtil isNotNull:userId]) {
        [param setValue:userId forKey:@"userId"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//删除员工
- (void)deleteUserByUserId:(NSString *)userId
         completionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,USER_DELETE];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([ObjectUtil isNotNull:userId]) {
        [param setValue:userId forKey:@"userId"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//重置密码
- (void)changePwd:(NSString* )userId
              pwd:(NSString *)pwd
completionHandler:(HttpResponseBlock) completionBlock
     errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,USER_CHANGE_PWD];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([ObjectUtil isNotNull:userId]) {
        [param setValue:userId forKey:@"userId"];
    }
    if ([ObjectUtil isNotNull:pwd]) {
        [param setValue:[SignUtil convertPassword:pwd] forKey:@"pwd"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//员工添加更新初始化
- (void)employeeInitWithCompletionHandler:(HttpResponseBlock) completionBlock
                             errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,USER_INIT];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//员工新增更新
- (void)saveEmployee:(EmployeeUserVo *)user
         operateType:(NSString *)operateType
            shopType:(NSInteger)shopType
   completionHandler:(HttpResponseBlock) completionBlock
        errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,USER_SAVE];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    if ([ObjectUtil isNotNull:user]) {
        [param setValue:[user getDic:user] forKey:@"user"];
    }
    if ([ObjectUtil isNotNull:operateType]) {
        
        [param setValue:operateType forKey:@"operateType"];
    }
    if (0 != shopType) {
        [param setValue:[NSNumber numberWithInteger:shopType] forKey:@"shopType"];
    }
    [param setValue:@2 forKey:@"interface_version"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//附件上传
- (void)uploadAttachment:(NSString *)entityId
                  userId:(NSString *)userId
              entityCode:(NSString *)entityCode
                    kind:(NSString *)kind
       completionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,USER_LIST];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([ObjectUtil isNotNull:entityId]) {
        [param setValue:entityId forKey:@"entityId"];
    }
    if ([ObjectUtil isNotNull:userId]) {
        
        [param setValue:userId forKey:@"userId"];
    }
    if ([ObjectUtil isNotNull:entityCode]) {
        
        [param setValue:entityCode forKey:@"entityCode"];
    }
    if ([ObjectUtil isNotNull:kind]) {
        
        [param setValue:kind forKey:@"kind"];
    }
    
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//删除附件
- (void)deleteAttachment:(NSString *)entityId
                  userId:(NSString *)userId
            attachmentId:(NSString *)attachmentId
       completionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,USER_LIST];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

#pragma mark - 角色提成设置
//角色提成信息一览
- (void)roleCommissionListByRoleName:(NSString *)roleName
                            roleType:(NSInteger)roleType
                            shopId:(NSString *) shopId
                   completionHandler:(HttpResponseBlock) completionBlock
                        errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,ROLECOMMISSION_SELECT];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if ([ObjectUtil isNotNull:roleName]) {
        [param setValue:roleName forKey:@"roleName"];
    }
    if (0 != roleType) {
        [param setValue:[NSNumber numberWithInteger:roleType] forKey:@"roleType"];
    }
    
    [param setValue:shopId forKey:@"shopId"];

    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//查询单个角色提成信息
- (void)roleCommissionByRoleCommissionId:(NSString *)roleCommissionId
                       completionHandler:(HttpResponseBlock) completionBlock
                            errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,ROLECOMMISSION_FIND];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([ObjectUtil isNotNull:roleCommissionId]) {
        [param setValue:roleCommissionId forKey:@"roleCommissionId"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//角色提成信息操作
- (void)saveRoleCommission:(RoleCommissionVo *)roleCommission
      roleCommissionDetail:(NSArray *)roleCommissionDetailList
         completionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,ROLECOMMISSION_SAVE];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    if ([ObjectUtil isNotNull:roleCommission]) {
        
        NSDictionary *dicCommission = [roleCommission getDic:roleCommission];
        [param setValue:dicCommission forKey:@"roleCommission"];
    }
    if ([ObjectUtil isNotEmpty:roleCommissionDetailList]) {
        NSMutableArray *arrList = [[NSMutableArray alloc]initWithCapacity:roleCommissionDetailList.count];
        for (RoleCommissionDetailVo *detailVo in roleCommissionDetailList) {
            NSDictionary *dicDetail = [detailVo getDic:detailVo];
            [arrList addObject:dicDetail];
        }
        [param setValue:arrList forKey:@"roleCommissionDetail"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
#pragma mark - 业绩目标管理

//业绩目标员工一览
- (void)performanceTargetByShopId:(NSString *)shopId
                        startDate:(NSInteger )startDate
                          endDate:(NSInteger )endDate
                          keyword:(NSString *)keyword
                     lastDateTime:(NSInteger )lastDateTime
                completionHandler:(HttpResponseBlock) completionBlock
                     errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,PERFORMANCETARGET_SEARCH];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if (0 != startDate) {
         [param setValue:[NSNumber numberWithInteger:startDate] forKey:@"startDate"];
    }
    if (0 != endDate) {
         [param setValue:[NSNumber numberWithInteger:endDate] forKey:@"endDate"];
    }
    if ([ObjectUtil isNotNull:keyword]) {
        [param setValue:keyword forKey:@"keyword"];
    }
    if (0 != lastDateTime) {
         [param setValue:[NSNumber numberWithInteger:lastDateTime] forKey:@"lastDateTime"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


//保存业绩目标*按日
- (void)performanceTargetAdd:(NSString *)userId
                      shopId:(NSString *)shopId
      dateAndPerformanceList:(NSArray  *)performanceDetailVoList
                 operateType:(NSString *)operateType
           completionHandler:(HttpResponseBlock) completionBlock
                errorHandler:(HttpErrorBlock) errorBlock{
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,PERFORMANCETARGET_SAVE];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    if ([ObjectUtil isNotNull:userId]) {
        [param setValue:userId forKey:@"userId"];
    }
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if ([ObjectUtil isNotEmpty:performanceDetailVoList]) {
        NSMutableArray *arrList = [[NSMutableArray alloc]initWithCapacity:performanceDetailVoList.count];
        for (PerformanceDetailVo *detailVo in performanceDetailVoList) {
            NSDictionary *dicDetail = [detailVo getDic:detailVo];
            [arrList addObject:dicDetail];
        }
        [param setValue:arrList forKey:@"performanceDetailVoList"];
    }
    if ([ObjectUtil isNotNull:operateType]) {
        [param setValue:operateType forKey:@"operateType"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//保存业绩目标*按月
- (void)performanceTargetAdd:(NSString *)userId
                      shopId:(NSString *)shopId
         performanceDetailVo:(PerformanceDetailVo  *)performanceDetailVo
                 operateType:(NSString *)operateType
           completionHandler:(HttpResponseBlock) completionBlock
                errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,PERFORMANCETARGET_SAVE_MONTH];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    if ([ObjectUtil isNotNull:userId]) {
        [param setValue:userId forKey:@"userId"];
    }
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if ([ObjectUtil isNotNull:performanceDetailVo]) {
        NSDictionary *dic = [performanceDetailVo getDic:performanceDetailVo];
        [param setValue:dic forKey:@"performanceDetailVo"];
    }
    if ([ObjectUtil isNotNull:operateType]) {
        [param setValue:operateType forKey:@"operateType"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//业绩目标详情
- (void)performanceTargetDetail:(NSString *)userId
                         shopId:(NSString *)shopId
                      startDate:(NSInteger )startDate
                        endDate:(NSInteger )endDate
              completionHandler:(HttpResponseBlock) completionBlock
                   errorHandler:(HttpErrorBlock) errorBlock{
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,PERFORMANCETARGET_DETAIL];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    if ([ObjectUtil isNotNull:userId]) {
        [param setValue:userId forKey:@"userId"];
    }
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if (0 != startDate) {
        [param setValue:[NSNumber numberWithInteger:startDate] forKey:@"startDate"];
    }
    if (0 != endDate) {
        [param setValue:[NSNumber numberWithInteger:endDate] forKey:@"endDate"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//业绩目标导出
- (void)exportPerformanceTargetExcel:(NSString *)shopId
                           startDate:(NSInteger )startDate
                             endDate:(NSInteger )endDate
                             keyword:(NSString *)keyword
                        lastDateTime:(NSInteger )lastDateTime
                          userIdList:(NSArray  *)userIdList
                   completionHandler:(HttpResponseBlock) completionBlock
                        errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,PERFORMANCETARGET_EXPORT];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if (0 != startDate) {
        [param setValue:[NSNumber numberWithInteger:startDate] forKey:@"startDate"];
    }
    if (0 != endDate) {
        [param setValue:[NSNumber numberWithInteger:endDate] forKey:@"endDate"];
    }
    if ([ObjectUtil isNotNull:keyword]) {
        [param setValue:keyword forKey:@"keyword"];
    }
    if (0 != lastDateTime) {
        [param setValue:[NSNumber numberWithInteger:lastDateTime] forKey:@"lastDateTime"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}



#pragma mark - 主页显示设置
//主页显示角色一览
- (void)homepageRoleListByRoleName:(NSString *)roleName
                          roleType:(NSInteger)roleType
                 completionHandler:(HttpResponseBlock) completionBlock
                      errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,HOMEPAGESET_SEARCH];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    if ([ObjectUtil isNotNull:roleName]) {
        [param setValue:roleName forKey:@"roleName"];
    }
    if (0 != roleType) {
        [param setValue:[NSNumber numberWithInteger:roleType] forKey:@"roleType"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//主页显示详情
- (void)homepageDetailByRoleId:(NSString *)roleId
                        shopId:(NSString *)shopId
             completionHandler:(HttpResponseBlock) completionBlock
                  errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,HOMEPAGESET_DETAIL];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    if ([ObjectUtil isNotNull:roleId]) {
        [param setValue:roleId forKey:@"roleId"];
    }
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//主页显示保存
- (void)homepageSettingSaveByRoleId:(NSString *)roleId
                             shopId:(NSString *)shopId
                     showTypeVoList:(NSArray *)showTypeVoList
                  completionHandler:(HttpResponseBlock) completionBlock
                       errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,HOMEPAGESET_SAVE];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    if ([ObjectUtil isNotNull:roleId]) {
        [param setValue:roleId forKey:@"roleId"];
    }
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if ([ObjectUtil isNotEmpty:showTypeVoList]) {
        NSMutableArray *arrList = [[NSMutableArray alloc]initWithCapacity:showTypeVoList.count];
        for (ShowTypeVo *tempVo in showTypeVoList) {
            NSDictionary *dicDetail = [tempVo getDic:tempVo];
            [arrList addObject:dicDetail];
        }
        [param setValue:arrList forKey:@"showTypeVoList"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//主页显示或排序设置
- (void)homepageSettingSortByRoleId:(NSString *)roleId
                             shopId:(NSString *)shopId
                     showTypeVoList:(NSArray *)showTypeVoList
                  completionHandler:(HttpResponseBlock) completionBlock
                       errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,HOMEPAGESET_SORT];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    if ([ObjectUtil isNotNull:roleId]) {
        [param setValue:roleId forKey:@"roleId"];
    }
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if ([ObjectUtil isNotEmpty:showTypeVoList]) {
        NSMutableArray *arrList = [[NSMutableArray alloc]initWithCapacity:showTypeVoList.count];
        for (ShowTypeVo *tempVo in showTypeVoList) {
            NSDictionary *dicDetail = [tempVo getDic:tempVo];
            [arrList addObject:dicDetail];
        }
        [param setValue:arrList forKey:@"showTypeVoList"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//主页排序设置初始化
- (void)homepageSettingInitWithCompletionHandler:(HttpResponseBlock) completionBlock
                                    errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,HOMEPAGESET_INIT];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//新加：根据shopID获取上级shopcode
- (void)selectOrgByShopId:(NSString *)shopId
        completionHandler:(HttpResponseBlock) completionBlock
             errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"organization/selectOrgByShopId"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
@end
