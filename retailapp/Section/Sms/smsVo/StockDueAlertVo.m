//
//  StockDueAlertVo.m
//  retailapp
//
//  Created by hm on 15/11/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StockDueAlertVo.h"

@implementation StockDueAlertVo
+ (StockDueAlertVo *)convetToVo:(NSDictionary *)dic
{
    StockDueAlertVo *vo = [[StockDueAlertVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        vo.goodsName = [ObjectUtil getStringValue:dic key:@"goodsName"];
        vo.barCode = [ObjectUtil getStringValue:dic key:@"barCode"];
        vo.nowStore = [ObjectUtil getStringValue:dic key:@"nowStore"];
        vo.expiredDate = [ObjectUtil getLonglongValue:dic key:@"expiredDate"];
    }
    return vo;
}

+ (NSMutableArray *)converToArr:(NSArray *)arr
{
    if ([ObjectUtil isNotEmpty:arr]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSDictionary *dic in arr) {
            StockDueAlertVo *vo = [StockDueAlertVo convetToVo:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}

@end
