//
//  NameValueItemVO.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "NameValueItemVO.h"

@implementation NameValueItemVO

-(NSString*) obtainItemId
{
    return self.itemId;
}

-(NSString*) obtainItemName
{
    return self.itemName;
}

-(NSString*) obtainOrignName
{
    return self.itemName;
}

-(NSString*) obtainItemValue
{
    return self.itemVal;
}

-(id)initWithVal:(NSString*)name val:(NSString*)val andId:(NSString*)itemId
{
    self.itemId=itemId;
    self.itemName=name;
    self.itemVal=val;
    return self;
}

@end
