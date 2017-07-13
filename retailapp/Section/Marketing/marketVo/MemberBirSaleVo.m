//
//  MemberBirSaleVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberBirSaleVo.h"

@implementation MemberBirSaleVo

+(MemberBirSaleVo*)convertToMemberBirSaleVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        MemberBirSaleVo* memberBirSaleVo = [[MemberBirSaleVo alloc] init];
        memberBirSaleVo.meBirSaleId = [ObjectUtil getStringValue:dic key:@"meBirSaleId"];
        memberBirSaleVo.priceScheme = [ObjectUtil getShortValue:dic key:@"priceScheme"];
        memberBirSaleVo.status = [ObjectUtil getShortValue:dic key:@"status"];
        memberBirSaleVo.rate = [ObjectUtil getDoubleValue:dic key:@"rate"];
        memberBirSaleVo.goodsCount = [ObjectUtil getIntegerValue:dic key:@"goodsCount"];
        memberBirSaleVo.purchaseNumber = [ObjectUtil getIntegerValue:dic key:@"purchaseNumber"];
        memberBirSaleVo.validityType = [ObjectUtil getShortValue:dic key:@"validityType"];
        memberBirSaleVo.birthdayBeforeDays = [ObjectUtil getIntegerValue:dic key:@"birthdayBeforeDays"];
        memberBirSaleVo.birthdayAfterDays = [ObjectUtil getIntegerValue:dic key:@"birthdayAfterDays"];
        memberBirSaleVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        
        return memberBirSaleVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(MemberBirSaleVo *)memberBirSaleVo
{
    if ([ObjectUtil isNotNull:memberBirSaleVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"meBirSaleId" val:memberBirSaleVo.meBirSaleId];
        [ObjectUtil setShortValue:data key:@"priceScheme" val:memberBirSaleVo.priceScheme];
        [ObjectUtil setShortValue:data key:@"status" val:memberBirSaleVo.status];
        [ObjectUtil setDoubleValue:data key:@"rate" val:memberBirSaleVo.rate];
        [ObjectUtil setIntegerValue:data key:@"goodsCount" val:memberBirSaleVo.goodsCount];
        [ObjectUtil setIntegerValue:data key:@"purchaseNumber" val:memberBirSaleVo.purchaseNumber];
        [ObjectUtil setShortValue:data key:@"validityType" val:memberBirSaleVo.validityType];
        [ObjectUtil setIntegerValue:data key:@"birthdayBeforeDays" val:memberBirSaleVo.birthdayBeforeDays];
        [ObjectUtil setIntegerValue:data key:@"birthdayAfterDays" val:memberBirSaleVo.birthdayAfterDays];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:memberBirSaleVo.lastVer];
        
        return data;
    }
    return nil;
}

@end
