//
//  MicroShopInfoVo.m
//  retailapp
//
//  Created by taihangju on 2017/3/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroShopInfoVo.h"
#import "MJExtension.h"

@implementation MicroShopInfoVo

+ (instancetype)microShopInfoVoFrom:(NSDictionary *)keyValues {
    return [self mj_objectWithKeyValues:keyValues];
}
@end
