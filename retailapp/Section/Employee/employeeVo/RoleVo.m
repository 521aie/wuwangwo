//
//  RoleVo.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RoleVo.h"
#import "ObjectUtil.h"
@implementation RoleVo

-(NSString*) obtainItemId {
    return self.roleId;
}
-(NSString*) obtainItemName {
    return self.roleName;
}
-(NSString*) obtainItemValue {
    return self.roleId;
}

+ (RoleVo*)convertToUser:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        RoleVo* role = [[RoleVo alloc] init];
        role.roleId = [ObjectUtil getStringValue:dic key:@"roleId"];
        role.roleName = [ObjectUtil getStringValue:dic key:@"roleName"];
        role.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        role.roleType = [ObjectUtil getIntegerValue:dic key:@"roleType"];
        return role;
    }
    return nil;
}


- (NSMutableDictionary *)getDic:(RoleVo *)roleVo{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if ([ObjectUtil isNotNull:roleVo]) {
        
        [dic setValue:[ObjectUtil isNull:roleVo.roleId]?[NSNull null]:roleVo.roleId forKey:@"roleId"];
        [dic setValue:[ObjectUtil isNull:roleVo.roleName]?[NSNull null]:roleVo.roleName forKey:@"roleName"];
        [dic setValue:[NSNumber numberWithInteger:roleVo.lastVer] forKey:@"lastVer"];
        [dic setValue:[NSNumber numberWithInteger:roleVo.roleType] forKey:@"roleType"];
        
    }
    return dic;
}

+ (NSMutableArray*)convertToArr:(NSArray*)array {
    
    if ([ObjectUtil isEmpty:array]) {
        return nil;
    }
    
    NSMutableArray *roleList = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        RoleVo* role = [RoleVo convertToUser:dic];
        if (role) {
            [roleList addObject:role];
        }
    }
    return roleList;
}

@end
