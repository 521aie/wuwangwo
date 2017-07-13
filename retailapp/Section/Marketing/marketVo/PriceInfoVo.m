//
//  PriceInfoVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PriceInfoVo.h"
#import "GoodsSkuVo.h"

@implementation PriceInfoVo

+(PriceInfoVo*)convertToPriceInfoVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        PriceInfoVo* priceInfoVo = [[PriceInfoVo alloc] init];
        priceInfoVo.priceId = [ObjectUtil getStringValue:dic key:@"priceId"];
        priceInfoVo.goodsName = [ObjectUtil getStringValue:dic key:@"goodsName"];
        priceInfoVo.goodsPic = [ObjectUtil getStringValue:dic key:@"goodPic"];
        priceInfoVo.goodsId = [ObjectUtil getStringValue:dic key:@"goodId"];
        priceInfoVo.innerCode = [ObjectUtil getStringValue:dic key:@"innerCode"];
        priceInfoVo.barCode = [ObjectUtil getStringValue:dic key:@"barCode"];
        priceInfoVo.styleId = [ObjectUtil getStringValue:dic key:@"styleId"];
        priceInfoVo.styleName = [ObjectUtil getStringValue:dic key:@"styleName"];
        priceInfoVo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        priceInfoVo.stylePic = [ObjectUtil getStringValue:dic key:@"stylePic"];
        priceInfoVo.price = [ObjectUtil getDoubleValue:dic key:@"price"];
        priceInfoVo.discount = [ObjectUtil getDoubleValue:dic key:@"discount"];
        priceInfoVo.retailPrice = [ObjectUtil getDoubleValue:dic key:@"retailPrice"];
        priceInfoVo.hangTagPrice = [ObjectUtil getDoubleValue:dic key:@"hangTagPrice"];
        priceInfoVo.goodsSkuList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"goodsSkuList"]]) {
            NSMutableArray* list = [dic objectForKey:@"goodsSkuList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    if ([ObjectUtil isNotNull:dic1]) {
                        [priceInfoVo.goodsSkuList addObject:[GoodsSkuVo convertToGoodsSkuVo:dic1]];
                    }
                }
            }
        }
        
        return priceInfoVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(PriceInfoVo *)priceInfoVo
{
    if ([ObjectUtil isNotNull:priceInfoVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"priceId" val:priceInfoVo.priceId];
        [ObjectUtil setStringValue:data key:@"goodsName" val:priceInfoVo.goodsName];
        [ObjectUtil setStringValue:data key:@"goodPic" val:priceInfoVo.goodsPic];
        [ObjectUtil setStringValue:data key:@"goodId" val:priceInfoVo.goodsId];
        [ObjectUtil setStringValue:data key:@"innerCode" val:priceInfoVo.innerCode];
        [ObjectUtil setStringValue:data key:@"barCode" val:priceInfoVo.barCode];
        [ObjectUtil setStringValue:data key:@"styleId" val:priceInfoVo.styleId];
        [ObjectUtil setStringValue:data key:@"styleName" val:priceInfoVo.styleName];
        [ObjectUtil setStringValue:data key:@"styleCode" val:priceInfoVo.styleCode];
        [ObjectUtil setStringValue:data key:@"stylePic" val:priceInfoVo.stylePic];
        [ObjectUtil setDoubleValue:data key:@"price" val:priceInfoVo.price];
        [ObjectUtil setDoubleValue:data key:@"discount" val:priceInfoVo.discount];
        [ObjectUtil setDoubleValue:data key:@"retailPrice" val:priceInfoVo.retailPrice];
        [ObjectUtil setDoubleValue:data key:@"hangTagPrice" val:priceInfoVo.hangTagPrice];
        if (priceInfoVo.goodsSkuList != nil && priceInfoVo.goodsSkuList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (GoodsSkuVo* vo in priceInfoVo.goodsSkuList) {
                [list addObject:[GoodsSkuVo getDictionaryData:vo]];
            }
            [data setValue:list forKey:@"goodsSkuList"];
        }
        
        return data;
    }
    return nil;
}

+ (NSMutableArray *)converToArr:(NSArray*)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary *dic in sourceList) {
            PriceInfoVo *vo =[PriceInfoVo convertToPriceInfoVo:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}

@end
