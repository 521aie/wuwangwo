//
//  LSCardOperateListVo.m
//  retailapp
//
//  Created by wuwangwo on 17/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCardOperateListVo.h"

@implementation LSCardOperateListVo
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"customerOpLogList" : @"LSCardOperateListVo"
             };
}
- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
