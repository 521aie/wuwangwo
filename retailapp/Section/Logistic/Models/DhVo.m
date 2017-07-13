//
//  DhVo.m
//  retailapp
//
//  Created by hm on 15/10/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DhVo.h"

@implementation DhVo
+ (DhVo *)convertFromDic:(NSDictionary *)dictionary {
    if ([ObjectUtil isNotEmpty:dictionary]) {
        DhVo *dhVo = [[DhVo alloc] init];

        dhVo.styleId = [ObjectUtil getStringValue:dictionary key:@"styleId"];
        dhVo.colorId = [ObjectUtil getStringValue:dictionary key:@"colorId"];
        dhVo.sumCount = [ObjectUtil getIntegerValue:dictionary key:@"sumCount"];
        dhVo.sumMoney = [ObjectUtil getIntegerValue:dictionary key:@"sumMoney"];
        dhVo.s24 = [ObjectUtil getIntegerValue:dictionary key:@"s24"];
        dhVo.s25 = [ObjectUtil getIntegerValue:dictionary key:@"s25"];
        dhVo.s26 = [ObjectUtil getIntegerValue:dictionary key:@"s26"];
        dhVo.s27 = [ObjectUtil getIntegerValue:dictionary key:@"s27"];
        dhVo.s28 = [ObjectUtil getIntegerValue:dictionary key:@"s28"];
        dhVo.s29 = [ObjectUtil getIntegerValue:dictionary key:@"s29"];
        dhVo.s30 = [ObjectUtil getIntegerValue:dictionary key:@"s30"];
        dhVo.s31 = [ObjectUtil getIntegerValue:dictionary key:@"s31"];
        dhVo.s32 = [ObjectUtil getIntegerValue:dictionary key:@"s32"];
        dhVo.s33 = [ObjectUtil getIntegerValue:dictionary key:@"s33"];
        dhVo.s34 = [ObjectUtil getIntegerValue:dictionary key:@"s34"];
        dhVo.s35 = [ObjectUtil getIntegerValue:dictionary key:@"s35"];
        dhVo.s36 = [ObjectUtil getIntegerValue:dictionary key:@"s36"];
        dhVo.s37 = [ObjectUtil getIntegerValue:dictionary key:@"s37"];
        dhVo.s38 = [ObjectUtil getIntegerValue:dictionary key:@"s38"];
        dhVo.s39 = [ObjectUtil getIntegerValue:dictionary key:@"s39"];
        dhVo.s40 = [ObjectUtil getIntegerValue:dictionary key:@"s40"];
        
        return dhVo;
    }
    return nil;
}

+ (NSArray *)convertFromArr:(NSArray *)array {
    if ([ObjectUtil isNotEmpty:array]) {
        NSMutableArray *dhVoList = [NSMutableArray arrayWithCapacity:array.count];
        
        for (NSDictionary *dic in array) {
            DhVo *dhVo  = [DhVo convertFromDic:dic];
            if (dic) {
                [dhVoList addObject:dhVo];
            }
        }
        
        return dhVoList;
    }
    return nil;
}

+ (NSInteger)getAllDhl:(NSArray *)dhVoList {
    NSInteger dhl = 0;
    for (DhVo *dhVo in dhVoList) {
        dhl += dhVo.sumCount;
    }
    return dhl;
}

+ (NSDictionary *)getDictionaryData:(DhVo *)dhVo
{
    if ([ObjectUtil isNotNull:dhVo]) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc]init];

        [ObjectUtil setStringValue:data key:@"styleId" val:dhVo.styleId];
        [ObjectUtil setStringValue:data key:@"colorId" val:dhVo.colorId];
        [ObjectUtil setIntegerValue:data key:@"sumCount" val:dhVo.sumCount];
        [ObjectUtil setIntegerValue:data key:@"sumMoney" val:dhVo.sumMoney];
        [ObjectUtil setIntegerValue:data key:@"s24" val:dhVo.s24];
        [ObjectUtil setIntegerValue:data key:@"s25" val:dhVo.s25];
        [ObjectUtil setIntegerValue:data key:@"s26" val:dhVo.s26];
        [ObjectUtil setIntegerValue:data key:@"s27" val:dhVo.s27];
        [ObjectUtil setIntegerValue:data key:@"s28" val:dhVo.s28];
        [ObjectUtil setIntegerValue:data key:@"s29" val:dhVo.s29];
        [ObjectUtil setIntegerValue:data key:@"s30" val:dhVo.s30];
        [ObjectUtil setIntegerValue:data key:@"s31" val:dhVo.s31];
        [ObjectUtil setIntegerValue:data key:@"s32" val:dhVo.s32];
        [ObjectUtil setIntegerValue:data key:@"s33" val:dhVo.s33];
        [ObjectUtil setIntegerValue:data key:@"s34" val:dhVo.s34];
        [ObjectUtil setIntegerValue:data key:@"s35" val:dhVo.s35];
        [ObjectUtil setIntegerValue:data key:@"s36" val:dhVo.s36];
        [ObjectUtil setIntegerValue:data key:@"s37" val:dhVo.s37];
        [ObjectUtil setIntegerValue:data key:@"s38" val:dhVo.s38];
        [ObjectUtil setIntegerValue:data key:@"s39" val:dhVo.s39];
        [ObjectUtil setIntegerValue:data key:@"s40" val:dhVo.s40];
        return data;
    }
    return nil;
}

+ (NSArray *)getArrayData:(NSArray *)array
{
    if ([ObjectUtil isNotEmpty:array]) {
        NSMutableArray *dhVoList = [NSMutableArray arrayWithCapacity:array.count];
        for (DhVo *dhVo in array) {
            NSDictionary *data = [DhVo getDictionaryData:dhVo];
            if ([ObjectUtil isNotNull:data]) {
                [dhVoList addObject:data];
            }
        }
        return dhVoList;
    }
    return [[NSMutableArray alloc]init];
}

@end
