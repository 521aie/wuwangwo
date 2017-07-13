//
//  ShowTypeVo.m
//  retailapp
//
//  Created by qingmei on 15/10/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShowTypeVo.h"

@implementation ShowTypeVo
+ (ShowTypeVo*)convertToUser:(NSDictionary*)dic{
    
    if ([ObjectUtil isNotEmpty:dic]) {
        
        ShowTypeVo *showTypeVo = [[ShowTypeVo alloc]init];
        showTypeVo.showType = [ObjectUtil getIntegerValue:dic key:@"showType"];
        showTypeVo.sortCode = [ObjectUtil getIntegerValue:dic key:@"sortCode"];
        showTypeVo.isShow = [ObjectUtil getIntegerValue:dic key:@"isShow"];
        showTypeVo.showTypeName = [ObjectUtil getStringValue:dic key:@"showTypeName"];
        return showTypeVo;
    }
    
    return nil;
}

- (NSMutableDictionary *)getDic:(ShowTypeVo *)showTypeVo{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:[ObjectUtil isNull:showTypeVo.showTypeName]?[NSNull null]:showTypeVo.showTypeName forKey:@"showTypeName"];
    [dic setValue:[NSNumber numberWithInteger:showTypeVo.showType] forKey:@"showType"];
    [dic setValue:[NSNumber numberWithInteger:showTypeVo.sortCode] forKey:@"sortCode"];
    [dic setValue:[NSNumber numberWithInteger:showTypeVo.isShow] forKey:@"isShow"];

    return dic;
}

@end
