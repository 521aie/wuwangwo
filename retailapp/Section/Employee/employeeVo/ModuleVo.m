//
//  ModuleVo.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ModuleVo.h"
#import "ActionVo.h"
#import "ObjectUtil.h"

@implementation ModuleVo
+ (ModuleVo *)convertToUser:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        ModuleVo* module = [[ModuleVo alloc] init];
        
        module.moduleId = [ObjectUtil getIntegerValue:dic key:@"moduleId"];
        module.moduleName = [ObjectUtil getStringValue:dic key:@"moduleName"];
        module.moduleCode = [ObjectUtil getStringValue:dic key:@"moduleCode"];
        module.actionNameOfModule = [ObjectUtil getStringValue:dic key:@"actionNameOfModule"];
        module.count = [ObjectUtil getIntegerValue:dic key:@"count"];
        
        NSArray *arrActions = [dic objectForKey:@"actionVoList"];
        module.actionList = [[NSMutableArray alloc]initWithCapacity:arrActions.count];
        for (NSDictionary *dicAction in arrActions) {
            [module.actionList addObject:[ActionVo convertToUser:dicAction]];
        }
        module.isActionChange = NO;
        return module;
    }
    return nil;
}

- (id)copy{
    ModuleVo *voCopy = [[ModuleVo alloc]init];
    voCopy.moduleId = self.moduleId;
    
    if ([ObjectUtil isNull:self.moduleName]) {
        voCopy.moduleName = @"";
    }else{
        voCopy.moduleName = [NSString stringWithString:self.moduleName];
    }
    if ([ObjectUtil isNull:self.moduleCode]) {
        voCopy.moduleCode = @"";
    }else{
        voCopy.moduleCode = [NSString stringWithString:self.moduleCode];
    }
    if ([ObjectUtil isNull:self.actionNameOfModule]) {
        voCopy.actionNameOfModule = @"";
    }else{
        voCopy.actionNameOfModule = [NSString stringWithString:self.actionNameOfModule];
    }
    voCopy.count = self.count;
    
   
    voCopy.actionList = [[NSMutableArray alloc]initWithCapacity:self.actionList.count];
    for (int i = 0; i < self.actionList.count;i++)
    {
        ActionVo *temp = self.actionList[i];
        ActionVo *actionvo = [temp copy];
        [voCopy.actionList addObject:actionvo];
    }

    
    return voCopy;
}

@end
