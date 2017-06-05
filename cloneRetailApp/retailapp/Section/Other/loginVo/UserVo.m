//
//  UserVo.m
//  retailapp
//
//  Created by hm on 15/8/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "UserVo.h"
#import "ObjectUtil.h"
@implementation UserVo

+ (UserVo*)convertToUser:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        UserVo* user = [[UserVo alloc] init];
        user.userId = [ObjectUtil getStringValue:dic key:@"userId"];
        user.roleId = [ObjectUtil getStringValue:dic key:@"roleId"];
        user.userName = [ObjectUtil getStringValue:dic key:@"userName"];
        user.staffId = [ObjectUtil getStringValue:dic key:@"staffId"];
        user.roleName = [ObjectUtil getStringValue:dic key:@"roleName"];
        user.picture = [ObjectUtil getStringValue:dic key:@"picture"];
        user.relevanceEntity = [ObjectUtil getStringValue:dic key:@"relevanceEntity"];
        user.name = [ObjectUtil getStringValue:dic key:@"name"];
        return user;
    }
    return nil;
}

+ (NSMutableArray *)convertToUserList:(NSArray*)arr {
    if ([ObjectUtil isNotEmpty:arr]) {
        NSMutableArray* orgList = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSDictionary* dic in arr) {
            UserVo* user = [UserVo convertToUser:dic];
            if (dic) {
                [orgList addObject:user];
            }
        }
        return orgList;
    }
    return nil;
}

@end
