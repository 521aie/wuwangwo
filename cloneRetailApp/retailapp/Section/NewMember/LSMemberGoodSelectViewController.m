//
//  LSMemberGoodSelectViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberGoodSelectViewController.h"
#import "LSMemberGoodDetailViewController.h"
#import "ScanViewController.h"
#import "NavigateTitle2.h"
#import "SearchBar.h"
#import "SearchBar3.h"
#import "KxMenu.h"
#import "LSFooterView.h"
//#import "GoodsChoiceCell.h"
#import "LSMemberGoodCell.h"
#import "LSAlertHelper.h"
#import "ServiceFactory.h"
//#import "GoodsVo.h"
//#import "StyleGoodsVo.h"
#import "GoodsGiftListVo.h"
#import "GoodsSkuVo.h"
#import "MyUILabel.h"

//static NSString *noGoodGiftCellId = @"noGoodGiftCellId";
@interface LSMemberGoodSelectViewController ()<INavigateEvent, ISearchBarEvent ,LSFooterViewDelegate ,LSScanViewDelegate ,UITableViewDelegate, UITableViewDataSource> {
    
    BOOL isCloth;
}
@property (nonatomic, strong) GoodsService *goodsService;
@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) SearchBar3 *searchBar1;/*<服鞋搜索框>*/
@property (nonatomic ,strong) SearchBar *searchBar2;/*<商超搜索框>*/
@property (nonatomic ,strong) LSFooterView *footerView;/*<>*/
@property (nonatomic ,strong) UITableView *tableView;/*<>*/
@property (nonatomic ,strong) NSMutableArray *dataArray;/*<>*/
@property (nonatomic ,assign) NSInteger currentPage ;/*<当前页>*/
@property (nonatomic ,strong) NSArray *searchTypeItems;/*<searchType 数组>*/
@property (nonatomic ,strong) NSString *searchType;/*<搜索类型>*/
@property (nonatomic, strong) NSString *keyWords;/**<搜索关键词>*/
@end

@implementation LSMemberGoodSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isCloth = [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101;
    self.goodsService = [ServiceFactory shareInstance].goodsService;
    self.dataArray = [[NSMutableArray alloc] init];
    self.searchType = @"店内码";
    self.keyWords = @"";
    [self configSubViews];
    [self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)configSubViews {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"选择商品" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
  
    // searchBar
    if (isCloth) {
        self.searchBar1 = [SearchBar3 searchBar3];
        self.searchBar1.ls_top = self.titleBox.ls_bottom;
        [self.searchBar1 showCondition:YES];
        [self.searchBar1 initDeleagte:self withName:@"店内码" placeholder:@""];
        [self.view addSubview:self.searchBar1];
    } else  { //商超
        self.searchBar2 = [SearchBar searchBar];
        self.searchBar2.ls_top = self.titleBox.ls_bottom;
        [self.searchBar2 initDeleagte:self placeholder:@"条形码/简码/拼音码"];
        [self.view addSubview:self.searchBar2];
    }

    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_W, SCREEN_H-108) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 88.0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf getNotGiftGoodsList];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        weakSelf.currentPage += 1;
        [weakSelf getNotGiftGoodsList];
    }];
    
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootScan]];
    [self.view addSubview:self.footerView];
    self.footerView.ls_bottom = SCREEN_H;

}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self showScanEvent];
    }
}

- (NSArray *)searchTypeItems {
    if (!_searchTypeItems) {
        _searchTypeItems = @[
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
                                           action:@selector(pushMenuItem:)],
                             ];
    }
    return _searchTypeItems;
}


#pragma mark - 协议方法 
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

//  ISearchBarEvent, 弹出选择搜索类型选择类别
- (void)selectCondition {
    CGRect rect = CGRectMake(47, self.searchBar1.frame.origin.y, 80, 32);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:self.searchTypeItems];
}

// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord {
    self.keyWords = keyWord;
    [self getNotGiftGoodsList];
}

- (void)scanStart {
    [self showScanEvent];
}

- (void)pushMenuItem:(id)sender {
    
    KxMenuItem *item = (KxMenuItem *)sender;
    [self.searchBar1 changeLimitCondition:item.title];
    if ([item.title isEqualToString:@"款号"]) {
        //        self.searchType = @"1";
        self.searchType = @"款号";
    }
    else if ([item.title isEqualToString:@"条形码"]) {
        //        self.searchType = @"2";
        self.searchType = @"条形码";
    }
    else if ([item.title isEqualToString:@"店内码"]) {
        //        self.searchType = @"3";
        self.searchType = @"店内码";
    }
    else if ([item.title isEqualToString:@"拼音码"]) {
        //        self.searchType = @"4";
        self.searchType = @"拼音码";
    }
}

#pragma mark - FooterListEvent 

- (void)showScanEvent {
    self.currentPage = 1;
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self pushController:vc from:kCATransitionFromRight];
}

// LSScanViewDelegate
- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [LSAlertHelper showAlert:message block:nil];
}

- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {

    if ([NSString isNotBlank:scanString]) {
        if (self.searchBar1) {
            self.searchBar1.txtKeyWord.text = scanString;
        }
        else {
            self.searchBar2.keyWordTxt.text = scanString;
        }
        self.keyWords = scanString;
        [self getNotGiftGoodsList];
    }
}

#pragma mark - UITableView

- (void)endRefreshing {
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsGiftListVo *vo = self.dataArray[indexPath.row];
    LSMemberGoodCell *cell = [LSMemberGoodCell mb_goodCellWith:tableView optional:NO];
    [cell setGiftGoodVo:vo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self toGoodDetailPage:self.dataArray[indexPath.row]];
}

- (void)toGoodDetailPage:(GoodsGiftListVo *)vo {
    LSMemberGoodDetailViewController *vc = [[LSMemberGoodDetailViewController alloc]
                                            init:ACTION_CONSTANTS_ADD selectObj:vo];
    [self pushController:vc from:kCATransitionFromRight];
}

#pragma mark - 网络请求

// 获取未设置成为积分商品的商品列表
- (void)getNotGiftGoodsList {
    
    __weak typeof(self) weakSelf = self;
    [_goodsService selectNotGiftGoodsList:_keyWords searchType:self.searchType currentPage:weakSelf.currentPage
                        completionHandler:^(id json) {
        
        [weakSelf endRefreshing];
        NSArray *resultArr = json[@"goodsGiftList"];
        if ([ObjectUtil isNotEmpty:resultArr]) {
            
            NSArray *objects = [GoodsGiftListVo getGoodsGiftListVoArray:resultArr];
            if (weakSelf.currentPage == 1 || [NSString isNotBlank:_keyWords]) {
                [weakSelf.dataArray removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:objects];

        } else {
            
            if (weakSelf.currentPage > 1) {
                weakSelf.currentPage -= 1;
            }
        }
        [weakSelf.tableView reloadData];
        weakSelf.tableView.ls_show = YES;
        // 搜索情况只搜索到一个GoodsGiftListVo，直接跳转到详情页+
        if ([NSString isNotBlank:_keyWords] && weakSelf.dataArray.count == 1) {
            [weakSelf toGoodDetailPage:weakSelf.dataArray[0]];
        }
                            
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
        [weakSelf endRefreshing];
    }];
}

@end
