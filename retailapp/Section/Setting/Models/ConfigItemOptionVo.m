//
//  ConfigItemOptionVo.m
//  retailapp
//
//  Created by hm on 15/9/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ConfigItemOptionVo.h"

@implementation ConfigItemOptionVo
-(NSString*) obtainItemId
{
    return self.value;
}
-(NSString*) obtainItemName
{
    return self.name;
}
-(NSString*) obtainOrignName
{
    return self.name;
}

+ (ConfigItemOptionVo*)converToVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        ConfigItemOptionVo* vo = [ConfigItemOptionVo new];
        vo.name = [ObjectUtil getStringValue:dic key:@"name"];
        vo.value = [ObjectUtil getStringValue:dic key:@"value"];
        return vo;
    }
    return nil;
}

+ (NSMutableArray*)converToArr:(NSArray*)arrList
{
    if ([ObjectUtil isNotEmpty:arrList]) {
        NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:arrList.count];
        for (NSDictionary* dic in arrList) {
            ConfigItemOptionVo* vo = [ConfigItemOptionVo converToVo:dic];
            [dataList addObject:vo];
        }
        return dataList;
    }
    return [NSMutableArray array];
}

+ (NSDictionary*)converToDic:(ConfigItemOptionVo*)vo
{
    NSMutableDictionary* data=[NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:vo]) {
        [ObjectUtil setStringValue:data key:@"name" val:vo.name];
        [ObjectUtil setStringValue:data key:@"value" val:vo.value];
    }
    return data;
}

@end
