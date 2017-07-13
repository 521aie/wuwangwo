//
//  SelectSampleListView.m
//  retailapp
//
//  Created by hm on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectSampleListView.h"
#import "TreeItem.h"
#import "UIView+Sizes.h"
#import "ViewFactory.h"


@implementation SelectSampleListView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    self.dataList = [NSMutableArray array];
    self.treeItemsToInsert = [NSMutableArray array];
    self.treeItemsToRemove = [NSMutableArray array];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
}

- (void)configViews {
    self.searchBar = [SearchBar2 searchBar2];
    self.searchBar.frame = CGRectMake(0, kNavH, SCREEN_W, 44);
    [self.view addSubview:self.searchBar];
    
    self.mainGrid = [[UITableView alloc] init];
    self.mainGrid.frame = CGRectMake(0, self.searchBar.ls_bottom,self.view.ls_width , self.view.ls_height - self.searchBar.ls_bottom);
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainGrid];
    
    
    self.footView = [LSFooterView footerView];
    self.footView.ls_bottom = self.view.ls_bottom;
    [self.footView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
    [self.view addSubview:self.footView];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectAll]) {
        [self checkAllEvent];
    } else if ([footerType isEqualToString:kFootSelectNo]) {
        [self notCheckAllEvent];
    }
}

- (void)checkAllEvent {
    
}

- (void)notCheckAllEvent {
    
}

#pragma mark -- insert
//打开所有的下级(备用)
- (NSArray *)insertTreeMenuIndexPaths:(TreeItem *)item
{
    NSArray * arr;
    [_treeItemsToInsert removeAllObjects];
    [self insertTreeMenuObject:item];
    [self.dataList addObjectsFromArray:_treeItemsToInsert];
    arr = [self insertIndexsOfMenuObject:_treeItemsToInsert];
    return arr;
}

- (void) insertTreeMenuObject:(TreeItem *)item
{
    TreeItem *childItem;
    for (int i = 0; i<[item.subItems count] ; i++) {
        childItem = [item.subItems objectAtIndex:i];
        [_treeItemsToInsert addObject:childItem];
        item.isSubItemOpen = YES;
        if (childItem.subItems.count>0&&childItem.type!=2) {
            [self insertTreeMenuObject:childItem];
        }
    }
}

//打开下一级
- (NSArray *)insertMenuIndexPaths:(TreeItem *)item
{
    NSArray * arr;
    [_treeItemsToInsert removeAllObjects];
    [self insertMenuObject:item];
    arr = [self insertIndexsOfMenuObject:_treeItemsToInsert];
    return arr;
}

- (void) insertMenuObject:(TreeItem *)item
{
    if (item == nil)
    {
        return ;
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:[_dataList indexOfObject:item] inSection:0];
    
    TreeItem *childItem;
    for (int i = 0; i<[item.subItems count] ; i++) {
        childItem = [item.subItems objectAtIndex:i];
        [_dataList insertObject:childItem atIndex:path.row + i +1];
        [_treeItemsToInsert addObject:childItem];
        item.isSubItemOpen = YES;
    }
    
    for (int i = 0; i <[item.subItems count]; i ++) {
        childItem = [item.subItems objectAtIndex:i];
        
        if (childItem .isSubCascadeOpen) {
            [self insertMenuObject:childItem];
        }
        
    }
    return ;
    
}
- (NSArray *) insertIndexsOfMenuObject :(NSMutableArray *) array
{
    NSMutableArray * mutableArr;
    mutableArr = [NSMutableArray array];
    for (TreeItem * item in array) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:[_dataList indexOfObject:item] inSection:0];
        [mutableArr addObject:path];
    }
    return mutableArr;
}
#pragma mark -- delete
- (NSArray *)deleteMenuIndexPaths:(TreeItem *)item
{
    NSArray * arr;
    [_treeItemsToRemove removeAllObjects];
    [self deleteMenuObject:item];
    arr = [self deleteIndexsOfMenuObject:_treeItemsToRemove];
    return arr;
}
- (void) deleteMenuObject:(TreeItem *)item
{
    if (item == nil)
    {
        return ;
    }
    
    TreeItem *childItem;
    for (int i = 0; i<[item.subItems count] && item.isSubItemOpen ; i++) {
        childItem = [item.subItems objectAtIndex:i];
        [self deleteMenuObject:childItem];
        
        [_treeItemsToRemove addObject:childItem];
    }
    
    item.isSubItemOpen = NO;
    
    return ;
}
- (NSArray *) deleteIndexsOfMenuObject:(NSMutableArray *)arr
{
    
    NSMutableArray *mutableArr;
    mutableArr = [NSMutableArray array];
    NSMutableIndexSet * set;
    set = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [_treeItemsToRemove count]; i++)
    {
        TreeItem * item;
        item = [_treeItemsToRemove objectAtIndex:i];
        NSIndexPath *path = [NSIndexPath indexPathForRow:[_dataList indexOfObject:item] inSection:0];
        [mutableArr addObject:path];
        [set addIndex:path.row];
    }
    
    [_dataList removeObjectsAtIndexes:set];
    
    return mutableArr;
}


@end
