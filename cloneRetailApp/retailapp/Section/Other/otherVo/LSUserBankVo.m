//
//  LSUserBankVo.m
//  retailapp
//
//  Created by guozhi on 16/3/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSUserBankVo.h"

@implementation LSUserBankVo
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (instancetype)userBankVoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
