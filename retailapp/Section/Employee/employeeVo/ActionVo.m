//
//  ActionVo.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ActionVo.h"
#import "JsonHelper.h"
#import "ObjectUtil.h"

@implementation ActionVo
+ (ActionVo *)convertToUser:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        ActionVo* action = [[ActionVo alloc] init];
        
        action.actionId = [ObjectUtil getIntegerValue:dic key:@"actionId"];
        action.actionName = [ObjectUtil getStringValue:dic key:@"actionName"];
        action.actionCode = [ObjectUtil getStringValue:dic key:@"actionCode"];
        action.actionDataType = [ObjectUtil getIntegerValue:dic key:@"actionDataType"];
        action.actionType = [ObjectUtil getIntegerValue:dic key:@"actionType"];
        action.choiceFlag = [ObjectUtil getIntegerValue:dic key:@"choiceFlag"];
        
        action.oldChoiceFlag = action.choiceFlag;
        action.oldActionDataType = action.actionDataType;
        
        action.dicVoList = [dic objectForKey:@"dicVoList"];
        return action;
    }
    return nil;
}

- (NSMutableDictionary *)getDic:(ActionVo *)actionVo{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if ([ObjectUtil isNotNull:actionVo]) {
        [dic setValue:[NSNumber numberWithInteger:actionVo.actionId] forKey:@"actionId"];
        [dic setValue:[ObjectUtil isNull:actionVo.actionName]?[NSNull null]:actionVo.actionName forKey:@"actionName"];
        [dic setValue:[ObjectUtil isNull:actionVo.actionCode]?[NSNull null]:actionVo.actionCode forKey:@"actionCode"];
        [dic setValue:[NSNumber numberWithInteger:actionVo.actionDataType] forKey:@"actionDataType"];
        [dic setValue:[NSNumber numberWithInteger:actionVo.actionType] forKey:@"actionType"];
        [dic setValue:[NSNumber numberWithInteger:actionVo.choiceFlag] forKey:@"choiceFlag"];
    }
    return dic;

}
- (id)copy
{
    ActionVo *copyVo = [[ActionVo alloc]init];
    
    if ([ObjectUtil isNull:self.actionName]) {
        copyVo.actionName = @"";
    }else{
        copyVo.actionName = [NSString stringWithString:self.actionName];
    }
    if ([ObjectUtil isNull:self.actionCode]) {
        copyVo.actionCode = @"";
    }else{
        copyVo.actionCode = [NSString stringWithString:self.actionCode];
    }
    
    copyVo.actionId = self.actionId;
    copyVo.actionDataType = self.actionDataType;
    copyVo.actionType = self.actionType;
    copyVo.choiceFlag = self.choiceFlag;
    copyVo.dicVoList = self.dicVoList;
    
    copyVo.oldChoiceFlag = self.oldChoiceFlag;
    copyVo.oldActionDataType = self.oldActionDataType;
    
    return copyVo;
}

- (BOOL)isChange {
    return (self.actionDataType != self.oldActionDataType || self.choiceFlag != self.oldChoiceFlag);
}
@end
