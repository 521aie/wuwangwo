//
//  SalesNpDiscountVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalesNpDiscountVo.h"
#import "DiscountGoodsVo.h"

@implementation SalesNpDiscountVo

+(SalesNpDiscountVo*)convertToSalesNpDiscountVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        SalesNpDiscountVo* salesNpDiscountVo = [[SalesNpDiscountVo alloc] init];
        salesNpDiscountVo.npDiscountId = [ObjectUtil getStringValue:dic key:@"npDiscountId"];
        salesNpDiscountVo.salesId = [ObjectUtil getStringValue:dic key:@"salesId"];
        salesNpDiscountVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        salesNpDiscountVo.exceedRate = [ObjectUtil getDoubleValue:dic key:@"exceedRate"];
        salesNpDiscountVo.goodsCount = [ObjectUtil getIntegerValue:dic key:@"goodsCount"];
        salesNpDiscountVo.groupType = [ObjectUtil getIntegerValue:dic key:@"groupType"];
        salesNpDiscountVo.goodsScope = [ObjectUtil getShortValue:dic key:@"goodsScope"];
        salesNpDiscountVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        salesNpDiscountVo.containStyleNum = [ObjectUtil getIntegerValue:dic key:@"containStyleNum"];
        salesNpDiscountVo.isDiscountCap = [ObjectUtil getShortValue:dic key:@"isDiscountCap"];
        salesNpDiscountVo.discountVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"discountVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"discountVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    [salesNpDiscountVo.discountVoList addObject:[DiscountGoodsVo convertToDiscountGoodsVo:dic1]];
                }
            }
        }

        return salesNpDiscountVo;
    }    
    return nil;
}

+(NSDictionary*)getDictionaryData:(SalesNpDiscountVo *)salesNpDiscountVo
{
    if ([ObjectUtil isNotNull:salesNpDiscountVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"npDiscountId" val:salesNpDiscountVo.npDiscountId];
        [ObjectUtil setStringValue:data key:@"salesId" val:salesNpDiscountVo.salesId];
        [ObjectUtil setStringValue:data key:@"name" val:salesNpDiscountVo.name];
        [ObjectUtil setDoubleValue:data key:@"exceedRate" val:salesNpDiscountVo.exceedRate];
        [ObjectUtil setIntegerValue:data key:@"goodsCount" val:salesNpDiscountVo.goodsCount];
        [ObjectUtil setIntegerValue:data key:@"groupType" val:salesNpDiscountVo.groupType];
        [ObjectUtil setShortValue:data key:@"goodsScope" val:salesNpDiscountVo.goodsScope];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:salesNpDiscountVo.lastVer];
        [ObjectUtil setIntegerValue:data key:@"containStyleNum" val:salesNpDiscountVo.containStyleNum];
        [ObjectUtil setShortValue:data key:@"isDiscountCap" val:salesNpDiscountVo.isDiscountCap];
        if (salesNpDiscountVo.discountVoList != nil && salesNpDiscountVo.discountVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (DiscountGoodsVo* vo in salesNpDiscountVo.discountVoList) {
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
            SalesNpDiscountVo* vo = [SalesNpDiscountVo convertToSalesNpDiscountVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}
@end
