//
//  SupplyReportVo.m
//  retailapp
//
//  Created by guozhi on 16/2/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SupplyReportVo.h"

@implementation SupplyReportVo
- (instancetype)initWIthDictionary:(NSDictionary *)json {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
