//
//  StockQueryView.h
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VirtualStockManagementView : BaseViewController

@property (nonatomic ,strong) UITableView *mainGrid;
- (void)loadVirtualListAndVirtualCount;
@end
