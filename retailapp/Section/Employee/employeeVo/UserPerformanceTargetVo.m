//
//  UserPerformanceTargetVo.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "UserPerformanceTargetVo.h"

@implementation UserPerformanceTargetVo
+ (UserPerformanceTargetVo*)convertToUser:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        UserPerformanceTargetVo *userPerformanceTargetVo = [[UserPerformanceTargetVo alloc]init];
        
        
        userPerformanceTargetVo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
        userPerformanceTargetVo.userId = [ObjectUtil getStringValue:dic key:@"userId"];
        userPerformanceTargetVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        userPerformanceTargetVo.mobile = [ObjectUtil getStringValue:dic key:@"mobile"];
        userPerformanceTargetVo.staffId = [ObjectUtil getStringValue:dic key:@"staffId"];
        
        userPerformanceTargetVo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        userPerformanceTargetVo.totalTarget = [ObjectUtil getStringValue:dic key:@"totalTarget"];
        userPerformanceTargetVo.sex = [ObjectUtil getIntegerValue:dic key:@"sex"];
    
        return userPerformanceTargetVo;
    }
    return nil;

}
@end
