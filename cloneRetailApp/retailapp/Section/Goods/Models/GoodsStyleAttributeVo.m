//
//  GoodsStyleAttributeVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsStyleAttributeVo.h"

@implementation GoodsStyleAttributeVo

-(id) initWith:(id<ITreeNode>)orgin
{
    if (self==nil) {
        self=[GoodsStyleAttributeVo new];
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

-(void) addChild:(GoodsStyleAttributeVo*) node
{
    if (self.children==nil || [self.children count]==0) {
        self.children=[NSMutableArray array];
    }
    [self.children addObject:node];
}


@end
