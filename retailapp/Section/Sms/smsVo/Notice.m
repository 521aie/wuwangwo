//
//  Notice.m
//  retailapp
//
//  Created by hm on 15/9/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Notice.h"
#import "ObjectUtil.h"

@implementation Notice

+(Notice*)converToNotice:(NSDictionary*)dic
{
    Notice* notice = [Notice new];
    if ([ObjectUtil isNotEmpty:dic]) {
        notice.currShopId = [ObjectUtil getStringValue:dic key:@"currShopId"];
        notice.targetShopId = [ObjectUtil getStringValue:dic key:@"targetShopId"];
        notice.targetShopName = [ObjectUtil getStringValue:dic key:@"targetShopName"];
        notice.noticeId = [ObjectUtil getStringValue:dic key:@"noticeId"];
        notice.noticeTitle = [ObjectUtil getStringValue:dic key:@"noticeTitle"];
        notice.noticeContent = [ObjectUtil getStringValue:dic key:@"noticeContent"];
        notice.publishTime = [ObjectUtil getLonglongValue:dic key:@"publishTime"];
        notice.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        notice.status = [ObjectUtil getShortValue:dic key:@"status"];
    }
    return notice;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    if ([ObjectUtil isNotNull:sourceList]) {
        NSMutableArray* arr = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary* dic in sourceList) {
            Notice* notice = [Notice converToNotice:dic];
            [arr addObject:notice];
        }
        return arr;
    }
    return [NSMutableArray array];
}

+ (NSDictionary*)converToDic:(Notice*)notice
{
    if ([ObjectUtil isNotNull:notice]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"currShopId" val:notice.currShopId];
        [ObjectUtil setStringValue:data key:@"targetShopId" val:notice.targetShopId];
        [ObjectUtil setStringValue:data key:@"targetShopName" val:notice.targetShopName];
        [ObjectUtil setStringValue:data key:@"noticeId" val:notice.noticeId];
        [ObjectUtil setStringValue:data key:@"noticeTitle" val:notice.noticeTitle];
        [ObjectUtil setStringValue:data key:@"noticeContent" val:notice.noticeContent];
        [ObjectUtil setLongLongValue:data key:@"publishTime" val:notice.publishTime];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:notice.lastVer];
        [ObjectUtil setShortValue:data key:@"status" val:notice.status];
        return data;
    }
    return [NSMutableDictionary dictionary];
}

@end
