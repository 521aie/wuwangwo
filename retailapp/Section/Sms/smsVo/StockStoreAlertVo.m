//
//  StockStoreAlertVo.m
//  retailapp
//
//  Created by hm on 15/11/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StockStoreAlertVo.h"

@implementation StockStoreAlertVo
+ (StockStoreAlertVo *)converToVo:(NSDictionary *)dic
{
    StockStoreAlertVo *vo = [[StockStoreAlertVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        vo.goodsName = [ObjectUtil getStringValue:dic key:@"goodsName"];
        vo.nowStore = [ObjectUtil getStringValue:dic key:@"nowStore"];
        vo.baseStore = [ObjectUtil getStringValue:dic key:@"baseStore"];
        vo.barCode = [ObjectUtil getStringValue:dic key:@"barCode"];
    }
    return vo;
}

+ (NSMutableArray *)converToArr:(NSArray *)arr
{
    if ([ObjectUtil isNotEmpty:arr]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSDictionary *dic in arr) {
            StockStoreAlertVo *vo = [StockStoreAlertVo converToVo:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}

@end
