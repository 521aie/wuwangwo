//
//  ShopSalesVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopSalesVo.h"

@implementation ShopSalesVo

+(ShopSalesVo*)convertToShopSalesVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        ShopSalesVo* shopSalesVo = [[ShopSalesVo alloc] init];
        shopSalesVo.shopSaleId = [ObjectUtil getStringValue:dic key:@"shopSaleId"];
        shopSalesVo.salesId = [ObjectUtil getStringValue:dic key:@"salesId"];
        shopSalesVo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
        shopSalesVo.shopName = [ObjectUtil getStringValue:dic key:@"shopName"];
        shopSalesVo.shopCode = [ObjectUtil getStringValue:dic key:@"shopCode"];
        
        return shopSalesVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(ShopSalesVo *)shopSalesVo
{
    if ([ObjectUtil isNotNull:shopSalesVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"shopSaleId" val:shopSalesVo.shopSaleId];
        [ObjectUtil setStringValue:data key:@"salesId" val:shopSalesVo.salesId];
        [ObjectUtil setStringValue:data key:@"shopId" val:shopSalesVo.shopId];
        [ObjectUtil setStringValue:data key:@"shopName" val:shopSalesVo.shopName];
        [ObjectUtil setStringValue:data key:@"shopCode" val:shopSalesVo.shopCode];
        
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
            ShopSalesVo* vo = [ShopSalesVo convertToShopSalesVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

@end
