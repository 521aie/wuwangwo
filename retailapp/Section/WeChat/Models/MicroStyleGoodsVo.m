//
//  MicroStyleGoodsVo.m
//  retailapp
//
//  Created by Jianyong Duan on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroStyleGoodsVo.h"

@implementation MicroStyleGoodsVo

+(MicroStyleGoodsVo*)convertToMicroStyleGoodsVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        MicroStyleGoodsVo* microStyleGoodsVo = [[MicroStyleGoodsVo alloc] init];
        microStyleGoodsVo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        microStyleGoodsVo.microPrice = [ObjectUtil getDoubleValue:dic key:@"microPrice"];
        microStyleGoodsVo.color = [ObjectUtil getStringValue:dic key:@"color"];
        microStyleGoodsVo.size = [ObjectUtil getStringValue:dic key:@"size"];
        microStyleGoodsVo.innerCode = [ObjectUtil getStringValue:dic key:@"innerCode"];
        return microStyleGoodsVo;
    }
    return nil;
}

+(NSDictionary*)getDictionaryData:(MicroStyleGoodsVo *)microStyleGoodsVo
{
    if ([ObjectUtil isNotNull:microStyleGoodsVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"goodsId" val:microStyleGoodsVo.goodsId];
        [ObjectUtil setDoubleValue:data key:@"microPrice" val:microStyleGoodsVo.microPrice];
        [ObjectUtil setStringValue:data key:@"color" val:microStyleGoodsVo.color];
        [ObjectUtil setStringValue:data key:@"size" val:microStyleGoodsVo.size];
        [ObjectUtil setStringValue:data key:@"innerCode" val:microStyleGoodsVo.innerCode];
        return data;
    }
    return nil;
}

@end
