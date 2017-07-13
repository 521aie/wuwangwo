//
//  SalesMatchRuleMinusVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalesMatchRuleMinusVo.h"

@implementation SalesMatchRuleMinusVo

+(SalesMatchRuleMinusVo*)convertToSalesMatchRuleMinusVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        SalesMatchRuleMinusVo* salesMatchRuleMinusVo = [[SalesMatchRuleMinusVo alloc] init];
        salesMatchRuleMinusVo.minusRuleId = [ObjectUtil getStringValue:dic key:@"minusRuleId"];
        salesMatchRuleMinusVo.salesId = [ObjectUtil getStringValue:dic key:@"salesId"];
        salesMatchRuleMinusVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        salesMatchRuleMinusVo.amountCondition = [ObjectUtil getNumberValue:dic key:@"amountCondition"];
        salesMatchRuleMinusVo.goodsNumber = [ObjectUtil getNumberValue:dic key:@"goodsNumber"];
        salesMatchRuleMinusVo.groupType = [ObjectUtil getIntegerValue:dic key:@"groupType"];
        salesMatchRuleMinusVo.goodsScope = [ObjectUtil getShortValue:dic key:@"goodsScope"];
        salesMatchRuleMinusVo.deduction = [ObjectUtil getDoubleValue:dic key:@"deduction"];
        salesMatchRuleMinusVo.maxDeduction = [ObjectUtil getNumberValue:dic key:@"maxDeduction"];
        salesMatchRuleMinusVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        salesMatchRuleMinusVo.containStyleNum = [ObjectUtil getIntegerValue:dic key:@"containStyleNum"];
        
        return salesMatchRuleMinusVo;
    }
    return nil;
}

+(NSDictionary*)getDictionaryData:(SalesMatchRuleMinusVo *)salesMatchRuleMinusVo
{
    if ([ObjectUtil isNotNull:salesMatchRuleMinusVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"minusRuleId" val:salesMatchRuleMinusVo.minusRuleId];
        [ObjectUtil setStringValue:data key:@"salesId" val:salesMatchRuleMinusVo.salesId];
        [ObjectUtil setStringValue:data key:@"name" val:salesMatchRuleMinusVo.name];
        [ObjectUtil setNumberValue:data key:@"amountCondition" val:salesMatchRuleMinusVo.amountCondition];
        [ObjectUtil setNumberValue:data key:@"goodsNumber" val:salesMatchRuleMinusVo.goodsNumber];
        [ObjectUtil setIntegerValue:data key:@"groupType" val:salesMatchRuleMinusVo.groupType];
        [ObjectUtil setShortValue:data key:@"goodsScope" val:salesMatchRuleMinusVo.goodsScope];
        [ObjectUtil setDoubleValue:data key:@"deduction" val:salesMatchRuleMinusVo.deduction];
        [ObjectUtil setNumberValue:data key:@"maxDeduction" val:salesMatchRuleMinusVo.maxDeduction];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:salesMatchRuleMinusVo.lastVer];
        [ObjectUtil setIntegerValue:data key:@"containStyleNum" val:salesMatchRuleMinusVo.containStyleNum];

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
            SalesMatchRuleMinusVo* vo = [SalesMatchRuleMinusVo convertToSalesMatchRuleMinusVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

@end
