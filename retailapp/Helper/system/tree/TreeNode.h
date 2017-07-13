//
//  TreeNode.h
//  RestApp
//
//  Created by zxh on 14-4-24.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITreeNode.h"
#import "INameItem.h"
#import "INameValueItem.h"
#import "Jastor.h"

@interface TreeNode : Jastor<ITreeNode,INameItem,INameValueItem>

@property (nonatomic,retain) NSString* itemId;
@property (nonatomic,retain) NSString* itemName;
@property (nonatomic,retain) NSString* itemVal;
@property (nonatomic,retain) NSString* itemOrignName;
@property (nonatomic,retain) NSString* parentId;
@property (nonatomic) id<ITreeNode> orign;
@property (nonatomic) NSMutableArray* children;

- (id)initWith:(id<ITreeNode>)orgin;
- (void)addChild:(TreeNode*) node;
- (BOOL)isLeaf;
- (BOOL)isRoot;

@end
