//
//  SupplyTypeVo.m
//  retailapp
//
//  Created by hm on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SupplyTypeVo.h"

@implementation SupplyTypeVo
+ (SupplyTypeVo *)converToVo:(NSDictionary *)dic
{
    SupplyTypeVo *supplyTypeVo = [[SupplyTypeVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        supplyTypeVo.dicItemId = [ObjectUtil getStringValue:dic key:@"dicItemId"];
        supplyTypeVo.typeName = [ObjectUtil getStringValue:dic key:@"typeName"];
        supplyTypeVo.typeVal = [ObjectUtil getStringValue:dic key:@"typeVal"];
    }
    return supplyTypeVo;
}
+ (NSMutableArray *)converToArr:(NSArray *)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary *dic in sourceList) {
            if (![@"-1" isEqualToString:[dic objectForKey:@"typeVal"]]) {
                SupplyTypeVo* vo = [SupplyTypeVo converToVo:dic];
                [datas addObject:vo];
            }
        }
        return datas;
    }
    return [NSMutableArray array];
}

-(NSString*) obtainItemId
{
    return self.dicItemId;
}
-(NSString*) obtainItemName
{
    return self.typeName;
}

-(NSString*) obtainItemValue
{
    return self.typeVal;
}

@end
