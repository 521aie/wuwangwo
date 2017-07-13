//
//  SelectOrgListView.m
//  retailapp
//
//  Created by hm on 15/8/31.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectOrgListView.h"
#import "NavigateTitle2.h"
#import "SearchBar2.h"
#import "CheckShopCell.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "AlertBox.h"
#import "TreeBuilder.h"
#import "TreeNodeUtils.h"
#import "SubOrgVo.h"
#import "TreeNodeUtils.h"

@interface SelectOrgListView ()<ISearchBarEvent,CheckShopCellDelegate>

@property (nonatomic,strong) SettingService* service;

@property (nonatomic,strong) NSMutableArray* dataList;

@property (nonatomic,strong) NSMutableArray*  treeItemsToInsert;

@property (nonatomic,strong) NSMutableArray*  treeItemsToRemove;

@property (nonatomic,copy) NSString* keyWord;
//type 1列表结构 2 树状结构
@property (nonatomic) NSInteger type;

@property (nonatomic,copy) NSString* selectId;

@property (nonatomic) NSInteger currentPage;

@end

@implementation SelectOrgListView
@synthesize keyWord,service;


- (void)viewDidLoad {
    [super viewDidLoad];
    service = [ServiceFactory shareInstance].settingService;
    [self initNavigate];
    [self configViews];
    self.dataList = [NSMutableArray array];
    self.treeItemsToInsert = [NSMutableArray array];
    self.treeItemsToRemove = [NSMutableArray array];
     [self selectById];
}

- (void)configViews {

    __weak typeof(self) wself = self;
    self.searchBar = [SearchBar2 searchBar2];
    [self.searchBar initDelagate:self placeholder:@"名称/编号"];
    [self.view addSubview:self.searchBar];
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
        make.height.equalTo(44);
    }];
    
    self.mainGrid = [[UITableView alloc] init];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
    [self.mainGrid makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.searchBar.bottom);
    }];
}


- (void)initNavigate
{
    [self configTitle:@"选择机构" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        _callBack(nil);
    }
    
}

#pragma mark - 检索
- (void)imputFinish:(NSString *)_keyWord
{
    keyWord = _keyWord;
    if ([NSString isNotBlank:_keyWord]) {
        self.type = 1;
        self.currentPage = 1;
        [self addHeaderAndFooter];
        [self.mainGrid headerBeginRefreshing];
    }else{
        self.type = 2;
        [self removeHeaderAndFooter];
        [self selectById];
    }
}

#pragma mark - 添加刷新，加载
- (void)addHeaderAndFooter
{
    __weak SelectOrgListView* weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf selectByKeyWord];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf selectByKeyWord];
    }];

}
#pragma mark - 移除刷新，加载
- (void)removeHeaderAndFooter
{
    [self.mainGrid removeHeader];
    [self.mainGrid removeFooter];
    [self.dataList removeAllObjects];
    [self.treeItemsToInsert removeAllObjects];
    [self.treeItemsToRemove removeAllObjects];
}

#pragma mark - 加载树状结构数据
- (void)loadData:(NSString*)_id  callBack:(CallBackNew)callBack
{
    self.type = 2;
    self.selectId = _id;
    [self removeHeaderAndFooter];
    _callBack = callBack;
}

#pragma mark - 网络数据处理
//树状机构数据
- (void)selectById
{
    __weak SelectOrgListView* weakSelf = self;
    [service selectAllSubOrg:[[Platform Instance] getkey:ORG_ID] withDepFlag:NO withShopFlag:NO withIsMicroShop:NO completionHandler:^(id json) {
        NSMutableArray* subArr = [SubOrgVo converToSubOrgList:[json objectForKey:@"sonList"]];
        NSMutableArray* treeItems = [TreeBuilder buildTreeItem:subArr];
        TreeItem* treeItem = nil;
        for (TreeItem *item in treeItems) {
            if ([[item obtainItemId] isEqualToString:[[Platform Instance] getkey:ORG_ID]]) {
                treeItem = item;
            }
        }
//        TreeItem* treeItem = [treeItems objectAtIndex:0];
        if (treeItem) {
            [weakSelf.dataList addObject:treeItem];
            [weakSelf insertMenuIndexPaths:treeItem];
        }
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

//列表数据
- (void)selectByKeyWord
{
    NSString* page = [NSString stringWithFormat:@"%tu",self.currentPage];
    __weak SelectOrgListView* weakSelf = self;
    [service selectInBranch:[[Platform Instance] getkey:ORG_ID] withPage:page withKeyWord:self.keyWord withDepFlag:NO withShopFlag:NO withIsMicroShop:NO completionHandler:^(id json) {
        NSMutableArray* arr = [SubOrgVo converToSubOrgList:[json objectForKey:@"sonList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.dataList removeAllObjects];
        }
        NSMutableArray* sonArr = [TreeNodeUtils converToTreeItemArr:arr];
        [weakSelf.dataList addObjectsFromArray:sonArr];
        [weakSelf.mainGrid reloadData];
        arr = nil;
        sonArr = nil;
        weakSelf.mainGrid.ls_show = YES;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* checkShopCellId = @"CheckShopCell";
    CheckShopCell* cell = [tableView dequeueReusableCellWithIdentifier:checkShopCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CheckShopCell" bundle:nil] forCellReuseIdentifier:checkShopCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:checkShopCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckShopCell* detailItem = (CheckShopCell*)cell;
    id<ITreeItem> item = [self.dataList objectAtIndex:indexPath.row];
    detailItem.lblName.text = [item obtainItemName];
    detailItem.lblNo.text = [NSString stringWithFormat:@"机构编号：%@",[item obtainItemValue]];
    [detailItem initDeleagte:self withItem:item];
    [detailItem showImg:([item obtainItemType]==2) withType:self.type withCheck:[self.selectId isEqualToString:[item obtainItemId]]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type==1) {
        SubOrgVo* orgVo = [self.dataList objectAtIndex:indexPath.row];
        _callBack(orgVo);
    }else{
        CheckShopCell* cell = (CheckShopCell*)[tableView cellForRowAtIndexPath:indexPath];
        _callBack(cell.item);
    }
}

#pragma mark -cell折叠和展开
- (void)expandCell:(CheckShopCell *)cell
{
    if (cell.item.isSubItemOpen)
    {
        NSArray * arr;
        arr = [self deleteMenuIndexPaths:cell.item];
        if ([arr count] >0) {
            [self.mainGrid deleteRowsAtIndexPaths: arr withRowAnimation:UITableViewRowAnimationBottom];
        }
    }
    else
    {
        NSArray * arr;
        arr = [self insertMenuIndexPaths:cell.item];
        if ([arr count] >0) {
            [self.mainGrid insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationBottom];
        }
    }

}


#pragma mark -- insert
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
