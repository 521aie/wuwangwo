//
//  BalanceLogVo.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "BalanceLogVo.h"

@implementation BalanceLogVo

+ (BalanceLogVo*)converToVo:(NSDictionary*)dic
{
    BalanceLogVo* balanceLogVo = [[BalanceLogVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        balanceLogVo.action=[ObjectUtil getIntegerValue:dic key:@"action"];
        balanceLogVo.moneyFlowId=[ObjectUtil getIntegerValue:dic key:@"moneyFlowId"];
        balanceLogVo.opName = [ObjectUtil getStringValue:dic key:@"opName"];
        balanceLogVo.fee = [ObjectUtil getDoubleValue:dic key:@"fee"];
        balanceLogVo.opTime = [ObjectUtil getStringValue:dic key:@"opTime"];
    }
    
    return balanceLogVo;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    if ([ObjectUtil isEmpty:sourceList]) {
        return nil;
    }
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            BalanceLogVo* balanceLogVo = [BalanceLogVo converToVo:dic];
            [dataList addObject:balanceLogVo];
        }
    }
    return dataList;
}

@end
