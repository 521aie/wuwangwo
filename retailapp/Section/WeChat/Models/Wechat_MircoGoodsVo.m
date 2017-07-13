//
//  Wechat_MicroStyleVo.m
//  retailapp
//
//  Created by zhangzt on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Wechat_MircoGoodsVo.h"
#import "MicroStyleGoodsVo.h"
#import "MicroGoodsImageVo.h"
#import "ObjectUtil.h"

@implementation Wechat_MircoGoodsVo

+(Wechat_MircoGoodsVo*)convertToMicroGoodsVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        Wechat_MircoGoodsVo* microGoodsVo = [[Wechat_MircoGoodsVo alloc] init];        
        microGoodsVo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        microGoodsVo.isSale = [ObjectUtil getStringValue:dic key:@"isSale"];
        microGoodsVo.isShelves = [ObjectUtil getStringValue:dic key:@"isShelves"];
        microGoodsVo.priority = [ObjectUtil getIntegerValue:dic key:@"priority"];
        microGoodsVo.salesStrategy = [ObjectUtil getShortValue:dic key:@"salesStrategy"];
        microGoodsVo.weixinPrice = [ObjectUtil getDoubleValue:dic key:@"weixinPrice"];
        microGoodsVo.weixinDiscount = [ObjectUtil getDoubleValue:dic key:@"weixinDiscount"];
        microGoodsVo.details = [ObjectUtil getStringValue:dic key:@"details"];
        microGoodsVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];

        /*
        microGoodsVo.goodsVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"goodsVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"goodsVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    [microStyleVo.goodsVoList addObject:[MicroStyleGoodsVo convertToMicroStyleGoodsVo:dic1]];
                }
            }
        }
         */
        
        microGoodsVo.mainImageVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"mainImageVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"mainImageVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    MicroGoodsImageVo *vo = [MicroGoodsImageVo convertToMicroGoodsImageVo:dic1];
                    if (vo) {
                        [microGoodsVo.mainImageVoList addObject:vo];
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

+(NSDictionary*)getDictionaryData:(Wechat_MircoGoodsVo *)microGoodsVo
{
    if ([ObjectUtil isNotNull:microGoodsVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"goodsId" val:microGoodsVo.goodsId];
        [ObjectUtil setStringValue:data key:@"isSale" val:microGoodsVo.isSale];
        [ObjectUtil setStringValue:data key:@"isShelves" val:microGoodsVo.isShelves];
        [ObjectUtil setIntegerValue:data key:@"priority" val:microGoodsVo.priority];
        [ObjectUtil setShortValue:data key:@"salesStrategy" val:microGoodsVo.salesStrategy];
        [ObjectUtil setDoubleValue:data key:@"weixinPrice" val:microGoodsVo.weixinPrice];
        [ObjectUtil setDoubleValue:data key:@"weixinDiscount" val:microGoodsVo.weixinDiscount];
        [ObjectUtil setStringValue:data key:@"details" val:microGoodsVo.details];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:microGoodsVo.lastVer];
        [ObjectUtil setStringValue:data key:@"goodsName" val:microGoodsVo.goodsName];
        [ObjectUtil setStringValue:data key:@"goodsName" val:microGoodsVo.goodsName];
        [ObjectUtil setStringValue:data key:@"brandName" val:microGoodsVo.brandName];
        [ObjectUtil setDoubleValue:data key:@"retailPrice" val:microGoodsVo.retailPrice];
        
        /*
        if (microGoodsVo.goodsVoList != nil && microGoodsVo.goodsVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (microGoodsVo* vo in microGoodsVo.goodsVoList) {
                [list addObject:[MicroStyleGoodsVo getDictionaryData:vo]];
            }
            [data setValue:[NSNull null] forKey:@"goodsVoList"];
        }
         */
        
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
        
        
        /*
        if (microGoodsVo.colorImageVoList != nil && microGoodsVo.colorImageVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (MicroGoodsImageVo* vo in microGoodsVo.colorImageVoList) {
                [list addObject:[MicroGoodsImageVo getDictionaryData:vo]];
            }
            [data setValue:list forKey:@"colorImageVoList"];
        }
         */
        
        return data;
    }
    
    return nil;
}

@end
