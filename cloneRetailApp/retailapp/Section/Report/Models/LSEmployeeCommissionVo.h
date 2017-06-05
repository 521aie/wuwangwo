//
//  LSEmployeeCommissionVo.h
//  retailapp
//
//  Created by guozhi on 2016/11/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSEmployeeCommissionVo : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSNumber *sortId;
/** <#注释#> */
@property (nonatomic, copy) NSString *entityId;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopEntityId;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopId;
/** <#注释#> */
@property (nonatomic, copy) NSString *userId;
/** <#注释#> */
@property (nonatomic, strong) NSNumber *currDate;
/** <#注释#> */
@property (nonatomic, copy) NSString *code;
/** 店铺名称 */
@property (nonatomic, copy) NSString *shopName;
/** <#注释#> */
@property (nonatomic, strong) NSNumber *shopType;
/** 员工工号 */
@property (nonatomic, copy) NSString *staffId;
/** 员工姓名 */
@property (nonatomic, copy) NSString *staffName;
/** 员工角色姓名 */
@property (nonatomic, copy) NSString *staffRole;
/** 员工角色Id */
@property (nonatomic, copy) NSString *staffRoleId;
/** <#注释#> */
@property (nonatomic, copy) NSString *mobile;
/** 销售单数 */
@property (nonatomic, strong) NSNumber *saleOrderCount;
/** 销售金额 */
@property (nonatomic, strong) NSNumber *saleAmount;
/** 退货单数 */
@property (nonatomic, strong) NSNumber *returnOrderCount;
/** 退货金额(元) */
@property (nonatomic, strong) NSNumber *returnAmount;
/** 净销售额 */
@property (nonatomic, strong) NSNumber *netSalesAmount;
/** 提成 */
@property (nonatomic, strong) NSNumber *commissionAmount;
/** <#注释#> */
@property (nonatomic, strong) NSNumber *createTime;

@end
