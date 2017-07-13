//
//  SubOrgShopListView.h
//  retailapp
//
//  Created by hm on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface SubOrgShopListView : LSRootViewController

//设置页面参数
- (void)loadData:(NSString*)organizationId withOrgName:(NSString *)orgName withParent:(BOOL)hasParent;

@end
