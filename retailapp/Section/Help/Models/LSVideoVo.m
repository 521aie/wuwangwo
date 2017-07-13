//
//  LSVideoVo.m
//  retailapp
//
//  Created by guozhi on 2017/3/3.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSVideoVo.h"
#import "MJExtension.h"

@implementation LSVideoVo
+ (NSArray *)ls_objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray {
    return [LSVideoVo mj_objectArrayWithKeyValuesArray:keyValuesArray];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"vedioItems" : @"LSVideoItemVo"};
}

@end
