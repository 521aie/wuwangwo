//
//  SalesMatchRuleSendVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalesMatchRuleSendVo.h"

@implementation SalesMatchRuleSendVo

+(SalesMatchRuleSendVo*)convertToSalesMatchRuleSendVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        SalesMatchRuleSendVo* salesMatchRuleSendVo = [[SalesMatchRuleSendVo alloc] init];
        salesMatchRuleSendVo.fullSendId = [ObjectUtil getStringValue:dic key:@"fullSendId"];
        salesMatchRuleSendVo.salesId = [ObjectUtil getStringValue:dic key:@"salesId"];
        salesMatchRuleSendVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        salesMatchRuleSendVo.amountCondition = [ObjectUtil getNumberValue:dic key:@"amountCondition"];
        salesMatchRuleSendVo.goodsNumber = [ObjectUtil getNumberValue:dic key:@"goodsNumber"];
        salesMatchRuleSendVo.groupType = [ObjectUtil getIntegerValue:dic key:@"groupType"];
        salesMatchRuleSendVo.additionAmount = [ObjectUtil getDoubleValue:dic key:@"additionAmount"];
        salesMatchRuleSendVo.goodsScope = [ObjectUtil getShortValue:dic key:@"goodsScope"];
        salesMatchRuleSendVo.giveNumber = [ObjectUtil getIntegerValue:dic key:@"giveNumber"];
        salesMatchRuleSendVo.maxGiveNumber = [ObjectUtil getNumberValue:dic key:@"maxGiveNumber"];
        salesMatchRuleSendVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        salesMatchRuleSendVo.containStyleNum = [ObjectUtil getIntegerValue:dic key:@"containStyleNum"];
        
        return salesMatchRuleSendVo;
    }
    return nil;
}

+(NSDictionary*)getDictionaryData:(SalesMatchRuleSendVo *)salesMatchRuleSendVo
{
    if ([ObjectUtil isNotNull:salesMatchRuleSendVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"fullSendId" val:salesMatchRuleSendVo.fullSendId];
        [ObjectUtil setStringValue:data key:@"salesId" val:salesMatchRuleSendVo.salesId];
        [ObjectUtil setStringValue:data key:@"name" val:salesMatchRuleSendVo.name];
        [ObjectUtil setNumberValue:data key:@"amountCondition" val:salesMatchRuleSendVo.amountCondition];
        [ObjectUtil setNumberValue:data key:@"goodsNumber" val:salesMatchRuleSendVo.goodsNumber];
        [ObjectUtil setIntegerValue:data key:@"groupType" val:salesMatchRuleSendVo.groupType];
        [ObjectUtil setDoubleValue:data key:@"additionAmount" val:salesMatchRuleSendVo.additionAmount];
        [ObjectUtil setShortValue:data key:@"goodsScope" val:salesMatchRuleSendVo.goodsScope];
        [ObjectUtil setIntegerValue:data key:@"giveNumber" val:salesMatchRuleSendVo.giveNumber];
        [ObjectUtil setNumberValue:data key:@"maxGiveNumber" val:salesMatchRuleSendVo.maxGiveNumber];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:salesMatchRuleSendVo.lastVer];
        [ObjectUtil setIntegerValue:data key:@"containStyleNum" val:salesMatchRuleSendVo.containStyleNum];
        
        return data;
    }
    return nil;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray* datas = nil;
    if ([ObjectUtil isNotEmpty:sourceList]) {
        datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary* dic in sourceList) {
            SalesMatchRuleSendVo* vo = [SalesMatchRuleSendVo convertToSalesMatchRuleSendVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

@end
