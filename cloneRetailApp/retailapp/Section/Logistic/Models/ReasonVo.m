//
//  ReasonVo.m
//  retailapp
//
//  Created by hm on 15/10/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReasonVo.h"

@implementation ReasonVo
+ (ReasonVo*)converToVo:(NSDictionary*)dic
{
    ReasonVo *vo = [[ReasonVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        vo.dicItemId = [ObjectUtil getStringValue:dic key:@"dicItemId"];
        vo.name = [ObjectUtil getStringValue:dic key:@"name"];
        vo.val = [ObjectUtil getIntegerValue:dic key:@"val"];
    }
    return vo;
}
+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary *dic in sourceList) {
            ReasonVo *vo = [ReasonVo converToVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

-(NSString*) obtainItemId
{
    return self.dicItemId;
}
-(NSString*) obtainItemName
{
    return self.name;
}
-(NSString*) obtainOrignName
{
    return self.name;
}
-(NSString*) obtainItemValue
{
    return [NSString stringWithFormat:@"%tu",self.val];
}

@end
