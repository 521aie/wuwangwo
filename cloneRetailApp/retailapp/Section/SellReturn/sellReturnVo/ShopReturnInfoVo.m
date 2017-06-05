//
//  ShopReturnInfoVo.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopReturnInfoVo.h"

@implementation ShopReturnInfoVo

+ (ShopReturnInfoVo*)converToVo:(NSDictionary*)dic
{
    ShopReturnInfoVo* shopReturnInfoVo = [[ShopReturnInfoVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        
        shopReturnInfoVo.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        shopReturnInfoVo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
        shopReturnInfoVo.linkMan = [ObjectUtil getStringValue:dic key:@"linkMan"];
        shopReturnInfoVo.phone = [ObjectUtil getStringValue:dic key:@"phone"];
        shopReturnInfoVo.address = [ObjectUtil getStringValue:dic key:@"address"];
        shopReturnInfoVo.provinceid = [ObjectUtil getStringValue:dic key:@"provinceid"];
        shopReturnInfoVo.cityid = [ObjectUtil getStringValue:dic key:@"cityid"];
        shopReturnInfoVo.countyid = [ObjectUtil getStringValue:dic key:@"countyid"];
        shopReturnInfoVo.zipcode = [ObjectUtil getStringValue:dic key:@"zipcode"];
        shopReturnInfoVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
    }
    
    return shopReturnInfoVo;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            ShopReturnInfoVo* shopReturnInfoVo = [ShopReturnInfoVo converToVo:dic];
            [dataList addObject:shopReturnInfoVo];
        }
    }
    return dataList;
}

@end
