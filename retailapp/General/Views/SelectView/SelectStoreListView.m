//
//  SelectStoreListView.m
//  retailapp
//
//  Created by hm on 16/1/14.
//  Copyright (c) 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectStoreListView.h"
#import "SupplierCell.h"
#import "ViewFactory.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "WareHouseVo.h"

@interface SelectStoreListView ()<ISearchBarEvent>
@property (nonatomic,strong) CommonService* commonService;
@property (nonatomic,copy) StoreHandler storeHandeler;
@property (nonatomic,copy) NSString* orgId;
@property (nonatomic,copy) NSString* keyWord;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL selfWareHouse;
@property (nonatomic,copy) NSString* selectId;
@property (nonatomic,strong) NSMutableDictionary *param;
@end

@implementation SelectStoreListView
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.commonService = [ServiceFactory shareInstance].commonService;
        self.dataList = [[NSMutableArray alloc] init];
        self.param = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self.searchBar initDelagate:self placeholder:@"名称/编号"];
    self.footView.hidden = YES;
    [self addHeaderAndFooter];
    [self selectStoreList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData:(NSString*)selectId withOrgId:(NSString *)orgId withIsSelf:(BOOL)isSelf callBack:(StoreHandler)storeHandele
{
    self.selectId = selectId;
    self.orgId = orgId;
    self.selfWareHouse = isSelf;
    self.storeHandeler = storeHandele;
    self.currentPage = 1;
    [self.param setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPage"];
    [self.param setValue:self.keyWord forKey:@"keyWord"];
    [self.param setValue:self.orgId forKey:@"orgId"];
    [self.param setValue:[NSNumber numberWithBool:self.selfWareHouse] forKey:@"selfWareHouse"];
}

- (void)addHeaderAndFooter
{
    __weak typeof(self) weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf.param setValue:[NSNumber numberWithInteger:weakSelf.currentPage] forKey:@"currentPage"];
        [weakSelf.dataList removeAllObjects];
        [weakSelf selectStoreList];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf.param setValue:[NSNumber numberWithInteger:weakSelf.currentPage] forKey:@"currentPage"];
        [weakSelf selectStoreList];
    }];
}

- (void)initNavigate
{
    [self configTitle:@"选择仓库" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        if (self.storeHandeler) {
            self.storeHandeler(nil);
        }
    }
}

- (void)imputFinish:(NSString *)keyWord
{
    self.currentPage = 1;
    self.keyWord = keyWord;
    [self.param setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPage"];
    [self.param setValue:self.keyWord forKey:@"keyWord"];
    [self.param setValue:self.orgId forKey:@"orgId"];
    [self.mainGrid headerBeginRefreshing];
}

- (void)selectStoreList
{
    __weak typeof(self) weakSelf = self;
    [self.commonService selectStoreListByParams:self.param completionHandler:^(id json) {
        NSMutableArray* arrList = [WareHouseVo converToArr:[json objectForKey:@"wareHouseList"]];
        [weakSelf.dataList addObjectsFromArray:arrList];
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
    if (indexPath.row < self.dataList.count) {
        id<INameCode> item = [self.dataList objectAtIndex:indexPath.row];
        detailItem.lblName.text = [item obtainItemName];
        detailItem.lblDetail.hidden = [[item obtainItemId] isEqualToString:@"0"];
        detailItem.lblDetail.text = [NSString stringWithFormat:@"仓库编号：%@",[item obtainItemCode]];
        [detailItem.checkPic setHidden:![self.selectId isEqualToString:[item obtainItemId]]];
        [detailItem showImageType:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<INameCode> item = [self.dataList objectAtIndex:indexPath.row];
    self.storeHandeler(item);
}


@end
