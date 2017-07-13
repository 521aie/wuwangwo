//
//  GoodsStyleBatchSelectView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "ISampleListEvent.h"
#import "ISearchBarEvent.h"
#import "StyleTopSelectView.h"
#import "LSFooterView.h"

@class  ListStyleVo, SearchBar2, StyleTopSelectView;
@interface GoodsStyleBatchSelectView : LSRootViewController<ISampleListEvent,LSFooterViewDelegate, ISearchBarEvent, StyleTopSelectViewDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LSFooterView *footView;

@property (nonatomic, strong) SearchBar2 *searchBar;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic,retain) NSMutableArray *goodsIds;

@property (nonatomic, strong) NSMutableArray* styleList;

@property (nonatomic, strong) NSMutableDictionary *condition;

@property (nonatomic, strong) NSMutableDictionary* conditionOfBatchView;

//款式筛选页面
@property (nonatomic, strong) StyleTopSelectView *styleTopSelectView;

-(void) loadDatasFromOperateView:(int) action;

-(void) loadDatasFromSelect:(NSMutableDictionary *)condition;

@end
