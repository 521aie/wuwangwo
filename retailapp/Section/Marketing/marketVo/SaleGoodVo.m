//
//  SaleGoodVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SaleGoodVo.h"
#import "GoodsSkuVo.h"

@implementation SaleGoodVo

+(SaleGoodVo*)convertToSaleGoodVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        SaleGoodVo* saleGoodVo = [[SaleGoodVo alloc] init];
        saleGoodVo.goodId = [ObjectUtil getStringValue:dic key:@"goodId"];
        saleGoodVo.goodCode = [ObjectUtil getStringValue:dic key:@"goodCode"];
        saleGoodVo.goodName = [ObjectUtil getStringValue:dic key:@"goodName"];
        saleGoodVo.goodPic = [ObjectUtil getStringValue:dic key:@"goodPic"];
        saleGoodVo.createTime = [ObjectUtil getIntegerValue:dic key:@"createTime"];
        saleGoodVo.goodsSkuList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"goodsSkuList"]]) {
            NSMutableArray* list = [dic objectForKey:@"goodsSkuList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    if ([ObjectUtil isNotNull:dic1]) {
                        [saleGoodVo.goodsSkuList addObject:[GoodsSkuVo convertToGoodsSkuVo:dic1]];
                    }
                }
            }
        }
        
        return saleGoodVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(SaleGoodVo *)saleGoodVo
{
    if ([ObjectUtil isNotNull:saleGoodVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"goodId" val:saleGoodVo.goodId];
        [ObjectUtil setStringValue:data key:@"goodCode" val:saleGoodVo.goodCode];
        [ObjectUtil setStringValue:data key:@"goodName" val:saleGoodVo.goodName];
        [ObjectUtil setStringValue:data key:@"goodPic" val:saleGoodVo.goodPic];
        [ObjectUtil setIntegerValue:data key:@"createTime" val:saleGoodVo.createTime];
        if (saleGoodVo.goodsSkuList != nil && saleGoodVo.goodsSkuList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (GoodsSkuVo* vo in saleGoodVo.goodsSkuList) {
                [list addObject:[GoodsSkuVo getDictionaryData:vo]];
            }
            [data setValue:list forKey:@"goodsSkuList"];
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
            SaleGoodVo* vo = [SaleGoodVo convertToSaleGoodVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

+ (NSMutableArray*)converToDicArr:(NSArray*)voList
{
    NSMutableArray* datas = nil;
    if ([ObjectUtil isNotEmpty:voList]) {
        datas = [NSMutableArray arrayWithCapacity:voList.count];
        for (SaleGoodVo* tempVo in voList) {
            NSDictionary* dic = [SaleGoodVo getDictionaryData:tempVo];
            [datas addObject:dic];
        }
    }
    return datas;
}

@end
