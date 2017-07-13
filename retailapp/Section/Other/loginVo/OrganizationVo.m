//
//  OrganizationVo.m
//  retailapp
//
//  Created by hm on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrganizationVo.h"
#import "ObjectUtil.h"
#import "PurchaseSupplyVo.h"

@implementation OrganizationVo
+ (OrganizationVo*)convertToOrganization:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        OrganizationVo* org = [[OrganizationVo alloc] init];
        org.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        org.organizationId = [ObjectUtil getStringValue:dic key:@"id"];
        org.name = [ObjectUtil getStringValue:dic key:@"name"];
        org.code = [ObjectUtil getStringValue:dic key:@"code"];
        org.type = [ObjectUtil getIntegerValue:dic key:@"type"];
        org.parentId = [ObjectUtil getStringValue:dic key:@"parentId"];
        org.parentName = [ObjectUtil getStringValue:dic key:@"parentName"];
        org.joinMode = [ObjectUtil getIntegerValue:dic key:@"joinMode"];
        org.attachmentId = [ObjectUtil getStringValue:dic key:@"attachmentId"];
        org.provinceId = [ObjectUtil getStringValue:dic key:@"provinceId"];
        org.cityId = [ObjectUtil getStringValue:dic key:@"cityId"];
        org.countyId = [ObjectUtil getStringValue:dic key:@"countyId"];
        org.address = [ObjectUtil getStringValue:dic key:@"address"];
        org.linkman = [ObjectUtil getStringValue:dic key:@"linkman"];
        org.mobile = [ObjectUtil getStringValue:dic key:@"mobile"];
        org.tel = [ObjectUtil getStringValue:dic key:@"tel"];
        org.file = [ObjectUtil getStringValue:dic key:@"file"];
        org.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
        org.fileOperate = [ObjectUtil getNumberValue:dic key:@"fileOperate"];
        org.sortCode = [ObjectUtil getIntegerValue:dic key:@"sortCode"];
        org.brandId = [ObjectUtil getStringValue:dic key:@"brandId"];
        org.spell = [ObjectUtil getStringValue:dic key:@"spell"];
        org.appId = [ObjectUtil getStringValue:dic key:@"appId"];
        org.hierarchyCode = [ObjectUtil getStringValue:dic key:@"hierarchyCode"];
        org.sonCount = [ObjectUtil getIntegerValue:dic key:@"sonCount"];
        org.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        org.allowSupply = [ObjectUtil getStringValue:dic key:@"allowSupply"];
        org.appointCompany = [ObjectUtil getStringValue:dic key:@"appointCompany"];
        org.purchaseSupplyVoList = [PurchaseSupplyVo converToArr:[dic objectForKey:@"purchaseSupplyVoList"]];
        return org;
    }
    return nil;
}

+ (NSDictionary*)getDictionaryData:(OrganizationVo*)orgVo
{
    if ([ObjectUtil isNotNull:orgVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"entityId" val:orgVo.entityId];
        [ObjectUtil setStringValue:data key:@"id" val:orgVo.organizationId];
        [ObjectUtil setStringValue:data key:@"name" val:orgVo.name];
        [ObjectUtil setStringValue:data key:@"code" val:orgVo.code];
        [ObjectUtil setIntegerValue:data key:@"type" val:orgVo.type];
        [ObjectUtil setStringValue:data key:@"parentId" val:orgVo.parentId];
        [ObjectUtil setStringValue:data key:@"parentName" val:orgVo.parentName];
        [ObjectUtil setIntegerValue:data key:@"joinMode" val:orgVo.joinMode];
        [ObjectUtil setStringValue:data key:@"attachmentId" val:orgVo.attachmentId];
        [ObjectUtil setStringValue:data key:@"provinceId" val:orgVo.provinceId];
        [ObjectUtil setStringValue:data key:@"cityId" val:orgVo.cityId];
        [ObjectUtil setStringValue:data key:@"countyId" val:orgVo.countyId];
        [ObjectUtil setStringValue:data key:@"address" val:orgVo.address];
        [ObjectUtil setStringValue:data key:@"linkman" val:orgVo.linkman];
        [ObjectUtil setStringValue:data key:@"mobile" val:orgVo.mobile];
        [ObjectUtil setStringValue:data key:@"tel" val:orgVo.tel];
        [ObjectUtil setStringValue:data key:@"file" val:orgVo.file];
        [ObjectUtil setStringValue:data key:@"fileName" val:orgVo.fileName];
        [ObjectUtil setNumberValue:data key:@"fileOperate" val:orgVo.fileOperate];
        [ObjectUtil setIntegerValue:data key:@"sortCode" val:orgVo.sortCode];
        [ObjectUtil setStringValue:data key:@"appId" val:orgVo.appId];
        [ObjectUtil setStringValue:data key:@"brandId" val:orgVo.brandId];
        [ObjectUtil setStringValue:data key:@"spell" val:orgVo.spell];
        [ObjectUtil setStringValue:data key:@"hierarchyCode" val:orgVo.hierarchyCode];
        [ObjectUtil setIntegerValue:data key:@"sonCount" val:orgVo.sonCount];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:orgVo.lastVer];
        [ObjectUtil setStringValue:data key:@"allowSupply" val:orgVo.allowSupply];
        [ObjectUtil setStringValue:data key:@"appointCompany" val:orgVo.appointCompany];
        [data setValue:[PurchaseSupplyVo converToDicArr:orgVo.purchaseSupplyVoList] forKey:@"purchaseSupplyVoList"];
        return data;
    }
    return nil;
}

+ (NSMutableArray*)getArrayData:(NSArray*)arr
{
    if ([ObjectUtil isNotEmpty:arr]) {
        NSMutableArray* orgList = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSDictionary* dic in arr) {
            OrganizationVo* org = [OrganizationVo convertToOrganization:dic];
            if (dic) {
                [orgList addObject:org];
            }
        }
        return orgList;
    }
    return nil;
}

-(NSString*) obtainItemId
{
    return self.organizationId;
}
-(NSString*) obtainItemName
{
    return self.name;
}
-(NSString*) obtainItemValue
{
    return self.code;
}

@end
