//
//  SalesBindDiscountVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalesBindDiscountVo.h"
#import "DiscountGoodsVo.h"

@implementation SalesBindDiscountVo

+(SalesBindDiscountVo*)convertToSalesBindDiscountVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        SalesBindDiscountVo* salesBindDiscountVo = [[SalesBindDiscountVo alloc] init];
        salesBindDiscountVo.bindDiscountId = [ObjectUtil getStringValue:dic key:@"bindDiscountId"];
        salesBindDiscountVo.salesId = [ObjectUtil getStringValue:dic key:@"salesId"];
        salesBindDiscountVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        salesBindDiscountVo.goodsCount = [ObjectUtil getIntegerValue:dic key:@"goodsCount"];
        salesBindDiscountVo.groupType = [ObjectUtil getIntegerValue:dic key:@"groupType"];
        salesBindDiscountVo.goodsScope = [ObjectUtil getShortValue:dic key:@"goodsScope"];
        salesBindDiscountVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        salesBindDiscountVo.containStyleNum = [ObjectUtil getIntegerValue:dic key:@"containStyleNum"];
        salesBindDiscountVo.discountVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"discountVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"discountVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    [salesBindDiscountVo.discountVoList addObject:[DiscountGoodsVo convertToDiscountGoodsVo:dic1]];
                }
            }
        }
        
        return salesBindDiscountVo;
    }
    return nil;
}

+(NSDictionary*)getDictionaryData:(SalesBindDiscountVo *)salesBindDiscountVo
{
    if ([ObjectUtil isNotNull:salesBindDiscountVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"bindDiscountId" val:salesBindDiscountVo.bindDiscountId];
        [ObjectUtil setStringValue:data key:@"salesId" val:salesBindDiscountVo.salesId];
        [ObjectUtil setStringValue:data key:@"name" val:salesBindDiscountVo.name];
        [ObjectUtil setIntegerValue:data key:@"goodsCount" val:salesBindDiscountVo.goodsCount];
        [ObjectUtil setIntegerValue:data key:@"groupType" val:salesBindDiscountVo.groupType];
        [ObjectUtil setShortValue:data key:@"goodsScope" val:salesBindDiscountVo.goodsScope];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:salesBindDiscountVo.lastVer];
        [ObjectUtil setIntegerValue:data key:@"containStyleNum" val:salesBindDiscountVo.containStyleNum];
        if (salesBindDiscountVo.discountVoList != nil && salesBindDiscountVo.discountVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (DiscountGoodsVo* vo in salesBindDiscountVo.discountVoList) {
                [list addObject:[DiscountGoodsVo getDictionaryData:vo]];
            }
            [data setValue:list forKey:@"discountVoList"];
        }
        
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
            SalesBindDiscountVo* vo = [SalesBindDiscountVo convertToSalesBindDiscountVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

@end
