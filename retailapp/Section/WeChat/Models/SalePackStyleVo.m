//
//  SalePackStyleVo.m
//  retailapp
//
//  Created by Jianyong Duan on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalePackStyleVo.h"

@implementation SalePackStyleVo

+(SalePackStyleVo*)convertToSalePackStyleVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        SalePackStyleVo* salePackStyleVo = [[SalePackStyleVo alloc] init];
        salePackStyleVo.styleId = [ObjectUtil getStringValue:dic key:@"styleId"];
        salePackStyleVo.styleName = [ObjectUtil getStringValue:dic key:@"styleName"];
        salePackStyleVo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        salePackStyleVo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        salePackStyleVo.createTime = [ObjectUtil getLonglongValue:dic key:@"createTime"];
        return salePackStyleVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(SalePackStyleVo *)salePackStyleVo
{
    if ([ObjectUtil isNotNull:salePackStyleVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"styleId" val:salePackStyleVo.styleId];
        [ObjectUtil setStringValue:data key:@"styleName" val:salePackStyleVo.styleName];
        [ObjectUtil setStringValue:data key:@"filePath" val:salePackStyleVo.filePath];
        [ObjectUtil setStringValue:data key:@"styleCode" val:salePackStyleVo.styleCode];
        [ObjectUtil setLongLongValue:data key:@"createTime" val:salePackStyleVo.createTime];
        return data;
    }
    return nil;
}

@end
