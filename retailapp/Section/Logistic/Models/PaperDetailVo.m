//
//  PaperDetailVo.m
//  retailapp
//
//  Created by hm on 15/10/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PaperDetailVo.h"

@implementation PaperDetailVo
+ (PaperDetailVo*)converToVo:(NSDictionary*)dic paperType:(NSInteger)paperType
{
    PaperDetailVo* vo = [[PaperDetailVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        if (paperType==ORDER_PAPER_TYPE||paperType==CLIENT_ORDER_PAPER_TYPE) {
            vo.paperDetailId = [ObjectUtil getStringValue:dic key:@"orderGoodsDetailId"];
        }else if (paperType==PURCHASE_PAPER_TYPE) {
            vo.paperDetailId = [ObjectUtil getStringValue:dic key:@"stockInDetailId"];
            vo.productionDate = [ObjectUtil getLonglongValue:dic key:@"productionDate"];
            vo.oldDate = vo.productionDate;
        }else if (paperType==ALLOCATE_PAPER_TYPE) {
            vo.paperDetailId = [ObjectUtil getStringValue:dic key:@"allocateDetailId"];
            vo.outShopName = [ObjectUtil getStringValue:dic key:@"outShopNam"];
            vo.inShopNam = [ObjectUtil getStringValue:dic key:@"inShopNam"];
        }else if (paperType==RETURN_PAPER_TYPE||paperType==CLIENT_RETURN_PAPER_TYPE||paperType==PACK_BOX_PAPER_TYPE){
            vo.paperDetailId = [ObjectUtil getStringValue:dic key:@"returnGoodsDetailId"];
            vo.resonVal = [ObjectUtil getIntegerValue:dic key:@"resonVal"];
            vo.resonName = [ObjectUtil getStringValue:dic key:@"resonName"];
        }
        vo.retailPrice = [ObjectUtil getDoubleValue:dic key:@"retailPrice"];
        vo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        vo.goodsName = [ObjectUtil getStringValue:dic key:@"goodsName"];
        vo.goodsPrice = [ObjectUtil getDoubleValue:dic key:@"goodsPrice"];
        vo.purchasePrice = [ObjectUtil getDoubleValue:dic key:@"purchasePrice"];
        vo.goodsPurchaseTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsPurchaseTotalPrice"];
        vo.goodsHangTagTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsHangTagTotalPrice"];
        vo.goodsReturnTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsReturnTotalPrice"];
        vo.goodsRetailTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsRetailTotalPrice"];
        vo.goodsSum = [ObjectUtil getDoubleValue:dic key:@"goodsSum"];
        vo.goodsTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsTotalPrice"];
        vo.oldGoodsTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsTotalPrice"];
        vo.type = [ObjectUtil getShortValue:dic key:@"type"];
        vo.goodsStatus = [ObjectUtil getShortValue:dic key:@"goodsStatus"];
        vo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        vo.goodsBarcode = [ObjectUtil getStringValue:dic key:@"goodsBarcode"];
        vo.goodsInnercode = [ObjectUtil getStringValue:dic key:@"goodsInnercode"];
        vo.styleId = [ObjectUtil getStringValue:dic key:@"styleId"];
        vo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        vo.operateType = [ObjectUtil getStringValue:dic key:@"operateType"];
        vo.nowStore = [ObjectUtil getNumberValue:dic key:@"nowStore"];
        vo.styleCanReturn = [ObjectUtil getNumberValue:dic key:@"styleCanReturn"];
        vo.predictSum = [ObjectUtil getNumberValue:dic key:@"predictSum"];
        vo.oldGoodsPrice = vo.goodsPrice;
        vo.oldGoodsSum = vo.goodsSum;
        vo.changeFlag = 0;
        vo.oldResonVal = vo.resonVal;
    }
    return vo;
}

- (BOOL)isChange {
    BOOL change = (self.oldGoodsSum != self.goodsSum) || (self.oldGoodsPrice != self.goodsPrice) || (self.oldGoodsTotalPrice != self.goodsTotalPrice) || (self.oldResonVal != self.resonVal) || (self.oldDate!=self.productionDate)||[self.operateType isEqualToString:@"add"];
    return change;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList paperType:(NSInteger)paperType
{
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            PaperDetailVo* vo = [PaperDetailVo converToVo:dic paperType:paperType];
            [dataList addObject:vo];
        }
    }
    return dataList;
}

+ (NSMutableDictionary*)converToDic:(PaperDetailVo*)paperDetailVo paperType:(NSInteger)paperType
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:paperDetailVo]) {
        if (paperType==ORDER_PAPER_TYPE||paperType==CLIENT_ORDER_PAPER_TYPE) {
            [ObjectUtil setStringValue:data key:@"orderGoodsDetailId" val:paperDetailVo.paperDetailId];
        }else if (paperType==PURCHASE_PAPER_TYPE) {
            [ObjectUtil setStringValue:data key:@"stockInDetailId" val:paperDetailVo.paperDetailId];
            [ObjectUtil setLongLongValue:data key:@"productionDate" val:paperDetailVo.productionDate];
        }else if (paperType==ALLOCATE_PAPER_TYPE) {
            [ObjectUtil setStringValue:data key:@"allocateDetailId" val:paperDetailVo.paperDetailId];
            [ObjectUtil setStringValue:data key:@"outShopNam" val:paperDetailVo.paperDetailId];
            [ObjectUtil setStringValue:data key:@"inShopNam" val:paperDetailVo.paperDetailId];
        }else if (paperType==RETURN_PAPER_TYPE||paperType==CLIENT_RETURN_PAPER_TYPE||paperType==PACK_BOX_PAPER_TYPE) {
            [ObjectUtil setStringValue:data key:@"returnGoodsDetailId" val:paperDetailVo.paperDetailId];
            [ObjectUtil setIntegerValue:data key:@"resonVal" val:paperDetailVo.resonVal];
            [ObjectUtil setStringValue:data key:@"resonName" val:paperDetailVo.resonName];
        }
        [ObjectUtil setDoubleValue:data key:@"retailPrice" val:paperDetailVo.retailPrice];
        [ObjectUtil setStringValue:data key:@"goodsId" val:paperDetailVo.goodsId];
        [ObjectUtil setStringValue:data key:@"goodsName" val:paperDetailVo.goodsName];
        [ObjectUtil setDoubleValue:data key:@"goodsPrice" val:paperDetailVo.goodsPrice];
        [ObjectUtil setDoubleValue:data key:@"purchasePrice" val:paperDetailVo.purchasePrice];
        [ObjectUtil setDoubleValue:data key:@"goodsSum" val:paperDetailVo.goodsSum];
        [ObjectUtil setDoubleValue:data key:@"goodsTotalPrice" val:paperDetailVo.goodsTotalPrice];
         [ObjectUtil setDoubleValue:data key:@"goodsPurchaseTotalPrice" val:paperDetailVo.goodsPurchaseTotalPrice];
        [ObjectUtil setShortValue:data key:@"type" val:paperDetailVo.type];
        [ObjectUtil setStringValue:data key:@"goodsBarcode" val:paperDetailVo.goodsBarcode];
        [ObjectUtil setStringValue:data key:@"goodsInnercode" val:paperDetailVo.goodsInnercode];
        [ObjectUtil setStringValue:data key:@"styleId" val:paperDetailVo.styleId];
        [ObjectUtil setStringValue:data key:@"styleCode" val:paperDetailVo.styleCode];
        [ObjectUtil setStringValue:data key:@"operateType" val:paperDetailVo.operateType];
        [ObjectUtil setNumberValue:data key:@"nowStore" val:paperDetailVo.nowStore];
        [ObjectUtil setNumberValue:data key:@"predictSum" val:paperDetailVo.predictSum];
    }
    return data;
}

+ (NSMutableArray*)converToDicArr:(NSMutableArray*)sourceList paperType:(NSInteger)paperType
{
    NSMutableArray* data = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (PaperDetailVo* vo in sourceList) {
            NSMutableDictionary* dic = [PaperDetailVo converToDic:vo paperType:paperType];
            [data addObject:dic];
        }
    }
    return data;
}

-(NSString*) obtainItemId
{
    return self.goodsId;
}
-(NSString*) obtainItemName
{
    return self.goodsName;
}
-(NSString*) obtainItemValue
{
    return self.goodsBarcode;
}
@end
