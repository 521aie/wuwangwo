//
//  RoleCommissionVo.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoleCommissionVo : NSObject
/**角色提成ID*/
@property (nonatomic, strong) NSString *Id;
/**实体ID*/
@property (nonatomic, strong) NSString *entityId;
/**店铺ID*/
@property (nonatomic, strong) NSString *shopId;
/**角色ID*/
@property (nonatomic, strong) NSString *roleId;
/**角色名称*/
@property (nonatomic, strong) NSString *roleName;
/**角色类型*/
@property (nonatomic, assign) NSInteger roleType;
/**是否提成*/
@property (nonatomic, assign) BOOL isCommission;
/**提成方式*/
@property (nonatomic, assign) NSInteger commissionType;
/**提成比例*/
@property (nonatomic, assign) double commissionRatio;
/**提成金额*/
@property (nonatomic, assign) double commissionPrice;
/**操作类型*/
@property (nonatomic, strong) NSString *operateType;
/**版本号*/
@property (nonatomic, assign) NSInteger lastVer;

+ (RoleCommissionVo *)convertToUser:(NSDictionary*)dic;

- (NSMutableDictionary *)getDic:(RoleCommissionVo *)roleCommissionVo;
- (RoleCommissionVo *)copy;

@end
