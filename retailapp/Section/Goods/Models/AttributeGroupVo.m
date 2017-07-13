//
//  AttributeGroupVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AttributeGroupVo.h"

@implementation AttributeGroupVo

-(NSString*)obtainItemId
{
    return self.attributeGroupId;
}

-(NSString*) obtainItemName
{
    return self.attributeGroupName;
    
}

-(NSString*) obtainOrignName
{
    return self.attributeGroupId;
}

+(id) attributeValVoList_class
{
    return NSClassFromString(@"AttributeValVo");
}

@end
