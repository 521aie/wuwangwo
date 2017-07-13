//
//  RebateOrdersVo.m
//  retailapp
//
//  Created by diwangxie on 16/5/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "RebateOrdersVo.h"

@implementation RebateOrdersVo
+(RebateOrdersVo *)convertToRebateOrdersVo:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        RebateOrdersVo *vo=[[RebateOrdersVo alloc] init];
        vo.id=[ObjectUtil getShortValue:dic key:@"id"];
        vo.rebateOrderFee=[ObjectUtil getDoubleValue:dic key:@"rebateOrderFee"];
        vo.rebateState=[ObjectUtil getShortValue:dic key:@"rebateState"];
        
        vo.marginProfit=[dic objectForKey:@"marginProfit"];
        vo.rebateFee=[dic objectForKey:@"rebateFee"];
        vo.supplyFee=[dic objectForKey:@"supplyFee"];
        vo.returnFee=[dic objectForKey:@"returnFee"];
        vo.weiPlatformFee=[dic objectForKey:@"weiPlatformFee"];
        
        
        vo.createTime=[ObjectUtil getLonglongValue:dic key:@"createTime"];
        
        vo.orderId=[ObjectUtil getStringValue:dic key:@"orderId"];
        vo.orderCode=[ObjectUtil getStringValue:dic key:@"orderCode"];
        vo.orderState=[ObjectUtil getShortValue:dic key:@"orderStatus"];
        
        vo.instances=[dic objectForKey:@"instances"];
        
        vo.orderTotalFee=[ObjectUtil getDoubleValue:dic key:@"orderTotalFee"];
        vo.outFee=[ObjectUtil getDoubleValue:dic key:@"outFee"];
        
        vo.outType=[ObjectUtil getStringValue:dic key:@"outType"];
        vo.orderKind=[ObjectUtil getShortValue:dic key:@"orderKind"];
        vo.payMode=[ObjectUtil getShortValue:dic key:@"payMode"];
        vo.openTime=[ObjectUtil getLonglongValue:dic key:@"openTime"];
        return vo;
    }
    return nil;
}

+(NSDictionary*)getDictionaryData:(RebateOrdersVo *)rebateOrdersVo{
    return nil;
}
@end
