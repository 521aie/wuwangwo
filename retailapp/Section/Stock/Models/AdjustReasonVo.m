//
//  AdjustReasonVo.m
//  retailapp
//
//  Created by hm on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AdjustReasonVo.h"

@implementation AdjustReasonVo
+ (AdjustReasonVo *)converToVo:(NSDictionary *)dic
{
    AdjustReasonVo *vo = [[AdjustReasonVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        vo.typeVal = [ObjectUtil getStringValue:dic key:@"typeVal"];
        vo.typeName = [ObjectUtil getStringValue:dic key:@"typeName"];
    }
    return vo;
}

+ (NSMutableArray *)converToArr:(NSArray *)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary *dic in sourceList) {
            AdjustReasonVo *vo = [AdjustReasonVo converToVo:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}

-(NSString*) obtainItemId
{
    return self.typeName;
}
-(NSString*) obtainItemName
{
    return self.typeName;
}
-(NSString*) obtainOrignName
{
    return self.typeName;
}
@end
