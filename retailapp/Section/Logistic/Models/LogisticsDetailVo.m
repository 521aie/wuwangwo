//
//  LogisticsDetailVo.m
//  retailapp
//
//  Created by hm on 15/10/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LogisticsDetailVo.h"

@implementation LogisticsDetailVo
+ (LogisticsDetailVo*)converToVo:(NSDictionary*)dic
{
    LogisticsDetailVo* vo = [[LogisticsDetailVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        vo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        vo.goodsName = [ObjectUtil getStringValue:dic key:@"goodsName"];
        vo.goodsPrice = [ObjectUtil getDoubleValue:dic key:@"goodsPrice"];
        vo.retailPrice = [ObjectUtil getDoubleValue:dic key:@"retailPrice"];
        vo.hangTagPrice = [ObjectUtil getDoubleValue:dic key:@"hangTagPrice"];
        vo.goodsSum = [ObjectUtil getDoubleValue:dic key:@"goodsSum"];
        vo.goodsTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsTotalPrice"];
        vo.goodsTotalSum = [ObjectUtil getDoubleValue:dic key:@"goodsTotalSum"];
        vo.goodsType = [ObjectUtil getIntegerValue:dic key:@"goodsType"];
        vo.goodsBarcode = [ObjectUtil getStringValue:dic key:@"goodsBarcode"];
        vo.goodsInnerCode = [ObjectUtil getStringValue:dic key:@"goodsInnerCode"];
        vo.color = [ObjectUtil getStringValue:dic key:@"color"];
        vo.size = [ObjectUtil getStringValue:dic key:@"size"];
        vo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        vo.type = [ObjectUtil getShortValue:dic key:@"goodsType"];
        
        vo.goodsHangTagTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsHangTagTotalPrice"];
        vo.goodsRetailTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsRetailTotalPrice"];
        vo.goodsPurchaseTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsPurchaseTotalPrice"];
        
    }
    return vo;
}
+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray* datas = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            LogisticsDetailVo* vo = [LogisticsDetailVo converToVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}
@end
