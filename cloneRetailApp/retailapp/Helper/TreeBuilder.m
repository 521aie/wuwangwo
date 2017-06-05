//
//  TreeBuilder.m
//  RestApp
//
//  Created by zxh on 14-4-24.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TreeBuilder.h"
#import "ITreeNode.h"
#import "TreeNode.h"
#import "ITreeItem.h"
#import "TreeItem.h"

@implementation TreeBuilder
+(NSMutableArray*) buildTree:(NSMutableArray*)sourceList
{
    NSMutableArray* rootList=[NSMutableArray array];
    if (sourceList==nil || [sourceList count]==0) {
        return rootList;
    }
    NSMutableArray* childList=[NSMutableArray array];
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    TreeNode* treeNode=nil;
    for (id<ITreeNode> node in sourceList) {
        treeNode=[[TreeNode alloc] initWith:node];
        if ([treeNode isRoot]) {
            [rootList addObject:treeNode];
        }else{
            [childList addObject:treeNode];
        }
        [dic setValue:treeNode forKey:[node obtainItemId]];
    }
    TreeNode* parentNode=nil;
    for (TreeNode* node in childList) {
        parentNode=[dic objectForKey:[node obtainParentId]];
        if (parentNode) {
            [parentNode addChild:node];
        }else{
            [rootList addObject:node];
        }
    }
    return rootList;
}

+(NSMutableArray*) buildTreeItem:(NSMutableArray*)sourceList
{
    NSMutableArray* rootList=[NSMutableArray array];
    if (sourceList==nil || [sourceList count]==0) {
        return rootList;
    }
    NSMutableArray* childList=[NSMutableArray array];
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    TreeItem* treeItem=nil;
    for (id<ITreeItem> item in sourceList) {
        treeItem=[[TreeItem alloc] initWith:item];
        if ([treeItem isRoot]) {
            [treeItem mParentCode:[treeItem obtainItemValue]];
            [rootList addObject:treeItem];
        }else{
            [childList addObject:treeItem];
        }
        [dic setValue:treeItem forKey:[item obtainItemId]];
    }
    TreeItem* parentItem=nil;
    for (TreeItem* item in childList) {
        parentItem=[dic objectForKey:[item obtainParentId]];
        if (parentItem) {
            [parentItem addChild:item];
        }else{
            [rootList addObject:item];
        }
    }
    [self setTreeItemLevel:rootList level:1];
    return rootList;
}

+ (void)setTreeItemLevel:(NSMutableArray*)sources level:(NSInteger)level
{
    if (sources==nil||sources.count==0) {
        return;
    }
    for (TreeItem* item in sources) {
        item.level = level;
        [self setTreeItemLevel:item.subItems level:level+1];
    }

}


@end
