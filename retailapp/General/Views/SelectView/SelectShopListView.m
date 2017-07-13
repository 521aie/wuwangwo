//
//  SelectShopListView.m
//  retailapp
//
//  Created by hm on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectShopListView.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "AlertBox.h"
#import "CheckShopCell.h"
#import "SubOrgVo.h"
#import "TreeNodeUtils.h"
#import "UIView+Sizes.h"

@interface SelectShopListView ()<ISearchBarEvent>

@property (nonatomic,strong) SettingService* service;

@property (nonatomic) NSInteger currentPage;

@property (nonatomic,copy) NSString* keyWord;

@property (nonatomic,copy) NSString* selectId;

/**1 门店用户登录查询 2机构用户登录查询*/
@property (nonatomic) NSInteger type;

/**区分显示 "全部"*/
@property (nonatomic) NSInteger viewType;

/**页面是否是navigation push的*/
@property (nonatomic) BOOL isPush;

@end

@implementation SelectShopListView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.service = [ServiceFactory shareInstance].settingService;
    self.footView.hidden = YES;
    [self initNavigate];
    [self.searchBar initDelagate:self placeholder:@"名称/编号"];
    __weak SelectShopListView* weakSelf = self;
    
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage =1;
        if (weakSelf.type==1) {
            [weakSelf selectTransferList];
        }else{
            if (weakSelf.isJunior) {
                [weakSelf selectSonShopList];
            }else{
                [weakSelf selectShopList];
            }
        }
    }];
    
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        if (weakSelf.type==1) {
            [weakSelf selectTransferList];
        }else{
            if (weakSelf.isJunior) {
                [weakSelf selectSonShopList];
            }else{
                [weakSelf selectShopList];
            }
        }
    }];

    if (self.isPush) {
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigate
{
    [self configTitle:@"选择门店" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        _selectShopBlock(nil);
    }
}

- (void)imputFinish:(NSString *)keyWord
{
    self.currentPage = 1;
    self.keyWord = keyWord;
    [self.mainGrid headerBeginRefreshing];
}

- (void)loadShopList:(NSString*)selectId withType:(NSInteger)type withViewType:(NSInteger)viewType withIsPush:(BOOL)isPush callBack:(SelectShopList)callBack {
    
    self.selectId = selectId;
    self.selectShopBlock = callBack;
    self.type = [[Platform Instance] getShopMode]==3?2:1;
    self.viewType = viewType;
    self.isPush = isPush;
    [self clearData];
    if (!isPush) {
        [self loadData];
    }
}

- (void)clearData {
    self.currentPage = 1;
    self.keyWord = nil;
    [self.dataList removeAllObjects];
}

- (void)loadData {
    if (self.type==1) {
        [self selectTransferList];
    }else {
        if (self.isJunior) {
            [self selectSonShopList];
        }else {
            [self selectShopList];
        }
    }
}

//查询店家一览
- (void)selectShopList
{
    NSString* page = [NSString stringWithFormat:@"%tu",self.currentPage];
    __weak SelectShopListView* weakSelf = self;
    [self.service selectShopList:[[Platform Instance] getkey:ORG_ID] withPage:page withKeyWord:self.keyWord isMicroShop:self.isMicroShop completionHandler:^(id json) {
        NSMutableArray* arr = [SubOrgVo converToSubOrgList:[json objectForKey:@"sonList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.dataList removeAllObjects];
            SubOrgVo* allOrg = [[SubOrgVo alloc] init];
            allOrg.name = @"全部";
            allOrg._id = @"0";
            if (weakSelf.viewType==CONTAIN_ALL) {
                [arr insertObject:allOrg atIndex:0];
            }
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

//门店调拨使用
- (void)selectTransferList
{
    NSString* page = [NSString stringWithFormat:@"%tu",self.currentPage];
    __weak SelectShopListView* weakSelf = self;
    [self.service selectTransferList:[[Platform Instance] getkey:SHOP_ID] withPage:page withKeyWord:self.keyWord completionHandler:^(id json) {
        NSMutableArray* arr = [SubOrgVo converToSubOrgList:[json objectForKey:@"sonList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.dataList removeAllObjects];
            SubOrgVo* allOrg = [[SubOrgVo alloc] init];
            allOrg.name = @"全部";
            allOrg._id = @"0";
            if (weakSelf.viewType==CONTAIN_ALL) {
                [arr insertObject:allOrg atIndex:0];
            }
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

//选择直属下级门店
- (void)selectSonShopList
{
    __weak typeof(self) wself = self;
    [self.service selectSonShopList:[[Platform Instance] getkey:ORG_ID] page:self.currentPage keyWord:self.keyWord completionHandler:^(id json) {
        NSMutableArray* arr = [SubOrgVo converToSubOrgList:[json objectForKey:@"sonList"]];
        if (wself.currentPage==1) {
            [wself.dataList removeAllObjects];
            SubOrgVo* allOrg = [[SubOrgVo alloc] init];
            allOrg.name = @"全部";
            allOrg._id = @"0";
            if (wself.viewType==CONTAIN_ALL) {
                [arr insertObject:allOrg atIndex:0];
            }
        }
        NSMutableArray* sonArr = [TreeNodeUtils converToTreeItemArr:arr];
        [wself.dataList addObjectsFromArray:sonArr];
        [wself.mainGrid reloadData];
        arr = nil;
        sonArr = nil;
        wself.mainGrid.ls_show = YES;
        [wself.mainGrid headerEndRefreshing];
        [wself.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [wself.mainGrid headerEndRefreshing];
        [wself.mainGrid footerEndRefreshing];
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
    BOOL isAll = [NSString isBlank:[item obtainItemValue]];
    detailItem.lblName.ls_top = isAll ? 34 : 20;
    detailItem.lblNo.hidden = [NSString isBlank:[item obtainItemValue]];
    detailItem.lblNo.text = [NSString stringWithFormat:@"门店编号：%@",[item obtainItemValue]];
    BOOL checkVal = NO;
    // 对于包含“全部”选项的，作特殊处理
    if (self.viewType == CONTAIN_ALL && indexPath.row == 0 && [NSString isBlank:self.selectId]) {
        checkVal = YES;
    } else {
      checkVal = [self.selectId isEqualToString:[item obtainItemId]];
    }
    
    [detailItem showImg:([item obtainItemType]==2) withType:1 withCheck:checkVal];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<ITreeItem> orgVo = [self.dataList objectAtIndex:indexPath.row];
    _selectShopBlock(orgVo);
}

@end
