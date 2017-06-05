//
//  LSCostChangeRecordListController.m
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define CELL_HEIGHT 88
#define HEADER_HEIGHT 40
#import "LSCostChangeRecordListController.h"
#import "XHAnimalUtil.h"
#import "MemberListCell.h"
#import "DHHeadItem.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "MemberTransactionListVo.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "ExportView.h"
#import "LSCostChangeRecordVo.h"
#import "LSCostChangeRecordListCell.h"
#import "LSCostChangeRecordDetailListController.h"
#import "SearchBar.h"
#import "ScanViewController.h"
#import "LSFooterView.h"
@interface LSCostChangeRecordListController ()<UITableViewDataSource,UITableViewDelegate, ISearchBarEvent, LSScanViewDelegate, LSFooterViewDelegate>
@property (strong, nonatomic) UITableView  *tableView;  //tableview
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger             currentPage;        //当前页
/** <#注释#> */
@property (nonatomic, strong) SearchBar *searchBar;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;
@end

@implementation LSCostChangeRecordListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    [self configViews];
    [self configConstraints];
    [self loadData];
}

- (void)configViews {
    self.datas = [NSMutableArray array];
    self.view.backgroundColor = [UIColor clearColor];
    [self configTitle:@"成本价变更记录" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.searchBar = [SearchBar searchBar];
    [self.searchBar initDeleagte:self placeholder:@"条形码/简码/拼音码"];
    self.searchBar.keyWordTxt.text = self.keyWord;
    [self.view addSubview:self.searchBar];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        self.searchBar.hidden = YES;
    }
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource  =self;
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.currentPage += 1;
        [wself loadData];
    }];
    self.tableView.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    [self.view addSubview:self.tableView];
    
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootScan]];
    [self.view addSubview:self.footView];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        self.footView.hidden = YES;
    }
    
    
}


- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.height.equalTo(44);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            make.top.equalTo(wself.view.top).offset(kNavH);
        } else {
             make.top.equalTo(wself.searchBar.bottom);
        }
    }];
    
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
    
}



#pragma mark - network
- (void)loadData{
    [self.param setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPage"];//参数重新赋值
    [self.param setValue:self.searchBar.keyWordTxt.text forKey:@"findParameter"];
    __weak typeof(self) wself = self;
    NSString *url = @"costPriceChangeLog/list";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        
        if (wself.currentPage == 1) {
            [wself.datas removeAllObjects];//第一页清除所有数据 重新加载
        }
        NSArray *list = json[@"costPriceChangeLogList"];
        
        if ([ObjectUtil isNotEmpty:list]) {
            NSArray *arr = [LSCostChangeRecordVo ls_objectArrayWithKeyValuesArray:list];
            [wself.datas addObjectsFromArray:arr];
           
        }
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        
        [AlertBox show:json];
    }];
}

#pragma mark - <LSFooterView>
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self showScanEvent];
    }
}

#pragma mark - 搜索框代理
- (void)imputFinish:(NSString *)keyWord {
    self.currentPage = 1;
    [self loadData];
    
}

- (void)scanStart {
    [self showScanEvent];
}

// 打开条形码扫描界面
- (void)showScanEvent {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

// LSScanViewDelegate 代理
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.searchBar.keyWordTxt.text = scanString;
    [self imputFinish:scanString];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}



#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSCostChangeRecordListCell *cell = [LSCostChangeRecordListCell costChangeRecordListCelllWithTableView:tableView];
    cell.obj = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return CELL_HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSCostChangeRecordVo *obj = self.datas[indexPath.row];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setValue:[_param objectForKey:@"startTime"] forKey:@"startTime"];
    [param setValue:[_param objectForKey:@"endTime"] forKey:@"endTime"];
    [param setValue:[_param objectForKey:@"shopId"] forKey:@"shopId"];
    [param setValue:obj.goodsId forKey:@"goodsId"];
    LSCostChangeRecordDetailListController *vc = [[LSCostChangeRecordDetailListController alloc] init];
    vc.param = param;
    [self pushViewController:vc];
    
}


@end