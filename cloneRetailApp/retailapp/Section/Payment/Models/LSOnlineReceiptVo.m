//
//  OnlineReceiptVo.m
//  retailapp
//
//  Created by guozhi on 16/5/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSOnlineReceiptVo.h"


@implementation LSOnlineReceiptVo

- (id)initWithDictionary:(NSDictionary *)jsonObject
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:jsonObject];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (instancetype)onlineReceiptVoWithMap:(NSDictionary *)map {
    LSOnlineReceiptVo *receiptVo = [[LSOnlineReceiptVo alloc] initWithDictionary:map];
    return receiptVo;
}


@end
