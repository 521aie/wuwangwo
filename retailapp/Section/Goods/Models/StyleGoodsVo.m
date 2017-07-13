//
//  StyleGoodsVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StyleGoodsVo.h"
#import "GoodsSkuVo.h"

@implementation StyleGoodsVo

+(StyleGoodsVo*)convertToStyleGoodsVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        StyleGoodsVo* styleGoodsVo = [[StyleGoodsVo alloc] init];
        styleGoodsVo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        styleGoodsVo.innerCode = [ObjectUtil getStringValue:dic key:@"innerCode"];
        styleGoodsVo.barCode = [ObjectUtil getStringValue:dic key:@"barCode"];
        styleGoodsVo.skcCode = [ObjectUtil getStringValue:dic key:@"skcCode"];
        styleGoodsVo.purchasePrice = [ObjectUtil getDoubleValue:dic key:@"purchasePrice"];
        styleGoodsVo.hangTagPrice = [ObjectUtil getDoubleValue:dic key:@"hangTagPrice"];
        styleGoodsVo.memberPrice = [ObjectUtil getDoubleValue:dic key:@"memberPrice"];
        styleGoodsVo.wholesalePrice = [ObjectUtil getDoubleValue:dic key:@"wholesalePrice"];
        styleGoodsVo.retailPrice = [ObjectUtil getDoubleValue:dic key:@"retailPrice"];
        styleGoodsVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        styleGoodsVo.createTime = [ObjectUtil getIntegerValue:dic key:@"createTime"];
        styleGoodsVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        styleGoodsVo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        styleGoodsVo.goodsSkuVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"goodsSkuVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"goodsSkuVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    [styleGoodsVo.goodsSkuVoList addObject:[GoodsSkuVo convertToGoodsSkuVo:dic1]];
                }
            }
        }
        
        return styleGoodsVo;
    }
    return nil;
}

+(NSDictionary*)getDictionaryData:(StyleGoodsVo *)styleGoodsVo
{
    if ([ObjectUtil isNotNull:styleGoodsVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"goodsId" val:styleGoodsVo.goodsId];
        [ObjectUtil setStringValue:data key:@"innerCode" val:styleGoodsVo.innerCode];
        [ObjectUtil setStringValue:data key:@"barCode" val:styleGoodsVo.barCode];
        [ObjectUtil setStringValue:data key:@"skcCode" val:styleGoodsVo.skcCode];
        [ObjectUtil setDoubleValue:data key:@"purchasePrice" val:styleGoodsVo.purchasePrice];
        [ObjectUtil setDoubleValue:data key:@"hangTagPrice" val:styleGoodsVo.hangTagPrice];
        [ObjectUtil setDoubleValue:data key:@"memberPrice" val:styleGoodsVo.memberPrice];
        [ObjectUtil setDoubleValue:data key:@"wholesalePrice" val:styleGoodsVo.wholesalePrice];
        [ObjectUtil setDoubleValue:data key:@"retailPrice" val:styleGoodsVo.retailPrice];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:styleGoodsVo.lastVer];
        [ObjectUtil setStringValue:data key:@"name" val:styleGoodsVo.name];
        [ObjectUtil setStringValue:data key:@"filePath" val:styleGoodsVo.filePath];
        if (styleGoodsVo.goodsSkuVoList != nil && styleGoodsVo.goodsSkuVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (GoodsSkuVo* vo in styleGoodsVo.goodsSkuVoList) {
                [list addObject:[GoodsSkuVo getDictionaryData:vo]];
            }
            [data setValue:list forKey:@"goodsSkuVoList"];
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
            StyleGoodsVo* vo = [StyleGoodsVo convertToStyleGoodsVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

@end
