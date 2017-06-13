//
//  MicroGoodsVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroGoodsVo.h"
#import "ObjectUtil.h"
#import "MicroGoodsImageVo.h"

@implementation MicroGoodsVo

+(MicroGoodsVo*)convertToMicroGoodsVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        MicroGoodsVo* microGoodsVo = [[MicroGoodsVo alloc] init];
        microGoodsVo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
        microGoodsVo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        microGoodsVo.isSale = [ObjectUtil getStringValue:dic key:@"isSale"];
//        microGoodsVo.isShelves = [ObjectUtil getStringValue:dic key:@"isShelves"];
        microGoodsVo.priority = dic[@"priority"];
        microGoodsVo.salesStrategy = [ObjectUtil getShortValue:dic key:@"salesStrategy"];
        microGoodsVo.goodsName = [ObjectUtil getStringValue:dic key:@"goodsName"];
        microGoodsVo.brandName = [ObjectUtil getStringValue:dic key:@"brandName"];
        microGoodsVo.retailPrice = [ObjectUtil getDoubleValue:dic key:@"retailPrice"];
        microGoodsVo.weixinPrice = [ObjectUtil getDoubleValue:dic key:@"weixinPrice"];
        microGoodsVo.weixinDiscount = [ObjectUtil getDoubleValue:dic key:@"weixinDiscount"];
        microGoodsVo.barcode = [ObjectUtil getStringValue:dic key:@"barcode"];
        microGoodsVo.details = [ObjectUtil getStringValue:dic key:@"details"];
        microGoodsVo.goodsLable = [ObjectUtil getStringValue:dic key:@"goodsLable"];
        microGoodsVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        microGoodsVo.categoryId = [ObjectUtil getStringValue:dic key:@"categoryId"];
        
        microGoodsVo.mainImageVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"mainImageVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"mainImageVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    MicroGoodsImageVo *microGoodsImageVo = [MicroGoodsImageVo convertToMicroGoodsImageVo:dic1];
                    if (microGoodsImageVo) {
                        microGoodsImageVo.fileName = [NSString getImagePath:microGoodsImageVo.filePath];
                        [microGoodsVo.mainImageVoList addObject:microGoodsImageVo];
                    }
                }
            }
        }
        microGoodsVo.infoImageVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"infoImageVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"infoImageVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic2 in list) {
                    MicroGoodsImageVo *vo = [MicroGoodsImageVo convertToMicroGoodsImageVo:dic2];
                    if (vo) {
                         [microGoodsVo.infoImageVoList addObject:vo];
                    }
                }
            }
        }
        
        return microGoodsVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(MicroGoodsVo *)microGoodsVo
{
    if ([ObjectUtil isNotNull:microGoodsVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"shopId" val:microGoodsVo.shopId];
        [ObjectUtil setStringValue:data key:@"goodsId" val:microGoodsVo.goodsId];
        [ObjectUtil setStringValue:data key:@"isSale" val:microGoodsVo.isSale];
//        [ObjectUtil setStringValue:data key:@"isShelves" val:microGoodsVo.isShelves];
        [ObjectUtil setIntegerValue:data key:@"priority" val:microGoodsVo.priority.integerValue];
        [ObjectUtil setShortValue:data key:@"salesStrategy" val:microGoodsVo.salesStrategy];
        [ObjectUtil setStringValue:data key:@"goodsName" val:microGoodsVo.goodsName];
        [ObjectUtil setStringValue:data key:@"brandName" val:microGoodsVo.brandName];
        [ObjectUtil setDoubleValue:data key:@"retailPrice" val:microGoodsVo.retailPrice];
        [ObjectUtil setDoubleValue:data key:@"weixinPrice" val:microGoodsVo.weixinPrice];
        [ObjectUtil setDoubleValue:data key:@"weixinDiscount" val:microGoodsVo.weixinDiscount];
        [ObjectUtil setStringValue:data key:@"barcode" val:microGoodsVo.barcode];
        [ObjectUtil setStringValue:data key:@"details" val:microGoodsVo.details];
        [ObjectUtil setStringValue:data key:@"goodsLable" val:microGoodsVo.goodsLable];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:microGoodsVo.lastVer];
        [ObjectUtil setStringValue:data key:@"categoryId" val:microGoodsVo.categoryId];
        if (microGoodsVo.mainImageVoList != nil && microGoodsVo.mainImageVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (MicroGoodsImageVo* vo in microGoodsVo.mainImageVoList) {
                [list addObject:[MicroGoodsImageVo getDictionaryData:vo]];
            }
            [data setValue:list forKey:@"mainImageVoList"];
        }
        
        if (microGoodsVo.infoImageVoList != nil && microGoodsVo.infoImageVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (MicroGoodsImageVo* vo in microGoodsVo.infoImageVoList) {
                [list addObject:[MicroGoodsImageVo getDictionaryData:vo]];
            }
            [data setValue:list forKey:@"infoImageVoList"];
        }
   
        return data;
    }
    
    return nil;
}

@end
