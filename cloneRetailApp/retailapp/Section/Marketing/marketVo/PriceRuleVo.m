//
//  PriceRuleVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PriceRuleVo.h"

@implementation PriceRuleVo

+(PriceRuleVo*)convertToPriceRuleVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        PriceRuleVo* priceRuleVo = [[PriceRuleVo alloc] init];
        priceRuleVo.priceId = [ObjectUtil getStringValue:dic key:@"priceId"];
        priceRuleVo.isMember = [ObjectUtil getShortValue:dic key:@"isMember"];
        priceRuleVo.isShop = [ObjectUtil getShortValue:dic key:@"isShop"];
        priceRuleVo.isWeiXin = [ObjectUtil getShortValue:dic key:@"isWeiXin"];
        priceRuleVo.saleScheme = [ObjectUtil getShortValue:dic key:@"saleScheme"];
        priceRuleVo.shopPriceScheme = [ObjectUtil getShortValue:dic key:@"shopPriceScheme"];
        priceRuleVo.discountRate = [ObjectUtil getDoubleValue:dic key:@"discountRate"];
        priceRuleVo.salePrice = [ObjectUtil getDoubleValue:dic key:@"salePrice"];
        priceRuleVo.startTime = [ObjectUtil getLonglongValue:dic key:@"startTime"];
        priceRuleVo.endTime = [ObjectUtil getLonglongValue:dic key:@"endTime"];
        priceRuleVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        
        return priceRuleVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(PriceRuleVo *)priceRuleVo
{
    if ([ObjectUtil isNotNull:priceRuleVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"priceId" val:priceRuleVo.priceId];
        [ObjectUtil setShortValue:data key:@"isMember" val:priceRuleVo.isMember];
        [ObjectUtil setShortValue:data key:@"isShop" val:priceRuleVo.isShop];
        [ObjectUtil setShortValue:data key:@"isWeiXin" val:priceRuleVo.isWeiXin];
        [ObjectUtil setShortValue:data key:@"saleScheme" val:priceRuleVo.saleScheme];
        [ObjectUtil setShortValue:data key:@"shopPriceScheme" val:priceRuleVo.shopPriceScheme];
        [ObjectUtil setDoubleValue:data key:@"discountRate" val:priceRuleVo.discountRate];
        [ObjectUtil setDoubleValue:data key:@"salePrice" val:priceRuleVo.salePrice];
        [ObjectUtil setLongLongValue:data key:@"startTime" val:priceRuleVo.startTime];
        [ObjectUtil setLongLongValue:data key:@"endTime" val:priceRuleVo.endTime];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:priceRuleVo.lastVer];
        
        return data;
    }
    return nil;
}

@end
