//
//  LSCardBackgroundImageVo.m
//  retailapp
//
//  Created by taihangju on 16/9/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCardBackgroundImageVo.h"
#import "Masonry.h"

@implementation LSCardBackgroundImageVo


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"s_Id":@"_id",
             @"sId":@"id"};
}

+ (NSArray *)getObjectsFrom:(NSArray *)array {
    
    return [[self mj_objectArrayWithKeyValuesArray:array] copy];
}

@end
