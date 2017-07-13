//
//  LSStockChangeListController.m
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define CELL_HEIGHT 88
#define HEADER_HEIGHT 40
#import "LSStockChangeListController.h"
#import "XHAnimalUtil.h"
#import "MemberListCell.h"
#import "DHHeadItem.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "MemberTransactionListVo.h"
#import "SVProgressHUD.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "FooterListView3.h"
#import "ExportView.h"
#import "StockChangeLogVo.h"
#import "LSStockChangeListCell.h"
#import "LSGoodsChangeListController.h"
#import "SearchBar.h"
#import "ScanViewController.h"
#import "LSFooterView.h"
@interface LSStockChangeListController ()<UITableViewDataSource,UITableViewDelegate, ISearchBarEvent, LSScanViewDelegate, LSFooterViewDelegate>
@property (strong, nonatomic) UITableView  *tableView;  //tableview
@property (nonatomic, strong) NSMutableArray *stockChangeLogVoList;
/** <#注释#> */
@property (nonatomic, strong) SearchBar *searchBar;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;
/** <#注释#> */
@property (nonatomic, strong) NSNumber *lastTime;
@end

@implementation LSStockChangeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self loadData];
}

- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    [self configTitle:@"库存变更记录" leftPath:Head_ICON_BACK rightPath:nil];
    
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
        wself.lastTime = nil;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
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


#pragma mark - param Get
- (NSMutableArray *)stockChangeLogVoList{
    if (_stockChangeLogVoList == nil) {
        _stockChangeLogVoList = [NSMutableArray array];
    }
    
    return _stockChangeLogVoList;
}

#pragma mark - network
- (void)loadData{
    [self.param setValue:self.lastTime forKey:@"lastTime"];
    [self.param setObject:self.searchBar.keyWordTxt.text forKey:@"findParameter"];
    __weak typeof(self) wself = self;
    NSString *url = @"stockChangeLog/getStockChangeLogGoods";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.lastTime == nil) {
            [wself.stockChangeLogVoList removeAllObjects];//第一页清除所有数据 重新加载
        }
        NSArray *list = json[@"stockChangeLogGoods"];
        
        if ([ObjectUtil isNotEmpty:list]) {
            for (NSDictionary *dict in list) {
                StockChangeLogVo *changeVo = [[StockChangeLogVo alloc] initWithDictionary:dict];
                [wself.stockChangeLogVoList addObject:changeVo];
            }
            
        }
        wself.lastTime = json[@"lastTime"];
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
    self.lastTime = nil;
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
    return self.stockChangeLogVoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSStockChangeListCell *cell = [LSStockChangeListCell stockChangeListCellWithTableView:tableView];
    cell.obj = self.stockChangeLogVoList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return CELL_HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StockChangeLogVo *memberTransactionListVo = self.stockChangeLogVoList[indexPath.row];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[_param objectForKey:@"starttime"] forKey:@"starttime"];
    [param setObject:[_param objectForKey:@"endtime"] forKey:@"endtime"];
    [param setObject:[_param objectForKey:@"shopId"] forKey:@"shopId"];
    [param setObject:memberTransactionListVo.goodsId forKey:@"goodsId"];
    LSGoodsChangeListController *vc = [[LSGoodsChangeListController alloc] init];
    vc.param = param;
    vc.parentStockChangeLogVo = memberTransactionListVo;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}


@end
