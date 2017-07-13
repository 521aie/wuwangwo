//
//  LSEmployeeCommissionListController.h
//  retailapp
//
//  Created by guozhi on 2016/11/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSEmployeeCommissionListController : LSRootViewController
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSMutableDictionary *exportParam;
/**员工所属门店用来接受上一个页面的值*/
@property (nonatomic, strong) NSString *shopName;
@end
