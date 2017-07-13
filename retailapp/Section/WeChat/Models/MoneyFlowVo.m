//
//  MoneyFlowVo.m
//  retailapp
//
//  Created by diwangxie on 16/5/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "MoneyFlowVo.h"
#import "ObjectUtil.h"

@implementation MoneyFlowVo
+(MoneyFlowVo *)convertToMoneyFlowVo:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        MoneyFlowVo *vo=[[MoneyFlowVo alloc] init];
        vo.orderid=[ObjectUtil getStringValue:dic key:@"orderId"];
        vo.action=[ObjectUtil getShortValue:dic key:@"action"];
        vo.status=[ObjectUtil getShortValue:dic key:@"status"];
        vo.fee=[ObjectUtil getDoubleValue:dic key:@"fee"];
        vo.orderCode=[ObjectUtil getStringValue:dic key:@"code"];
        vo.id=[ObjectUtil getStringValue:dic key:@"id"];
        vo.createTime=[ObjectUtil getLonglongValue:dic key:@"createTime"];
        vo.customerName=[ObjectUtil getStringValue:dic key:@"customerName"];
        vo.outType=[ObjectUtil getStringValue:dic key:@"outType"];
        vo.rebateRate=[ObjectUtil getDoubleValue:dic key:@"rebateRate"];
        vo.customerMobile=[ObjectUtil getStringValue:dic key:@"customerMobile"];
        vo.opTime=[ObjectUtil getLonglongValue:dic key:@"opTime"];
        vo.withDrawType=[ObjectUtil getStringValue:dic key:@"withDrawType"];
        vo.bankName=[ObjectUtil getStringValue:dic key:@"bankName"];
        vo.accountNumber=[ObjectUtil getStringValue:dic key:@"accountNumber"];
        
        return vo;
    }
    return nil;
}
+(NSDictionary*)getDictionaryData:(MoneyFlowVo *)moneyFlowVo{
    if ([ObjectUtil isNotEmpty:moneyFlowVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"orderId" val:moneyFlowVo.orderid];
        [ObjectUtil setShortValue:data key:@"action" val:moneyFlowVo.action];
        [ObjectUtil setShortValue:data key:@"status" val:moneyFlowVo.status];
        [ObjectUtil setDoubleValue:data key:@"fee" val:moneyFlowVo.fee];
        [ObjectUtil setStringValue:data key:@"code" val:moneyFlowVo.orderCode];
        [ObjectUtil setStringValue:data key:@"id" val:moneyFlowVo.id];
        [ObjectUtil setLongLongValue:data key:@"createTime" val:moneyFlowVo.createTime];
        [ObjectUtil setStringValue:data key:@"customerName" val:moneyFlowVo.customerName];
        [ObjectUtil setStringValue:data key:@"outType" val:moneyFlowVo.outType];
        [ObjectUtil setDoubleValue:data key:@"rebateRate" val:moneyFlowVo.rebateRate];
        [ObjectUtil setStringValue:data key:@"customerMobile" val:moneyFlowVo.customerMobile];
        [ObjectUtil setLongLongValue:data key:@"opTime" val:moneyFlowVo.opTime];
        [ObjectUtil setStringValue:data key:@"opTime" val:moneyFlowVo.withDrawType];
        [ObjectUtil setStringValue:data key:@"bankName" val:moneyFlowVo.bankName];
        [ObjectUtil setStringValue:data key:@"accountNumber" val:moneyFlowVo.accountNumber];
        return data;
    }
    return nil;
}

@end
