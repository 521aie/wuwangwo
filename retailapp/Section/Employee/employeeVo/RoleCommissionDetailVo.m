//
//  RoleCommissionDetailVo.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RoleCommissionDetailVo.h"

@implementation RoleCommissionDetailVo
+ (RoleCommissionDetailVo*)convertToUser:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        RoleCommissionDetailVo *roleCommissionDetailVo = [[RoleCommissionDetailVo alloc]init];
        
        roleCommissionDetailVo.Id = [ObjectUtil getStringValue:dic key:@"id"];
        roleCommissionDetailVo.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        roleCommissionDetailVo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
        roleCommissionDetailVo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        roleCommissionDetailVo.goodsType = [ObjectUtil getIntegerValue:dic key:@"goodsType"];
        
        roleCommissionDetailVo.rolecommissionId = [ObjectUtil getStringValue:dic key:@"rolecommissionId"];
        roleCommissionDetailVo.goodsName = [ObjectUtil getStringValue:dic key:@"goodsName"];
        roleCommissionDetailVo.goodsBar = [ObjectUtil getStringValue:dic key:@"goodsBar"];
        roleCommissionDetailVo.commissionRatio = [ObjectUtil getDoubleValue:dic key:@"commissionRatio"];
        roleCommissionDetailVo.operateType = [ObjectUtil getStringValue:dic key:@"operateType"];
        
        return roleCommissionDetailVo;
    }
    return nil;
}

- (NSMutableDictionary *)getDic:(RoleCommissionDetailVo *)roleCommissionDetailVo{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ObjectUtil isNull:roleCommissionDetailVo.Id]?[NSNull null]:roleCommissionDetailVo.Id forKey:@"id"];
    [dic setValue:[ObjectUtil isNull:roleCommissionDetailVo.entityId]?[NSNull null]:roleCommissionDetailVo.entityId forKey:@"entityId"];
    [dic setValue:[ObjectUtil isNull:roleCommissionDetailVo.shopId]?[NSNull null]:roleCommissionDetailVo.shopId forKey:@"shopId"];
    [dic setValue:[ObjectUtil isNull:roleCommissionDetailVo.goodsId]?[NSNull null]:roleCommissionDetailVo.goodsId forKey:@"goodsId"];
    [dic setValue:[NSNumber numberWithInteger:roleCommissionDetailVo.goodsType] forKey:@"goodsType"];
    
    [dic setValue:[ObjectUtil isNull:roleCommissionDetailVo.rolecommissionId]?[NSNull null]:roleCommissionDetailVo.rolecommissionId forKey:@"rolecommissionId"];
    [dic setValue:[ObjectUtil isNull:roleCommissionDetailVo.goodsName]?[NSNull null]:roleCommissionDetailVo.goodsName forKey:@"goodsName"];
    [dic setValue:[ObjectUtil isNull:roleCommissionDetailVo.goodsBar]?[NSNull null]:roleCommissionDetailVo.goodsBar forKey:@"goodsBar"];
    [dic setValue:[NSNumber numberWithDouble:roleCommissionDetailVo.commissionRatio] forKey:@"commissionRatio"];
    [dic setValue:[ObjectUtil isNull:roleCommissionDetailVo.operateType]?[NSNull null]:roleCommissionDetailVo.operateType forKey:@"operateType"];
    
    return dic;
}
@end
