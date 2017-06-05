//
//  ShopVo.m
//  retailapp
//
//  Created by hm on 15/8/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopVo.h"
#import "ObjectUtil.h"
#import "NumberUtil.h"
#import "PurchaseSupplyVo.h"
#import "MicroGoodsImageVo.h"

@implementation ShopVo
- (instancetype)initWithDictionary:(NSDictionary *)json {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"purchaseSupplyVoList"]) {
        self.purchaseSupplyVoList = [[NSMutableArray alloc] init];
        for (NSDictionary *json in value) {
            PurchaseSupplyVo *purchaseSupplyVo = [[PurchaseSupplyVo alloc] initWithDictionary:json];
            [self.purchaseSupplyVoList addObject:purchaseSupplyVo];
        }
    } else {
        [super setValue:value forKey:key];
    }
}
+ (ShopVo*)convertToShop:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        ShopVo* shopVo = [[ShopVo alloc] init];
        shopVo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
        shopVo.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        shopVo.entityCode = [ObjectUtil getStringValue:dic key:@"entityCode"];
        shopVo.parentId = [ObjectUtil getStringValue:dic key:@"parentId"];
        shopVo.shopName = [ObjectUtil getStringValue:dic key:@"shopName"];
        shopVo.shopType = [ObjectUtil getStringValue:dic key:@"shopType"];
        shopVo.shortName = [ObjectUtil getStringValue:dic key:@"shortName"];
        shopVo.profession = [ObjectUtil getNumberValue:dic key:@"profession"];
        shopVo.orgId = [ObjectUtil getStringValue:dic key:@"orgId"];
        shopVo.orgName = [ObjectUtil getStringValue:dic key:@"orgName"];
        shopVo.provinceId = [ObjectUtil getStringValue:dic key:@"provinceId"];
        shopVo.cityId = [ObjectUtil getStringValue:dic key:@"cityId"];
        shopVo.countyId = [ObjectUtil getStringValue:dic key:@"countyId"];
        shopVo.address = [ObjectUtil getStringValue:dic key:@"address"];
        shopVo.area = [ObjectUtil getNumberValue:dic key:@"area"];
        shopVo.linkman = [ObjectUtil getStringValue:dic key:@"linkman"];
        shopVo.phone1 = [ObjectUtil getStringValue:dic key:@"phone1"];
        shopVo.phone2 = [ObjectUtil getStringValue:dic key:@"phone2"];
        shopVo.weixin = [ObjectUtil getStringValue:dic key:@"weixin"];
        shopVo.startTime = [ObjectUtil getStringValue:dic key:@"startTime"];
        shopVo.endTime = [ObjectUtil getStringValue:dic key:@"endTime"];
        shopVo.introduce = [ObjectUtil getStringValue:dic key:@"introduce"];
        shopVo.businessTime = [ObjectUtil getStringValue:dic key:@"businessTime"];
        shopVo.file = [ObjectUtil getStringValue:dic key:@"file"];
        shopVo.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
        shopVo.fileOperate = [ObjectUtil getNumberValue:dic key:@"fileOperate"];
        shopVo.attachmentId = [ObjectUtil getStringValue:dic key:@"attachmentId"];
        shopVo.appId = [ObjectUtil getStringValue:dic key:@"appId"];
        shopVo.brandId = [ObjectUtil getStringValue:dic key:@"brandId"];
        shopVo.code = [ObjectUtil getStringValue:dic key:@"code"];
        shopVo.flag = @"0";
        shopVo.dataFromShopId = [ObjectUtil getStringValue:dic key:@"dataFromShopId"];
        shopVo.industry = [ObjectUtil getIntegerValue:dic key:@"industry"];
        shopVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        shopVo.appointCompany = [ObjectUtil getStringValue:dic key:@"appointCompany"];
        shopVo.purchaseSupplyVoList = [PurchaseSupplyVo converToArr:[dic objectForKey:@"purchaseSupplyVoList"]];
        shopVo.shopEntityId = [ObjectUtil getStringValue:dic key:@"shopEntityId"];
        
        shopVo.mainImageVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"mainImageVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"mainImageVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    MicroGoodsImageVo *microGoodsImageVo = [MicroGoodsImageVo convertToMicroGoodsImageVo:dic1];
                    microGoodsImageVo.fileName = [NSString getImagePath:microGoodsImageVo.filePath];
                    [shopVo.mainImageVoList addObject:microGoodsImageVo];
                }
            }
        }

        
        return shopVo;
    }
    return nil;
}

+ (NSDictionary*)getDictionaryData:(ShopVo*)shopVo
{
    if ([ObjectUtil isNotNull:shopVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"shopId" val:shopVo.shopId];
        [ObjectUtil setStringValue:data key:@"entityId" val:shopVo.entityId];
        [ObjectUtil setStringValue:data key:@"entityCode" val:shopVo.entityCode];
        [ObjectUtil setStringValue:data key:@"parentId" val:shopVo.parentId];
        [ObjectUtil setStringValue:data key:@"shopName" val:shopVo.shopName];
        [ObjectUtil setStringValue:data key:@"shopType" val:shopVo.shopType];
        [ObjectUtil setStringValue:data key:@"shortName" val:shopVo.shortName];
        [ObjectUtil setStringValue:data key:@"orgId" val:shopVo.orgId];
        [ObjectUtil setStringValue:data key:@"orgName" val:shopVo.orgName];
        [ObjectUtil setNumberValue:data key:@"profession" val:shopVo.profession];
        [ObjectUtil setStringValue:data key:@"provinceId" val:shopVo.provinceId];
        [ObjectUtil setStringValue:data key:@"cityId" val:shopVo.cityId];
        [ObjectUtil setStringValue:data key:@"countyId" val:shopVo.countyId];
        [ObjectUtil setStringValue:data key:@"address" val:shopVo.address];
        [ObjectUtil setNumberValue:data key:@"area" val:shopVo.area];
        [ObjectUtil setStringValue:data key:@"linkman" val:shopVo.linkman];
        [ObjectUtil setStringValue:data key:@"phone1" val:shopVo.phone1];
        [ObjectUtil setStringValue:data key:@"phone2" val:shopVo.phone2];
        [ObjectUtil setStringValue:data key:@"weixin" val:shopVo.weixin];
        [ObjectUtil setStringValue:data key:@"startTime" val:shopVo.startTime];
        [ObjectUtil setStringValue:data key:@"endTime" val:shopVo.endTime];
        [ObjectUtil setStringValue:data key:@"businessTime" val:shopVo.businessTime];
        [ObjectUtil setStringValue:data key:@"file" val:shopVo.file];
        [ObjectUtil setStringValue:data key:@"fileName" val:shopVo.fileName];
        [ObjectUtil setNumberValue:data key:@"fileOperate" val:shopVo.fileOperate];
        [ObjectUtil setStringValue:data key:@"attachmentId" val:shopVo.attachmentId];
        [ObjectUtil setStringValue:data key:@"appId" val:shopVo.appId];
        [ObjectUtil setStringValue:data key:@"brandId" val:shopVo.brandId];
        [ObjectUtil setStringValue:data key:@"code" val:shopVo.code];
        [ObjectUtil setStringValue:data key:@"copyFlag" val:shopVo.flag];
        [ObjectUtil setStringValue:data key:@"dataFromShopId" val:shopVo.dataFromShopId];
        [ObjectUtil setIntegerValue:data key:@"industry" val:shopVo.industry];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:shopVo.lastVer];
        [ObjectUtil setStringValue:data key:@"appointCompany" val:shopVo.appointCompany];
        [ObjectUtil setStringValue:data key:@"shopEntityId" val:shopVo.shopEntityId];
        [ObjectUtil setNumberValue:data key:@"profession" val:shopVo.profession];
        [ObjectUtil setStringValue:data key:@"introduce" val:shopVo.introduce];
        [data setValue:[PurchaseSupplyVo converToDicArr:shopVo.purchaseSupplyVoList] forKey:@"purchaseSupplyVoList"];
        
        if (shopVo.mainImageVoList != nil && shopVo.mainImageVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (MicroGoodsImageVo* vo in shopVo.mainImageVoList) {
                [list addObject:[MicroGoodsImageVo getDictionaryData:vo]];
            }
            [data setValue:list forKey:@"mainImageVoList"];
        }
        return data;
    }
    return nil;
}

-(NSString*) obtainItemId
{
    return self.shopId;
}
-(NSString*) obtainItemName
{
    return self.shopName;
}
-(NSString*) obtainItemValue
{
    return self.code;
}

@end
