//
//  LSEmployeeModuleController.m
//  retailapp
//
//  Created by guozhi on 2016/11/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSEmployeeModuleController.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "ServiceFactory.h"
#import "RolePermissionView.h"
#import "EmployeeManageView.h"
#import "RoleCommissionView.h"
#import "PerformanceGoalView.h"
#import "SystemUtil.h"
#import "XHAnimalUtil.h"
#import "RoleCommissionVo.h"

@interface LSEmployeeModuleController ()
@property (nonatomic, assign) NSInteger roleNumber;//角色的数量
@property (nonatomic, assign) NSInteger roleCommissionNumber;//角色提成的数量
@end

@implementation LSEmployeeModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"员工管理"];
    [self loadNumbers];
    self.datas = [NSMutableArray array];
    [self createItems];
    
}

- (void)createItems {
    [self.datas removeAllObjects];
    LSModuleModel *model = [LSModuleModel moduleModelWithName:@"角色权限" detail:[NSString stringWithFormat:@"已添加%ld个角色",(long)self.roleNumber] path:@"ico_employee_role" code:ACTION_EMPLOYEE_ACTION];
    [self.datas addObject:model];
    model = [LSModuleModel moduleModelWithName:@"员工信息" detail:@"员工基本信息" path:@"ico_employee_UserInfo" code:ACTION_EMPLOYEE_MANAGE];
    [self.datas addObject:model];
    model = [LSModuleModel moduleModelWithName:@"角色提成设置" detail:[NSString stringWithFormat:@"已添加%ld个角色",(long)self.roleCommissionNumber] path:@"ico_employee_roleCommission" code:ACTION_ROLE_COMMISSION_SETTING];
    [self.datas addObject:model];
    model = [LSModuleModel moduleModelWithName:@"导购员业绩目标" detail:@"导购员的业绩目标管理" path:@"ico_employeer_performanceGole" code:ACTION_PERFORMANCE_TARGET];
    [self.datas addObject:model];
    [self.tableView reloadData];
}

#pragma mark - netWork
/**获取角色数量和角色提成数量*/
- (void)loadNumbers{
    self.roleNumber = 0;
    self.roleCommissionNumber = 0;
    
    __weak typeof(self) wself = self;
    
    NSInteger selectRoleType;
    if (3 == [[Platform Instance] getShopMode]) {
        selectRoleType = 0;//连锁机构要同时查询门店和机构
    }else{
        selectRoleType = 1;//连锁门店、单店只需要查询门店
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (0 != selectRoleType) {
        [param setValue:[NSNumber numberWithInteger:selectRoleType] forKey:@"roleType"];
    }
    NSString *url = @"roleAction/list";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        NSArray *arrDicVoList = [json objectForKey:@"roleVoList"];
        if ([ObjectUtil isNotEmpty:arrDicVoList]) {
            wself.roleNumber = arrDicVoList.count;
        }
        [self createItems];
    } errorHandler:^(id json) {
         [AlertBox show:json];
    }];
    NSString *shopId = nil;
    if ([[Platform Instance] getShopMode] == 3) {
        shopId = [[Platform Instance] getkey:ORG_ID];
    } else {
        shopId = [[Platform Instance] getkey:SHOP_ID];
    }
    [param removeAllObjects];
    if (0 != selectRoleType) {
        [param setValue:[NSNumber numberWithInteger:selectRoleType] forKey:@"roleType"];
    }
    [param setValue:shopId forKey:@"shopId"];
    url = @"roleCommission/list";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        NSArray *arr = [json objectForKey:@"roleCommission"];
        if ([ObjectUtil isNotEmpty:arr]) {
//            if (selectRoleType == 0) {
//                for (NSDictionary *dic in arr) {
//                    RoleCommissionVo *roleCommission =  [RoleCommissionVo convertToUser:dic];
//                    if (roleCommission.roleType == 1) {
//                        wself.roleCommissionNumber++;
//                    }
//                }
//            }else
//                wself.roleCommissionNumber = arr.count;
            for (NSDictionary *dic in arr) {
                RoleCommissionVo *roleCommission =  [RoleCommissionVo convertToUser:dic];
                if (roleCommission.roleType == 1) {
                    wself.roleCommissionNumber++;
                }
            }
        }
        [wself createItems];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

//点击单元格调用
- (void)showActionCode:(NSString *)code {
    
    if ([code isEqualToString:ACTION_EMPLOYEE_ACTION]) {
        
        // 角色权限 -> 角色权限
        RolePermissionView *rolePermissionView = [[RolePermissionView alloc] init];
        [self.navigationController pushViewController:rolePermissionView animated:NO];
        
    }else if ([code isEqualToString:ACTION_EMPLOYEE_MANAGE]){
        
        // 员工信息 -> 员工
        EmployeeManageView *employeeManageView = [[EmployeeManageView alloc] init];
        [self.navigationController pushViewController:employeeManageView animated:NO];
        
    }else if ([code isEqualToString:ACTION_ROLE_COMMISSION_SETTING]){
        
        // 角色提成设置 -> 角色提成设置
        RoleCommissionView *roleCommissionView = [[RoleCommissionView alloc] init];
        [self.navigationController pushViewController:roleCommissionView animated:NO];
        
    }else if ([code isEqualToString:ACTION_PERFORMANCE_TARGET]){
        
        // 导购员业绩目标 -> 导购员业绩目标
        PerformanceGoalView *performanceGoalView = [[PerformanceGoalView alloc] init];
        [self.navigationController pushViewController:performanceGoalView animated:NO];
        
    }
    
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}



@end
