//
//  LSByTimeServiceVo.m
//  retailapp
//
//  Created by taihangju on 2017/4/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSByTimeServiceVo.h"
#import "DateUtils.h"

@implementation LSByTimeServiceVo

+ (NSArray *)byTimeServiceVoListFromKeyValuesArray:(NSArray *)keyValuesArray {
    
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"isExpand",@"goodsArray"];
}

- (NSString *)statusString {
    
    if (self.isExpiry.boolValue) {
        
        if (self.status.integerValue == 2) {
            return @"已用完";
        } else if (_status.integerValue == 3) {
            return @"已退款";
        }
        
    } else {
        return @"已过期";
    }
    return @"";
}

- (NSString *)validTimeString {
    
    if (_expiryDate.integerValue == 0) {
        return @"不限期";
    }
    
    NSString *startTime = [DateUtils formateTime2:_startDate.longLongValue];
    NSString *endTime = [DateUtils formateTime2:_endDate.longLongValue];
    return [NSString stringWithFormat:@"有效期: %@至%@",startTime,endTime];
}

- (NSString *)goodNumberString {
    
    if (!_goodsKindCount) {
        return @"0";
    }
    return _goodsKindCount.stringValue;
}

@end


@implementation LSByTimeGoodVo

+ (NSArray *)byTimeGoodVoListFromKeyValuesArray:(NSArray *)keyValuesArray {
    
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}

@end
