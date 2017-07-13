//
//  TreeItem.m
//  retailapp
//
//  Created by hm on 15/8/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "TreeItem.h"

@implementation TreeItem

-(id) initWith:(id<ITreeItem>)orgin
{
    if (self==nil) {
        self=[TreeItem new];
    }
    self.orign=orgin;
    if (self.orign) {
        [self mId:[orgin obtainItemId]];
        [self mName:[orgin obtainItemName]];
        [self mVal:[orgin obtainItemValue]];
        [self mType:[orgin obtainItemType]];
        [self mParentId:[orgin obtainParentId]];
        [self mJoinMode:[orgin obtainJoinMode]];
        [self mCheckVal:[orgin obtainCheckVal]];
        self.entityId = [orgin obtainShopEntityId];
    }
    return self;
}


-(void) addChild:(TreeItem*) item
{
    if (self.subItems==nil || [self.subItems count]==0) {
        self.subItems=[NSMutableArray array];
    }
    [self.subItems addObject:item];
}


-(BOOL) isRoot
{
    return ([NSString isBlank:self.parentId] || [self.parentId isEqualToString:@"-1"] || [self.parentId isEqualToString:@"0"]) ;
}

-(NSString*) obtainItemId
{
    return self.itemId;
}

-(NSString*) obtainItemName
{
    return self.itemName;
}

- (NSString*) obtainItemValue
{
    return self.itemVal;
}

-(NSString*) obtainParentId
{
    return self.parentId;
}

- (NSInteger)obtainItemType
{
    return self.type;
}

-(void) mId:(NSString*)itemId
{
    self.itemId=itemId;
}

-(void) mName:(NSString*)itemName
{
    self.itemName=itemName;
}

-(void) mVal:(NSString *)itemVal
{
    self.itemVal = itemVal;
}
- (void)mType:(NSInteger)type
{
    self.type  = type;
}

-(void) mParentId:(NSString*)parentId
{
    self.parentId=parentId;
}

- (BOOL)obtainCheckVal
{
    return self.checkVal;
}
- (void)mCheckVal:(BOOL)checkVal
{
    self.checkVal = checkVal;
}

- (NSInteger)obtainJoinMode
{
    return self.joinMode;
}
-(void)mJoinMode:(NSInteger)mode
{
    self.joinMode = mode;
}

- (NSString *)obtainShopEntityId {
    return self.entityId;
}

- (NSString *)obtainParentCode
{
    return self.parentCode;
}

- (void)mParentCode:(NSString *)parentCode
{
    self.parentCode = parentCode;
}

@end
