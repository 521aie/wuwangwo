//
//  EmployeeRender.m
//  retailapp
//
//  Created by qingmei on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EmployeeRender.h"
#import "DicVo.h"
#import "NameItemVO.h"
#import "UserPerformanceTargetVo.h"

@implementation EmployeeRender
+(NSMutableArray*) getItemVoListByDicVoList:(NSArray*)dicVoList{
    NSMutableArray* vos=[NSMutableArray array];
    if (dicVoList != nil && dicVoList.count > 0) {
        for (NSDictionary* dic in dicVoList)
        {
            NSString *name = [dic objectForKey:@"name"];
            NSNumber *numberval = [dic objectForKey:@"val"];
            NSString *val = [NSString stringWithFormat:@"%ld",[numberval longValue]];
            NameItemVO *item=[[NameItemVO alloc] initWithVal:name andId:val];
            [vos addObject:item];
        }
    }
    
    return vos;
}

+ (NSMutableArray*) getItemVoListByRoleList:(NSArray *)roleList{
    NSMutableArray* vos=[NSMutableArray array];
    if (roleList != nil && roleList.count > 0) {
        for (NSDictionary* dic in roleList)
        {
            NSString *name = [dic objectForKey:@"roleName"];
            NSString *val = [dic objectForKey:@"roleId"];
            NameItemVO *item=[[NameItemVO alloc] initWithVal:name andId:val];
            [vos addObject:item];
        }
    }
    
    return vos;
}

+ (NSMutableArray*) getCommissionTypeListWithshopMode:(NSString *)shopMode{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item1=[[NameItemVO alloc] initWithVal:@"使用商品提成比例" andId:@"1"];
    [vos addObject:item1];
    
    NameItemVO *item2=[[NameItemVO alloc] initWithVal:@"按单提成" andId:@"2"];
    [vos addObject:item2];
    
    NameItemVO *item3=[[NameItemVO alloc] initWithVal:@"按销售额提成" andId:@"3"];
    [vos addObject:item3];
    
    if ([shopMode isEqualToString:@"101"]) {//服鞋
        //NameItemVO *item4=[[NameItemVO alloc] initWithVal:@"按款式设置提成" andId:@"4"];
        NameItemVO *item4=[[NameItemVO alloc] initWithVal:@"按商品设置提成" andId:@"4"];
        [vos addObject:item4];
    }else if([shopMode isEqualToString:@"102"]){//商超
        NameItemVO *item4=[[NameItemVO alloc] initWithVal:@"按商品设置提成" andId:@"4"];
        [vos addObject:item4];
    }
   
    return vos;
}



@end
