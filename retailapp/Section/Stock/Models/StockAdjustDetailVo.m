//
//  StockAdjustDetailVo.m
//  retailapp
//
//  Created by hm on 15/10/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StockAdjustDetailVo.h"

@implementation StockAdjustDetailVo
- (instancetype)initWithDictionary:(NSDictionary *)json {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"oldAdjustStore"]) {
        self.oldAdjustStore = self.adjustStore;
    }
}

+ (StockAdjustDetailVo *)converToVo:(NSDictionary *)dic
{
    StockAdjustDetailVo *vo = [[StockAdjustDetailVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        vo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        vo.goodsName = [ObjectUtil getStringValue:dic key:@"goodsName"];
        vo.barCode = [ObjectUtil getStringValue:dic key:@"barCode"];
        vo.hangTagPrice = [ObjectUtil getNumberValue:dic key:@"hangTagPrice"];
        vo.purchasePrice = [ObjectUtil getNumberValue:dic key:@"purchasePrice"];
        vo.retailPrice = [ObjectUtil getNumberValue:dic key:@"retailPrice"];
        vo.resultPrice = [ObjectUtil getNumberValue:dic key:@"resultPrice"];
        vo.adjustStore = [ObjectUtil getNumberValue:dic key:@"adjustStore"];
        vo.powerPrice = [ObjectUtil getNumberValue:dic key:@"powerPrice"];
        vo.nowStore = [ObjectUtil getNumberValue:dic key:@"nowStore"];
        vo.oldAdjustStore = [ObjectUtil getNumberValue:dic key:@"adjustStore"];
        vo.changeFlag = 0;
        vo.reasonFlag = 0;
        vo.oldReasonId = vo.adjustReasonId;
        vo.type = [ObjectUtil getShortValue:dic key:@"goodsType"];
        vo.operateType = [ObjectUtil getStringValue:dic key:@"operateType"];
        // 加载详情时，对于已有的商品，默认操作类型为edit
        if ([NSString isBlank:vo.operateType]) {
            vo.operateType = @"edit";
        }
        vo.adjustReasonId = [ObjectUtil getStringValue:dic key:@"adjustReasonId"];
        vo.adjustReason = [ObjectUtil getStringValue:dic key:@"adjustReason"];
        vo.styleId = [ObjectUtil getStringValue:dic key:@"styleId"];
        vo.styleName = [ObjectUtil getStringValue:dic key:@"styleName"];
        vo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        vo.sumAdjustMoney = [ObjectUtil getNumberValue:dic key:@"sumAdjustMoney"];
        vo.totalStore = [ObjectUtil getNumberValue:dic key:@"totalStore"];
        vo.oldTotalStore = [ObjectUtil getNumberValue:dic key:@"totalStore"];
        vo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        vo.goodsStatus = [ObjectUtil getIntegerValue:dic key:@"goodsStatus"];
        vo.goodsType = [ObjectUtil getIntegerValue:dic key:@"goodsType"];
    }
    return vo;
}

+ (NSMutableArray *)converToArr:(NSArray *)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary *dic in sourceList) {
            StockAdjustDetailVo *vo = [StockAdjustDetailVo converToVo:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}

+ (NSMutableDictionary *)converToDic:(StockAdjustDetailVo *)vo
{
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:vo]) {
        [ObjectUtil setStringValue:datas key:@"goodsId" val:vo.goodsId];
        [ObjectUtil setStringValue:datas key:@"goodsName" val:vo.goodsName];
        [ObjectUtil setStringValue:datas key:@"barCode" val:vo.barCode];
        [ObjectUtil setNumberValue:datas key:@"hangTagPrice" val:vo.hangTagPrice];
        [ObjectUtil setNumberValue:datas key:@"purchasePrice" val:vo.purchasePrice];
        [ObjectUtil setNumberValue:datas key:@"retailPrice" val:vo.retailPrice];
        [ObjectUtil setNumberValue:datas key:@"resultPrice" val:vo.resultPrice];
        [ObjectUtil setNumberValue:datas key:@"adjustStore" val:vo.adjustStore];
        [ObjectUtil setNumberValue:datas key:@"nowStore" val:vo.nowStore];
        [ObjectUtil setShortValue:datas key:@"type" val:vo.type];
        [ObjectUtil setStringValue:datas key:@"operateType" val:vo.operateType];
        [ObjectUtil setStringValue:datas key:@"adjustReasonId" val:vo.adjustReasonId];
        [ObjectUtil setStringValue:datas key:@"adjustReason" val:vo.adjustReason];
        [ObjectUtil setStringValue:datas key:@"styleId" val:vo.styleId];
        [ObjectUtil setStringValue:datas key:@"styleName" val:vo.styleName];
        [ObjectUtil setStringValue:datas key:@"styleCode" val:vo.styleCode];
        [ObjectUtil setNumberValue:datas key:@"sumAdjustMoney" val:vo.sumAdjustMoney];
        [ObjectUtil setNumberValue:datas key:@"totalStore" val:vo.totalStore];
    }
    return datas;
}

+ (NSMutableArray *)converArrToDicArr:(NSMutableArray *)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas  = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (StockAdjustDetailVo *vo  in sourceList) {
            NSMutableDictionary *dic = [StockAdjustDetailVo converToDic:vo];
            [datas addObject:dic];
        }
        return datas;
    }
    return [NSMutableArray array];
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
    return self.barCode;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name--->%@, adjustStore--->%@", self.goodsName, self.adjustStore];
}

@end
