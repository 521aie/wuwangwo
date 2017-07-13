//
//  LSSmsMainListController.h
//  retailapp
//
//  Created by wuwangwo on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class LSEditItemList;
@interface LSSmsMainListController : LSRootViewController
@property (nonatomic,strong) UITableView* mainGrid;
/**接受门店*/
@property (nonatomic,strong) LSEditItemList* lsShop;
@end
