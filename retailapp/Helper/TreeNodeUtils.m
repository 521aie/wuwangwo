//
//  TreeNodeUtils.m
//  RestApp
//
//  Created by zxh on 14-4-25.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TreeNodeUtils.h"
#import "TreeNode.h"
#import "NSString+Estimate.h"
#import "TreeItem.h"
//#import "KindMenu.h"

@implementation TreeNodeUtils

+(NSString*) getParentName:(TreeNode*)node dic:(NSMutableDictionary*)dic isSelf:(BOOL)isSelf
{
    NSString* temp=isSelf?node.itemName:@"";
    if ([node isRoot]) {
        return temp;
    }
    TreeNode* parentNode=[dic objectForKey:node.parentId];
    NSString* pName=[self getParentName:parentNode dic:dic isSelf:YES];
    if ([NSString isBlank:temp]) {
        temp=[NSString stringWithFormat:@"%@",pName];
    }else{
        temp=[NSString stringWithFormat:@"%@-%@",pName,temp];
    }
    return temp;
}

+(NSMutableDictionary*) convertNodeDic:(NSMutableArray*)sources
{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
//    if (sources==nil || [sources count]==0) {
//        return dic;
//    }
//    TreeNode* treeNode=nil;
//    for (KindMenu* kind in sources) {
//        treeNode=[[TreeNode alloc] initWith:kind];
//        [dic setValue:treeNode forKey:kind._id];
//    }
    return dic;
}

+(NSMutableArray*) convertAllNode:(NSMutableArray*)sources
{
    NSMutableArray* targets=[NSMutableArray array];
    if (sources==nil ||  [sources count]==0) {
        return targets;
    }
    for (TreeNode* node in sources) {
        [self addList:node arr:targets level:0];
    }
    return targets;
}

+(void) addList:(TreeNode*)node arr:(NSMutableArray*)arrs level:(int)level
{
    TreeNode* pnode=[node mutableCopy];
    pnode.itemName=[self getName:level name:[node obtainOrignName]];
    [arrs addObject:pnode];
    if (node.children==nil && [node.children count]==0) {
        return;
    }
    level++;
    for (TreeNode* child in node.children) {
        [self addList:child arr:arrs level:level];
    }
}

+(NSString*) getName:(int)level name:(NSString*)name
{
    if (level==0) {
        return name;
    }
    NSMutableString* result=[NSMutableString string];
    [result appendString:@""];
    for (int i=0; i<level; i++) {
        [result appendString:@"▪︎ "];
    }
    [result appendString:@" "];
    [result appendString:name];
    return [NSString stringWithString:result];
}

//转换成末级分类的集合.
+(NSMutableArray*) convertEndNode:(NSMutableArray*)sources
{
    NSMutableArray* targets=[NSMutableArray array];
    if (sources==nil ||  [sources count]==0) {
        return targets;
    }
    for (TreeNode* node in sources) {
        [self addEndList:node arr:targets];
    }
    return targets;
}

+(void) addEndList:(TreeNode*)node arr:(NSMutableArray*)arrs
{
    TreeNode* pnode=[node mutableCopy];
    if ([node isLeaf]) {
        [arrs addObject:pnode];
        return;
    }
    for (TreeNode* child in node.children) {
        [self addEndList:child arr:arrs];
    }
}

//转换多级的末级分类集合（点代表上级类）.
+(NSMutableArray*) convertDotEndNode:(NSMutableArray*)sources level:(int)level showAll:(BOOL) showAll
{
    NSMutableArray* targets=[NSMutableArray array];
    if (sources==nil ||  [sources count]==0) {
        return targets;
    }
    for (TreeNode* node in sources) {
        [self addDotEndList:node arr:targets level:level nowLevel:0 showAll:showAll];
    }
    return targets;
}


+(void) addDotEndList:(TreeNode*)node arr:(NSMutableArray*)arrs level:(int)level nowLevel:(int)thisLevel showAll:(BOOL) showAll
{
    int nowLevel=thisLevel+1;
    TreeNode* pnode=[node mutableCopy];
    NSString* format=nil;
    NSString* tempDot=nil;
    if (showAll || [node isLeaf]) {
        if (level==-1 || nowLevel<=level) {           
            if (thisLevel==0) {
                tempDot=@"";
            } else {
                format=[NSString stringWithFormat:@"%%0%dd",thisLevel];
                tempDot=[NSString stringWithFormat:format,0];
                tempDot=[tempDot stringByReplacingOccurrencesOfString:@"0" withString:@"▪︎"];
            }
            pnode.itemName=[NSString stringWithFormat:@"%@%@",tempDot,node.itemName];;
            [arrs addObject:pnode];
        }
        if ([node isLeaf]) {
            return;
        }
    }
   
    for (TreeNode* child in node.children) {
        [self addDotEndList:child arr:arrs level:level nowLevel:nowLevel showAll:showAll];
    }
}

//转换多级的末级分类集合(全路径).
+(NSMutableArray*) convertMultiEndNode:(NSMutableArray*)sources level:(int)level showAll:(BOOL) showAll
{
    NSMutableArray* targets=[NSMutableArray array];
    if (sources==nil ||  [sources count]==0) {
        return targets;
    }
    for (TreeNode* node in sources) {
        [self addMultiEndList:node arr:targets name:node.itemName level:level nowLevel:0 showAll:showAll];
    }
    return targets;
}


+(void) addMultiEndList:(TreeNode*)node arr:(NSMutableArray*)arrs name:(NSString*)temp level:(int)level nowLevel:(int)thisLevel showAll:(BOOL) showAll
{
    int nowLevel=thisLevel+1;
    TreeNode* pnode=[node mutableCopy];
    if (showAll || [node isLeaf]) {
        if (level==-1 || nowLevel<=level) {
            pnode.itemName=temp;
            [arrs addObject:pnode];
        }
        if ([node isLeaf]) {
            return;
        }
    }
    NSString* pname=nil;
    for (TreeNode* child in node.children) {
        pname=[NSString stringWithFormat:@"%@-%@",temp,child.itemName];
        [self addMultiEndList:child arr:arrs name:pname level:level nowLevel:nowLevel showAll:showAll];
    }
}

//
+(TreeNode*) getFirstRootKind:(NSMutableArray*)treeNodes
{
    TreeNode* root=nil;
    if (treeNodes!=nil && treeNodes.count>0) {
        for (TreeNode* node in treeNodes) {
            if ([node isLeaf]) {
                root= node;
                break;
            }else{
                root=[self getFirstRootKind:node.children];
            }
        }
    }
    return root;
}

+(NSMutableArray*)converToTreeItemArr:(NSArray*)arr
{
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:arr.count];
//    TreeItem* treeItem = nil;
    for (id<ITreeItem> item in arr) {
//        treeItem = [[TreeItem alloc] initWith:item];
        [dataList addObject:item];
    }
    return dataList;
}

@end
