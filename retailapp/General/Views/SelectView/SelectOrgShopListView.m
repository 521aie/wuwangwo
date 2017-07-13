//
//  SelectOrgShopListView.m
//  retailapp
//
//  Created by hm on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectOrgShopListView.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "AlertBox.h"
#import "SubOrgVo.h"
#import "TreeBuilder.h"
#import "CheckShopCell.h"
#import "TreeItem.h"
#import "SetRender.h"
#import "INameItem.h"

@interface SelectOrgShopListView ()<ISearchBarEvent,FooterMultiEvent,CheckShopCellDelegate>

@property (nonatomic,strong) SettingService* service;

/** moduleType == 1 从商品详情和款式详情页面进入时，默认在一览的最上方显示“同步所有、不同步”，当前登录的机构不显示*/
/** moduleType == 2 从员工一览和员工详情页面进入时，可查询登录者所属机构及其所有下属机构和门店；*/
/** moduleType == 3 从员工一览和员工详情以外的页面进入时，只能查询登录者所属机构及其机构类型是“公司”的下属机构和门店*/
/** moduleType == 4 只能查询登录者所属机构及其机构类型是“公司”的下属机构和门店,当前登录的机构不显示*/
@property (nonatomic) NSInteger moduleType;

/**显示模式 1列表 2树状列表*/
@property (nonatomic) NSInteger type;
/**单选 0 多选 1*/
@property (nonatomic) NSInteger checkMode;

@property (nonatomic,copy) NSString* selectId;

@property (nonatomic,copy) NSString* orgId;

@property (nonatomic,copy) NSString* keyWord;

@property (nonatomic) NSInteger currentPage;

@property (nonatomic,strong) NSMutableArray* selectArr;

/**是否显示部门*/
@property (nonatomic) BOOL depFlag;
/**是否显示门店*/
@property (nonatomic) BOOL shopFlag;
/**是否显示登录机构或门店*/
@property (nonatomic) BOOL isShow;
/**是否显示“同步所有、不同步”*/
@property (nonatomic) BOOL isSync;


@property (nonatomic,strong) NSMutableArray* allItems;

@end

@implementation SelectOrgShopListView
@synthesize service;


- (void)viewDidLoad {
    [super viewDidLoad];
     service = [ServiceFactory shareInstance].settingService;
    self.footView.hidden = YES;
    self.selectArr = [NSMutableArray array];
    self.allItems = [NSMutableArray array];
    service = [ServiceFactory shareInstance].settingService;
    [self initNavigate];
    [self.searchBar initDelagate:self placeholder:@"名称/编号"];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData:(NSString*)_id withModuleType:(NSInteger)type withCheckMode:(NSInteger)mode callBack:(SelectOrgShopBack)callBack
{
    self.selectBlock = callBack;
    self.moduleType = type;
    self.type = 2;
    self.checkMode = mode;
    self.selectId = _id;
}



- (void)initNavigate
{
    [self configTitle:@"选择机构/门店" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        _selectBlock(nil,nil);
    }else{
    
        [self confirm];
    }
}

- (void)imputFinish:(NSString *)keyWord
{
    self.currentPage = 1;
    self.keyWord = keyWord;
    if ([NSString isBlank:keyWord]) {
        self.type = 2;
        if (self.checkMode==MUTIl_CHECK) {
            self.footView.hidden = YES;
        }
        [self removeHeaderAndFooter];
        [self selectOrgOrShop:self.orgId withDepFlag:self.depFlag withShopFlag:self.shopFlag];
    }else{
        self.type = 1;
        if (self.checkMode==MUTIl_CHECK) {
            self.footView.hidden = NO;
        }
        [self addHeaderAndFooter];
        [self.mainGrid headerBeginRefreshing];
    }
    
}

- (void)addHeaderAndFooter
{
    __weak SelectOrgShopListView* weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage =1;
        [self selectByKeyWord:weakSelf.keyWord withDepFlah:weakSelf.depFlag withShopflag:weakSelf.shopFlag];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [self selectByKeyWord:weakSelf.keyWord withDepFlah:weakSelf.depFlag withShopflag:weakSelf.shopFlag];
    }];
}

- (void)removeHeaderAndFooter
{
    [self.mainGrid removeHeader];
    [self.mainGrid removeFooter];
    [self.dataList removeAllObjects];
    [self.treeItemsToInsert removeAllObjects];
    [self.treeItemsToRemove removeAllObjects];
}

- (void)initData
{
    [self removeHeaderAndFooter];
    self.searchBar.keyWordTxt.text = nil;
    self.isShow = !(self.moduleType==1||self.moduleType==4);
    self.isSync = (self.moduleType==1);
    self.depFlag = (self.moduleType==2);
    self.shopFlag = YES;
    if ([[Platform Instance] getShopMode]==2 || [[Platform Instance] getShopMode]==1) {
        self.orgId = [[Platform Instance] getkey:SHOP_ID];
    }else{
        self.orgId = [[Platform Instance] getkey:ORG_ID];
    }
    [self selectOrgOrShop:self.orgId withDepFlag:self.depFlag withShopFlag:self.shopFlag];
}


#pragma mark - 网络数据处理
//树状列表
- (void)selectOrgOrShop:(NSString*)loginId withDepFlag:(BOOL)depFlag withShopFlag:(BOOL)shopFlag
{
    __weak SelectOrgShopListView* weakSelf = self;
    [service selectAllSubOrg:loginId withDepFlag:depFlag withShopFlag:shopFlag withIsMicroShop:self.isMicroShop completionHandler:^(id json) {
        NSMutableArray* subArr = [SubOrgVo converToSubOrgList:[json objectForKey:@"sonList"]];
        SubOrgVo *microShop = [SubOrgVo converToSubOrg:[json objectForKey:@"microShop"]];
        if (!weakSelf.isShow) {
            if (weakSelf.isSync) {
                TreeItem* vo = [[TreeItem alloc] init];
                vo.itemId = loginId;
                vo.itemName = @"同步所有";
                [weakSelf.dataList addObject:vo];
                vo = [[TreeItem alloc] init];
                vo.itemId = @"0";
                vo.itemName = @"不同步";
                [weakSelf.dataList addObject:vo];
            }
            if (weakSelf.isAll) {
                TreeItem* vo = [[TreeItem alloc] init];
                vo.itemId = @"0";
                vo.itemName = @"全部";
                [weakSelf.dataList addObject:vo];
            }
            [subArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SubOrgVo* vo = (SubOrgVo*)obj;
                if ([weakSelf.orgId isEqualToString:vo._id]) {
                    *stop = YES;
                }

                if (*stop==YES) {
                    [subArr removeObjectAtIndex:idx];
                }
            }];
        }
        if (weakSelf.isFilterTop) {
            [subArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SubOrgVo* vo = (SubOrgVo*)obj;
                if ([@"0" isEqualToString:vo.parentId]) {
                    *stop = YES;
                }
                
                if (*stop==YES) {
                    [subArr removeObjectAtIndex:idx];
                }
            }];
        }
        if (weakSelf.isMicroShop) {
            [weakSelf.dataList addObject:microShop];
        }
        NSMutableArray* treeItems = [TreeBuilder buildTreeItem:subArr];
        for (TreeItem *treeItem in treeItems) {
            [weakSelf.dataList addObject:treeItem];
            if (weakSelf.isShow) {
                [weakSelf insertMenuIndexPaths:treeItem];
            }
        }
        [weakSelf.allItems removeAllObjects];
        [weakSelf.allItems addObjectsFromArray:subArr];
        [treeItems removeAllObjects];
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

//列表
- (void)selectByKeyWord:(NSString*)keyWord withDepFlah:(BOOL)depFlag withShopflag:(BOOL)shopFlag
{     __weak SelectOrgShopListView* weakSelf = self;
    NSString* page = [NSString stringWithFormat:@"%tu",self.currentPage];
    [service selectInBranch:self.orgId withPage:page withKeyWord:keyWord withDepFlag:depFlag withShopFlag:shopFlag withIsMicroShop:self.isMicroShop completionHandler:^(id json) {
        NSArray* sonList = [json objectForKey:@"sonList"];
        NSMutableArray* arr = [SubOrgVo converToSubOrgList:sonList];
        if (!weakSelf.isShow) {
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SubOrgVo* vo = (SubOrgVo*)obj;
                if ([weakSelf.orgId isEqualToString:vo._id]) {
                    *stop = YES;
                }
                if (*stop==YES) {
                    [arr removeObjectAtIndex:idx];
                }
            }];
        }
        if (weakSelf.isFilterTop) {
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SubOrgVo* vo = (SubOrgVo*)obj;
                if ([@"0" isEqualToString:vo.parentId]) {
                    *stop = YES;
                }
                
                if (*stop==YES) {
                    [arr removeObjectAtIndex:idx];
                }
            }];
        }
        TreeItem* treeItem = nil;
        NSMutableArray* itemArr = [NSMutableArray arrayWithCapacity:arr.count];
        
        for (id<ITreeItem> item  in arr) {
            treeItem = [[TreeItem alloc] initWith:item];
            [itemArr addObject:treeItem];
        }
        
        if (weakSelf.currentPage==1) {
            [weakSelf.dataList removeAllObjects];
            if (weakSelf.isSync) {
                TreeItem* vo = [[TreeItem alloc] init];
                vo.itemId = weakSelf.orgId;
                vo.itemName = @"同步所有";
                [weakSelf.dataList addObject:vo];
                vo = [[TreeItem alloc] init];
                vo.itemId = @"0";
                vo.itemName = @"不同步";
                [weakSelf.dataList addObject:vo];
            }
            if (weakSelf.isAll) {
                TreeItem* vo = [[TreeItem alloc] init];
                vo.itemId = @"0";
                vo.itemName = @"全部";
                [weakSelf.dataList addObject:vo];
            }
            SubOrgVo *microShop = [SubOrgVo converToSubOrg:[json objectForKey:@"microShop"]];
            if (weakSelf.isMicroShop) {
                [weakSelf.dataList addObject:microShop];
            }
        }
        [weakSelf.dataList addObjectsFromArray:itemArr];
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
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
    detailItem.lblNo.hidden = [NSString isBlank:[item obtainItemValue]];
    if ([NSString isBlank:[item obtainItemValue]]) {//总部
        CGPoint center = detailItem.lblName.center;
        center.y = 44;
        detailItem.lblName.center = center;
    } else {
        CGPoint center = detailItem.lblName.center;
        center.y = 30;
        detailItem.lblName.center = center;
    }
    detailItem.lblNo.text = ([item obtainItemType]==2)?[NSString stringWithFormat:@"门店编号：%@",[item obtainItemValue]]:[NSString stringWithFormat:@"机构编号：%@",[item obtainItemValue]];
    [detailItem initDeleagte:self withItem:item];
    if (self.checkMode==SINGLE_CHECK) {
        [item mCheckVal:[self.selectId isEqualToString:[item obtainItemId]]];
    }
    [detailItem showImg:([item obtainItemType]==2) withType:self.type withCheck:[item obtainCheckVal]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<ITreeItem> item = [self.dataList objectAtIndex:indexPath.row];
    if (self.checkMode==SINGLE_CHECK) {
        _selectBlock(nil,[self obtainItemParentCode:item]);
    }else{
        if (self.type==2) {
            //批量选择
            if ([item obtainItemType]==2) {
                //选择门店
                [item mCheckVal:![item obtainCheckVal]];
                [self cancelOrCheckParentItem:item];
            }else{
                //选择机构
                if ([self checkTreeItem:item checkVal:![item obtainCheckVal] count:0]==0) {
                    //机构下没有门店时，报信息
                    [AlertBox show:@"选择的机构下无下属门店，请选择其他机构或门店。"];
                    return;
                }else{
                    //机构下有门店时，选中机构并展开下级门店
                    [item mCheckVal:![item obtainCheckVal]];
                    [self addTreeItem:item];
                    [self cancelOrCheckParentItem:item];
                }
            }
        }else{
             [item mCheckVal:![item obtainCheckVal]];
        }
        [self changeNavigate];
        [self.mainGrid reloadData];
    }
}

//选择所有下属门店
- (NSInteger)checkTreeItem:(TreeItem *)item checkVal:(BOOL)checkVal count:(NSInteger)count
{
    NSInteger flg = count;
    for (TreeItem *treeItem in item.subItems) {
        if ([treeItem obtainItemType]==2) {
            flg+=1;
        }
        if ([treeItem obtainItemType]!=2&&treeItem.subItems.count>0) {
            //机构下是否有门店
            flg = [self checkTreeItem:treeItem checkVal:checkVal count:0];
        }
        if (flg>0) {
            treeItem.checkVal = checkVal;
        }
    }
    return flg;
}
//所有下属门店选择时，上级机构中；下级门店取消时，相应的选中机构也取消
- (void)cancelOrCheckParentItem:(TreeItem *)item
{
    if ([[item obtainParentId] isEqualToString:@"0"]) {
        return;
    }
    TreeItem *parentItem;
    //获取上级机构
    for (TreeItem *treeItem in self.dataList) {
        if ([[treeItem obtainItemId] isEqualToString:[item obtainParentId]]) {
            parentItem = treeItem;
            break;
        }
    }
    NSInteger count = 0;
    //判断机构下是否有机构或门店没有选中
    for (TreeItem *childItem in parentItem.subItems) {
        if (![childItem obtainCheckVal]) {
            count+=1;
        }
    }
    [parentItem mCheckVal:(count==0)];
    if (parentItem) {
        [self cancelOrCheckParentItem:parentItem];
    }
}

//展开选择的下一级机构和门店
- (void)addTreeItem:(TreeItem *)item
{
    if (!item.isSubItemOpen)
    {
        NSArray * arr;
        arr = [self insertMenuIndexPaths:item];
        if ([arr count] >0) {
            [self.mainGrid insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationBottom];
        }
    }
}

//获取上级机构的编号
- (id<ITreeItem>)obtainItemParentCode:(id<ITreeItem>)item
{
    if ([[item obtainParentId] isEqualToString:@"0"]) {
        [item mParentCode:[item obtainItemValue]];
        return item;
    }
    for (id<ITreeItem> treeItem in self.allItems) {
        if ([[item obtainParentId] isEqualToString:[treeItem obtainItemId]]) {
            [item mParentCode:[treeItem obtainItemValue]];
            break;
        }
    }
    return item;
}

#pragma mark - 树状列表展开折叠
- (void)expandCell:(CheckShopCell *)cell
{
    if (cell.item.isSubItemOpen)
    {
        NSArray * arr;
        arr = [self deleteMenuIndexPaths:cell.item];
        if ([arr count] >0) {
            [self.mainGrid deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationBottom];
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


#pragma mark - 选择数据
- (void)changeNavigate
{
    BOOL isChange = NO;
    for (id<ITreeItem> item in self.dataList) {
        if ([item obtainCheckVal]) {
            isChange = YES;
        }
    }
    [self editTitle:isChange act:ACTION_CONSTANTS_EDIT];
    if (isChange) {
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"确定" filePath:Head_ICON_OK];
    }
}


#pragma mark - 全选 /全不选
-(void) checkAllEvent
{
    for (id<ITreeItem> item in self.dataList) {
        [item mCheckVal:YES];
    }
    [self changeNavigate];
    [self.mainGrid reloadData];
}

-(void) notCheckAllEvent
{
    for (id<ITreeItem> item in self.dataList) {
        [item mCheckVal:NO];
    }
    [self changeNavigate];
    [self.mainGrid reloadData];
}

#pragma mark - 列表时获取选中机构下的门店
- (void)obtainOrgSubItems
{
    NSDate* tmpStartData = [NSDate date];

    NSMutableArray* orgList=[NSMutableArray array];
    for (id<ITreeItem> selectItem in self.selectArr) {
        if ([selectItem obtainItemType]!=2) {
            [orgList addObject:selectItem];
        }
    }
    [self.selectArr removeObjectsInArray:orgList];
    for (id<ITreeItem> orgItem in orgList) {
        for (id<ITreeItem> item in self.allItems) {
            if ([[orgItem obtainItemId] isEqualToString:[item obtainItemId]]) {
                [item mCheckVal:YES];
            }
        }
    }
    NSMutableArray* rootList = [TreeBuilder buildTreeItem:self.allItems];
    NSMutableArray *targets = [self convertAllTreeItem:rootList];
    [self.selectArr addObjectsFromArray:targets];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (id<ITreeItem> item in self.selectArr) {
        if ([item obtainItemType] ==2) {
            [dic setValue:item forKey:[item obtainItemId]];
        }
    }
    [self.selectArr removeAllObjects];
    [self.selectArr addObjectsFromArray:[dic allValues]];
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time = %f", deltaTime);
    orgList = nil;
    rootList = nil;
    targets = nil;
    dic = nil;
}

- (NSMutableArray*) convertAllTreeItem:(NSMutableArray*)sources
{
    NSMutableArray* targets=[NSMutableArray array];
    if (sources==nil ||  [sources count]==0) {
        return targets;
    }
    for (TreeItem* item in sources) {
        [self addList:item arr:targets];
    }
    return targets;
}

- (void) addList:(TreeItem*)node arr:(NSMutableArray*)arrs
{
    if ([node obtainCheckVal]) {
        [arrs addObject:node];
    }
    if (node.subItems==nil && [node.subItems count]==0) {
        return;
    }
    for (TreeItem* child in node.subItems) {
        if ([node obtainCheckVal]) {
            [child mCheckVal:YES];
        }
        [self addList:child arr:arrs];
    }
}


#pragma mark - 确定
- (void)confirm
{
    if (self.type==1) {
        //列表模式下选中
        for (id<ITreeItem> item in self.dataList) {
            if ([item obtainCheckVal]) {
                [self.selectArr addObject:item];
            }
        }
        [self obtainOrgSubItems];
    }else{
        //树状模式下选中
        TreeItem *parentItem = [self.dataList objectAtIndex:0];
        if ([parentItem obtainCheckVal]) {
            [self.selectArr addObject:parentItem];
        }
        [self selectAllChildItem:parentItem];
    }
    _selectBlock(self.selectArr,nil);
}

//取出所有选中的机构或门店
- (void)selectAllChildItem:(TreeItem *)item
{
    if (item.subItems.count>0) {
        for (TreeItem *childItem in item.subItems) {
            if ([childItem obtainCheckVal]) {
                [self.selectArr addObject:childItem];
            }
            if ([childItem obtainItemType]!=2&&childItem.subItems.count>0) {
                [self selectAllChildItem:childItem];
            }
        }
    }
}

@end
