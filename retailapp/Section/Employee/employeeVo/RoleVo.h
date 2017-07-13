//
//  RoleVo.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
#import "INameValue.h"

@interface RoleVo : Jastor<INameValue>

/**角色ID*/
@property (nonatomic, strong) NSString *roleId;
/**角色名*/
@property (nonatomic, strong) NSString *roleName;
/**角色类型 1：门店 2：机构 */
@property (nonatomic, assign) NSInteger roleType;
/**版本号*/
@property (nonatomic, assign) NSInteger lastVer;

+ (RoleVo*)convertToUser:(NSDictionary*)dic;

- (NSMutableDictionary *)getDic:(RoleVo *)roleVo;

+ (NSMutableArray*)convertToArr:(NSArray*)array;


@end
