//
//  SelectOrgListView.h
//  retailapp
//
//  Created by hm on 15/8/31.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//


#import "LSRootViewController.h"
#import "TreeItem.h"

typedef void(^CallBackNew)(id<ITreeItem> item);

@class SearchBar2;
@interface SelectOrgListView : LSRootViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) SearchBar2* searchBar;

@property (nonatomic,strong) UITableView* mainGrid;

@property (nonatomic,copy) CallBackNew callBack;


- (void)loadData:(NSString*)_id callBack:(CallBackNew)callBack;

@end
