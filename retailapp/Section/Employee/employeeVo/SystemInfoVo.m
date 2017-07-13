//
//  SystemInfoVo.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SystemInfoVo.h"
#import "ModuleVo.h"

@implementation SystemInfoVo
+ (SystemInfoVo *)convertToUser:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        SystemInfoVo* sysInfo = [[SystemInfoVo alloc] init];
        sysInfo.systemInfoId = [ObjectUtil getIntegerValue:dic key:@"systemInfoId"];
        sysInfo.systemName = [ObjectUtil getStringValue:dic key:@"systemName"];
        sysInfo.systemCode = [ObjectUtil getStringValue:dic key:@"systemCode"];
        sysInfo.systemType = [ObjectUtil getStringValue:dic key:@"systemType"];
        //sysInfo.businessid = [ObjectUtil getIntegerValue:dic key:@"businessid"];
        
        NSArray *arrModules = [dic objectForKey:@"moduleVoList"];
        sysInfo.moduleVoList = [[NSMutableArray alloc]initWithCapacity:arrModules.count];
        for (NSDictionary *dicModule in arrModules) {
            [sysInfo.moduleVoList addObject:[ModuleVo convertToUser:dicModule]];
        }
        
        return sysInfo;
    }
    return nil;
}
@end
