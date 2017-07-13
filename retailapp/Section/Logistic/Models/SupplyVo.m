//
//  SupplyVo.m
//  retailapp
//
//  Created by hm on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SupplyVo.h"

@implementation SupplyVo

-(NSString*) obtainItemId
{
    return self.supplyId;
}
-(NSString*) obtainItemName
{
    return self.supplyName;
}
-(NSString*) obtainItemValue
{
    return self.code;
}

-(NSString*) obtainItemType
{
    return [NSString stringWithFormat:@"%d",self.wareHouseFlg];
}

+ (SupplyVo*)converToVo:(NSDictionary*)dic
{
    SupplyVo* supplyVo = [[SupplyVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        supplyVo.supplyId = [ObjectUtil getStringValue:dic key:@"supplyId"];
        supplyVo.supplyName = [ObjectUtil getStringValue:dic key:@"supplyName"];
        supplyVo.code = [ObjectUtil getStringValue:dic key:@"code"];
        supplyVo.shortName = [ObjectUtil getStringValue:dic key:@"shortname"];
        supplyVo.relation = [ObjectUtil getStringValue:dic key:@"relation"];
        supplyVo.phone = [ObjectUtil getStringValue:dic key:@"phone"];
        supplyVo.mobile = [ObjectUtil getStringValue:dic key:@"mobile"];
        supplyVo.wareHouseFlg = [ObjectUtil getShortValue:dic key:@"wareHouseFlg"];
        
    }
    return supplyVo;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary* dic in sourceList) {
            SupplyVo* supplyVo = [SupplyVo converToVo:dic];
            [dataList addObject:supplyVo];
        }
        return dataList;
    }
    return [NSMutableArray array];
}
@end
