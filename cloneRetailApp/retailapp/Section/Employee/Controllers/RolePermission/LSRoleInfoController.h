//
//  LSRoleInfoController.h
//  retailapp
//
//  Created by guozhi on 2017/2/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSRoleInfoController : LSRootViewController
/** <#注释#> */
@property (nonatomic, assign) int action;
/*详情页面进入时调用*/
- (void)loadDataWithRoleID:(NSString *)roleID;
/*添加页面进入时调用*/
- (void)initDataInAddType;
@end
