//
//  StockQueryView.h
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface AlertSettingView : LSRootViewController
@property (strong, nonatomic) UITableView *mainGrid;
/**当前页*/
@property (nonatomic, assign) int currentPage;
/**加载数据*/
- (void)loadData;

/**加载分类列表*/
- (void)loadSelectCategory;
@end
