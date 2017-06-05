//
//  ConfigVo.m
//  retailapp
//
//  Created by hm on 15/9/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ConfigVo.h"
#import "ConfigItemOptionVo.h"

@implementation ConfigVo

+ (ConfigVo*)converToConfigVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        ConfigVo* configVo = [ConfigVo new];
        configVo.value = [ObjectUtil getStringValue:dic key:@"value"];
        configVo.code= [ObjectUtil getStringValue:dic key:@"code"];
        configVo.configItemOptionVoList = [ConfigItemOptionVo converToArr:[dic objectForKey:@"configItemOptionVoList"]];
        return configVo;
    }
    return nil;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary* dic in sourceList) {
            ConfigVo* vo = [ConfigVo converToConfigVo:dic];
            [dataList addObject:vo];
        }
        return dataList;
    }
    return [NSMutableArray array];
}

+ (NSDictionary*)converToDic:(ConfigVo*)vo
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:vo]) {
        [ObjectUtil setStringValue:data key:@"code" val:vo.code];
        [ObjectUtil setStringValue:data key:@"value" val:vo.value];
        NSMutableArray* list = [NSMutableArray arrayWithCapacity:vo.configItemOptionVoList.count];
        for (ConfigItemOptionVo* optionVo in vo.configItemOptionVoList) {
            [list addObject:[ConfigItemOptionVo converToDic:optionVo]];
        }
        [data setValue:list forKey:@"configItemOptionVoList"];
    }
    return data;
}

@end
