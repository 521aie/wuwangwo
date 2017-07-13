//
//  UserHandoverVo.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "UserHandoverVo.h"

@implementation UserHandoverVo
+ (UserHandoverVo*)convertToUser:(NSDictionary*)dic{
    
    if ([ObjectUtil isNotEmpty:dic]) {
        
        UserHandoverVo *userHandoverVo = [[UserHandoverVo alloc]init];
        
        userHandoverVo.userHandoverId = [ObjectUtil getStringValue:dic key:@"userHandoverId"];
        userHandoverVo.startWorkTime = [ObjectUtil getIntegerValue:dic key:@"startWorkTime"];
        userHandoverVo.endWorkTime = [ObjectUtil getIntegerValue:dic key:@"endWorkTime"];
        userHandoverVo.orderNumber = [ObjectUtil getIntegerValue:dic key:@"orderNumber"];
        userHandoverVo.saleGoodsNumber = [ObjectUtil getStringValue:dic key:@"saleGoodsNumber"];
        
        userHandoverVo.resultAmount = [ObjectUtil getStringValue:dic key:@"resultAmount"];
        userHandoverVo.discountAmount = [ObjectUtil getStringValue:dic key:@"discountAmount"];
        userHandoverVo.chargeAmount = [ObjectUtil getStringValue:dic key:@"chargeAmount"];
        userHandoverVo.presentAmount = [ObjectUtil getStringValue:dic key:@"presentAmount"];
        userHandoverVo.returnOrderNumber = [ObjectUtil getIntegerValue:dic key:@"returnOrderNumber"];
        
        userHandoverVo.royalties = [ObjectUtil getStringValue:dic key:@"royalties"];
        userHandoverVo.returnAmount = [ObjectUtil getStringValue:dic key:@"returnAmount"];
        userHandoverVo.cashierAmount = [ObjectUtil getStringValue:dic key:@"cashierAmount"];
        
        return userHandoverVo;
    }
    return nil;
}

- (NSMutableDictionary *)getDic:(UserHandoverVo *)userHandoverVo{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:[ObjectUtil isNull:userHandoverVo.userHandoverId]?[NSNull null]:userHandoverVo.userHandoverId forKey:@"userHandoverId"];
    [dic setValue:[NSNumber numberWithInteger:userHandoverVo.startWorkTime] forKey:@"startWorkTime"];
    [dic setValue:[NSNumber numberWithInteger:userHandoverVo.endWorkTime] forKey:@"endWorkTime"];
    [dic setValue:[NSNumber numberWithInteger:userHandoverVo.orderNumber] forKey:@"orderNumber"];
    [dic setValue:[ObjectUtil isNull:userHandoverVo.saleGoodsNumber]?[NSNull null]:userHandoverVo.saleGoodsNumber forKey:@"saleGoodsNumber"];
    
     [dic setValue:[ObjectUtil isNull:userHandoverVo.resultAmount]?[NSNull null]:userHandoverVo.resultAmount forKey:@"resultAmount"];
     [dic setValue:[ObjectUtil isNull:userHandoverVo.discountAmount]?[NSNull null]:userHandoverVo.discountAmount forKey:@"discountAmount"];
     [dic setValue:[ObjectUtil isNull:userHandoverVo.chargeAmount]?[NSNull null]:userHandoverVo.chargeAmount forKey:@"chargeAmount"];
     [dic setValue:[ObjectUtil isNull:userHandoverVo.presentAmount]?[NSNull null]:userHandoverVo.presentAmount forKey:@"presentAmount"];
     [dic setValue:[NSNumber numberWithInteger:userHandoverVo.returnOrderNumber] forKey:@"returnOrderNumber"];
    
     [dic setValue:[ObjectUtil isNull:userHandoverVo.royalties]?[NSNull null]:userHandoverVo.royalties forKey:@"royalties"];
     [dic setValue:[ObjectUtil isNull:userHandoverVo.returnAmount]?[NSNull null]:userHandoverVo.returnAmount forKey:@"returnAmount"];
     [dic setValue:[ObjectUtil isNull:userHandoverVo.cashierAmount]?[NSNull null]:userHandoverVo.cashierAmount forKey:@"cashierAmount"];
    
    return dic;
}
@end
