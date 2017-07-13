//
//  RechargeRecordDetailsVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RechargeRecordDetailsVo.h"
#import "ObjectUtil.h"

@implementation RechargeRecordDetailsVo

+(RechargeRecordDetailsVo*)convertToRechargeRecordDetailsVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        RechargeRecordDetailsVo* rechargeRecordDetailsVo = [[RechargeRecordDetailsVo alloc] init];
        rechargeRecordDetailsVo.cardCode = [ObjectUtil getStringValue:dic key:@"cardCode"];
        rechargeRecordDetailsVo.customerName = [ObjectUtil getStringValue:dic key:@"customerName"];
        rechargeRecordDetailsVo.mobile = [ObjectUtil getStringValue:dic key:@"mobile"];
        rechargeRecordDetailsVo.payMoney = [ObjectUtil getDoubleValue:dic key:@"payMoney"];
        rechargeRecordDetailsVo.giftMoney = [ObjectUtil getDoubleValue:dic key:@"giftMoney"];
        rechargeRecordDetailsVo.balance = [ObjectUtil getDoubleValue:dic key:@"balance"];
        rechargeRecordDetailsVo.moneyFlowCreatetime = [ObjectUtil getLonglongValue:dic key:@"moneyFlowCreatetime"];
        rechargeRecordDetailsVo.giftIntegral = [ObjectUtil getIntegerValue:dic key:@"giftIntegral"];
        rechargeRecordDetailsVo.staffName = [ObjectUtil getStringValue:dic key:@"staffName"];
        rechargeRecordDetailsVo.staffId = [ObjectUtil getStringValue:dic key:@"staffId"];
        rechargeRecordDetailsVo.payMode = [ObjectUtil getIntegerValue:dic key:@"payMode"];
        rechargeRecordDetailsVo.payModeName = [ObjectUtil getStringValue:dic key:@"payModeName"];
        rechargeRecordDetailsVo.action = [ObjectUtil getIntegerValue:dic key:@"action"];
        rechargeRecordDetailsVo.shopName = [ObjectUtil getStringValue:dic key:@"shopName"];
        rechargeRecordDetailsVo.payType = [ObjectUtil getIntegerValue:dic key:@"payType"];
        rechargeRecordDetailsVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        
        return rechargeRecordDetailsVo;
    }
    
    return nil;
}

@end
