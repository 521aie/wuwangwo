//
//  LogisticsVo.m
//  retailapp
//
//  Created by hm on 15/10/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LogisticsVo.h"

@implementation LogisticsVo
+ (LogisticsVo*)converToVo:(NSDictionary*)dic
{
    LogisticsVo* logisticsVo = [[LogisticsVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        logisticsVo.logisticsId = [ObjectUtil getStringValue:dic key:@"logisticsId"];
        logisticsVo.logisticsNo = [ObjectUtil getStringValue:dic key:@"logisticsNo"];
        logisticsVo.recordType = [ObjectUtil getStringValue:dic key:@"recordType"];
        logisticsVo.supplyName = [ObjectUtil getStringValue:dic key:@"supplyName"];
        logisticsVo.typeName = [ObjectUtil getStringValue:dic key:@"typeName"];
        logisticsVo.billStatusName = [ObjectUtil getStringValue:dic key:@"billStatusName"];
        logisticsVo.sendEndTime = [ObjectUtil getLonglongValue:dic key:@"sendEndTime"];
        logisticsVo.billStatus = [ObjectUtil getIntegerValue:dic key:@"billStatus"];
        logisticsVo.goodsTotalSum = [ObjectUtil getDoubleValue:dic key:@"goodsTotalSum"];
        logisticsVo.goodsTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsTotalPrice"];
        
    }
    return logisticsVo;
}


+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray* datas = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            LogisticsVo* vo = [LogisticsVo converToVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}
@end
