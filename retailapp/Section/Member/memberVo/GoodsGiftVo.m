//
//  GoodsGiftVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsGiftVo.h"
#import "ObjectUtil.h"

@implementation GoodsGiftVo

+(GoodsGiftVo*)convertToGoodsGiftVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        GoodsGiftVo* goodsGiftVo = [[GoodsGiftVo alloc] init];
        goodsGiftVo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        goodsGiftVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        goodsGiftVo.barCode = [ObjectUtil getStringValue:dic key:@"barCode"];
        goodsGiftVo.innerCode = [ObjectUtil getStringValue:dic key:@"innerCode"];
        goodsGiftVo.point = [ObjectUtil getIntegerValue:dic key:@"point"];
        goodsGiftVo.number = [ObjectUtil getIntegerValue:dic key:@"number"];
        goodsGiftVo.price = [ObjectUtil getLonglongValue:dic key:@"price"];
        goodsGiftVo.picture = [ObjectUtil getStringValue:dic key:@"picture"];
        goodsGiftVo.goodsColor = [ObjectUtil getStringValue:dic key:@"goodsColor"];
        goodsGiftVo.goodsSize = [ObjectUtil getStringValue:dic key:@"goodsSize"];
                
        return goodsGiftVo;
    }
    
    return nil;
}

+ (NSDictionary*)getDictionaryData:(GoodsGiftVo *)goodsGiftVo
{
    if ([ObjectUtil isNotNull:goodsGiftVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"goodsId" val:goodsGiftVo.goodsId];
        [ObjectUtil setStringValue:data key:@"name" val:goodsGiftVo.name];
        [ObjectUtil setStringValue:data key:@"barCode" val:goodsGiftVo.barCode];
        [ObjectUtil setStringValue:data key:@"innerCode" val:goodsGiftVo.innerCode];
        [ObjectUtil setIntegerValue:data key:@"point" val:goodsGiftVo.point];
        [ObjectUtil setIntegerValue:data key:@"number" val:goodsGiftVo.number];
        [ObjectUtil setDoubleValue:data key:@"price" val:goodsGiftVo.price];
        [ObjectUtil setStringValue:data key:@"picture" val:goodsGiftVo.picture];
        [ObjectUtil setStringValue:data key:@"goodsColor" val:goodsGiftVo.goodsColor];
        [ObjectUtil setStringValue:data key:@"goodsSize" val:goodsGiftVo.goodsSize];
        return data;
    }
    return nil;
}

@end
