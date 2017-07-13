//
//  HomeShowVo.m
//  retailapp
//
//  Created by qingmei on 15/10/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "HomeShowVo.h"
#import "ShowTypeVo.h"

@implementation HomeShowVo

+ (HomeShowVo*)convertToUser:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        HomeShowVo *homeShowVo = [[HomeShowVo alloc]init];
        
        homeShowVo.roleId = [ObjectUtil getStringValue:dic key:@"roleId"];
        homeShowVo.roleName = [ObjectUtil getStringValue:dic key:@"roleName"];
        homeShowVo.roleType = [ObjectUtil getIntegerValue:dic key:@"roleType"];
        
        NSMutableArray *arr = [dic objectForKey:@"showTypeVoList"];
        NSMutableArray *VoList = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            [VoList addObject:[ShowTypeVo convertToUser:dic]];
        }
        homeShowVo.showTypeVoList = VoList;
        
        return homeShowVo;
    }
    return nil;
}

@end
