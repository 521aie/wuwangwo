//
//  ESPShopVo.m
//  retailapp
//
//  东软园区火掌柜入驻商圈使用的shopVo
//  Created by qingmei on 15/12/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ESPShopVo.h"
#import "ESPAllShopVo.h"

@implementation ESPShopVo
- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"copyFlag"]) {
        self.CopyFlag = (NSString *)value;
    } else if ([key isEqualToString:@"shopList"]){
        NSMutableArray *shopListVos = [[NSMutableArray alloc] init];
        for (NSDictionary *map in value) {
            ESPAllShopVo *voTemp = [[ESPAllShopVo alloc] initWithDictionary:map];
            [shopListVos addObject:voTemp];
        }
        self.shopList = shopListVos;
    }
    else {
        [super setValue:value forKey:key];
    }
}
@end
