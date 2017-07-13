//
//  MicroDistributeVo.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroDistributeVo.h"

@implementation MicroDistributeVo

+ (MicroDistributeVo*)converToVo:(NSDictionary*)dic
{
    MicroDistributeVo *microDistributeVo = [[MicroDistributeVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        microDistributeVo.configId = [ObjectUtil getStringValue:dic key:@"configId"];
//        microDistributeVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        microDistributeVo.value = [ObjectUtil getStringValue:dic key:@"value"];
        microDistributeVo.code = [ObjectUtil getStringValue:dic key:@"code"];
//        microDistributeVo.detail = [ObjectUtil getStringValue:dic key:@"detail"];
    }
    
    return microDistributeVo;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    if ([ObjectUtil isEmpty:sourceList]) {
        return nil;
    }
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            MicroDistributeVo* microDistributeVo = [MicroDistributeVo converToVo:dic];
            [dataList addObject:microDistributeVo];
        }
    }
    return dataList;
}

@end
