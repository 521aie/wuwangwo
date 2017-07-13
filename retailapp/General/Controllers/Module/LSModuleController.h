//
//  LSModuleController.h
//  retailapp
//
//  Created by guozhi on 2016/11/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "NavigateTitle2.h"
#import "LSModuleModel.h"

@interface LSModuleController : LSRootViewController<UITableViewDelegate, UITableViewDataSource>
/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源如果是分组数据存的是分组标题 map存的标题是key组数据是list 如果不是分组数据存的是菜单数据 */
@property (nonatomic, strong) NSMutableArray *datas;
/** 数据源 */
@property (nonatomic, strong) NSMutableDictionary *map;
//点击单元格时调用 为了子类重用
- (void)showActionCode:(NSString*)actCode;
@end
