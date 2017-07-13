//
//  XuanKuanVo.m
//  retailapp
//
//  Created by hm on 15/10/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "XuanKuanVo.h"

@implementation XuanKuanVo
+ (XuanKuanVo *)convertFromDic:(NSDictionary *)dictionary {
    if ([ObjectUtil isNotEmpty:dictionary]) {
        XuanKuanVo *xuanKuanVo = [[XuanKuanVo alloc] init];
        xuanKuanVo.colorId = [ObjectUtil getStringValue:dictionary key:@"colorId"];
        xuanKuanVo.colorName = [ObjectUtil getStringValue:dictionary key:@"colorName"];
        xuanKuanVo.recCount = [ObjectUtil getIntegerValue:dictionary key:@"recCount"];
        return xuanKuanVo;
    }
    return nil;
}


+ (NSArray *)convertFromArr:(NSArray *)array {
    if ([ObjectUtil isNotEmpty:array]) {
        NSMutableArray *xuanKuanVoList = [NSMutableArray arrayWithCapacity:array.count];
        
        for (NSDictionary *dic in array) {
            XuanKuanVo *xuanKuanVo = [XuanKuanVo convertFromDic:dic];
            if (dic) {
                [xuanKuanVoList addObject:xuanKuanVo];
            }
        }
        
        return xuanKuanVoList;
    }
    return nil;
}
@end
