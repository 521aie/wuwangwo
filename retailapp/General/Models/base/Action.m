//
//  Action.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Action.h"

@implementation Action

-(NSString*) obtainItemId
{
    return self._id;
}

-(NSString*) obtainItemName
{
    return self.name;
}

-(NSString*) obtainOrignName
{
    return self.name;
}

-(NSString*) obtainParentId
{
    return self.parentId;
}

-(NSString*) obtainItemValue
{
    return @"";
}

-(void) mId:(NSString*)itemId
{
    self._id=itemId;
}

-(void) mName:(NSString*)itemName
{
    self.name=itemName;
}

-(void) mParentId:(NSString*)parentId
{
    self.parentId=parentId;
}

- (BOOL)isSelected
{
    return (self.state==1);
}

- (void)setIsSelected:(BOOL)isSelected
{
    self.state=(isSelected?1:0);
}

-(Action*) copyWithZone:(NSZone*)zone
{
    Action* obj=[[[self class] allocWithZone:zone] init];
    obj._id=[self._id copy];
    
    obj.lastVer=self.lastVer;
    obj.isValid=self.isValid;
    obj.createTime=self.createTime;
    obj.opTime=self.opTime;

    obj.parentId=[self.parentId copy];
    obj.name=[self.name copy];
    obj.code=[self.code copy];
    obj.status=self.status;
    
    return obj;
}

-(BOOL)isEqual:(id)object
{
    if ([ObjectUtil isNotNull:object] && [object isKindOfClass:[Action class]]) {
        Action *action = (Action *)object;
        if ([action._id isEqualToString:self._id]) {
            return YES;
        }
    }
    return NO;
}

@end

