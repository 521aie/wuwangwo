//
//  GoodsStyleListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "ISearchBarEvent.h"
#import "LSFooterView.h"
#import "INameValueItem.h"
#import "StyleTopSelectView.h"

@class  SearchBar2,  StyleVo, StyleTopSelectView;
@interface GoodsStyleListView : LSRootViewController<LSFooterViewDelegate, ISearchBarEvent, StyleTopSelectViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SearchBar2 *searchBar;
@property (nonatomic, strong) LSFooterView *footView;

@property (nonatomic, retain) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableDictionary *condition;
@property (nonatomic, strong) NSMutableDictionary *conditionOfInit;
@property (nonatomic, strong) NSMutableDictionary *conditionOfBatchView;

//款式筛选页面
@property (nonatomic, strong) StyleTopSelectView *styleTopSelectView;
@property (nonatomic, strong) NSString *synShopId;
@property (nonatomic, strong) NSString *synShopName;

- (void)loadDatasFromEditView:(StyleVo*) styleVo action:(int)action;
- (void)loadDatasFromBatchSelectView;
@end
