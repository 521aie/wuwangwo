//
//  LSShiftRecordListController.h
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSShiftRecordListController : LSRootViewController
/**用来接受门店,由上一个页面传入*/
@property (nonatomic, copy) NSString *shopName;
/**查询交接班记录所需参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/**导出页面所需参数*/
@property (nonatomic, strong) NSMutableDictionary *exportParam;
@end
