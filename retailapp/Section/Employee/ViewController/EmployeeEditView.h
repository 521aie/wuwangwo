//
//  EmployeeEditView.h
//  retailapp
//
//  Created by qingmei on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface EmployeeEditView : LSRootViewController

/*页面初始化*/
- (id)initWithParent:(id)parentTemp;
/**设置页面类型 添加:YES 详情:NO*/
- (void)setShowType:(BOOL)isAdd;
/*详情页面进入时调用*/
- (void)loadDataWithUserID:(NSString *)userID WithParam:(NSDictionary *)param;
/*添加页面进入时调用*/
- (void)initDataInAddTypeWithParam:(NSDictionary *)param;
@end
