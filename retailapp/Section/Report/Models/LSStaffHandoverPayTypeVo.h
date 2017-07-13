//
//  LSStaffHandoverPayTypeVo.h
//  retailapp
//
//  Created by guozhi on 2016/11/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSStaffHandoverPayTypeVo : NSObject
/** 员工工号 */
@property (nonatomic, copy) NSString *staffId;
/** 员工姓名 */
@property (nonatomic, copy) NSString *staffName;
/** 员工角色名称 */
@property (nonatomic, copy) NSString *staffRole;
/** 销售金额 */
@property (nonatomic, strong) NSNumber *salesAmount;

+ (NSArray *)getStaffHandoverPayTypeVoList:(NSArray *)keyValuesArray;
@end
