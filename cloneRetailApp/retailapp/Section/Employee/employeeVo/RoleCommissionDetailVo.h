//
//  RoleCommissionDetailVo.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoleCommissionDetailVo : NSObject
/**角色提成方式详情ID*/
@property (nonatomic, strong) NSString *Id;
/**实体ID*/
@property (nonatomic, strong) NSString *entityId;
/**店铺ID*/
@property (nonatomic, strong) NSString *shopId;
/**商品ID*/
@property (nonatomic, strong) NSString *goodsId;
/**商品类型 1:商品,2:款式*/ 
@property (nonatomic, assign) NSInteger goodsType;
/**角色提成id*/
@property (nonatomic, strong) NSString *rolecommissionId;
/**商品名称*/
@property (nonatomic, strong) NSString *goodsName;
/**商品条码*/
@property (nonatomic, strong) NSString *goodsBar;
/**提成比例*/
@property (nonatomic, assign) double commissionRatio;
/**操作类型*/
@property (nonatomic, strong) NSString *operateType;

+ (RoleCommissionDetailVo*)convertToUser:(NSDictionary*)dic;

- (NSMutableDictionary *)getDic:(RoleCommissionDetailVo *)roleCommissionDetailVo;
@end
