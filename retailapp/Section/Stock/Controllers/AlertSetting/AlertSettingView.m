//
//  StockQueryView.m
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertSettingView.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "LSEditItemList.h"
#import "UIHelper.h"
#import "SelectShopStoreListView.h"
#import "SearchBar.h"
#import "ScanViewController.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SearchBar2.h"
#import "Platform.h"
#import "MJRefresh.h"
#import "StockInfoVo.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "KindMenuView.h"
#import "TreeNode.h"
#import "JsonHelper.h"
#import "LSGoodsListViewController.h"
#import "AlertSettingCell.h"
#import "GoodsCategoryListView.h"
#import "AlertSettingDetail.h"
#import "AlertBox.h"
#import "GoodsVo.h"
#import "AlertSettingBatch.h"
#import "GoodsChoiceView.h"
#import "LSFooterView.h"
#import "IEditItemListEvent.h"
#import "SingleCheckHandle.h"
#import "ISearchBarEvent.h"

@interface AlertSettingView () <LSFooterViewDelegate,IEditItemListEvent,UITableViewDataSource,UITableViewDelegate,SingleCheckHandle,LSScanViewDelegate,ISearchBarEvent> {
    /**网络请求*/
    StockService *service;
    /**请求分类的网络请求*/
    //    GoodsService *categoryService;
}


/**搜索框*/
@property (strong, nonatomic) SearchBar *searchBar;
@property (strong, nonatomic) LSFooterView *footView;
/**门店/仓库*/
@property (strong, nonatomic) LSEditItemList *lstShop;

/**点击分类弹出的分类页面*/
@property (nonatomic, strong) KindMenuView *kindMenuView;
/**请求参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/**详情页参数*/
@property (nonatomic, strong) NSMutableDictionary *paramDetail;
/**分类列表*/
@property (nonatomic,retain) NSMutableArray* categoryList;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *alertSettingVos;
/**分类Id*/
@property (nonatomic, copy) NSString *categoryId;
/**条形码code*/
@property (nonatomic, copy) NSString *code;
@end

@implementation AlertSettingView


- (void)viewDidLoad {
    [super viewDidLoad];
    service = [ServiceFactory shareInstance].stockService;
    [self initNavigate];
    [self configViews];
    if ([[Platform Instance] getShopMode] != 3) {
        [self loadData];
    }
    [self loadSelectCategory];
    [self configHelpButton:HELP_STOCK_ALERT_SETTING];
    
    
}

#pragma mark - 初始化导航栏
- (void)initNavigate {
    [self configTitle:@"提醒设置" leftPath:Head_ICON_BACK rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
}

#pragma mark - 导航栏点击事件
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
   
    if (event == LSNavigationBarButtonDirectLeft) {
        [self popToLatestViewController:kCATransitionFromLeft];
    } else {
        [self showKindMenuView];
    }
}

- (void)configViews {
    CGFloat y = kNavH;
    if ([[Platform Instance] getShopMode] == 3) {
        self.lstShop = [LSEditItemList editItemList];
        self.lstShop.ls_top = y;
        self.lstShop.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [self.lstShop initLabel:@"门店" withHit:nil delegate:self];
         [self.lstShop initData:@"请选择" withVal:@""];
        self.lstShop.imgMore.image = [UIImage imageNamed:@"ico_next"];
        [self.view addSubview:self.lstShop];
        y = self.lstShop.ls_bottom;
    }
    
    self.searchBar = [SearchBar searchBar];
    self.searchBar.ls_top = y;
    [self.searchBar initDeleagte:self placeholder:@"条形码/简码/拼音码"];
    [self.view addSubview:self.searchBar];
    y = self.searchBar.ls_bottom;
    
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.ls_width, self.view.ls_height - y)];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    __weak typeof(self) weakself = self;
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    [self.mainGrid registerNib:[UINib nibWithNibName:@"AlertSettingCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.mainGrid.rowHeight = 88;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakself.currentPage = 1;
        [weakself loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        weakself.currentPage ++;
        [weakself loadData];
    }];
    [self.view addSubview:self.mainGrid];
    
    self.footView = [LSFooterView footerView];
    self.footView.ls_bottom = SCREEN_H;
    [self.footView initDelegate:self btnsArray:@[kFootScan, kFootAdd]];
    [self.view addSubview:self.footView];
    self.alertSettingVos= [[NSMutableArray alloc] init];
    self.currentPage = 1;
}

#pragma mark - 显示分类页面
- (void)showKindMenuView {
    self.kindMenuView.view.hidden = NO;
}

#pragma mark - 初始化分类页面
- (KindMenuView *)kindMenuView {
    if (_kindMenuView == nil) {
        _kindMenuView = [[KindMenuView alloc] init];
        _kindMenuView.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [self.view addSubview:_kindMenuView.view];
        [_kindMenuView initDelegate:self event:0 isShowManagerBtn:YES];
    }
    [_kindMenuView loadData:nil nodes:nil endNodes:self.categoryList];
    return _kindMenuView;
}

#pragma mark - SingleCheckHandle
// 点击导航栏"分类"按钮出现的右侧边栏列表项
- (void)singleCheck:(NSInteger)event item:(id<INameItem>)item {
    self.searchBar.keyWordTxt.text = @"";
    self.code = @"";
    self.kindMenuView.view.hidden = YES;
    self.currentPage = 1;
    TreeNode* node=(TreeNode*)item;
    self.categoryId = node.itemId;
    [self loadData];
}

// 点击导航栏"分类"按钮出现的右侧边栏右上"分类管理"
- (void)closeSingleView:(NSInteger)event {
    GoodsCategoryListView *vc = [[GoodsCategoryListView alloc] initWithTag:STOCK_ALERT_SETTING_VIEW];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}

#pragma mark - EditItemList点击事件
// 选择门店/仓库
- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == self.lstShop) {
        SelectShopStoreListView *vc= [[SelectShopStoreListView alloc] init];
        //只查询门店不包括仓库
        vc.onlyShop = YES;
        [self.navigationController pushViewController:vc animated:NO];
        __weak typeof(self) weakself = self;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [vc loadData:[[Platform Instance] getkey:ORG_ID] checkMode:SINGLE_CHECK isPush:YES callBack:^(id<INameCode> item) {
            [XHAnimalUtil animal:weakself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakself.navigationController popViewControllerAnimated:NO];
            if (item) {
               [weakself.lstShop initData:[item obtainItemName] withVal:[item obtainItemId]];
                [weakself.mainGrid headerBeginRefreshing];
            }
        }];
    }
}

#pragma mark - 加载数据
- (void)loadData {
    if ([self.lstShop.lblVal.text isEqualToString:@"请选择"])
    {
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
        [AlertBox show:@"请选择门店"];
        return;
    }
    __weak typeof(self) weakself = self;
    [service alertList:self.param CompletionHandler:^(id json) {
        [weakself.mainGrid headerEndRefreshing];
        [weakself.mainGrid footerEndRefreshing];
        if (weakself.currentPage == 1) {
            [weakself.alertSettingVos removeAllObjects];
        }
        for (NSDictionary *dict in json[@"goodsList"]) {
            GoodsVo *obj = [GoodsVo convertToGoodsVo:dict];
            [weakself.alertSettingVos addObject:obj];
        }
        [weakself.mainGrid reloadData];
         weakself.mainGrid.ls_show = YES;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 加载分类列表
- (void)loadSelectCategory {

    [[ServiceFactory shareInstance].commonService selectGoodsLastCategoryInfo:@"" completionHandler:^(id json) {
       
         NSMutableArray* list = [JsonHelper transList:[json objectForKey:@"categoryList"] objName:@"CategoryVo"];
        self.categoryList = [[NSMutableArray alloc] init];
        for (CategoryVo* vo in list) {
            TreeNode *vo1 = [[TreeNode alloc] init];
            vo1.itemName = vo.name;
            vo1.itemId = vo.categoryId;
            [self.categoryList addObject:vo1];
        }

    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 请求数据的参数
- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    if ([[Platform Instance] getShopMode] == 3) {
        [_param setValue:[self.lstShop getStrVal] forKey:@"shopId"];
    } else {
        [_param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    }
    
    if ([NSString isNotBlank:self.code]) {
        [_param setValue:self.code forKey:@"searchCode"];
    }
    if ([NSString isNotBlank:self.searchBar.keyWordTxt.text]) {
        [_param setValue:self.searchBar.keyWordTxt.text forKey:@"searchCode"];
    }
    [_param setValue:[NSNumber numberWithInt:self.currentPage] forKey:@"currentPage"];
    [_param setValue:@"1" forKey:@"showIsSetAlert"];
    if ([NSString isNotBlank:self.categoryId]) {
        if (![self.categoryId isEqualToString:@"noCategory"]) {
           [_param setValue:self.categoryId forKey:@"categoryId"];
        }
        [_param setValue:self.categoryId forKey:@"categoryFlg"];
        self.categoryId = nil;
    }
    return _param;
}
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootScan]) {
        [self showScanEvent];
    }
}
#pragma mark - 条形码扫描
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
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
    self.code = scanString;
    self.categoryId = @"";
    self.currentPage = 1;
    [self loadData];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}


#pragma mark - 点击添加事件
- (void)showAddEvent {
    if ([[self.lstShop getDataLabel] isEqualToString:@"请选择"]) {
        [AlertBox show:@"请选择门店"];
        return;
    }
    GoodsChoiceView *vc = [[GoodsChoiceView alloc]init];
    vc.searchType = @"1";
    NSString *shopId = [[Platform Instance] getShopMode] == 3 ? [self.lstShop getStrVal] : [[Platform Instance] getkey:SHOP_ID];
    [vc loaddatas:shopId callBack:^(NSMutableArray *goodList) {
        if (goodList == nil) {
            [self loadData];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            [self.navigationController popViewControllerAnimated:NO];
            
        }
        if (goodList.count == 1) {
            AlertSettingDetail *vc = [[AlertSettingDetail alloc] init];
            [self.navigationController pushViewController:vc animated:NO];
            GoodsVo *goodsVo = goodList[0];
            vc.obj = goodsVo;
            if ([[Platform Instance] getShopMode] == 3) {
                vc.shopId = [self.lstShop getStrVal];
            } else {
                vc.shopId = [[Platform Instance] getkey:SHOP_ID];
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
        if (goodList.count > 1) {
            AlertSettingBatch *vc = [[AlertSettingBatch alloc] init];
            [self.navigationController pushViewController:vc animated:NO];
            vc.goodsVos = goodList;
            if ([[Platform Instance] getShopMode] == 3) {
                vc.shopId = [self.lstShop getStrVal];
            } else {
                vc.shopId = [[Platform Instance] getkey:SHOP_ID];
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
    }];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}



#pragma mark - 输入框输入完成
- (void)imputFinish:(NSString *)keyWord {
    self.currentPage = 1;
    self.categoryId = @"";
    self.code = @"";
    [self loadData];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       return self.alertSettingVos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    AlertSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.obj = self.alertSettingVos[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AlertSettingDetail *vc = [[AlertSettingDetail alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    vc.obj = self.alertSettingVos[indexPath.row];
    if ([[Platform Instance] getShopMode] == 3) {
        vc.shopId = [self.lstShop getStrVal];
    } else {
        vc.shopId = [[Platform Instance] getkey:SHOP_ID];
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];

}
@end
