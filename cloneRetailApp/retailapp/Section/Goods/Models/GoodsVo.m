//
//  GoodsVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsVo.h"
#import "ObjectUtil.h"

@implementation GoodsVo

+(GoodsVo*)convertToGoodsVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        GoodsVo* goodsVo = [[GoodsVo alloc] init];
        goodsVo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        goodsVo.goodsName = [ObjectUtil getStringValue:dic key:@"goodsName"];
        goodsVo.upDownStatus = [ObjectUtil getShortValue:dic key:@"upDownStatus"];
        goodsVo.barCode = [ObjectUtil getStringValue:dic key:@"barCode"];
        goodsVo.innerCode = [ObjectUtil getStringValue:dic key:@"innerCode"];
        goodsVo.type = [ObjectUtil getShortValue:dic key:@"type"];
        goodsVo.purchasePrice = [ObjectUtil getDoubleValue:dic key:@"purchasePrice"];
        goodsVo.memberPrice = [ObjectUtil getDoubleValue:dic key:@"memberPrice"];
        goodsVo.wholesalePrice = [ObjectUtil getDoubleValue:dic key:@"wholesalePrice"];
        goodsVo.retailPrice = [ObjectUtil getDoubleValue:dic key:@"retailPrice"];
        goodsVo.number = [ObjectUtil getNumberValue:dic key:@"number"];
        goodsVo.synShopId = [ObjectUtil getStringValue:dic key:@"synShopId"];
        goodsVo.shortCode = [ObjectUtil getStringValue:dic key:@"shortCode"];
        goodsVo.spell = [ObjectUtil getStringValue:dic key:@"spell"];
        goodsVo.categoryId = [ObjectUtil getStringValue:dic key:@"categoryId"];
        goodsVo.categoryName = [ObjectUtil getStringValue:dic key:@"categoryName"];
        goodsVo.specification = [ObjectUtil getStringValue:dic key:@"specification"];
        goodsVo.brandId = [ObjectUtil getStringValue:dic key:@"brandId"];
        goodsVo.brandName = [ObjectUtil getStringValue:dic key:@"brandName"];
        goodsVo.origin = [ObjectUtil getStringValue:dic key:@"origin"];
        goodsVo.period = [ObjectUtil getNumberValue:dic key:@"period"];
        goodsVo.percentage = [ObjectUtil getDoubleValue:dic key:@"percentage"];
        goodsVo.nowStore = [ObjectUtil getNumberValue:dic key:@"nowStore"];
        goodsVo.hasDegree = [ObjectUtil getNumberValue:dic key:@"hasDegree"];
        goodsVo.isSales = [ObjectUtil getNumberValue:dic key:@"isSales"];
        goodsVo.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
        goodsVo.file = [ObjectUtil getStringValue:dic key:@"file"];
        goodsVo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        goodsVo.createTime = [ObjectUtil getLonglongValue:dic key:@"createTime"];
        goodsVo.baseId = [ObjectUtil getStringValue:dic key:@"baseId"];
        goodsVo.unitId = [ObjectUtil getStringValue:dic key:@"unitId"];
        goodsVo.memo = [ObjectUtil getStringValue:dic key:@"memo"];
        goodsVo.microShelveStatus = [ObjectUtil getStringValue:dic key:@"microShelveStatus"];
        goodsVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        goodsVo.splitStore = [ObjectUtil getNumberValue:dic key:@"splitStore"];
        goodsVo.unitName = [ObjectUtil getStringValue:dic key:@"unitName"];
        goodsVo.unitId = [ObjectUtil getStringValue:dic key:@"unitId"];
        goodsVo.powerPrice = [ObjectUtil getNumberValue:dic key:@"powerPrice"];
        goodsVo.latestReturnPrice = [ObjectUtil getDoubleValue:dic key:@"latestReturnPrice"];
        goodsVo.priceType = [ObjectUtil getIntegerValue:dic key:@"priceType"];
        return goodsVo;
    }
    
    return nil;
}

+ (NSDictionary*)getDictionaryData:(GoodsVo *)goodsVo
{
    if ([ObjectUtil isNotNull:goodsVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"goodsId" val:goodsVo.goodsId];
        [ObjectUtil setStringValue:data key:@"goodsName" val:goodsVo.goodsName];
        [ObjectUtil setShortValue:data key:@"upDownStatus" val:goodsVo.upDownStatus];
        [ObjectUtil setStringValue:data key:@"barCode" val:goodsVo.barCode];
        [ObjectUtil setStringValue:data key:@"innerCode" val:goodsVo.innerCode];
        [ObjectUtil setShortValue:data key:@"type" val:goodsVo.type];
//        [ObjectUtil setDoubleValue:data key:@"purchasePrice" val:goodsVo.purchasePrice];
        [ObjectUtil setDoubleValue:data key:@"memberPrice" val:goodsVo.memberPrice];
        [ObjectUtil setDoubleValue:data key:@"wholesalePrice" val:goodsVo.wholesalePrice];
        [ObjectUtil setDoubleValue:data key:@"retailPrice" val:goodsVo.retailPrice];
        [ObjectUtil setNumberValue:data key:@"number" val:goodsVo.number];
        [ObjectUtil setNumberValue:data key:@"nowStore" val:goodsVo.nowStore];
        [ObjectUtil setStringValue:data key:@"synShopId" val:goodsVo.synShopId];
        [ObjectUtil setStringValue:data key:@"shortCode" val:goodsVo.shortCode];
        [ObjectUtil setStringValue:data key:@"spell" val:goodsVo.spell];
        [ObjectUtil setStringValue:data key:@"categoryId" val:goodsVo.categoryId];
        [ObjectUtil setStringValue:data key:@"categoryName" val:goodsVo.categoryName];
        [ObjectUtil setStringValue:data key:@"specification" val:goodsVo.specification];
        [ObjectUtil setStringValue:data key:@"brandId" val:goodsVo.brandId];
        [ObjectUtil setStringValue:data key:@"brandName" val:goodsVo.brandName];
        [ObjectUtil setStringValue:data key:@"origin" val:goodsVo.origin];
        [ObjectUtil setNumberValue:data key:@"period" val:goodsVo.period];
        [ObjectUtil setDoubleValue:data key:@"percentage" val:goodsVo.percentage];
        [ObjectUtil setNumberValue:data key:@"hasDegree" val:goodsVo.hasDegree];
        [ObjectUtil setNumberValue:data key:@"isSales" val:goodsVo.isSales];
        [ObjectUtil setStringValue:data key:@"fileName" val:goodsVo.fileName];
        [ObjectUtil setStringValue:data key:@"file" val:goodsVo.file];
        [ObjectUtil setStringValue:data key:@"filePath" val:goodsVo.filePath];
        [ObjectUtil setLongLongValue:data key:@"createTime" val:goodsVo.createTime];
        [ObjectUtil setStringValue:data key:@"baseId" val:goodsVo.baseId];
        [ObjectUtil setStringValue:data key:@"unitId" val:goodsVo.unitId];
        [ObjectUtil setStringValue:data key:@"memo" val:goodsVo.memo];
        [ObjectUtil setStringValue:data key:@"microShelveStatus" val:goodsVo.microShelveStatus];
        [ObjectUtil setStringValue:data key:@"unitId" val:goodsVo.unitId];
        [ObjectUtil setStringValue:data key:@"unitName" val:goodsVo.unitName];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:goodsVo.lastVer];
        [ObjectUtil setIntegerValue:data key:@"fileDeleteFlg" val:goodsVo.fileDeleteFlg.integerValue];
        [ObjectUtil setNumberValue:data key:@"powerPrice" val:goodsVo.powerPrice];
        [ObjectUtil setIntegerValue:data key:@"priceType" val:goodsVo.priceType];
        
        return data;
    }
    return nil;
    
}

+ (NSMutableArray *)converToDicArr:(NSMutableArray *)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
         NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (GoodsVo *goodsVo in sourceList) {
            NSDictionary *dic = [GoodsVo getDictionaryData:goodsVo];
            [datas addObject:dic];
        }
        return datas;
    }
    return [NSMutableArray array];
}

@end
