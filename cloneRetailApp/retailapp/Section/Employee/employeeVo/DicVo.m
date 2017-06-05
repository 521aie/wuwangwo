//
//  DicVo.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DicVo.h"

@implementation DicVo


-(NSString*) obtainItemId {
    return [NSString stringWithFormat:@"%ld", self.val];
}

-(NSString*) obtainItemName {
    return self.name;
}

-(NSString*) obtainOrignName {
    return self.name;
}

-(NSString*) obtainItemValue {
    return [NSString stringWithFormat:@"%ld", self.val];
}


+ (DicVo*)converToVo:(NSDictionary*)dic {
    DicVo* dicVo = [[DicVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        dicVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        dicVo.val = [ObjectUtil getIntegerValue:dic key:@"val"];
    }
    
    return dicVo;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList {
    if ([ObjectUtil isEmpty:sourceList]) {
        return nil;
    }
    
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            DicVo* dicVo = [DicVo converToVo:dic];
            [dataList addObject:dicVo];
        }
    }
    return dataList;
}

@end
