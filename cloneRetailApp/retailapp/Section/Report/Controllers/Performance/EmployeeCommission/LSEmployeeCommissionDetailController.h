//
//  LSEmployeeCommissionDetailController.h
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class LSEmployeeCommissionVo;
@interface LSEmployeeCommissionDetailController : LSRootViewController
/**员工所属门店用来接受上一个页面的值*/
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) LSEmployeeCommissionVo *employeeCommissionVo;
@end
