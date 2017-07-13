//
//  ReturnGoodsDetailVo.m
//  retailapp
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReturnGoodsDetailVo.h"

@implementation ReturnGoodsDetailVo
+ (ReturnGoodsDetailVo *)converToVo:(NSDictionary *)dic
{
    ReturnGoodsDetailVo *vo = [[ReturnGoodsDetailVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        vo.returnGoodsDetailId = [ObjectUtil getStringValue:dic key:@"returnGoodsDetailId"];
        vo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        vo.goodsName = [ObjectUtil getStringValue:dic key:@"goodsName"];
        vo.goodsBarcode = [ObjectUtil getStringValue:dic key:@"goodsBarcode"];
        vo.goodsInnercode = [ObjectUtil getStringValue:dic key:@"goodsInnercode"];
        vo.goodsPrice = [ObjectUtil getDoubleValue:dic key:@"goodsPrice"];
        vo.goodsSum = [ObjectUtil getIntegerValue:dic key:@"goodsSum"];
        vo.goodsTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsTotalPrice"];
        vo.operateType = [ObjectUtil getStringValue:dic key:@"operateType"];
        vo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        vo.predictSum = [ObjectUtil getNumberValue:dic key:@"predictSum"];
        vo.oldGoodsPrice = vo.goodsPrice;
        vo.oldGoodsSum = vo.goodsSum;
        vo.changeFlag = 0;
    }
    return vo;
}
+ (NSMutableArray *)converToArr:(NSArray *)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary *dic in sourceList) {
            ReturnGoodsDetailVo *vo = [ReturnGoodsDetailVo converToVo:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}


+ (NSMutableDictionary *)converToDic:(ReturnGoodsDetailVo *)vo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:vo]) {
        [ObjectUtil setStringValue:dic key:@"returnGoodsDetailId" val:vo.returnGoodsDetailId];
        [ObjectUtil setStringValue:dic key:@"goodsId" val:vo.goodsId];
        [ObjectUtil setStringValue:dic key:@"goodsName" val:vo.goodsName];
        [ObjectUtil setStringValue:dic key:@"goodsBarcode" val:vo.goodsBarcode];
        [ObjectUtil setStringValue:dic key:@"goodsInnercode" val:vo.goodsInnercode];
        [ObjectUtil setStringValue:dic key:@"operateType" val:vo.operateType];
        [ObjectUtil setStringValue:dic key:@"styleCode" val:vo.styleCode];
        [ObjectUtil setIntegerValue:dic key:@"goodsSum" val:vo.goodsSum];
        [ObjectUtil setDoubleValue:dic key:@"goodsPrice" val:vo.goodsPrice];
        [ObjectUtil setDoubleValue:dic key:@"goodsTotalPrice" val:vo.goodsTotalPrice];
        [ObjectUtil setNumberValue:dic key:@"predictSum" val:vo.predictSum];
    }
    return dic;
}


+ (NSMutableArray *)converToArrDic:(NSMutableArray *)dataList
{
    if ([ObjectUtil isNotEmpty:dataList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:dataList.count];
        for (ReturnGoodsDetailVo *vo  in dataList) {
           NSMutableDictionary *dic = [ReturnGoodsDetailVo converToDic:vo];
            [datas addObject:dic];
        }
        return datas;
    }
    return [NSMutableArray array];
}
@end
