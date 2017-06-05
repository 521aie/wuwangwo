//
//  MemberTransactionListVo.m
//  retailapp
//
//  Created by guozhi on 15/10/12.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberTransactionListVo.h"
#import "MJExtension.h"


@implementation MemberTransactionListVo

+ (instancetype)memberTranscationVo:(NSDictionary *)keyValues {
    return [self mj_objectWithKeyValues:keyValues];
}

+ (NSArray *)memberTranscationVoList:(NSArray *)keyVaulesArray {
    
    return [self mj_objectArrayWithKeyValuesArray:keyVaulesArray];
}
@end
