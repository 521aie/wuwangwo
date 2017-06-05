//
//  LSDealRecordVo.m
//  retailapp
//
//  Created by guozhi on 2017/3/29.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSDealRecordVo.h"

@implementation LSDealRecordVo
+ (NSArray *)dealRecordVoWithArray:(NSArray *)array {
    return [self mj_objectArrayWithKeyValuesArray:array];
}
@end
