//
//  TracesVos.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "TracesVos.h"

@implementation TracesVos

+ (TracesVos*)converToVo:(NSDictionary*)dic
{
    TracesVos *tracesVos = [[TracesVos alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        
        tracesVos.billCode = [ObjectUtil getStringValue:dic key:@"billCode"];
        tracesVos.traces = [TracesVo converToArr:dic[@"traces"]];
    }
    
    return tracesVos;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    if ([sourceList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            TracesVos *tracesVos = [TracesVos converToVo:dic];
            [dataList addObject:tracesVos];
        }
    }
    return dataList;
}

@end
