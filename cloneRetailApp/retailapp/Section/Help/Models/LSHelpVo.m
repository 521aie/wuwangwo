//
//  LSHelpVo.m
//  retailapp
//
//  Created by guozhi on 2017/3/8.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSHelpVo.h"
#import "MJExtension.h"

@implementation LSHelpVo
+ (instancetype)helpVoWithCode:(NSString *)code {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"help.plist" ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    LSHelpVo *obj = [LSHelpVo mj_objectWithKeyValues:dict[code]];
    return obj;
}

//+ (NSDictionary *)mj_objectClassInArray {
//    return @{@"list" : @"LSHelpContextVo"};
//}

@end
