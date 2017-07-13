//
//  DiscountGoodsVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DiscountGoodsVo.h"

@implementation DiscountGoodsVo

+(DiscountGoodsVo*)convertToDiscountGoodsVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        DiscountGoodsVo* discountGoodsVo = [[DiscountGoodsVo alloc] init];
        discountGoodsVo.discountId = [ObjectUtil getStringValue:dic key:@"discountId"];
        discountGoodsVo.npiecesDiscountId = [ObjectUtil getStringValue:dic key:@"npiecesDiscountId"];
        discountGoodsVo.rate = [ObjectUtil getDoubleValue:dic key:@"rate"];
        discountGoodsVo.count = [ObjectUtil getIntegerValue:dic key:@"count"];
        discountGoodsVo.sortCode = [ObjectUtil getIntegerValue:dic key:@"sortCode"];
        
        return discountGoodsVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(DiscountGoodsVo *)discountGoodsVo
{
    if ([ObjectUtil isNotNull:discountGoodsVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"discountId" val:discountGoodsVo.discountId];
        [ObjectUtil setStringValue:data key:@"npiecesDiscountId" val:discountGoodsVo.npiecesDiscountId];
        [ObjectUtil setDoubleValue:data key:@"rate" val:discountGoodsVo.rate];
        [ObjectUtil setIntegerValue:data key:@"count" val:discountGoodsVo.count];
        [ObjectUtil setIntegerValue:data key:@"sortCode" val:discountGoodsVo.sortCode];
        
        return data;
    }
    return nil;
}

+ (NSMutableArray*)converToDicArr:(NSArray*)voList
{
    NSMutableArray* datas = nil;
    if ([ObjectUtil isNotEmpty:voList]) {
        datas = [NSMutableArray arrayWithCapacity:voList.count];
        for (DiscountGoodsVo* tempVo in voList) {
            NSDictionary* dic = [DiscountGoodsVo getDictionaryData:tempVo];
            [datas addObject:dic];
        }
    }
    return datas;
}

@end
