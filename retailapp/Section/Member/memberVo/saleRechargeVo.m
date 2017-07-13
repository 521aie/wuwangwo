//
//  MemberSalesRechargeVo.m
//  RestApp
//
//  Created by zhangzhiliang on 15/7/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SaleRechargeVo.h"
#import "ObjectUtil.h"

@implementation SaleRechargeVo

-(NSString*) obtainItemName
{
    return self.name;
    
}

-(NSString*) obtainItemId
{
    return self.saleRechargeId;
}

-(NSString*) obtainItemValue
{
    return self.saleRechargeId;
}

-(NSString*) obtainOrignName
{
    return self.name;
}

+ (SaleRechargeVo*)convertToSaleRecharge:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        SaleRechargeVo* saleRechargeVo = [[SaleRechargeVo alloc] init];
        saleRechargeVo.saleRechargeId = [ObjectUtil getStringValue:dic key:@"saleRechargeId"];
        saleRechargeVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        saleRechargeVo.rechargeThreshold = [ObjectUtil getDoubleValue:dic key:@"rechargeThreshold"];
        saleRechargeVo.startTime = [ObjectUtil getLonglongValue:dic key:@"startTime"];
        saleRechargeVo.endTime = [ObjectUtil getLonglongValue:dic key:@"endTime"];
        saleRechargeVo.point = [ObjectUtil getIntegerValue:dic key:@"point"];
        saleRechargeVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        saleRechargeVo.money = [ObjectUtil getDoubleValue:dic key:@"money"];
        
        return saleRechargeVo;
    }
    return nil;
    
}

+ (NSDictionary*)getDictionaryData:(SaleRechargeVo*)saleRechargeVo
{
    if ([ObjectUtil isNotNull:saleRechargeVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"saleRechargeId" val:saleRechargeVo.saleRechargeId];
        [ObjectUtil setStringValue:data key:@"name" val:saleRechargeVo.name];
        [ObjectUtil setDoubleValue:data key:@"rechargeThreshold" val:saleRechargeVo.rechargeThreshold];
        [ObjectUtil setLongLongValue:data key:@"startTime" val:saleRechargeVo.startTime];
        [ObjectUtil setLongLongValue:data key:@"endTime" val:saleRechargeVo.endTime];
        [ObjectUtil setIntegerValue:data key:@"point" val:saleRechargeVo.point];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:saleRechargeVo.lastVer];
        [ObjectUtil setDoubleValue:data key:@"money" val:saleRechargeVo.money];
        
        return data;
    }
    return nil;
}

@end
