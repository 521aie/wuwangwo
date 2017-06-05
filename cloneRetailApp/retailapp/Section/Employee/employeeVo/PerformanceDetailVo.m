//
//  PerformanceDetailVo.m
//  retailapp
//
//  Created by qingmei on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PerformanceDetailVo.h"

@implementation PerformanceDetailVo

+ (PerformanceDetailVo*)convertToUser:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        PerformanceDetailVo *performanceDetailVo = [[PerformanceDetailVo alloc]init];
        
       
        performanceDetailVo.performanceId = [ObjectUtil getIntegerValue:dic key:@"performanceId"];
        performanceDetailVo.startDate = [ObjectUtil getIntegerValue:dic key:@"startDate"];
        performanceDetailVo.endDate = [ObjectUtil getIntegerValue:dic key:@"endDate"];
        performanceDetailVo.collectType = [ObjectUtil getIntegerValue:dic key:@"collectType"];
        performanceDetailVo.saleTargetDay = [ObjectUtil getStringValue:dic key:@"saleTargetDay"];
        performanceDetailVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        
        return performanceDetailVo;
    }
    return nil;

}

- (NSMutableDictionary *)getDic:(PerformanceDetailVo *)performanceDetailVo{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ObjectUtil isNull:performanceDetailVo.saleTargetDay]?[NSNull null]:performanceDetailVo.saleTargetDay forKey:@"saleTargetDay"];
   
    [dic setValue:[NSNumber numberWithInteger:performanceDetailVo.performanceId] forKey:@"performanceId"];
    [dic setValue:[NSNumber numberWithInteger:performanceDetailVo.startDate] forKey:@"startDate"];
    [dic setValue:[NSNumber numberWithInteger:performanceDetailVo.endDate] forKey:@"endDate"];
    [dic setValue:[NSNumber numberWithInteger:performanceDetailVo.collectType] forKey:@"collectType"];
    [dic setValue:[NSNumber numberWithInteger:performanceDetailVo.lastVer] forKey:@"lastVer"];
    
    return dic;

}

@end
