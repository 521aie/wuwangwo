//
//  RoleCommissionnDetailView.h
//  retailapp
//
//  Created by qingmei on 15/10/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface RoleCommissionnDetailView : LSRootViewController
@property (nonatomic, strong)NSString *roleCommissionId;//角色提成ID
/**通过roleCommissionId加载页面*/
- (void)loadDataWithRoleCommissionId:(NSString *)roleCommissionId block:(void(^)())callBack;
@end
