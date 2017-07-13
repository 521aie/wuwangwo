//
//  GoodsBrandVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsBrandVo.h"

@implementation GoodsBrandVo

+(GoodsBrandVo*)convertToGoodsBrandVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        GoodsBrandVo* goodsBrandVo = [[GoodsBrandVo alloc] init];
        goodsBrandVo.goodsBrandId = [ObjectUtil getStringValue:dic key:@"goodsBrandId"];
        goodsBrandVo.code = [ObjectUtil getStringValue:dic key:@"code"];
        goodsBrandVo.sortCode = [ObjectUtil getShortValue:dic key:@"sortCode"];
        goodsBrandVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        goodsBrandVo.memo = [ObjectUtil getStringValue:dic key:@"memo"];
        goodsBrandVo.spell = [ObjectUtil getStringValue:dic key:@"spell"];
        goodsBrandVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        
        return goodsBrandVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(GoodsBrandVo *)goodsBrandVo
{
    if ([ObjectUtil isNotNull:goodsBrandVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"goodsBrandId" val:goodsBrandVo.goodsBrandId];
        [ObjectUtil setStringValue:data key:@"code" val:goodsBrandVo.code];
        [ObjectUtil setIntegerValue:data key:@"sortCode" val:goodsBrandVo.sortCode];
        [ObjectUtil setStringValue:data key:@"name" val:goodsBrandVo.name];
        [ObjectUtil setStringValue:data key:@"memo" val:goodsBrandVo.memo];
        [ObjectUtil setStringValue:data key:@"spell" val:goodsBrandVo.spell];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:goodsBrandVo.lastVer];
        
        return data;
    }
    
    return nil;
}

@end
