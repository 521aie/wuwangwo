//
//  HandoverPayTypeVo.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "HandoverPayTypeVo.h"

@implementation HandoverPayTypeVo

+ (HandoverPayTypeVo*)convertToUser:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        HandoverPayTypeVo *handoverPayTypeVo = [[HandoverPayTypeVo alloc]init];
        
        handoverPayTypeVo.handoverId = [ObjectUtil getStringValue:dic key:@"handoverId"];
        handoverPayTypeVo.payTypeId = [ObjectUtil getIntegerValue:dic key:@"payTypeId"];
        handoverPayTypeVo.payAmount = [ObjectUtil getStringValue:dic key:@"payAmount"];
        handoverPayTypeVo.payTypeName = [ObjectUtil getStringValue:dic key:@"payTypeName"];
        
        return handoverPayTypeVo;
    }
    return nil;
}

- (NSMutableDictionary *)getDic:(HandoverPayTypeVo *)handoverPayTypeVo{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:[ObjectUtil isNull:handoverPayTypeVo.handoverId]?[NSNull null]:handoverPayTypeVo.handoverId forKey:@"handoverId"];
    [dic setValue:[NSNumber numberWithInteger:handoverPayTypeVo.payTypeId] forKey:@"payTypeId"];
    [dic setValue:[ObjectUtil isNull:handoverPayTypeVo.payAmount]?[NSNull null]:handoverPayTypeVo.payAmount forKey:@"payAmount"];
    [dic setValue:[ObjectUtil isNull:handoverPayTypeVo.payTypeName]?[NSNull null]:handoverPayTypeVo.payTypeName forKey:@"payTypeName"];
    
    return dic;
}

@end
