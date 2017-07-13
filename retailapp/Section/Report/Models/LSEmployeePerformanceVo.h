//
//  LSEmployeePerformanceVo.h
//  retailapp
//
//  Created by guozhi on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSEmployeePerformanceVo : NSObject
/** 员工姓名 */
@property (nonatomic, copy) NSString *staffName;
/** 净销售量 */
@property (nonatomic, strong) NSNumber *netSalesNum;
/** 净销售额 */
@property (nonatomic, strong) NSNumber *netSalesAmount;
/** 员工工号 */
@property (nonatomic, copy) NSString *staffId;
/** 员工Id */
@property (nonatomic, copy) NSString *userId;
@end
