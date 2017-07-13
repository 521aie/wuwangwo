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
    
    if (_action.integerValue == 1) {
        return LSByTimeRechargeRecordOperType_Recharge;
    } else if (_action.integerValue == 2) {
        return LSByTimeRechargeRecordOperType_Pay;
    }
    return LSByTimeRechargeRecordOperType_Refund;
}

- (NSString *)operationTypeString {
    
    if (_action.integerValue == 1) {
        return @"充值";
    } else if (_action.integerValue == 2) {
        return @"支付";
    }
    return @"退款";
}

- (NSString *)payModeString {
    
    // 支付方式
    switch (_payMode.integerValue) {
        case 1:
            return @"会员卡";
        case 2:
            return @"优惠券";
        case 4:
            return @"银行卡";
        case 5:
            return @"现金";
        case 6:
            return @"[微信]";
        case 8:
            return @"[支付宝]";
        case 9:
            return @"[微信]";
        case 50:
            return @"（现金）货到付款";
        case 51:
            return @"手动退款";
        case 52:
            return @"[QQ钱包]";
        case 99:
            return @"其他";
        default:
            break;
    }
    return @"";
}

- (NSString *)vailidTimeString {
    // 判断是否为不限期
    if (_endDate.intValue == 0) {
        return @"不限期";
    }
    NSString *effectiveTime = [NSString stringWithFormat:@"%@至%@",
                               [DateUtils formateTime5:_startDate.longLongValue],
                               [DateUtils formateTime5:_endDate.longLongValue]];
    return effectiveTime;
}

@end
