//
//  EnterCircleListView.h
//  retailapp
//
//  Created by qingmei on 15/12/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface EnterCircleListView : LSRootViewController
@property (nonatomic, strong) UITableView* mainGrid;
@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;


- (void)loadData;

@end
