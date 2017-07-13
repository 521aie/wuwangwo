//
//  GoodsOperationVo.m
//  retailapp
//
//  Created by guozhi on 16/2/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsOperationVo.h"

@implementation GoodsOperationVo

- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
