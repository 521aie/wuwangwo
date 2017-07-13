//
//  LSMemberMeterGoodsVo.m
//  retailapp
//
//  Created by wuwangwo on 2017/3/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberMeterGoodsVo.h"

@implementation LSMemberMeterGoodsVo

+ (instancetype)meterGoodsVoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
