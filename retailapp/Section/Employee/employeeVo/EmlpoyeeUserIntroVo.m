//
//  EmlpoyeeUserIntroVo.m
//  retailapp
//
//  Created by qingmei on 15/10/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EmlpoyeeUserIntroVo.h"

@implementation EmlpoyeeUserIntroVo

+ (EmlpoyeeUserIntroVo*)convertToUser:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        EmlpoyeeUserIntroVo *emlpoyeeUserIntroVo = [[EmlpoyeeUserIntroVo alloc]init];
        
        emlpoyeeUserIntroVo.userId = [ObjectUtil getStringValue:dic key:@"userId"];
        emlpoyeeUserIntroVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        emlpoyeeUserIntroVo.staffId = [ObjectUtil getStringValue:dic key:@"staffId"];
        emlpoyeeUserIntroVo.roleName = [ObjectUtil getStringValue:dic key:@"roleName"];
        emlpoyeeUserIntroVo.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
        emlpoyeeUserIntroVo.mobile = [ObjectUtil getStringValue:dic key:@"mobile"];
        emlpoyeeUserIntroVo.sex = [ObjectUtil getIntegerValue:dic key:@"sex"];
        return emlpoyeeUserIntroVo;
    }
    return nil;
}

- (NSMutableDictionary *)getDic:(EmlpoyeeUserIntroVo *)emlpoyeeUserIntroVo{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:[ObjectUtil isNull:emlpoyeeUserIntroVo.userId]?[NSNull null]:emlpoyeeUserIntroVo.userId forKey:@"userId"];
    [dic setValue:[ObjectUtil isNull:emlpoyeeUserIntroVo.name]?[NSNull null]:emlpoyeeUserIntroVo.name forKey:@"name"];
    [dic setValue:[ObjectUtil isNull:emlpoyeeUserIntroVo.staffId]?[NSNull null]:emlpoyeeUserIntroVo.staffId forKey:@"staffId"];
    [dic setValue:[ObjectUtil isNull:emlpoyeeUserIntroVo.roleName]?[NSNull null]:emlpoyeeUserIntroVo.roleName forKey:@"roleName"];
    [dic setValue:[ObjectUtil isNull:emlpoyeeUserIntroVo.fileName]?[NSNull null]:emlpoyeeUserIntroVo.fileName forKey:@"fileName"];
    [dic setValue:[ObjectUtil isNull:emlpoyeeUserIntroVo.mobile]?[NSNull null]:emlpoyeeUserIntroVo.mobile forKey:@"mobile"];
    [dic setValue:[ObjectUtil isNull:emlpoyeeUserIntroVo.mobile]?[NSNull null]:emlpoyeeUserIntroVo.mobile forKey:@"mobile"];
    return dic;
}



@end
