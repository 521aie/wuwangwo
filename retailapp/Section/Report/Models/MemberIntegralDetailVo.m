//
//  MemberIntegralDetailVo.m
//  retailapp
//
//  Created by 叶在义 on 15/10/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberIntegralDetailVo.h"
#import "MJExtension.h"
//#import "MemberIntegralDetailCellVo.h"

@implementation MemberIntegralDetailVo

//- (instancetype)initWithDictionary:(NSDictionary *)json {
//    self = [super init];
//    if (self) {
//        [self setValuesForKeysWithDictionary:json];
//    }
//    return self;
//}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    
//}

//- (void)setValue:(id)value forKey:(NSString *)key {
//    if ([key isEqualToString:@"exchangeDetailList"]) {
//        NSMutableArray *memberIntegralDetailCellVos = [[NSMutableArray alloc] init];
//        for (NSDictionary *map in value) {
//            MemberIntegralDetailCellVo *memberIntegralDetailCellVo = [[MemberIntegralDetailCellVo alloc] initWIthDictionary:map];
//            [memberIntegralDetailCellVos addObject:memberIntegralDetailCellVo];
//        }
//        self.memberIntegralDetailCellVos = memberIntegralDetailCellVos;
//    } else {
//        [super setValue:value forKey:key];
//    }
//    
//}

+ (instancetype)memberIntegralDetailVo:(NSDictionary *)json {
    return [MemberIntegralDetailVo mj_objectWithKeyValues:json];
}
@end
