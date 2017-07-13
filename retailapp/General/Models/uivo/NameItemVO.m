//
//  NameItemVO.m
//  RestApp
//
//  Created by zxh on 14-4-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "NameItemVO.h"

@implementation NameItemVO

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

-(NSInteger) obtainItemSortCode{
    return self.itemSortCode;
}
-(NSString*) obtainItemValue
{
    return @"";
}

-(id)initWithVal:(NSString*)name andId:(NSString*)itemId
{
    self.itemId=itemId;
    self.itemName=name;
    return self;
}

-(id)initWithVal:(NSString*)name andId:(NSString*)itemId  andSortCode:(NSInteger) itemSortCode
{
    self.itemId=itemId;
    self.itemName=name;
    self.itemSortCode=itemSortCode;
    return self;
}

-(id)mutableCopyWithZone:(NSZone*) zone
{
    NameItemVO* obj=[[[self class] allocWithZone:zone] init];
    obj.itemId=[self.itemId copy];
    obj.itemName=[self.itemName copy];
    return obj;
}

-(id)copyWithZone:(NSZone*) zone
{
    NameItemVO* obj=[[[self class] allocWithZone:zone] init];
    obj.itemId=[self.itemId copy];
    obj.itemName=[self.itemName copy];
    return obj;
}

-(BOOL)isEqual:(id)object
{
    if (object !=nil && [object respondsToSelector:@selector(obtainItemId)]) {
        if ([[object obtainItemId] isEqualToString:self.itemId]) {
            return YES;
        }
    }
    return NO;
}

@end
