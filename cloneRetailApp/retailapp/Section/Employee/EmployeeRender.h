//
//  EmployeeRender.h
//  retailapp
//
//  Created by qingmei on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmployeeRender : NSObject

+ (NSMutableArray*) getItemVoListByDicVoList:(NSArray *)dicVoList;
+ (NSMutableArray*) getItemVoListByRoleList:(NSArray *)roleList;
+ (NSMutableArray*) getCommissionTypeListWithshopMode:(NSString *)shopMode;

@end
