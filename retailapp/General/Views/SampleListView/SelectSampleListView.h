//
//  SelectSampleListView.h
//  retailapp
//
//  Created by hm on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

typedef NS_ENUM(NSInteger, CHECK_MODE){
    SINGLE_CHECK,       //单选.
    MUTIl_CHECK     //多选
};

#import "LSRootViewController.h"
#import "SearchBar2.h"
#import "FooterMultiView.h"
#import "EditItemList.h"
#import "LSFooterView.h"

@class TreeItem;
@interface SelectSampleListView : LSRootViewController<UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate>

@property (nonatomic,strong) SearchBar2* searchBar;


@property (nonatomic,strong) UITableView* mainGrid;

@property (nonatomic,strong) LSFooterView * footView;


@property (nonatomic,strong) NSMutableArray* dataList;

@property (nonatomic,strong) NSMutableArray*  treeItemsToInsert;

@property (nonatomic,strong) NSMutableArray*  treeItemsToRemove;

//打开所有下级(备用)
- (NSArray *)insertTreeMenuIndexPaths:(TreeItem *)item;
//打开下一级
- (NSArray *)insertMenuIndexPaths:(TreeItem *)item;
- (NSArray *)deleteMenuIndexPaths:(TreeItem *)item;

// 选择全部
- (void)checkAllEvent;
// 全不选
- (void)notCheckAllEvent;

@end
