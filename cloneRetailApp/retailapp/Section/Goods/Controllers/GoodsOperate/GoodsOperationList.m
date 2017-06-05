//
//  GoodsOperationList.m
//  retailapp
//
//  Created by guozhi on 16/2/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsOperationList.h"
#import "SearchBar.h"
#import "FooterListView6.h"
#import "XHAnimalUtil.h"
#import "ScanViewController.h"
#import "GoodsService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "GoodsOperationVo.h"
#import "CommonGoodsSelectCell.h"
#import "ColorHelper.h"
#import "GoodsSplitView.h"
#import "LSFooterView.h"
#import "HeaderItem.h"
@interface GoodsOperationList ()<LSFooterViewDelegate,ISearchBarEvent,UITableViewDataSource,UITableViewDelegate ,LSScanViewDelegate>
@property (strong, nonatomic) SearchBar *searchBar;
@property (strong, nonatomic) UITableView *tableView;
/**页面标题*/
@property (nonatomic, copy) NSString *title1;
/**精确查询的code*/
@property (nonatomic, copy) NSString *scanCode;
/**输入框输入的码*/
@property (nonatomic, copy) NSString *inputCode;
/**分页标志*/
@property (nonatomic, assign) NSInteger currentPage;
/**网络请求的参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/**网络请求*/
@property (nonatomic, strong) GoodsService *service;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *datas;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;

@end

@implementation GoodsOperationList

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title1 = title;
        self.service = [ServiceFactory shareInstance].goodsService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    [self initNavigate];
    [self configViews];
    [self initSearchBar];
    [self inittableView];
    [self loadData];
}

#pragma mark - 导航栏
//初始化导航栏
- (void)initNavigate {
    [self configTitle:self.title1 leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)configViews {
    CGFloat y = kNavH;
    self.searchBar = [SearchBar searchBar];
    self.searchBar.frame = CGRectMake(0, y, SCREEN_W, 44);
    [self.view addSubview:self.searchBar];
    
    y = self.searchBar.ls_bottom;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootScan, kFootAdd]];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self showScanView];
    } else if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    }
}


#pragma mark - 搜索框
//初始化搜索框
- (void)initSearchBar {
    [self.searchBar initDeleagte:self placeholder:@"条形码/简码/拼音码"];
}

// 输入完成
- (void)imputFinish:(NSString *)keyWord {
    self.inputCode = keyWord;
    [self loadData];
    self.inputCode = nil;
}


#pragma mark - 条形码扫描
// ISearchBarEvent 代理
- (void)scanStart {
    [self showScanView];
}

- (void)showScanView {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.scanCode = scanString;
    self.searchBar.keyWordTxt.text = scanString;
    [self loadData];
    self.scanCode = nil;
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}



//底部的扫一扫点击事件
- (void)showScanEvent {
    [self showScanView];
}

//底部的添加点击事件
- (void)showAddEvent {
//    UIViewController *vc = [[GoodsSplitView alloc] initWithNibName:[SystemUtil getXibName:@"GoodsSplitView"] bundle:nil action:ActionAddEvent title:self.title1 goodsId:nil];
    GoodsSplitView *vc = [[GoodsSplitView alloc] init];
    vc.action = ActionAddEvent;
    vc.title1 = [NSString stringWithFormat:@"%@规则",self.title1];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

#pragma mark - 表格
- (void)inittableView {
    _tableView.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    _tableView.rowHeight = 88.0f;
    _tableView.sectionHeaderHeight = 44.0f;
    __weak typeof(self) weakSelf = self;
    [self.tableView ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
        
    }];
    [self.tableView ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
        
    }];
}
#pragma mark - 网络请求
//加载数据
- (void)loadData {
    NSString *url = nil;
    if ([self.title1 isEqualToString:@"商品拆分"]) {
        [self configHelpButton:HELP_GOODS_SPLIT];
        url = @"split/list";
    }
    if ([self.title1 isEqualToString:@"商品组装"]) {
        [self configHelpButton:HELP_GOODS_ASSEMBLE];
        url = @"assemble/list";
    }
    if ([self.title1 isEqualToString:@"商品加工管理"]) {
        [self configHelpButton:HELP_GOODS_MACHINING];
        url = @"processing/list";
    }
    __weak typeof(self) weakSelf = self;
    [self.service getGoodsInfo:url param:self.param completionHandler:^(id json) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (weakSelf.currentPage == 1) {
            [weakSelf.datas removeAllObjects];
        }
        if ([ObjectUtil isNotNull:json]) {
            NSArray *goodsHandleList = [json objectForKey:@"goodsHandleList"];
            if ([ObjectUtil isNotNull:goodsHandleList]) {
                for (NSDictionary *obj in goodsHandleList) {
                    GoodsOperationVo *vo = [[GoodsOperationVo alloc] initWithDictionary:obj];
                    [weakSelf.datas addObject:vo];
                }
            }
        }
        [weakSelf.tableView reloadData];
         weakSelf.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
}

//数据源
- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}
//网络请求的参数
-(NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    if ([NSString isNotBlank:self.searchBar.keyWordTxt.text]) {
        [_param setValue:self.searchBar.keyWordTxt.text forKey:@"searchCode"];
    }
    if ([NSString isNotBlank:self.scanCode]) {
        [_param setValue:self.scanCode forKey:@"barCode"];
    }
    [_param setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPage"];
    return _param;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommonGoodsSelectCell *cell = [CommonGoodsSelectCell commonGoodsSelectCellWith:tableView];
    [cell fillGoodsOperationVo:self.datas[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderItem *item = [HeaderItem headerItem];
    NSString *title = @"";
    if ([self.title1 containsString:@"商品加工"]) {
        title = @"商品加工规则";
    } else {
        title = [NSString stringWithFormat:@"%@规则",self.title1];
    }
    [item initWithName:title];
    return item;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsOperationVo *item = [self.datas objectAtIndex:indexPath.row];
//    UIViewController *vc = [[GoodsSplitView alloc] initWithNibName:[SystemUtil getXibName:@"GoodsSplitView"] bundle:nil action:ActionEditEvent title:self.title1 goodsId:item.goodsId];
    GoodsSplitView *vc = [[GoodsSplitView alloc] init];
    vc.action = ActionEditEvent;
    vc.title1 = [NSString stringWithFormat:@"%@规则",self.title1];
    vc.goodsId = item.goodsId;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

@end
