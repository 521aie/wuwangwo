//
//  SupplyManageVo.m
//  retailapp
//
//  Created by hm on 15/12/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SupplyManageVo.h"

@implementation SupplyManageVo
+ (SupplyManageVo *)converToVo:(NSDictionary *)dic
{
    SupplyManageVo *vo = [[SupplyManageVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        vo.entityid = [ObjectUtil getStringValue:dic key:@"entityid"];
        vo.supplyId = [ObjectUtil getStringValue:dic key:@"id"];
        vo.name = [ObjectUtil getStringValue:dic key:@"name"];
        vo.shortName = [ObjectUtil getStringValue:dic key:@"shortname"];
        vo.code = [ObjectUtil getStringValue:dic key:@"code"];
        vo.typeName = [ObjectUtil getStringValue:dic key:@"typeName"];
        vo.typeVal = [ObjectUtil getStringValue:dic key:@"typeVal"];
        vo.relation = [ObjectUtil getStringValue:dic key:@"relation"];
        vo.mobile = [ObjectUtil getStringValue:dic key:@"mobile"];
        vo.phone = [ObjectUtil getStringValue:dic key:@"phone"];
        vo.weixin = [ObjectUtil getStringValue:dic key:@"weiXin"];
        vo.email = [ObjectUtil getStringValue:dic key:@"email"];
        vo.fax = [ObjectUtil getStringValue:dic key:@"fax"];
        vo.address = [ObjectUtil getStringValue:dic key:@"address"];
        vo.bankname = [ObjectUtil getStringValue:dic key:@"bankname"];
        vo.bankcardno = [ObjectUtil getStringValue:dic key:@"bankcardno"];
        vo.bankaccountname = [ObjectUtil getStringValue:dic key:@"bankaccountname"];
        vo.lastver = [ObjectUtil getIntegerValue:dic key:@"lastver"];
        vo.opuserid = [ObjectUtil getStringValue:dic key:@"opuserid"];
    }
    return vo;
}

+ (NSMutableDictionary *)converToDic:(SupplyManageVo *)vo
{
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:vo]) {
        [ObjectUtil setStringValue:datas key:@"entityid" val:vo.entityid];
        [ObjectUtil setStringValue:datas key:@"id" val:vo.supplyId];
        [ObjectUtil setStringValue:datas key:@"name" val:vo.name];
        [ObjectUtil setStringValue:datas key:@"shortname" val:vo.shortName];
        [ObjectUtil setStringValue:datas key:@"code" val:vo.code];
        [ObjectUtil setStringValue:datas key:@"typeName" val:vo.typeName];
        [ObjectUtil setStringValue:datas key:@"typeVal" val:vo.typeVal];
        [ObjectUtil setStringValue:datas key:@"relation" val:vo.relation];
        [ObjectUtil setStringValue:datas key:@"mobile" val:vo.mobile];
        [ObjectUtil setStringValue:datas key:@"phone" val:vo.phone];
        [ObjectUtil setStringValue:datas key:@"weiXin" val:vo.weixin];
        [ObjectUtil setStringValue:datas key:@"email" val:vo.email];
        [ObjectUtil setStringValue:datas key:@"fax" val:vo.fax];
        [ObjectUtil setStringValue:datas key:@"address" val:vo.address];
        [ObjectUtil setStringValue:datas key:@"bankname" val:vo.bankname];
        [ObjectUtil setStringValue:datas key:@"bankcardno" val:vo.bankcardno];
        [ObjectUtil setStringValue:datas key:@"bankaccountname" val:vo.bankaccountname];
        [ObjectUtil setIntegerValue:datas key:@"lastver" val:vo.lastver];
        [ObjectUtil setStringValue:datas key:@"opuserid" val:vo.opuserid];
    }
    return datas;
}

@end
