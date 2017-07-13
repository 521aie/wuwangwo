//
//  WareHouseVo.m
//  retailapp
//
//  Created by hm on 15/10/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WareHouseVo.h"

@implementation WareHouseVo
+ (WareHouseVo*)converToVo:(NSDictionary*)dic
{
    WareHouseVo* wareHouseVo = [[WareHouseVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        wareHouseVo.wareHouseId = [ObjectUtil getStringValue:dic key:@"wareHouseId"];
        wareHouseVo.wareHouseName = [ObjectUtil getStringValue:dic key:@"wareHouseName"];
        wareHouseVo.wareHouseCode = [ObjectUtil getStringValue:dic key:@"wareHouseCode"];
        wareHouseVo.type = 2;
        wareHouseVo.orgId = [ObjectUtil getStringValue:dic key:@"orgId"];
        wareHouseVo.orgName = [ObjectUtil getStringValue:dic key:@"orgName"];
        wareHouseVo.provinceId = [ObjectUtil getStringValue:dic key:@"provinceId"];
        wareHouseVo.cityId = [ObjectUtil getStringValue:dic key:@"cityId"];
        wareHouseVo.countryId = [ObjectUtil getStringValue:dic key:@"countryId"];
        wareHouseVo.address = [ObjectUtil getStringValue:dic key:@"address"];
        wareHouseVo.linkMan = [ObjectUtil getStringValue:dic key:@"linkMan"];
        wareHouseVo.mobile = [ObjectUtil getStringValue:dic key:@"mobile"];
        wareHouseVo.phone = [ObjectUtil getStringValue:dic key:@"phone"];
        wareHouseVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
//        wareHouseVo.supplyCode = [ObjectUtil getStringValue:dic key:@"asSupplyCode"];
//        wareHouseVo.supplyTypeName = [ObjectUtil getStringValue:dic key:@"supplyTypeName"];
//        wareHouseVo.supplyTypeVal = [ObjectUtil getStringValue:dic key:@"supplyTypeVal"];
//        wareHouseVo.supplyFlg = [ObjectUtil getShortValue:dic key:@"supplyFlg"];
//        wareHouseVo.isAppointSupply = [ObjectUtil getShortValue:dic key:@"isAppointSupply"];
        wareHouseVo.operateType = [ObjectUtil getStringValue:dic key:@"operateType"];

        wareHouseVo.checkVal = NO;
    }
    return wareHouseVo;
}
+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray* datas = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            WareHouseVo* vo = [WareHouseVo converToVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

+ (NSMutableDictionary *)converToDic:(WareHouseVo *)wareHouseVo
{
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:wareHouseVo]) {
        [ObjectUtil setStringValue:datas key:@"wareHouseId" val:wareHouseVo.wareHouseId];
        [ObjectUtil setStringValue:datas key:@"wareHouseName" val:wareHouseVo.wareHouseName];
        [ObjectUtil setStringValue:datas key:@"wareHouseCode" val:wareHouseVo.wareHouseCode];
        [ObjectUtil setStringValue:datas key:@"orgId" val:wareHouseVo.orgId];
        [ObjectUtil setStringValue:datas key:@"orgName" val:wareHouseVo.orgName];
        [ObjectUtil setStringValue:datas key:@"provinceId" val:wareHouseVo.provinceId];
        [ObjectUtil setStringValue:datas key:@"cityId" val:wareHouseVo.cityId];
        [ObjectUtil setStringValue:datas key:@"countryId" val:wareHouseVo.countryId];
        [ObjectUtil setStringValue:datas key:@"address" val:wareHouseVo.address];
        [ObjectUtil setStringValue:datas key:@"linkMan" val:wareHouseVo.linkMan];
        [ObjectUtil setStringValue:datas key:@"mobile" val:wareHouseVo.mobile];
        [ObjectUtil setStringValue:datas key:@"phone" val:wareHouseVo.phone];
        [ObjectUtil setStringValue:datas key:@"wareHouseId" val:wareHouseVo.wareHouseId];
        [ObjectUtil setStringValue:datas key:@"wareHouseId" val:wareHouseVo.wareHouseId];
        [ObjectUtil setStringValue:datas key:@"wareHouseId" val:wareHouseVo.wareHouseId];
        [ObjectUtil setIntegerValue:datas key:@"lastVer" val:wareHouseVo.lastVer];
//        [ObjectUtil setStringValue:datas key:@"asSupplyCode" val:wareHouseVo.supplyCode];
//        [ObjectUtil setStringValue:datas key:@"supplyTypeName" val:wareHouseVo.supplyTypeName];
//        [ObjectUtil setStringValue:datas key:@"supplyTypeVal" val:wareHouseVo.supplyTypeVal];
//        [ObjectUtil setShortValue:datas key:@"supplyFlg" val:wareHouseVo.supplyFlg];
//        [ObjectUtil setShortValue:datas key:@"isAppointSupply" val:wareHouseVo.isAppointSupply];
        [ObjectUtil setStringValue:datas key:@"operateType" val:wareHouseVo.operateType];
    }
    return datas;
}

+ (NSMutableArray *)converObjArrToDicArr:(NSMutableArray *)sourceList
{
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (WareHouseVo *vo in sourceList) {
            NSMutableDictionary *dic = [WareHouseVo converToDic:vo];
            [datas addObject:dic];
        }
    }
    return datas;
}

-(NSString*) obtainItemId
{
    return self.wareHouseId;
}
-(NSString*) obtainItemName
{
    return self.wareHouseName;
}
-(NSString*) obtainItemCode
{
    return self.wareHouseCode;
}
-(short) obtainItemType
{
    return self.type;
}


-(void)mOperateType:(NSString *)type
{
    self.operateType = type;
}

-(NSString*)obtainOperateType
{
    return self.operateType;
}


-(BOOL) obtainCheckVal
{
    return self.checkVal;
}
-(void) mCheckVal:(BOOL)check
{
    self.checkVal = check;
}

-(NSString*) obtainItemValue {
    return self.wareHouseCode;
}

@end
