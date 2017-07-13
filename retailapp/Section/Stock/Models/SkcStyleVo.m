//
//  SkcStyleVo.m
//  retailapp
//
//  Created by hm on 15/10/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SkcStyleVo.h"
#import "SkcListVo.h"
@implementation SkcStyleVo
+ (SkcStyleVo *)converToVo:(NSDictionary *)dic
{
    return [SkcStyleVo mj_objectWithKeyValues:dic];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"skcList" : @"SkcListVo"};
}



@end
