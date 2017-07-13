//
//  SizeRefer.m
//  retailapp
//
//  Created by hm on 15/9/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SizeRefer.h"
#import "ObjectUtil.h"

@implementation SizeRefer
+ (SizeRefer *)convertFromDic:(NSDictionary *)dictionary {
    if ([ObjectUtil isNotEmpty:dictionary]) {
        SizeRefer *sizeRefer = [[SizeRefer alloc] init];
        
        sizeRefer.sizetype = [ObjectUtil getShortValue:dictionary key:@"sizetye"];
        sizeRefer.sizeid = [ObjectUtil getStringValue:dictionary key:@"sizeid"];
        sizeRefer.sizevalue = [ObjectUtil getStringValue:dictionary key:@"sizevalue"];
        sizeRefer.type = [ObjectUtil getStringValue:dictionary key:@"typename"];
        
        return sizeRefer;
    }
    return nil;
}

+ (NSArray *)convertFromArr:(NSArray *)array {
    if ([ObjectUtil isNotEmpty:array]) {
        NSMutableArray *sizeReferList = [NSMutableArray arrayWithCapacity:array.count];
        
        for (NSDictionary *dic in array) {
            SizeRefer *sizeRefer  = [SizeRefer convertFromDic:dic];
            if (dic) {
                [sizeReferList addObject:sizeRefer];
            }
        }
        
        return sizeReferList;
    }
    return nil;
}
@end
