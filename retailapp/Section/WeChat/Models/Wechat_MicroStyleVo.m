//
//  Wechat_MicroStyleVo.m
//  retailapp
//
//  Created by zhangzt on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Wechat_MicroStyleVo.h"
#import "MicroStyleGoodsVo.h"
#import "MicroGoodsImageVo.h"
#import "AttributeValVo.h"
#import "ObjectUtil.h"

@implementation Wechat_MicroStyleVo

+(Wechat_MicroStyleVo*)convertToMicroGoodsVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        Wechat_MicroStyleVo* microStyleVo = [[Wechat_MicroStyleVo alloc] init];
        microStyleVo.styleId = [ObjectUtil getStringValue:dic key:@"styleId"];
        microStyleVo.saleStatus = [ObjectUtil getStringValue:dic key:@"saleStatus"];
//        microStyleVo.upDownStatus = [ObjectUtil getStringValue:dic key:@"upDownStatus"];
        microStyleVo.priority = [ObjectUtil getIntegerValue:dic key:@"priority"];
        microStyleVo.saleStrategy = [ObjectUtil getShortValue:dic key:@"saleStrategy"];
        microStyleVo.microPrice = [ObjectUtil getDoubleValue:dic key:@"microPrice"];
        microStyleVo.microDiscountRate = [ObjectUtil getDoubleValue:dic key:@"microDiscountRate"];
        microStyleVo.saleType = [ObjectUtil getShortValue:dic key:@"saleType"];
        microStyleVo.details = [ObjectUtil getStringValue:dic key:@"details"];
        microStyleVo.styleName = [ObjectUtil getStringValue:dic key:@"styleName"];
        microStyleVo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        microStyleVo.brandName = [ObjectUtil getStringValue:dic key:@"brandName"];
        microStyleVo.hangTagPrice = [ObjectUtil getDoubleValue:dic key:@"hangTagPrice"];
        microStyleVo.retailPrice = [ObjectUtil getDoubleValue:dic key:@"retailPrice"];
        microStyleVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        microStyleVo.singleDiscountConfigVal=[ObjectUtil getDoubleValue:dic key:@"singleDiscountConfigVal"];

        microStyleVo.attributeValVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"attributeValVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"attributeValVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    [microStyleVo.attributeValVoList addObject:[AttributeValVo convertToAttributeValVo:dic1]];
                }
            }
        }
        
        
        microStyleVo.goodsVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"goodsVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"goodsVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    [microStyleVo.goodsVoList addObject:[MicroStyleGoodsVo convertToMicroStyleGoodsVo:dic1]];
                }
            }
        }

        microStyleVo.mainImageVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"mainImageVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"mainImageVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    MicroGoodsImageVo *microGoodsImageVo = [MicroGoodsImageVo convertToMicroGoodsImageVo:dic1];
                    microGoodsImageVo.fileName = [NSString getImagePath:microGoodsImageVo.filePath];
                    [microStyleVo.mainImageVoList addObject:microGoodsImageVo];
                }
            }
        }
        
        microStyleVo.infoImageVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"infoImageVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"infoImageVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic2 in list) {
                    [microStyleVo.infoImageVoList addObject:[MicroGoodsImageVo convertToMicroGoodsImageVo:dic2]];
                }
            }
        }
        
        microStyleVo.colorImageVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"colorImageVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"colorImageVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic2 in list) {
                    [microStyleVo.colorImageVoList addObject:[MicroGoodsImageVo convertToMicroGoodsImageVo:dic2]];
                }
            }
        }
        
        return microStyleVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(Wechat_MicroStyleVo *)microStyleVo
{
    if ([ObjectUtil isNotNull:microStyleVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"styleId" val:microStyleVo.styleId];
        [ObjectUtil setStringValue:data key:@"saleStatus" val:microStyleVo.saleStatus];
//        [ObjectUtil setStringValue:data key:@"upDownStatus" val:microStyleVo.upDownStatus];
        [ObjectUtil setIntegerValue:data key:@"priority" val:microStyleVo.priority];
        [ObjectUtil setShortValue:data key:@"saleStrategy" val:microStyleVo.saleStrategy];
        [ObjectUtil setDoubleValue:data key:@"microPrice" val:microStyleVo.microPrice];
        [ObjectUtil setDoubleValue:data key:@"microDiscountRate" val:microStyleVo.microDiscountRate];
        [ObjectUtil setShortValue:data key:@"saleType" val:microStyleVo.saleType];
        [ObjectUtil setStringValue:data key:@"details" val:microStyleVo.details];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:microStyleVo.lastVer];
        [ObjectUtil setStringValue:data key:@"styleName" val:microStyleVo.styleName];
         [ObjectUtil setStringValue:data key:@"categoryId" val:microStyleVo.categoryId];
        [ObjectUtil setStringValue:data key:@"styleCode" val:microStyleVo.styleCode];
        [ObjectUtil setStringValue:data key:@"brandName" val:microStyleVo.brandName];
        [ObjectUtil setDoubleValue:data key:@"retailPrice" val:microStyleVo.retailPrice];
        [ObjectUtil setDoubleValue:data key:@"hangTagPrice" val:microStyleVo.hangTagPrice];
        
        if(microStyleVo.attributeValVoList !=nil && microStyleVo.attributeValVoList.count>0){
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (AttributeValVo *attValVo in microStyleVo.attributeValVoList) {
                [list addObject:[AttributeValVo getDictionaryData:attValVo]];
            }
            [data setValue:list forKey:@"attributeValVoList"];
        }
        
        if (microStyleVo.goodsVoList != nil && microStyleVo.goodsVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (MicroStyleGoodsVo* vo in microStyleVo.goodsVoList) {
                [list addObject:[MicroStyleGoodsVo getDictionaryData:vo]];
            }
            [data setValue:list forKey:@"goodsVoList"];
        }
      
    //    [data setValue:[NSNull null] forKey:@"goodsVoList"];
        
        if (microStyleVo.mainImageVoList != nil && microStyleVo.mainImageVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (MicroGoodsImageVo* vo in microStyleVo.mainImageVoList) {
                [list addObject:[MicroGoodsImageVo getDictionaryData:vo]];
            }
            [data setValue:list forKey:@"mainImageVoList"];
        }
        
//        if (microStyleVo.infoImageVoList != nil && microStyleVo.infoImageVoList.count > 0) {
            NSMutableArray* list1 = [[NSMutableArray alloc] init];
            for (MicroGoodsImageVo* vo in microStyleVo.infoImageVoList) {
                [list1 addObject:[MicroGoodsImageVo getDictionaryData:vo]];
            }
            [data setValue:list1 forKey:@"infoImageVoList"];
//        }
        
//        if (microStyleVo.colorImageVoList != nil && microStyleVo.colorImageVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (MicroGoodsImageVo* vo in microStyleVo.colorImageVoList) {
                if ([NSString isNotBlank:vo.fileName]) {
                    [list addObject:[MicroGoodsImageVo getDictionaryData:vo]];
                }
            }
            [data setValue:list forKey:@"colorImageVoList"];
//        }
        
        return data;
    }
    
    return nil;
}


@end
