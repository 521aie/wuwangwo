//
//  LSEmployeePerformanceListController.h
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSEmployeePerformanceListController : LSRootViewController
/**查询交接班记录所需参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/**导出页面所需参数*/
@property (nonatomic, strong) NSMutableDictionary *exportParam;
/**员工所属门店用来接受上一个页面的值传给下一个页面*/
@property (nonatomic, copy) NSString *title1;
@end
