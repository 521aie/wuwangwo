//
//  SelectShopStoreListView.m
//  retailapp
//
//  Created by hm on 15/9/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectShopStoreListView.h"
#import "SupplierCell.h"
#import "ViewFactory.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "AllShopVo.h"
#import "WareHouseVo.h"
#import "UIView+Sizes.h"

@interface SelectShopStoreListView ()<ISearchBarEvent,FooterMultiEvent>

@property (nonatomic,strong) CommonService* commonService;

@property (nonatomic,strong) NSMutableArray* selectArr;

@property (nonatomic) NSInteger currentPage;

@property (nonatomic) NSInteger checkMode;

@property (nonatomic,copy) NSString* keyWord;

@property (nonatomic,copy) NSString* selectId;

@property (nonatomic,copy) NSString* loginId;

@property (nonatomic) BOOL isPush;

@property (nonatomic,assign) long lastCreateTime;

@property (nonatomic) BOOL isHeadUser;

@end

@implementation SelectShopStoreListView
- (void)viewDidLoad {
    [super viewDidLoad];
    self.commonService = [ServiceFactory shareInstance].commonService;
    [self initNavigate];
    [self.searchBar initDelagate:self placeholder:@"名称/编号"];
    self.footView.hidden = YES;
    self.dataList = [NSMutableArray array];
    [self addHeaderAndFooter];
    if (self.isAdjust) {
        [self selectAdjustShopStore];
    }else{
        [self selectShopStoreList];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addHeaderAndFooter
{
    __weak typeof(self) weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        weakSelf.lastCreateTime = 0;
        if (self.isAdjust) {
            [weakSelf selectAdjustShopStore];
        }else{
            [weakSelf selectShopStoreList];
        }
    }];
    
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        if (self.isAdjust) {
            [weakSelf selectAdjustShopStore];
        }else{
            [weakSelf selectShopStoreList];
        }
    }];
}

- (void)initNavigate
{
    [self configTitle:@"选择门店" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        if (_shopStoreHandele) {
            _shopStoreHandele(nil);
        }
    }
}

- (void)imputFinish:(NSString *)keyWord
{
    self.currentPage = 1;
    self.lastCreateTime = 0;
    self.keyWord = keyWord;
    [self.mainGrid headerBeginRefreshing];
}

- (void)loadData:(NSString*)selectId checkMode:(NSInteger)mode isPush:(BOOL)isPush callBack:(ShopStoreHandler)shopStoreHandele
{
    self.selectId = selectId;
    self.checkMode = mode;
    self.isPush = isPush;
    _shopStoreHandele = shopStoreHandele;
    self.footView.hidden = (mode==SINGLE_CHECK);
    self.loginId = [[Platform Instance] getkey:ORG_ID];
    self.currentPage = 1;
    self.keyWord = nil;
    self.isHeadUser = [[[Platform Instance] getkey:FATHER_ORG_ID] isEqualToString:@"0"];
    if (!isPush) {
        [self selectShopStoreList];
    }
}


#pragma mark -网络数据处理
- (void)selectShopStoreList
{
    __weak typeof(self) weakSelf = self;
    [self.commonService selectShopStoreList:self.loginId keyWord:self.keyWord page:self.currentPage lastCreateTime:self.lastCreateTime notInclude:self.notInclude completionHandler:^(id json) {
        NSMutableArray* shopList = [AllShopVo converToArr:[json objectForKey:@"allShopList"]];
        weakSelf.lastCreateTime = [[json objectForKey:@"lastCreateTime"] longValue];
        if (weakSelf.currentPage==1) {
            [weakSelf.dataList removeAllObjects];
            if (self.isContainAll&&shopList.count>0) {
                AllShopVo* allVo = [[AllShopVo alloc] init];
                allVo.shopId = @"0";
                allVo.shopName = @"全部";
                [shopList insertObject:allVo atIndex:0];
            }
            if (weakSelf.isHeadUser&&weakSelf.isDayReport&&shopList.count>0) {
                AllShopVo* allVo = [[AllShopVo alloc] init];
                allVo.shopId = @"0";
                allVo.shopName = @"全部";
                [weakSelf.dataList addObject:allVo];
            }
        }
        if ([ObjectUtil isNotEmpty:shopList]) {
            [shopList enumerateObjectsUsingBlock:^(AllShopVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (weakSelf.onlyShop) {//只查询门店不包括仓库
                    if (obj.shopType == 1) {
                        [weakSelf.dataList addObject:obj];
                    }
                } else {
                    [weakSelf.dataList addObject:obj];
                }
                
                
            }];
            
        }

        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        weakSelf.currentPage--;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];

}

#pragma mark - 库存调整用选择门店仓库(下一级门店仓库)
- (void)selectAdjustShopStore
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:self.keyWord forKey:@"keyWord"];
    [param setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPage"];
    [param setValue:[NSNumber numberWithLong:self.lastCreateTime] forKey:@"lastCreateTime"];
    __weak typeof(self) weakSelf = self;
    [self.commonService selectNextLevelShopStoreByParam:param completionHandler:^(id json) {
        NSMutableArray* shopList = [AllShopVo converToArr:[json objectForKey:@"allShopList"]];
        weakSelf.lastCreateTime = [[json objectForKey:@"lastCreateTime"] longValue];
        if (weakSelf.currentPage==1) {
            [weakSelf.dataList removeAllObjects];
            if (weakSelf.isAdjust&&shopList.count>0) {
                AllShopVo* allVo = [[AllShopVo alloc] init];
                allVo.shopId = @"0";
                allVo.shopName = @"全部";
                [weakSelf.dataList addObject:allVo];
            }
        }
        if ([ObjectUtil isNotEmpty:shopList]) {
            [weakSelf.dataList addObjectsFromArray:shopList];
        }
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        weakSelf.currentPage--;
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
    static NSString* supplierCellId = @"SupplierCell";
    SupplierCell* cell = [tableView dequeueReusableCellWithIdentifier:supplierCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SupplierCell" bundle:nil] forCellReuseIdentifier:supplierCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:supplierCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SupplierCell* detailItem = (SupplierCell*)cell;
    id<INameCode> item = [self.dataList objectAtIndex:indexPath.row];
    detailItem.lblName.text = [item obtainItemName];
    BOOL isAll = [[item obtainItemId] isEqualToString:@"0"];
    detailItem.layoutConstraint.priority = isAll ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow;
    detailItem.lblDetail.hidden = [[item obtainItemId] isEqualToString:@"0"];
    detailItem.lblDetail.text = [item obtainItemType]==1?[NSString stringWithFormat:@"门店编号：%@",[item obtainItemCode]]:[NSString stringWithFormat:@"仓库编号：%@",[item obtainItemCode]];
    [detailItem.checkPic setHidden:![self.selectId isEqualToString:[item obtainItemId]]];
    [detailItem.uncheckPic setHidden:[self.selectId isEqualToString:[item obtainItemId]]];
    [detailItem showImageType:[item obtainItemType]==1];
    [detailItem.warehousePic setHidden:[@"0" isEqualToString:[item obtainItemId]]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.checkMode==SINGLE_CHECK) {
        id<INameCode> item = [self.dataList objectAtIndex:indexPath.row];
        _shopStoreHandele(item);
    }
}

#pragma mark - 全选/全不选
-(void) checkAllEvent
{
    [self changeNavigateUI:YES];
}

-(void) notCheckAllEvent
{

    [self changeNavigateUI:YES];
}

- (void)changeNavigateUI:(BOOL)isChange
{
    [self editTitle:isChange act:ACTION_CONSTANTS_EDIT];
    if (isChange) {
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"确认" filePath:Head_ICON_OK];
    }
}

- (void)confirm
{
    

}


@end
