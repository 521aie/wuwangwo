//
//  GoodsStyleAttributeVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITreeNode.h"
#import "INameItem.h"
#import "INameValueItem.h"
#import "Jastor.h"

@interface GoodsStyleAttributeVo : Jastor<ITreeNode,INameItem,INameValueItem>

@property (nonatomic,strong) NSString* itemId;
@property (nonatomic,strong) NSString* itemName;
@property (nonatomic,strong) NSString* itemVal;
@property (nonatomic,strong) NSString* itemOrignName;
@property (nonatomic,strong) NSString* parentId;
@property (nonatomic) id<ITreeNode> orign;
@property (nonatomic,strong) NSMutableArray* children;

- (void)addChild:(GoodsStyleAttributeVo*) node;
- (id)initWith:(id<ITreeNode>)orgin;
@end
