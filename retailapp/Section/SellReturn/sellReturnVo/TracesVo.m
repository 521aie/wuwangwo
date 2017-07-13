//
//  TracesVo.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "TracesVo.h"

@implementation TracesVo

+ (TracesVo*)converToVo:(NSDictionary*)dic
{
    TracesVo *tracesVo = [[TracesVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        
        tracesVo.desc = [ObjectUtil getStringValue:dic key:@"desc"];
        tracesVo.dispOrRecMan = [ObjectUtil getStringValue:dic key:@"dispOrRecMan"];
        tracesVo.dispOrRecManCode = [ObjectUtil getStringValue:dic key:@"dispOrRecManCode"];
        tracesVo.dispOrRecManPhone = [ObjectUtil getStringValue:dic key:@"dispOrRecManPhone"];
        tracesVo.preOrNextSite = [ObjectUtil getStringValue:dic key:@"preOrNextSite"];
        tracesVo.preOrNextSiteCode = [ObjectUtil getStringValue:dic key:@"preOrNextSiteCode"];
        tracesVo.preOrNextSitePhone = [ObjectUtil getStringValue:dic key:@"preOrNextSitePhone"];
        tracesVo.remark = [ObjectUtil getStringValue:dic key:@"remark"];
        tracesVo.scanDate = [ObjectUtil getStringValue:dic key:@"scanDate"];
        tracesVo.scanSite = [ObjectUtil getStringValue:dic key:@"scanSite"];
        tracesVo.scanSiteCode = [ObjectUtil getStringValue:dic key:@"scanSiteCode"];
        tracesVo.scanSitePhone = [ObjectUtil getStringValue:dic key:@"scanSitePhone"];
        tracesVo.scanType = [ObjectUtil getStringValue:dic key:@"scanType"];
        tracesVo.signMan = [ObjectUtil getStringValue:dic key:@"signMan"];
    }
    
    return tracesVo;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    if ([sourceList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            TracesVo *tracesVo = [TracesVo converToVo:dic];
            [dataList addObject:tracesVo];
        }
    }
    return dataList;
}

@end
