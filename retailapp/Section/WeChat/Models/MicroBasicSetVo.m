//
//  MicroBasicSetVo.m
//  retailapp
//
//  Created by zhangzt on 15/10/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroBasicSetVo.h"

@implementation MicroBasicSetVo

+ (MicroBasicSetVo*)converToVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        MicroBasicSetVo* vo = [MicroBasicSetVo new];
        vo.configId = [ObjectUtil getStringValue:dic key:@"configId"];
        vo.name = [ObjectUtil getStringValue:dic key:@"name"];
        vo.value = [ObjectUtil getStringValue:dic key:@"value"];
        vo.code = [ObjectUtil getStringValue:dic key:@"code"];
        vo.detail = [ObjectUtil getStringValue:dic key:@"detail"];
        return vo;
    }
    return nil;
}

+ (NSMutableArray*)converToArr:(NSArray*)arrList
{
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:arrList.count];
    if ([ObjectUtil isNotEmpty:arrList]) {
        for (NSDictionary* dic in arrList) {
            MicroBasicSetVo* vo = [MicroBasicSetVo converToVo:dic];
            [dataList addObject:vo];
        }
    }
    return dataList;
}

+ (NSDictionary*)converToDic:(MicroBasicSetVo*)vo
{
    NSMutableDictionary* data=[NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:vo]) {
        [ObjectUtil setStringValue:data key:@"configId" val:vo.configId];
        [ObjectUtil setStringValue:data key:@"name" val:vo.name];
        [ObjectUtil setStringValue:data key:@"value" val:vo.value];
        [ObjectUtil setStringValue:data key:@"code" val:vo.code];
        [ObjectUtil setStringValue:data key:@"detail" val:vo.detail];
    }
    return data;
}

@end
