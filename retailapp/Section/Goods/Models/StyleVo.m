	//
//  GoodsStyleVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StyleVo.h"
#import "INameValueItem.h"
#import "StyleGoodsVo.h"
#import "AttributeValVo.h"
#import "MicroGoodsImageVo.h"
@implementation StyleVo

+(StyleVo*)convertToStyleVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        StyleVo* styleVo = [[StyleVo alloc] init];
        styleVo.styleId = [ObjectUtil getStringValue:dic key:@"styleId"];
        styleVo.styleName = [ObjectUtil getStringValue:dic key:@"styleName"];
        styleVo.upDownStatus = (int)[ObjectUtil getIntegerValue:dic key:@"upDownStatus"];
        styleVo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        styleVo.synShopId = [ObjectUtil getStringValue:dic key:@"synShopId"];
        styleVo.categoryId = [ObjectUtil getStringValue:dic key:@"categoryId"];
        styleVo.brandId = [ObjectUtil getStringValue:dic key:@"brandId"];
        styleVo.applySex = [ObjectUtil getShortValue:dic key:@"applySex"];
        styleVo.serialValId = [ObjectUtil getStringValue:dic key:@"serialValId"];
        styleVo.serial = [ObjectUtil getStringValue:dic key:@"serial"];
        styleVo.origin = [ObjectUtil getStringValue:dic key:@"origin"];
        styleVo.year = [ObjectUtil getStringValue:dic key:@"year"];
        styleVo.seasonValId = [ObjectUtil getStringValue:dic key:@"seasonValId"];
        styleVo.season = [ObjectUtil getStringValue:dic key:@"season"];
        styleVo.stage = [ObjectUtil getStringValue:dic key:@"stage"];
        styleVo.fabricValId = [ObjectUtil getStringValue:dic key:@"fabricValId"];
        styleVo.fabric = [ObjectUtil getStringValue:dic key:@"fabric"];
        styleVo.liningValId = [ObjectUtil getStringValue:dic key:@"liningValId"];
        styleVo.lining = [ObjectUtil getStringValue:dic key:@"lining"];
        styleVo.tag = [ObjectUtil getStringValue:dic key:@"tag"];
        styleVo.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
        styleVo.file = [ObjectUtil getStringValue:dic key:@"file"];
        styleVo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        styleVo.details = [ObjectUtil getStringValue:dic key:@"details"];

        styleVo.fileDeleteFlg = [ObjectUtil getShortValue:dic key:@"fileDeleteFlg"];
        styleVo.percentage = [ObjectUtil getDoubleValue:dic key:@"percentage"];
        styleVo.hasDegree = [ObjectUtil getNumberValue:dic key:@"hasDegree"];
        styleVo.isSales = [ObjectUtil getNumberValue:dic key:@"isSales"];
        styleVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        styleVo.createTime = [ObjectUtil getLonglongValue:dic key:@"createTime"];
        styleVo.spell = [ObjectUtil getStringValue:dic key:@"spell"];
        styleVo.categoryName = [ObjectUtil getStringValue:dic key:@"categoryName"];
        styleVo.brandName = [ObjectUtil getStringValue:dic key:@"brandName"];
        styleVo.unitName = [ObjectUtil getStringValue:dic key:@"unitName"];
        styleVo.unitId = [ObjectUtil getStringValue:dic key:@"unitId"];
//        styleVo.microShelveStatus = [ObjectUtil getStringValue:dic key:@"microShelveStatus"];
        styleVo.purchasePrice = [ObjectUtil getNumberValue:dic key:@"purchasePrice"];
        styleVo.memberPrice = [ObjectUtil getNumberValue:dic key:@"memberPrice"];
        styleVo.wholesalePrice = [ObjectUtil getNumberValue:dic key:@"wholesalePrice"];
        styleVo.retailPrice = [ObjectUtil getNumberValue:dic key:@"retailPrice"];
        styleVo.hangTagPrice = [ObjectUtil getNumberValue:dic key:@"hangTagPrice"];
        styleVo.prototypeValId = [ObjectUtil getStringValue:dic key:@"prototypeValId"];
        styleVo.auxiliaryValId = [ObjectUtil getStringValue:dic key:@"auxiliaryValId"];
        styleVo.prototype = [ObjectUtil getStringValue:dic key:@"prototype"];
        styleVo.auxiliary = [ObjectUtil getStringValue:dic key:@"auxiliary"];
        styleVo.microSaleStatus=[ObjectUtil getStringValue:dic key:@"microSaleStatus"];
        styleVo.isSpecial=[ObjectUtil getShortValue:dic key:@"isSpecial"];
        styleVo.spacialPrice=[ObjectUtil getDoubleValue:dic key:@"spacialPrice"];
        styleVo.weixinPrice=[ObjectUtil getDoubleValue:dic key:@"weixinPrice"];
        styleVo.spacialPriceStartTime=[ObjectUtil getLonglongValue:dic key:@"spacialPriceStartTime"];
        styleVo.spacialPriceEndTime=[ObjectUtil getLonglongValue:dic key:@"spacialPriceEndTime"];
        styleVo.salesStrategy=[ObjectUtil getShortValue:dic key:@"salesStrategy"];
        styleVo.salesType=[ObjectUtil getShortValue:dic key:@"salesType"];
        styleVo.weixinDiscountRate=[ObjectUtil getDoubleValue:dic key:@"weixinDiscountRate"];
        styleVo.singleDiscountConfigVal=[ObjectUtil getDoubleValue:dic key:@"singleDiscountConfigVal"];
        
        styleVo.attributeValVoList=[[NSMutableArray alloc]init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"attributeValVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"attributeValVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    [styleVo.attributeValVoList addObject:[AttributeValVo convertToAttributeValVo:dic1]];
                }
            }
        }
        
        styleVo.mainImageVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"mainImageVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"mainImageVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    [styleVo.mainImageVoList addObject:[MicroGoodsImageVo convertToMicroGoodsImageVo:dic1]];
                }
            }
        }
        
        styleVo.styleGoodsVoList = [[NSMutableArray alloc] init];
        
        if ([ObjectUtil isNotNull:[dic objectForKey:@"styleGoodsVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"styleGoodsVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    [styleVo.styleGoodsVoList addObject:[StyleGoodsVo convertToStyleGoodsVo:dic1]];
                }
            }
        }
        
        return styleVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(StyleVo *)styleVo
{
    if ([ObjectUtil isNotNull:styleVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"styleId" val:styleVo.styleId];
        [ObjectUtil setStringValue:data key:@"styleName" val:styleVo.styleName];
        [ObjectUtil setStringValue:data key:@"details" val:styleVo.details];
        [ObjectUtil setIntegerValue:data key:@"upDownStatus" val:styleVo.upDownStatus];
        [ObjectUtil setStringValue:data key:@"styleCode" val:styleVo.styleCode];
        [ObjectUtil setStringValue:data key:@"synShopId" val:styleVo.synShopId];
        [ObjectUtil setStringValue:data key:@"categoryId" val:styleVo.categoryId];
        [ObjectUtil setStringValue:data key:@"brandId" val:styleVo.brandId];
        [ObjectUtil setShortValue:data key:@"applySex" val:styleVo.applySex];
        [ObjectUtil setStringValue:data key:@"serialValId" val:styleVo.serialValId];
        [ObjectUtil setStringValue:data key:@"serial" val:styleVo.serial];
        [ObjectUtil setStringValue:data key:@"origin" val:styleVo.origin];
        [ObjectUtil setStringValue:data key:@"year" val:styleVo.year];
        [ObjectUtil setStringValue:data key:@"seasonValId" val:styleVo.seasonValId];
        [ObjectUtil setStringValue:data key:@"season" val:styleVo.season];
        [ObjectUtil setStringValue:data key:@"stage" val:styleVo.stage];
        [ObjectUtil setStringValue:data key:@"fabricValId" val:styleVo.fabricValId];
        [ObjectUtil setStringValue:data key:@"fabric" val:styleVo.fabric];
        [ObjectUtil setStringValue:data key:@"liningValId" val:styleVo.liningValId];
        [ObjectUtil setStringValue:data key:@"lining" val:styleVo.lining];
        [ObjectUtil setStringValue:data key:@"tag" val:styleVo.tag];
        [ObjectUtil setStringValue:data key:@"fileName" val:styleVo.fileName];
        [ObjectUtil setStringValue:data key:@"file" val:styleVo.file];
        [ObjectUtil setStringValue:data key:@"filePath" val:styleVo.filePath];
        [ObjectUtil setShortValue:data key:@"fileDeleteFlg" val:styleVo.fileDeleteFlg];
        [ObjectUtil setDoubleValue:data key:@"percentage" val:styleVo.percentage];
        [ObjectUtil setNumberValue:data key:@"hasDegree" val:styleVo.hasDegree];
        [ObjectUtil setNumberValue:data key:@"isSales" val:styleVo.isSales];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:styleVo.lastVer];
        [ObjectUtil setLongLongValue:data key:@"createTime" val:styleVo.createTime];
        [ObjectUtil setStringValue:data key:@"spell" val:styleVo.spell];
        [ObjectUtil setStringValue:data key:@"categoryName" val:styleVo.categoryName];
        [ObjectUtil setStringValue:data key:@"unitName" val:styleVo.unitName];
        [ObjectUtil setStringValue:data key:@"unitId" val:styleVo.unitId];
        [ObjectUtil setStringValue:data key:@"brandName" val:styleVo.brandName];
//        [ObjectUtil setStringValue:data key:@"microShelveStatus" val:styleVo.microShelveStatus];
//        [ObjectUtil setNumberValue:data key:@"purchasePrice" val:styleVo.purchasePrice];
        [ObjectUtil setNumberValue:data key:@"memberPrice" val:styleVo.memberPrice];
        [ObjectUtil setNumberValue:data key:@"wholesalePrice" val:styleVo.wholesalePrice];
        [ObjectUtil setNumberValue:data key:@"retailPrice" val:styleVo.retailPrice];
        [ObjectUtil setNumberValue:data key:@"hangTagPrice" val:styleVo.hangTagPrice];
        [ObjectUtil setStringValue:data key:@"prototypeValId" val:styleVo.prototypeValId];
        [ObjectUtil setStringValue:data key:@"auxiliaryValId" val:styleVo.auxiliaryValId];
        [ObjectUtil setStringValue:data key:@"prototype" val:styleVo.prototype];
        [ObjectUtil setStringValue:data key:@"auxiliary" val:styleVo.auxiliary];
        if (styleVo.styleGoodsVoList != nil && styleVo.styleGoodsVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (StyleGoodsVo* vo in styleVo.styleGoodsVoList) {
                [list addObject:[StyleGoodsVo getDictionaryData:vo]];
            }
            [data setValue:list forKey:@"styleGoodsVoList"];
        }
        
        return data;
    }
    return nil;
}

@end
