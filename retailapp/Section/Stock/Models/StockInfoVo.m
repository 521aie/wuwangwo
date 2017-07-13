//
//  StockInfoVo.m
//  retailapp
//
//  Created by guozhi on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StockInfoVo.h"

@implementation StockInfoVo
- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
+ (NSMutableArray *)converToArr:(NSArray *)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary *dic in sourceList) {
            StockInfoVo *vo = (StockInfoVo *)[[StockInfoVo alloc] initWithDictionary:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}

// 2-拆分商品 3-组装商品 4-散装商品 5-原料商品 6-加工商品
- (NSString *)goodTypeImageString {
    switch (self.goodsType.integerValue) {
        case 2:
            return @"status_chaifen";
            break;
        case 3:
            return @"status_zhuzhuang";
            break;
        case 4:
            return @"status_shancheng";
            break;
        case 5:
            return nil;
            break;
        case 6:
            return @"status_jiagong";
            break;
        default:
            break;
    }
    return nil;
}

- (NSNumber *)weixinPrice {
    if (!_weixinPrice) {
        return @(0);
    }
    return _weixinPrice;
}
@end
