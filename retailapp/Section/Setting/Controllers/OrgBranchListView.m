//
//  OrgBranchListView.m
//  retailapp
//
//  Created by hm on 15/8/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrgBranchListView.h"
#import "SearchBar2.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SubOrgVo.h"
#import "TreeItem.h"
#import "TreeBuilder.h"
#import "TreeNodeUtils.h"
#import "ShopCell.h"
#import "ColorHelper.h"
#import "SearchBar2.h"
#import "NavigateTitle2.h"
#import "LSChainShopInfoController.h"
#import "LSOrgInfoController.h"

@interface OrgBranchListView ()<ISearchBarEvent,ShopCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) SettingService* settingService;
//tableView数据源
@property (nonatomic,strong) NSMutableArray* dataList;
//子级插入列表
@property (nonatomic,strong) NSMutableArray*  treeItemsToInsert;
//子级删除列表
@property (nonatomic,strong) NSMutableArray*  treeItemsToRemove;
//检索关键词
@property (nonatomic,copy) NSString* keyWord;
//分页
@property (nonatomic) NSInteger currentPage;
//1 列表 2树状列表
@property (nonatomic) NSInteger type;
//数据模型
@property (nonatomic,strong) TreeItem* treeItem;

@property (nonatomic,strong) SearchBar2* searchBar;

@property (nonatomic,strong) UITableView* mainGrid;
@end

@implementation OrgBranchListView
@synthesize settingService;



- (void)viewDidLoad {
    [super viewDidLoad];
     settingService = [ServiceFactory shareInstance].settingService;
    [self initNavigate];
    [self configViews];
    self.dataList = [NSMutableArray array];
    self.treeItemsToInsert = [NSMutableArray array];
    self.treeItemsToRemove = [NSMutableArray array];
    [self loadData];
}
- (void)configViews {
    self.searchBar = [SearchBar2 searchBar2];
    //设置查询代理
    [self.searchBar initDelagate:self placeholder:@"名称/编号"];
    [self.view addSubview:self.searchBar];
    __weak typeof(self) wself = self;
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


#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"分支" leftPath:Head_ICON_BACK rightPath:nil];
}
//导航事件
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - 查询分支
- (void)imputFinish:(NSString *)keyWord
{
    self.keyWord = keyWord;
    if ([NSString isBlank:keyWord]) {
        [self loadData];
    }else{
        self.currentPage = 1;
        self.type = 1;
        [self addHeaderAndFooter];
        [self.mainGrid headerBeginRefreshing];
    }
}

//添加刷新加载控件
- (void)addHeaderAndFooter
{
    __weak OrgBranchListView* weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage=1;
        [weakSelf selectInBranch:weakSelf.organizationId withPage:weakSelf.currentPage withKeyWord:weakSelf.keyWord];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf selectInBranch:weakSelf.organizationId withPage:weakSelf.currentPage withKeyWord:weakSelf.keyWord];
    }];
}
//移除刷新加载控件
- (void)removeHeaderAndFooter
{
    [self.mainGrid removeHeader];
    [self.mainGrid removeFooter];
    [self.dataList removeAllObjects];
    [self.treeItemsToInsert removeAllObjects];
    [self.treeItemsToRemove removeAllObjects];
}

#pragma mark - 初始化页面
- (void)loadData
{
    [self removeHeaderAndFooter];
    self.currentPage = 1;
    self.type = 2;
    [self selectAllSubOrg:self.organizationId];
}

#pragma mark -网络数据处理
//树状
- (void)selectAllSubOrg:(NSString*)organizationId
{
    __weak OrgBranchListView* weakSelf = self;
    [settingService selectAllSubOrg:organizationId withDepFlag:YES withShopFlag:YES withIsMicroShop:NO completionHandler:^(id json) {
        NSMutableArray* subArr = [SubOrgVo converToSubOrgList:[json objectForKey:@"sonList"]];
        //构建树状
        NSMutableArray* treeItems = [TreeBuilder buildTreeItem:subArr];
        if (treeItems.count>0) {
            for (TreeItem *treeItem in treeItems) {
                if ([treeItem.itemId isEqualToString:weakSelf.organizationId]) {
                    [weakSelf.dataList addObject:treeItem];
                    [weakSelf insertMenuIndexPaths:treeItem];
                }
            }
        }
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
//列表
- (void)selectInBranch:(NSString*)_id withPage:(NSInteger)page withKeyWord:(NSString*)keyWord
{
    NSString* currentPage = [NSString stringWithFormat:@"%tu",page];
    __weak OrgBranchListView* weakSelf = self;
    [settingService selectInBranch:_id withPage:currentPage withKeyWord:keyWord withDepFlag:YES withShopFlag:YES withIsMicroShop:NO completionHandler:^(id json) {
        NSArray* sonList = [json objectForKey:@"sonList"];
        NSMutableArray* arr = [SubOrgVo converToSubOrgList:sonList];
        if (weakSelf.currentPage==1) {
            [weakSelf.dataList removeAllObjects];
        }
        [weakSelf.dataList addObjectsFromArray:arr];
        [weakSelf.mainGrid reloadData];
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
    static NSString* shopCellId = @"ShopCell";
    ShopCell* cell = [tableView dequeueReusableCellWithIdentifier:shopCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ShopCell" bundle:nil] forCellReuseIdentifier:shopCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:shopCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCell* detailItem = (ShopCell*)cell;
    if (self.type==1) {
        SubOrgVo* orgVo = [self.dataList objectAtIndex:indexPath.row];
        detailItem.lblName.text = orgVo.name;
        detailItem.lblNo.text = orgVo.type==2?[NSString stringWithFormat:@"门店编号：%@",orgVo.code]:[NSString stringWithFormat:@"机构编号：%@",orgVo.code];
        detailItem.lblNo.textColor = [ColorHelper getBlueColor];
        [detailItem showImg:(orgVo.type==2) withType:self.type];
    }else{
        id<ITreeItem> item = [self.dataList objectAtIndex:indexPath.row];
        detailItem.lblName.text = [item obtainItemName];
        detailItem.lblNo.text = [item obtainItemType]==2?[NSString stringWithFormat:@"门店编号：%@",[item obtainItemValue]]:[NSString stringWithFormat:@"机构编号：%@",[item obtainItemValue]];
        detailItem.lblNo.textColor = [ColorHelper getBlueColor];
        [detailItem initDelegate:self withItem:item];
        [detailItem showImg:([item obtainItemType]==2) withType:self.type];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCell* cell = (ShopCell*)[tableView cellForRowAtIndexPath:indexPath];
    _treeItem  = self.dataList[indexPath.row];
    if (_treeItem.type==2) {
        //查看门店详情
//        ChainShopInfoView* chainShopInfoView = [[ChainShopInfoView alloc] initWithNibName:[SystemUtil getXibName:@"ChainShopInfoView"] bundle:nil];
        LSChainShopInfoController *chainShopInfoView = [[LSChainShopInfoController alloc] init];
        chainShopInfoView.isLogin = NO;
        chainShopInfoView.action = ACTION_CONSTANTS_EDIT;
        chainShopInfoView.shopId = [_treeItem obtainItemId];
        chainShopInfoView.shopEntityId = [_treeItem obtainShopEntityId];
        [chainShopInfoView changChainInfo:^(id<INameValue> item, NSInteger action) {
            if (item) {
                if (action==ACTION_CONSTANTS_DEL) {
                    [self.dataList removeObject:self.treeItem];
                }else{
                    self.treeItem.itemName = [item obtainItemName];
                    self.treeItem.itemVal = [item obtainItemValue];
                }
                [self.mainGrid reloadData];
            }
        }];
        [self.navigationController pushViewController:chainShopInfoView animated:NO];
        chainShopInfoView= nil;
    }else{
        //查看机构详情
//        OrgInfoView* orgInfoView = [[OrgInfoView alloc] initWithNibName:[SystemUtil getXibName:@"OrgInfoView"] bundle:nil];
        LSOrgInfoController *orgInfoView = [[LSOrgInfoController alloc] init];
        orgInfoView.isLogin = NO;
        orgInfoView.action = ACTION_CONSTANTS_EDIT;
        orgInfoView.organizationId = [_treeItem obtainItemId];
        [orgInfoView changeOrgInfo:^(id<INameValue> item, NSInteger action) {
            if (item) {
                if (action==ACTION_CONSTANTS_DEL) {
                    [self.dataList removeObject:self.treeItem];
                }else{
                    self.treeItem.itemName = [item obtainItemName];
                    self.treeItem.itemVal = [item obtainItemValue];
                }
                [self.mainGrid reloadData];
            }
        }];
        [self.navigationController pushViewController:orgInfoView animated:NO];
        orgInfoView = nil;
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}


#pragma mark -展开折叠cell
- (void)expandCell:(ShopCell*)cellItem
{
    ShopCell *cell = cellItem;
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

#pragma mark - insert
- (NSArray *)insertMenuIndexPaths:(TreeItem *)item
{
    NSArray * arr;
    [_treeItemsToInsert removeAllObjects];
    [self insertMenuObject:item];
    arr = [self insertIndexsOfMenuObject:_treeItemsToInsert];
    return arr;
}

//展开所有子级
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

//返回子级插入的NSIndexPath列表
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
//移除父类下的所有子级
- (NSArray *)deleteMenuIndexPaths:(TreeItem *)item
{
    NSArray * arr;
    [_treeItemsToRemove removeAllObjects];
    [self deleteMenuObject:item];
    arr = [self deleteIndexsOfMenuObject:_treeItemsToRemove];
    return arr;
}
//移除所有子级项
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
//移除子级项NSIndexPath列表
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
