//
//  MicroWechatGoodsVo.m
//  retailapp
//
//  Created by yanguangfu on 15/11/16.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroWechatGoodsVo.h"
#import "ObjectUtil.h"
@implementation MicroWechatGoodsVo
+ (MicroWechatGoodsVo *)convertToMicroWechatGoodsVo:(NSDictionary *)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        MicroWechatGoodsVo* goodsVo = [[MicroWechatGoodsVo alloc] init];
        
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
        goodsVo.number = [ObjectUtil getDoubleValue:dic key:@"number"];
        goodsVo.synShopId = [ObjectUtil getStringValue:dic key:@"synShopId"];
        goodsVo.shortCode = [ObjectUtil getStringValue:dic key:@"shortCode"];
        goodsVo.spell = [ObjectUtil getStringValue:dic key:@"spell"];
        goodsVo.categoryId = [ObjectUtil getStringValue:dic key:@"categoryId"];
        goodsVo.categoryName = [ObjectUtil getStringValue:dic key:@"categoryName"];
        goodsVo.Specification = [ObjectUtil getStringValue:dic key:@"Specification"];
        goodsVo.brandId = [ObjectUtil getStringValue:dic key:@"brandId"];
        goodsVo.brandName = [ObjectUtil getStringValue:dic key:@"brandName"];
        goodsVo.origin = [ObjectUtil getStringValue:dic key:@"origin"];
        goodsVo.period = [ObjectUtil getIntegerValue:dic key:@"period"];
        goodsVo.percentage = [ObjectUtil getDoubleValue:dic key:@"percentage"];
        goodsVo.hasDegree = [ObjectUtil getShortValue:dic key:@"hasDegree"];
        goodsVo.isSales = [ObjectUtil getShortValue:dic key:@"isSales"];
        goodsVo.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
        goodsVo.file = [ObjectUtil getStringValue:dic key:@"file"];
        goodsVo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        goodsVo.createTime = [ObjectUtil getLonglongValue:dic key:@"createTime"];
        goodsVo.baseId = [ObjectUtil getStringValue:dic key:@"baseId"];
        goodsVo.unitId = [ObjectUtil getStringValue:dic key:@"unitId"];
        goodsVo.memo = [ObjectUtil getStringValue:dic key:@"memo"];
//        goodsVo.microShelveStatus = [ObjectUtil getStringValue:dic key:@"microShelveStatus"];
        goodsVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        
        return goodsVo;
    }
    
    return nil;
}
@end
