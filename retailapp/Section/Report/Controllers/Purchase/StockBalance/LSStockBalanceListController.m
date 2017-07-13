//
//  LSStockBalanceListController.m
//  retailapp
//
//  Created by guozhi on 2017/1/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockBalanceListController.h"
#import "SearchBar.h"
#import "LSFooterView.h"
#import "ScanViewController.h"
#import "XHAnimalUtil.h"
#import "LSStockBalanceVo.h"
#import "LSStockBalanceListCell.h"
#import "LSStockBalanceDetailController.h"
#import "LSRightFilterListView.h"
#import "ExportView.h"
#import "SearchBar3.h"
#import "KxMenu.h"
@interface LSStockBalanceListController ()<ISearchBarEvent, LSScanViewDelegate ,UITableViewDataSource,UITableViewDelegate, LSFooterViewDelegate, LSRightFilterListViewDelegate>
@property (strong, nonatomic) SearchBar3 *searchBarF;
@property (strong, nonatomic) SearchBar *searchBarS;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LSFooterView *footView;/*<>*/
@property (nonatomic, strong) NSMutableArray *datas; /**<数据源>*/
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation LSStockBalanceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDatas];
    [self configSubViews];
    [self configConstraints];
    [self loadData];
}
- (void)configDatas {
    self.datas = [NSMutableArray array];
    self.currentPage = 1;
}
- (void)configSubViews {
    [self configTitle:@"库存结存报表" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.searchBarS = [SearchBar searchBar];
    [self.searchBarS initDeleagte:self placeholder:@"条形码/简码/拼音码"];
    self.searchBarS.keyWordTxt.text = self.keyWord;
    [self.view addSubview:self.searchBarS];
    
    self.searchBarF = [SearchBar3 searchBar3];
    NSString *name = nil;
    if (self.searchType == 1) {
        name = @"店内码";
    } else if (self.searchType == 2) {
        name = @"条形码";
    } else if (self.searchType == 3) {
        name = @"款号";
    } else if (self.searchType == 4) {
        name = @"拼音码";
    }
    [self.searchBarF initDeleagte:self withName:name placeholder:[NSString stringWithFormat:@"输入%@", name]];
    [self.searchBarF showCondition:YES];
    self.searchBarF.txtKeyWord.text = self.keyWord;
    [self.view addSubview:self.searchBarF];
    
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        self.searchBarS.hidden = YES;
    } else {
        self.searchBarF.hidden = YES;
    }
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __strong typeof(self) wself = self;
    self.tableView.rowHeight = 88.0f;
    self.tableView.sectionHeaderHeight = 44.0;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.currentPage++;
        [wself loadData];
    }];
    self.tableView.tableFooterView = [ViewFactory generateFooter:60.0];
    [self.view addSubview:self.tableView];
    
    
    self.footView = [LSFooterView footerView];
    
    [self.footView initDelegate:self btnsArray:@[kFootScan,kFootExport]];
    
    [self.view addSubview:self.footView];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
        //添加商品分类
        [LSRightFilterListView addFilterView:self.view type:LSRightFilterListViewTypeCategoryFirst delegate:self];
    } else {
        //添加商品分类
         [LSRightFilterListView addFilterView:self.view type:LSRightFilterListViewTypeCategoryLast delegate:self];
    }
   
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.searchBarS makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.height.equalTo(44);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    [self.searchBarF makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.height.equalTo(44);
        make.top.equalTo(wself.view.top).offset(kNavH);    }];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.searchBarS.bottom);
    }];
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
}


- (void)loadData {
    __weak typeof(self) wself = self;
    [self.param setValue:@(self.currentPage) forKey:@"currPage"];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
         [self.param setValue:self.searchBarF.txtKeyWord.text forKey:@"keyWord"];
         [self.param setValue:@(self.searchType) forKey:@"searchType"];
    } else {
        [self.param setValue:self.searchBarS.keyWordTxt.text forKey:@"keyWord"];
    }
   
    NSString *url = @"warehouseInventory/list";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.currentPage == 1) {
            [wself.datas removeAllObjects];
        }
        NSArray *list = json[@"warehouseInventoryList"];
        if ([ObjectUtil isNotNull:list]) {
            NSArray *objs = [LSStockBalanceVo mj_objectArrayWithKeyValuesArray:list];
            [wself.datas addObjectsFromArray:objs];
        }
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        wself.currentPage--;
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
    
}



#pragma mark - 导出事件
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self scanStart];
    } else if ([footerType isEqualToString:kFootExport]) {//导出
        [self showExportEvent];
    }
}
- (void)showExportEvent {
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [self.param removeObjectForKey:@"currentPage"];
    [vc loadData:self.param withPath:@"warehouseInventory/export" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

#pragma mark - 搜索代理
- (void)imputFinish:(NSString *)keyWord {
    self.currentPage = 1;
    [self loadData];
}

#pragma mark - 选择检索条件
- (void)selectCondition {
    
    NSArray *menuItems = @[
                           [KxMenuItem menuItem:@"款号"
                                          image:nil
                                         target:self
                                         action:@selector(pushMenuItem:)],
                           
                           [KxMenuItem menuItem:@"条形码"
                                          image:nil
                                         target:self
                                         action:@selector(pushMenuItem:)],
                           [KxMenuItem menuItem:@"店内码"
                                          image:nil
                                         target:self
                                         action:@selector(pushMenuItem:)],
                           [KxMenuItem menuItem:@"拼音码"
                                          image:nil
                                         target:self
                                         action:@selector(pushMenuItem:)]
                           ];
    
    
    CGRect rect = CGRectMake(47, self.searchBarF.frame.origin.y, 80, 32);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
}

- (void)pushMenuItem:(id)sender
{
    KxMenuItem* item = (KxMenuItem*)sender;
    [self.searchBarF changeLimitCondition:item.title];
    [self.searchBarF initDeleagte:self withName:item.title placeholder:[NSString stringWithFormat:@"输入%@", item.title]];
    if ([item.title isEqualToString:@"款号"]) {
        self.searchType = 3;
    } else if ([item.title isEqualToString:@"条形码"]) {
        self.searchType = 2;
    } else if ([item.title isEqualToString:@"店内码"]) {
        self.searchType = 1;
    } else if ([item.title isEqualToString:@"拼音码"]) {
        self.searchType = 4;
    }
}

#pragma mark - 扫码代理
//  扫码
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
        self.searchBarF.txtKeyWord.text = scanString;
    } else {//商超
        self.searchBarS.keyWordTxt.text= scanString;
    }
    [self imputFinish:scanString];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [LSAlertHelper showAlert:message];
}
#pragma mark - <LSCategoryFilterViewDelegate>
- (void)rightFilterListView:(LSRightFilterListView *)rightFilterListView didSelectObj:(id<INameItem>)obj {
    self.currentPage = 1;
    [self.param setValue:[obj obtainItemId] forKey:@"categoryId"];
    [self loadData];

}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSStockBalanceListCell *cell = [LSStockBalanceListCell stockBalanceListCellWithTableView:tableView];
    LSStockBalanceVo *obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    LSStockBalanceVo *obj = self.datas[indexPath.row];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
         [param setValue:obj.styleId forKey:@"styleId"];
         [param setValue:obj.goodsId forKey:@"goodsId"];
    } else {
         [param setValue:obj.goodsId forKey:@"goodsId"];
    }
   
    [param setValue:obj.shopId forKey:@"shopId"];
    [param setValue:self.param[@"startTime"] forKey:@"startTime"];
    [param setValue:self.param[@"endTime"] forKey:@"endTime"];
    LSStockBalanceDetailController *vc = [[LSStockBalanceDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    vc.param = param;
    vc.time = self.time;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}


@end
