//
//  SalesCouponVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalesCouponVo.h"

@implementation SalesCouponVo

+(SalesCouponVo*)convertToSalesCouponVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        SalesCouponVo* salesCouponVo = [[SalesCouponVo alloc] init];
        salesCouponVo.couponRuleId = [ObjectUtil getStringValue:dic key:@"couponRuleId"];
        salesCouponVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        salesCouponVo.number = [ObjectUtil getIntegerValue:dic key:@"number"];
        salesCouponVo.salesId = [ObjectUtil getStringValue:dic key:@"salesId"];
        salesCouponVo.worth = [ObjectUtil getDoubleValue:dic key:@"worth"];
        salesCouponVo.couponCreateFee = [ObjectUtil getNumberValue:dic key:@"couponCreateFee"];
        salesCouponVo.couponCreateNumber = [ObjectUtil getNumberValue:dic key:@"couponCreateNumber"];
        salesCouponVo.couponUseFee = [ObjectUtil getNumberValue:dic key:@"couponUseFee"];
        salesCouponVo.couponUseNumber = [ObjectUtil getNumberValue:dic key:@"couponUseNumber"];
        salesCouponVo.groupType = [ObjectUtil getShortValue:dic key:@"groupType"];
        salesCouponVo.userGoodsScope = [ObjectUtil getShortValue:dic key:@"userGoodsScope"];
        salesCouponVo.generateGoodsScope = [ObjectUtil getShortValue:dic key:@"generateGoodsScope"];
        salesCouponVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        salesCouponVo.containStyleNum = [ObjectUtil getIntegerValue:dic key:@"containStyleNum"];
        salesCouponVo.startDate = [ObjectUtil getIntegerValue:dic key:@"startDate"];
        salesCouponVo.endDate = [ObjectUtil getIntegerValue:dic key:@"endDate"];
        salesCouponVo.remark = [ObjectUtil getStringValue:dic key:@"remark"];
        salesCouponVo.isDoingAct = [ObjectUtil getShortValue:dic key:@"isDoingAct"];
        
        return salesCouponVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(SalesCouponVo *)salesCouponVo
{
    if ([ObjectUtil isNotNull:salesCouponVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"couponRuleId" val:salesCouponVo.couponRuleId];
        [ObjectUtil setStringValue:data key:@"name" val:salesCouponVo.name];
        [ObjectUtil setIntegerValue:data key:@"number" val:salesCouponVo.number];
        [ObjectUtil setStringValue:data key:@"salesId" val:salesCouponVo.salesId];
        [ObjectUtil setDoubleValue:data key:@"worth" val:salesCouponVo.worth];
        [ObjectUtil setNumberValue:data key:@"couponCreateFee" val:salesCouponVo.couponCreateFee];
        [ObjectUtil setNumberValue:data key:@"couponCreateNumber" val:salesCouponVo.couponCreateNumber];
        [ObjectUtil setNumberValue:data key:@"couponUseFee" val:salesCouponVo.couponUseFee];
        [ObjectUtil setNumberValue:data key:@"couponUseNumber" val:salesCouponVo.couponUseNumber];
        [ObjectUtil setShortValue:data key:@"groupType" val:salesCouponVo.groupType];
        [ObjectUtil setShortValue:data key:@"userGoodsScope" val:salesCouponVo.userGoodsScope];
        [ObjectUtil setShortValue:data key:@"generateGoodsScope" val:salesCouponVo.generateGoodsScope];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:salesCouponVo.lastVer];
        [ObjectUtil setIntegerValue:data key:@"containStyleNum" val:salesCouponVo.containStyleNum];
        [ObjectUtil setLongLongValue:data key:@"startDate" val:salesCouponVo.startDate];
        [ObjectUtil setLongLongValue:data key:@"endDate" val:salesCouponVo.endDate];
        [ObjectUtil setStringValue:data key:@"remark" val:salesCouponVo.remark];
        [ObjectUtil setShortValue:data key:@"isDoingAct" val:salesCouponVo.isDoingAct];
        
        return data;
    }
    return nil;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray* datas = nil;
    if ([ObjectUtil isNotEmpty:sourceList]) {
        datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary* dic in sourceList) {
            SalesCouponVo* vo = [SalesCouponVo convertToSalesCouponVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

@end
