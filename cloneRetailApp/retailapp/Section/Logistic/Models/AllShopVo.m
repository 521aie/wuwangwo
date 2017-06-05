//
//  AllShopVo.m
//  retailapp
//
//  Created by hm on 15/10/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AllShopVo.h"

@implementation AllShopVo
+ (AllShopVo*)converToVo:(NSDictionary*)dic
{
    AllShopVo* allShopVo = [[AllShopVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        allShopVo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
        allShopVo.shopEntityId = [ObjectUtil getStringValue:dic key:@"shopEntityId"];
        allShopVo.shopName = [ObjectUtil getStringValue:dic key:@"shopName"];
        allShopVo.code = [ObjectUtil getStringValue:dic key:@"code"];
        allShopVo.shopType = [ObjectUtil getShortValue:dic key:@"shopType"];;
        allShopVo.operateType = [ObjectUtil getStringValue:dic key:@"operateType"];
        allShopVo.orgId = [ObjectUtil getStringValue:dic key:@"orgId"];
        allShopVo.checkVal = NO;
    }
    return allShopVo;
}
+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray* datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary* dic in sourceList) {
            AllShopVo* vo = [AllShopVo converToVo:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}

+ (NSMutableDictionary *)converToDic:(AllShopVo *)shopVo
{
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:shopVo]) {
        [ObjectUtil setStringValue:datas key:@"shopId" val:shopVo.shopId];
        [ObjectUtil setStringValue:datas key:@"shopEntityId" val:shopVo.shopEntityId];
        [ObjectUtil setStringValue:datas key:@"shopName" val:shopVo.shopName];
        [ObjectUtil setStringValue:datas key:@"code" val:shopVo.code];
        [ObjectUtil setShortValue:datas key:@"shopType" val:shopVo.shopType];
        [ObjectUtil setStringValue:datas key:@"operateType" val:shopVo.operateType];
    }
    return datas;
}

+ (NSMutableArray *)converObjArrToDicArr:(NSMutableArray *)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (AllShopVo* shopVo in sourceList) {
            NSMutableDictionary *dic = [AllShopVo converToDic:shopVo];
            [datas addObject:dic];
        }
        return datas;
    }
    return [NSMutableArray array];
}

-(NSString*) obtainItemId
{
    return self.shopId;
}
-(NSString*) obtainItemEntityId
{
    return self.shopEntityId;
}
-(NSString*) obtainItemName
{
    return self.shopName;
}
-(NSString*) obtainItemCode
{
    return self.code;
}
-(short) obtainItemType
{
    return self.shopType;
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
    return self.code;
}

-(NSString*)obtainOrgId
{
    return self.orgId;
}

@end
