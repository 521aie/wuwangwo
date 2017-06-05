//
//  InstanceVo.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "InstanceVo.h"

@implementation InstanceVo
+ (InstanceVo*)converToVo:(NSDictionary*)dic {
    InstanceVo* instanceVo = [[InstanceVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        instanceVo.instanceId = [ObjectUtil getStringValue:dic key:@"id"];
        instanceVo.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        instanceVo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
        instanceVo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        instanceVo.orderId = [ObjectUtil getStringValue:dic key:@"orderId"];
        instanceVo.categoryId = [ObjectUtil getStringValue:dic key:@"categoryId"];
        instanceVo.originalGoodsName = [ObjectUtil getStringValue:dic key:@"originalGoodsName"];
        instanceVo.originalPurchasePrice = [ObjectUtil getDoubleValue:dic key:@"originalPurchasePrice"];
        instanceVo.accountNum = [ObjectUtil getDoubleValue:dic key:@"accountNum"];
        instanceVo.price = [ObjectUtil getDoubleValue:dic key:@"price"];
        instanceVo.sales_price = [ObjectUtil getDoubleValue:dic key:@"salesPrice"];
        instanceVo.supplyPrice = [ObjectUtil getDoubleValue:dic key:@"supplyPrice"];
        instanceVo.finalRatioFee = [ObjectUtil getDoubleValue:dic key:@"finalRatioFee"];
        instanceVo.finalRatio = [ObjectUtil getDoubleValue:dic key:@"finalRatio"];
        instanceVo.fee = [ObjectUtil getDoubleValue:dic key:@"fee"];
        instanceVo.ratioFee = [ObjectUtil getDoubleValue:dic key:@"ratioFee"];
        instanceVo.discountType = (int)[ObjectUtil getIntegerValue:dic key:@"discountType"];
        instanceVo.ratio = [ObjectUtil getDoubleValue:dic key:@"ratio"];
        
        NSDictionary *expansionDic = [dic objectForKey:@"instanceExpansion"];
        if ([ObjectUtil isNotNull:expansionDic]) {
            instanceVo.sku = [ObjectUtil getStringValue:expansionDic key:@"sku"];
            instanceVo.receiving_time = [ObjectUtil getStringValue:expansionDic key:@"receiving_time"];
            instanceVo.consumePoints = [ObjectUtil getStringValue:expansionDic key:@"consumePoints"];
            //服鞋取innerCode
            instanceVo.innerCode = [ObjectUtil getStringValue:expansionDic key:@"innerCode"];
            //商超取barCode
            instanceVo.barCode = [ObjectUtil getStringValue:expansionDic key:@"barCode"];
           
        }
        
    }
    
    return instanceVo;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList {
    if ([ObjectUtil isEmpty:sourceList]) {
        return nil;
    }
    
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            InstanceVo* instanceVo = [InstanceVo converToVo:dic];
            [dataList addObject:instanceVo];
        }
    }
    return dataList;
}

@end
