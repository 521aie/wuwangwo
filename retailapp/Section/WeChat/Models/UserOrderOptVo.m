//
//  UserOrderOptVo.m
//  retailapp
//
//  Created by diwangxie on 16/3/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "UserOrderOptVo.h"

@implementation UserOrderOptVo

+(NSDictionary*)getDictionaryData:(UserOrderOptVo *)userOrderOptVo
{
    if ([ObjectUtil isNotNull:userOrderOptVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"roleId" val:userOrderOptVo.roleId];
        [ObjectUtil setStringValue:data key:@"userId" val:userOrderOptVo.userId];
        [ObjectUtil setStringValue:data key:@"orderId" val:userOrderOptVo.orderId];
        [ObjectUtil setStringValue:data key:@"attributeValGroup" val:userOrderOptVo.code];
        [ObjectUtil setShortValue:data key:@"orderType" val:userOrderOptVo.orderType];

        
        return data;
    }
    
    return nil;
}

@end
