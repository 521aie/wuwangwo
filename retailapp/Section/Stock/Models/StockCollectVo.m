//
//  StockCollectVo.m
//  retailapp
//
//  Created by zhangzhiliang on 16/2/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "StockCollectVo.h"

@implementation StockCollectVo

+ (StockCollectVo *)converToVo:(NSDictionary *) dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        StockCollectVo* vo = [[StockCollectVo alloc] init];
        vo.name = [ObjectUtil getStringValue:dic key:@"name"];
        vo.num = [ObjectUtil getNumberValue:dic key:@"num"];
        vo.money = [ObjectUtil getDoubleValue:dic key:@"money"];
        
        return vo;
    }
    
    return nil;
}

+ (NSMutableArray *)converToArr:(NSArray*) sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary* dic in sourceList) {
            [datas addObject:[StockCollectVo converToVo:dic]];
        }
        
        return datas;
    }
    return nil;
}

@end
