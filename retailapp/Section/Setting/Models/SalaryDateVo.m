//
//  SalaryDateVo.m
//  retailapp
//
//  Created by hm on 15/10/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalaryDateVo.h"

@implementation SalaryDateVo
+ (SalaryDateVo *)converToVo:(NSDictionary *)dic
{
    SalaryDateVo *vo = [[SalaryDateVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        vo.name = [ObjectUtil getStringValue:dic key:@"name"];
        vo.value = [ObjectUtil getStringValue:dic key:@"value"];
    }
    return vo;
}
+ (NSMutableArray *)converToArr:(NSArray *)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary *dic in sourceList) {
            SalaryDateVo *vo = [SalaryDateVo converToVo:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}

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
@end
