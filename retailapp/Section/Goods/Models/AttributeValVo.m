//
//  AttributeValVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AttributeValVo.h"

@implementation AttributeValVo

+(AttributeValVo*)convertToAttributeValVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        AttributeValVo* attributeValVo = [[AttributeValVo alloc] init];
        attributeValVo.attributeValId = [ObjectUtil getStringValue:dic key:@"attributeValId"];
        attributeValVo.attributeNameId = [ObjectUtil getStringValue:dic key:@"attributeNameId"];
        attributeValVo.attributeVal = [ObjectUtil getStringValue:dic key:@"attributeVal"];
        attributeValVo.attributeValGroup = [ObjectUtil getStringValue:dic key:@"attributeValGroup"];
        attributeValVo.attributeCode = [ObjectUtil getStringValue:dic key:@"attributeCode"];
        attributeValVo.attributeType = [ObjectUtil getShortValue:dic key:@"attributeType"];
        attributeValVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        attributeValVo.microGoodPrice = [ObjectUtil getDoubleValue:dic key:@"microGoodPrice"];
        attributeValVo.goodsIdList=[dic objectForKey:@"goodsIdList"];
        attributeValVo.colorHangTagPrice=[ObjectUtil getDoubleValue:dic key:@"colorHangTagPrice"];
        return attributeValVo;
    }
    
    return nil;

}

+(NSDictionary*)getDictionaryData:(AttributeValVo *)attributeValVo
{
    if ([ObjectUtil isNotNull:attributeValVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"attributeValId" val:attributeValVo.attributeValId];
        [ObjectUtil setStringValue:data key:@"attributeNameId" val:attributeValVo.attributeNameId];
        [ObjectUtil setStringValue:data key:@"attributeVal" val:attributeValVo.attributeVal];
        [ObjectUtil setStringValue:data key:@"attributeValGroup" val:attributeValVo.attributeValGroup];
        [ObjectUtil setStringValue:data key:@"attributeCode" val:attributeValVo.attributeCode];
        [ObjectUtil setShortValue:data key:@"attributeType" val:attributeValVo.attributeType];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:attributeValVo.lastVer];
        [ObjectUtil setDoubleValue:data key:@"microGoodPrice" val:attributeValVo.microGoodPrice];
        [ObjectUtil setDoubleValue:data key:@"colorHangTagPrice" val:attributeValVo.colorHangTagPrice];
        if([ObjectUtil isNotEmpty:attributeValVo.goodsIdList]){
            [data setValue:attributeValVo.goodsIdList forKey:@"goodsIdList"];
        }
        return data;
    }
    
    return nil;
}

+ (NSMutableArray *)convertToDicListFromArr:(NSMutableArray *)array {
    if ([ObjectUtil isNotEmpty:array]) {
        NSMutableArray *dicList = [[NSMutableArray alloc] init];
        
        for (AttributeValVo *attributeValVo in array) {
            NSDictionary *dic  = [AttributeValVo getDictionaryData:attributeValVo];
            [dicList addObject:dic];
        }
        return dicList;
    }
    return nil;
}

-(NSString*) obtainItemId
{
    return self.attributeValId;
}
-(NSString*) obtainItemName
{
    return self.attributeVal;
}
-(NSString*) obtainOrignName
{
    return self.attributeVal;
}

@end
