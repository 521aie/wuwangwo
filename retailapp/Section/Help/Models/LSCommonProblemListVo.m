//
//  LSCommonProblemListVo.m
//  retailapp
//
//  Created by guozhi on 2017/3/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCommonProblemListVo.h"
#import "MJExtension.h"

@implementation LSCommonProblemListVo
+ (NSArray *)ls_objectArrayWithKeyValuesArray:(NSArray *)array {
    return [self mj_objectArrayWithKeyValuesArray:array];
}
+ (instancetype)ls_objectWithKeyValues:(NSDictionary *)keyValues {
    return [self mj_objectWithKeyValues:keyValues];
}
@end
