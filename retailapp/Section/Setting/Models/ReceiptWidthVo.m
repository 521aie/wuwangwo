//
//  ReceiptWidthVo.m
//  retailapp
//
//  Created by hm on 15/9/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReceiptWidthVo.h"
#import "ObjectUtil.h"


@implementation ReceiptWidthVo
-(NSString*) obtainItemId
{
    return self.value;
}
-(NSString*) obtainItemName
{
    return self.name;
}
-(NSString*) obtainOrignName
{
    return self.name;
}

+ (ReceiptWidthVo*)converToVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        ReceiptWidthVo* vo = [ReceiptWidthVo new];
        vo.name = [ObjectUtil getStringValue:dic key:@"name"];
        vo.value = [ObjectUtil getStringValue:dic key:@"value"];
        return vo;
    }
    return nil;
}


+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            ReceiptWidthVo* vo = [ReceiptWidthVo converToVo:dic];
            [dataList addObject:vo];
        }
    }
    return dataList;
}

@end
