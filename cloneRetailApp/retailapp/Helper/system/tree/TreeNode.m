//
//  TreeNode.m
//  RestApp
//
//  Created by zxh on 14-4-24.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TreeNode.h"
#import "NSString+Estimate.h"
#import "NSMutableArray+DeepCopy.h"

@implementation TreeNode

-(id) initWith:(id<ITreeNode>)orgin
{
    if (self==nil) {
        self=[TreeNode new];
    }
    self.orign=orgin;
    if (self.orign) {
        [self mId:[orgin obtainItemId]];
        [self mName:[orgin obtainItemName]];
        self.itemOrignName=[orgin obtainItemName];
        [self mParentId:[orgin obtainParentId]];
    }
    return self;
}

-(void) addChild:(TreeNode*) node
{
    if (self.children==nil || [self.children count]==0) {
        self.children=[NSMutableArray array];
    }
    [self.children addObject:node];
}

-(BOOL) isLeaf
{
    return (self.children==nil || [self.children count]==0);
}

-(BOOL) isRoot
{
    return ([NSString isBlank:self.parentId] || [self.parentId isEqualToString:@"-1"] || [self.parentId isEqualToString:@"0"]) ;
}


-(NSString*) obtainItemId
{
    return self.itemId;
}

-(NSString*) obtainItemValue
{
    if (self.itemVal != nil) {
        return self.itemVal;
    }
    return @"";
}

-(NSString*) obtainItemName
{
    return self.itemName;
}

-(NSString*) obtainOrignName
{
    return self.itemOrignName;
}

-(NSString*) obtainParentId
{
    return self.parentId;
}

-(void) mId:(NSString*)itemId
{
    self.itemId=itemId;
}

-(void) mName:(NSString*)itemName
{
    self.itemName=itemName;
}

-(void) mParentId:(NSString*)parentId
{
    self.parentId=parentId;
}


-(id)mutableCopyWithZone:(NSZone*) zone
{
    TreeNode* node=[[[self class] allocWithZone:zone] init];
    node.itemId=[self.itemId copy];
    node.itemName=[self.itemName copy];
    node.itemOrignName=[self.itemOrignName copy];
    node.parentId=[self.parentId copy];
    node.orign=[self.orign copy];
    node.children=[self.children deepCopy];
    
    return node;
}

-(id)copyWithZone:(NSZone*) zone
{
    TreeNode* node=[[[self class] allocWithZone:zone] init];
    node.itemId=[self.itemId copy];
    node.itemName=[self.itemName copy];
    node.itemOrignName=[self.itemOrignName copy];
    node.parentId=[self.parentId copy];
    node.orign=[self.orign copy];
    node.children=[self.children deepCopy];

    return node;
}

@end
