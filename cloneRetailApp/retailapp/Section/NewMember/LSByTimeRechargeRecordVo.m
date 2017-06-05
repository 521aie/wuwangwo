//
//  LSByTimeRechargeRecordVo.m
//  retailapp
//
//  Created by taihangju on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSByTimeRechargeRecordVo.h"
#import "DateUtils.h"

@implementation LSByTimeRechargeRecordVo

+ (instancetype)byTimeRechargeRecordVo:(NSDictionary *)jsonDic {
    return [self mj_objectWithKeyValues:jsonDic];
}

+ (NSArray *)byTimeRechargeRecordVoList:(NSArray *)keyValuesArray {
    
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}

- (LSByTimeRechargeRecordOperType)byTimeRechargeRecordVoOperType {
    
    if ([_operType isEqualToString:@"退款"]) {
        return LSByTimeRechargeRecordOperType_Refund;
    } else {
        return LSByTimeRechargeRecordOperType_Recharge;
    }
}

- (NSString *)vailidTimeString {
    // 判断是否为不限期
    if (_startDate == nil && _endDate == nil) {
        return @"不限期";
    }
    NSString *effectiveTime = [NSString stringWithFormat:@"%@至%@",
                               [DateUtils formateTime2:_startDate.longLongValue],
                               [DateUtils formateTime2:_endDate.longLongValue]];
    return effectiveTime;
}

@end
