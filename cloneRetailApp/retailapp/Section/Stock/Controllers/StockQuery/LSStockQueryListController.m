//
//  LSStockQueryListController.m
//  retailapp
//
//  Created by guozhi on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockQueryListController.h"
#import "ServiceFactory.h"
#import "ViewFactory.h"
#import "SearchBar.h"
#import "SearchBar2.h"
#import "XHAnimalUtil.h"
#import "FormatUtil.h"
#import "AlertBox.h"
#import "LSStockQueryListCell.h"
#import "StockInfoVo.h"
#import "ScanViewController.h"
#import "ExportView.h"
#import "LSStockQueryDetailController.h"
#import "SMHeaderItem.h"
#import "LSFooterView.h"
#import "HeaderItem.h"

@interface LSStockQueryListController ()<ISearchBarEvent,LSScanViewDelegate,UITableViewDataSource,UITableViewDelegate, LSFooterViewDelegate>
@property (nonatomic,strong) SearchBar* searchBar;
@property (nonatomic,strong) SearchBar2* searchBar2;
@property (nonatomic,strong) UITableView* mainGrid;
@property (nonatomic,strong) LSFooterView *footView;
/**数据源*/
@property (nonatomic,strong) NSMutableArray* dataList;
/**条件参数dic*/
@property (nonatomic,strong) NSMutableDictionary *params;
/**分页*/
@property (nonatomic,assign) NSInteger currentPage;
/**总数量*/
@property (nonatomic,strong) NSNumber* totalCount;
/**总金额*/
@property (nonatomic,strong) NSNumber* totalMoney;
/**回调block*/
@property (nonatomic,copy) ChangeKeyWordHandler keyWordHangdler;
/**检索关键词*/
@property (nonatomic,copy) NSString* keyWord;
/**扫码*/
@property (nonatomic,copy) NSString* scanCode;
/**数据模型*/
@property (nonatomic,strong) StockInfoVo *stockInfoVo;
/**是否商超*/
@property (nonatomic) BOOL isMarket;
/**是否连锁*/
@property (nonatomic) BOOL isChain;
/** 是否显示成本价 */
@property (nonatomic, assign) BOOL isShowCostPrice;
@end

@implementation LSStockQueryListController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    self.dataList = [NSMutableArray array];
    //有权限显示成本价 没有权限 商超显示零售价 服鞋显示吊牌价
    self.isShowCostPrice = ![[Platform Instance] lockAct:ACTION_COST_PRICE_SEARCH];
    [self addHeaderAndFooter];
    [self queryStockInfoList];
    //由于后台技术有限 商超的商品数量总和需要调用新的接口 服鞋的不需要调用新的接口
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
        //获取商品数量总和
        [self loadGoodsTotalNumber];
    }
    [self configHelpButton:HELP_STOCK_QUERY];
    
}

- (void)configViews {
    //标题
    [self configTitle:@"库存查询" leftPath:Head_ICON_BACK rightPath:nil];
    //搜索框
    self.searchBar = [SearchBar searchBar];
    [self.searchBar initDeleagte:self placeholder:@"条形码/简码/拼音码"];
    [self.view addSubview:self.searchBar];
    
    self.searchBar2 = [SearchBar2 searchBar2];
    [self.searchBar2 initDelagate:self placeholder:@"名称/款号"];
    [self.view addSubview:self.searchBar2];
    
    //表格
    self.mainGrid = [[UITableView alloc] init];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainGrid];
    
    //底部工具栏
    self.footView = [LSFooterView footerView];
    [self.view addSubview:self.footView];
    
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == CLOTHESHOES_MODE) {
        self.searchBar.hidden = YES;
        [self.footView initDelegate:self btnsArray:@[kFootExport]];
        if ([NSString isNotBlank:[self.params objectForKey:@"scanCode"]]) {
            self.searchBar2.keyWordTxt.text = [self.params objectForKey:@"scanCode"];
        }
        if ([NSString isNotBlank:[self.params objectForKey:@"keywords"]]) {
            self.searchBar2.keyWordTxt.text = [self.params objectForKey:@"keywords"];
        }
    }else{
        self.searchBar2.hidden = YES;
        
        [self.footView initDelegate:self btnsArray:@[kFootExport, kFootScan]];
        if ([NSString isNotBlank:[self.params objectForKey:@"scanCode"]]) {
            self.searchBar.keyWordTxt.text = [self.params objectForKey:@"scanCode"];
        }
        if ([NSString isNotBlank:[self.params objectForKey:@"keywords"]]) {
            self.searchBar.keyWordTxt.text = [self.params objectForKey:@"keywords"];
        }
    }

    
}



- (void)configConstraints {
    //配置约束
    __weak typeof(self) wself = self;
    [wself.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
        make.height.equalTo(44);
    }];
    [wself.searchBar2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
        make.height.equalTo(44);
    }];
    [wself.mainGrid makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.searchBar.bottom);
        make.bottom.equalTo(wself.view.bottom);
    }];
    [wself.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
       make.bottom.equalTo(wself.view.bottom);
        make.height.equalTo(60);
    }];
    
    
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self showScanEvent];
    } else if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    }
}



#pragma mark - 添加刷新加载控件
- (void)addHeaderAndFooter {
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    self.mainGrid.sectionHeaderHeight = 30.0f;
    self.mainGrid.rowHeight = 88.f;
    __block typeof(self) strongSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        strongSelf.currentPage = 1;
        [strongSelf queryStockInfoList];
        
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        strongSelf.currentPage++;
        [strongSelf queryStockInfoList];
    }];
    
}
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        self.keyWordHangdler(self.keyWord);
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - 设置查询条件及回调
- (void)loadDataWithCondition:(NSMutableDictionary *)param callBack:(ChangeKeyWordHandler)handler {
    self.currentPage = 1;
    self.params = param;
    self.keyWordHangdler = handler;
    self.isMarket = ([[[Platform Instance] getkey:SHOP_MODE] integerValue]==102);
    self.isChain = ([[Platform Instance] getShopMode]!=1);
}


#pragma mark - searchbar
//输入关键词检索
- (void)imputFinish:(NSString *)keyWord {
    self.keyWord = keyWord;
    self.scanCode = nil;
    self.currentPage = 1;
    [self.params setValue:keyWord forKey:@"keywords"];
    [self.params setValue:self.scanCode forKey:@"scanCode"];
    [self queryStockInfoList];
}

#pragma mark - 条形码扫描
//开始扫码
- (void)scanStart
{
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

//开始扫码
- (void)showScanEvent {
    [self scanStart];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.scanCode = scanString;
    self.keyWord = nil;
    self.currentPage = 1;
    self.searchBar.keyWordTxt.text = scanString;
    [self.params setValue:self.keyWord forKey:@"keywords"];
    [self.params setValue:scanString forKey:@"scanCode"];
    [self queryStockInfoList];
    
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}


#pragma mark - footview
//导出
- (void)showExportEvent
{
    ExportView *expotView = [[ExportView alloc] init];
    __strong typeof(self) strongSelf = self;
    [expotView  loadData:self.params withPath:@"stockInfo/exportExcel" withIsPush:YES callBack:^{
                [XHAnimalUtil animal:strongSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                [strongSelf.navigationController popToViewController:strongSelf animated:NO];
    }];
        [self.navigationController pushViewController:expotView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (void)showHelpEvent
{
    
    
}

#pragma mark - 查询商品库存信息
- (void)queryStockInfoList {
    __strong typeof(self) strongSelf = self;
    [self.params setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPage"];
    NSString *url = @"stockInfo/list";
    [BaseService getRemoteLSDataWithUrl:url param:self.params withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray *stockInfoList = [StockInfoVo converToArr:[json objectForKey:@"stockInfoVoList"]];
        if (strongSelf.currentPage==1) {
            //由于后台技术有限 商超的商品数量总和需要调用新的接口 服鞋的不需要调用新的接口
            if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
                //获取商品数量总和
                strongSelf.totalCount = [json objectForKey:@"sumStore"];
            }
            
            [strongSelf.dataList removeAllObjects];
        }
        [strongSelf.dataList addObjectsFromArray:stockInfoList];
        [strongSelf.mainGrid reloadData];
        strongSelf.mainGrid.ls_show = YES;
        [strongSelf.mainGrid headerEndRefreshing];
        [strongSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [strongSelf.mainGrid headerEndRefreshing];
        [strongSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma mark - 查询商品总是
- (void)loadGoodsTotalNumber {
    [self.params removeObjectForKey:@"currentPage"];
    NSString *url = @"stockInfo/stockInfoNowStores";
    __strong typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:self.params withMessage:nil show:NO CompletionHandler:^(id json) {
        wself.totalCount = [json objectForKey:@"sumStore"];
        [wself.mainGrid reloadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count>0?1:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderItem *headerView = [HeaderItem headerItem];
    NSString *title = nil;
    if ([self.totalCount.stringValue containsString:@"."]) {
        title = [NSString stringWithFormat:@"合计%.3f件",self.totalCount.doubleValue];
    } else {
        title = [NSString stringWithFormat:@"合计%.f件",self.totalCount.doubleValue];
    }
    [headerView initWithName:title];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSStockQueryListCell *cell = [LSStockQueryListCell stockQueryListCellWithTableView:tableView];
    StockInfoVo *obj = self.dataList[indexPath.row];
    cell.obj = obj;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //只有服鞋模式才可以查询详情
    if (!self.isMarket) {
        self.stockInfoVo = [self.dataList objectAtIndex:indexPath.row];
        LSStockQueryDetailController *detailView = [[LSStockQueryDetailController alloc] init];
        detailView.shopId = [self.params objectForKey:@"shopId"];
        detailView.styleId = self.stockInfoVo.styleId;
        detailView.isChain = self.isChain;
        detailView.price = self.isChain?[self.stockInfoVo.hangTagPrice doubleValue]:[self.stockInfoVo.purchasePrice doubleValue];
                [self.navigationController pushViewController:detailView animated:NO];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}


@end
