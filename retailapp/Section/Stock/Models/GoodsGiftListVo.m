//
//  GoodsGiftListVo.m
//  retailapp
//
//  Created by guozhi on 15/10/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsGiftListVo.h"
#import "MJExtension.h"

@implementation GoodsGiftListVo
- (instancetype)initWithDictionary:(NSDictionary *)json {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSArray *)getGoodsGiftListVoArray:(NSArray *)keyValuesArray {
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
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
            return @"";
            break;
        case 6:
            return @"status_jiagong";
            break;
        default:
            break;
    }
    return @"";
}

@end
