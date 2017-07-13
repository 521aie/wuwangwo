//
//  SubOrgVo.m
//  retailapp
//
//  Created by hm on 15/8/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SubOrgVo.h"
#import "ObjectUtil.h"
@implementation SubOrgVo
+ (SubOrgVo*)converToSubOrg:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        SubOrgVo* org = [SubOrgVo new];
        org._id = [ObjectUtil getStringValue:dic key:@"id"];
        org.code = [ObjectUtil getStringValue:dic key:@"code"];
        org.name = [ObjectUtil getStringValue:dic key:@"name"];
        org.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        org.hierarchyCode = [ObjectUtil getStringValue:dic key:@"hierarchyCode"];
        org.mobile = [ObjectUtil getStringValue:dic key:@"mobile"];
        org.parentId = [ObjectUtil getStringValue:dic key:@"parentId"];
        org.joinMode = [ObjectUtil getIntegerValue:dic key:@"joinMode"];
        org.type = [ObjectUtil getIntegerValue:dic key:@"type"];
        return org;
    }
    return nil;
}

+ (NSMutableArray*)converToSubOrgList:(NSArray*)array
{
    if ([ObjectUtil isNotEmpty:array]) {
        NSMutableArray* arr = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary* dic in array) {
            SubOrgVo* org = [SubOrgVo converToSubOrg:dic];
            if (org) {
                [arr addObject:org];
            }
        }
        return arr;
    }
    return nil;
}

-(NSString*) obtainItemId
{
    return self._id;
}

-(NSString*) obtainItemName
{
    return self.name;
}

-(NSString*) obtainItemValue{
    return self.code;
}

- (NSInteger) obtainItemType{

    return self.type;
    
}

-(NSString*) obtainParentId
{
    return self.parentId;
}

- (NSString *)obtainShopEntityId {
    return self.entityId;
}

- (void)mId:(NSString *)itemId {
    self._id=itemId;
}

-(void) mName:(NSString*)itemName
{
    self.name=itemName;
}

- (void)mVal:(NSString *)itemVal
{
    self.code = itemVal;
}


-(void) mParentId:(NSString*)parentId
{
    self.parentId=parentId;
}

- (NSInteger)obtainJoinMode
{
    return self.joinMode;
}
-(void)mJoinMode:(NSInteger)mode
{
    self.joinMode = mode;
}
- (void)mCheckVal:(BOOL)checkVal
{
    self.checkVal = checkVal;
}
- (BOOL)obtainCheckVal
{
    return self.checkVal;
}

@end
