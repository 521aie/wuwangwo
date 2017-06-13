//
//  LSMemberMeterCardListVo.m
//  retailapp
//
//  Created by wuwangwo on 2017/4/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberMeterCardListVo.h"

@implementation LSMemberMeterCardListVo

+ (instancetype)byTimeRechargeRecordVo:(NSDictionary *)jsonDic {
    return [self mj_objectWithKeyValues:jsonDic];
}

+ (NSArray *)byTimeRechargeRecordVoList:(NSArray *)keyValuesArray {
    
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}

@end
