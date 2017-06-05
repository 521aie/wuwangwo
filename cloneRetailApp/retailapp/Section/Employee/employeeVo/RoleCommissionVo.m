//
//  RoleCommissionVo.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RoleCommissionVo.h"

@implementation RoleCommissionVo

+ (RoleCommissionVo*)convertToUser:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        RoleCommissionVo *roleCommissionVo = [[RoleCommissionVo alloc]init];
        
        roleCommissionVo.Id = [ObjectUtil getStringValue:dic key:@"id"];
        roleCommissionVo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
        roleCommissionVo.roleId = [ObjectUtil getStringValue:dic key:@"roleId"];
        roleCommissionVo.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        roleCommissionVo.roleName = [ObjectUtil getStringValue:dic key:@"roleName"];
        
        roleCommissionVo.roleType = [ObjectUtil getIntegerValue:dic key:@"roleType"];
        roleCommissionVo.isCommission = [ObjectUtil getIntegerValue:dic key:@"isCommission"];
        roleCommissionVo.commissionType = [ObjectUtil getIntegerValue:dic key:@"commissionType"];
        roleCommissionVo.commissionRatio = [ObjectUtil getDoubleValue:dic key:@"commissionRatio"];
        roleCommissionVo.commissionPrice = [ObjectUtil getDoubleValue:dic key:@"commissionPrice"];
        
        roleCommissionVo.operateType = [ObjectUtil getStringValue:dic key:@"operateType"];
        roleCommissionVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        
        return roleCommissionVo;
    }
    return nil;
}

- (NSMutableDictionary *)getDic:(RoleCommissionVo *)roleCommissionVo{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ObjectUtil isNull:roleCommissionVo.Id]?[NSNull null]:roleCommissionVo.Id forKey:@"id"];
    [dic setValue:[ObjectUtil isNull:roleCommissionVo.shopId]?[NSNull null]:roleCommissionVo.shopId forKey:@"shopId"];
    [dic setValue:[ObjectUtil isNull:roleCommissionVo.roleId]?[NSNull null]:roleCommissionVo.roleId forKey:@"roleId"];
    [dic setValue:[ObjectUtil isNull:roleCommissionVo.entityId]?[NSNull null]:roleCommissionVo.entityId forKey:@"entityId"];
    [dic setValue:[ObjectUtil isNull:roleCommissionVo.roleName]?[NSNull null]:roleCommissionVo.roleName forKey:@"roleName"];
    
    
    [dic setValue:[NSNumber numberWithInteger:roleCommissionVo.roleType] forKey:@"roleType"];
    [dic setValue:[NSNumber numberWithInteger:roleCommissionVo.isCommission] forKey:@"isCommission"];
    [dic setValue:[NSNumber numberWithInteger:roleCommissionVo.commissionType] forKey:@"commissionType"];
    [dic setValue:[NSNumber numberWithDouble:roleCommissionVo.commissionRatio] forKey:@"commissionRatio"];
    [dic setValue:[NSNumber numberWithDouble:roleCommissionVo.commissionPrice] forKey:@"commissionPrice"];
    
    [dic setValue:[ObjectUtil isNull:roleCommissionVo.operateType]?[NSNull null]:roleCommissionVo.operateType forKey:@"operateType"];
    [dic setValue:[NSNumber numberWithInteger:roleCommissionVo.lastVer] forKey:@"lastVer"];
    
    return dic;
}

- (RoleCommissionVo *)copy{
    RoleCommissionVo *copyVo = [[RoleCommissionVo alloc]init];
    
    
    
    if ([ObjectUtil isNull:self.Id]) {
        copyVo.Id = nil;
    }else{
        copyVo.Id = [NSString stringWithString:self.Id];
    }
    
    if ([ObjectUtil isNull:self.shopId]) {
        copyVo.shopId = nil;
    }else{
        copyVo.shopId = [NSString stringWithString:self.shopId];
    }
    
    if ([ObjectUtil isNull:self.roleId]) {
        copyVo.roleId = nil;
    }else{
        copyVo.roleId = [NSString stringWithString:self.roleId];
    }
    
    if ([ObjectUtil isNull:self.entityId]) {
        copyVo.entityId = nil;
    }else{
        copyVo.entityId = [NSString stringWithString:self.entityId];
    }
    
    if ([ObjectUtil isNull:self.roleName]) {
        copyVo.roleName = nil;
    }else{
        copyVo.roleName = [NSString stringWithString:self.roleName];
    }
    
    
    copyVo.roleType = self.roleType;
    copyVo.isCommission = self.isCommission;
    copyVo.commissionType = self.commissionType;
    copyVo.commissionRatio = self.commissionRatio;
    copyVo.commissionPrice = self.commissionPrice;
    
    if ([ObjectUtil isNull:self.operateType]) {
        copyVo.operateType = nil;
    }else{
        copyVo.operateType = [NSString stringWithString:self.operateType];
    }
    copyVo.lastVer = self.lastVer;
    
    return copyVo;
}

@end
