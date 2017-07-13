//
//  AttributeVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AttributeVo.h"

@implementation AttributeVo

+(AttributeVo*)convertToAttributeVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        AttributeVo* attributeVo = [[AttributeVo alloc] init];
        attributeVo.attributeId = [ObjectUtil getStringValue:dic key:@"attributeId"];
        attributeVo.collectionType = [ObjectUtil getShortValue:dic key:@"collectionType"];
        attributeVo.code = [ObjectUtil getStringValue:dic key:@"code"];
        attributeVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        attributeVo.spell = [ObjectUtil getStringValue:dic key:@"spell"];
        attributeVo.groupCnt = [ObjectUtil getIntegerValue:dic key:@"groupCnt"];
        attributeVo.valCnt = [ObjectUtil getIntegerValue:dic key:@"valCnt"];
        attributeVo.attributeType = [ObjectUtil getStringValue:dic key:@"attributeType"];
        attributeVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        
        return attributeVo;
    }
    
    return nil;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray* datas = nil;
    if ([ObjectUtil isNotEmpty:sourceList]) {
        datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary* dic in sourceList) {
            AttributeVo* vo = [AttributeVo convertToAttributeVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

@end
