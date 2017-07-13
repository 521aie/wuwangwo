//
//  GoodsSkuVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsSkuVo.h"

@implementation GoodsSkuVo

+(GoodsSkuVo*)convertToGoodsSkuVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        GoodsSkuVo* goodsSkuVo = [[GoodsSkuVo alloc] init];
        goodsSkuVo.attributeNameId = [ObjectUtil getStringValue:dic key:@"attributeNameId"];
        goodsSkuVo.attributeName = [ObjectUtil getStringValue:dic key:@"attributeName"];
        goodsSkuVo.attributeValId = [ObjectUtil getStringValue:dic key:@"attributeValId"];
        goodsSkuVo.attributeVal = [ObjectUtil getStringValue:dic key:@"attributeVal"];
        goodsSkuVo.skuVal = [ObjectUtil getStringValue:dic key:@"skuVal"];
        goodsSkuVo.attributeType = [ObjectUtil getShortValue:dic key:@"attributeType"];
        goodsSkuVo.attributeCode = [ObjectUtil getStringValue:dic key:@"attributeCode"];

        return goodsSkuVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(GoodsSkuVo *)goodsSkuVo
{
    if ([ObjectUtil isNotNull:goodsSkuVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"attributeNameId" val:goodsSkuVo.attributeNameId];
        [ObjectUtil setStringValue:data key:@"attributeName" val:goodsSkuVo.attributeName];
        [ObjectUtil setStringValue:data key:@"attributeValId" val:goodsSkuVo.attributeValId];
        [ObjectUtil setStringValue:data key:@"attributeVal" val:goodsSkuVo.attributeVal];
        [ObjectUtil setStringValue:data key:@"skuVal" val:goodsSkuVo.skuVal];
        [ObjectUtil setShortValue:data key:@"attributeType" val:goodsSkuVo.attributeType];
        [ObjectUtil setStringValue:data key:@"attributeCode" val:goodsSkuVo.attributeCode];
        return data;
    }
    
    return nil;
}

+ (NSMutableArray *)convertToDicListFromArr:(NSMutableArray *)array {
    if ([ObjectUtil isNotEmpty:array]) {
        NSMutableArray *dicList = [[NSMutableArray alloc] init];
        
        for (GoodsSkuVo *goodsSkuVo in array) {
            NSDictionary *dic  = [GoodsSkuVo getDictionaryData:goodsSkuVo];
            [dicList addObject:dic];
        }
        return dicList;
    }
    return nil;
}

@end
