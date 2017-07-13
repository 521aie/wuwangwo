//
//  LSWechatHomeSetGoodListViewController.m
//  retailapp
//
//  Created by guozhi on 16/8/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSWechatHomeSetGoodListViewController.h"
#import "CategoryVo.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "SearchBar.h"
#import "GoodsVo.h"
#import "ViewFactory.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "GoodsModuleEvent.h"
#import "ShopVo.h"
#import "XHAnimalUtil.h"
#import "Platform.h"
#import "CategoryVo.h"
#import "JsonHelper.h"
#import "TreeNode.h"
#import "KindMenuView.h"
#import "GoodsCategoryListView.h"
#import "KindMenuView.h"
#import "Wechat_MircoGoodsVo.h"
#import "ScanViewController.h"
#import "MicroWechatGoodsVo.h"
#import "LSWechatGoodCell.h"
#import "MJExtension.h"
#import "LSSearchBar.h"
#import "WechatGoodsTopSelectView.h"
#import "LSWechatHomeSetGoodCell.h"

@interface LSWechatHomeSetGoodListViewController ()<LSScanViewDelegate, LSScanViewDelegate, INavigateEvent, ISearchBarEvent, IEditItemListEvent, SingleCheckHandle, LSSearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NavigateTitle2 *titleBox;
@property (nonatomic, strong) LSSearchBar *searchBar;
@property (nonatomic, strong) GoodsVo *goodsVo;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic,strong) NSMutableArray* categoryList;

/**
 *  请求参数
 */
@property (nonatomic, strong) NSMutableDictionary *param;


@property (nonatomic , strong) WechatService *wechatService;
@property (nonatomic , strong) MicroWechatGoodsVo* tempVo;
//微店商品管理 筛选页面
@property (nonatomic, strong)WechatGoodsTopSelectView *wechatGoodsTopSelectView;
@property (nonatomic,strong ) KindMenuView *kindMenuView;


@end

@implementation LSWechatHomeSetGoodListViewController
- (instancetype)initWithBlock:(CallBlock)callBlock {
    if (self = [super init]) {
        self.callBlock = callBlock;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self selectCategory];
    [self selectMicGoodsList];
    [self configHelpButton:HELP_WECHAT_HOME_SETTING];
}


#pragma mark - 网络请求

#pragma mark 请求微店商品列表
- (void)selectMicGoodsList {
    __weak typeof(self) wself = self;
    NSString *url = @"microGoods/list";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.createTime == 0) {
            [wself.datas removeAllObjects];
        }
        if ([ObjectUtil isNotNull:json[@"goodsVoList"]]){
            NSMutableArray *goodsVoList = [MicroWechatGoodsVo mj_objectArrayWithKeyValuesArray:json[@"goodsVoList"]];
            [wself.datas addObjectsFromArray:goodsVoList];
        }
        if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
            wself.createTime = [[json objectForKey:@"createTime"] longLongValue];
        }
        [wself.tableView reloadData];
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
    
}

#pragma mark 请求微店商品分类
- (void)selectCategory
{
    NSString *url = @"category/lastCategoryInfo";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:@"true" forKey:@"hasNoCategory"];
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        NSMutableArray *categoryList = json[@"categoryList"];
        if ([ObjectUtil isNotNull:categoryList]) {
            NSMutableArray *list = [CategoryVo mj_objectArrayWithKeyValuesArray:categoryList];
            wself.categoryList = [[NSMutableArray alloc] init];
            TreeNode *item = [[TreeNode alloc] init];
            item.itemName = @"全部";
            item.itemId = @"";
            [wself.categoryList addObject:item];
            for (CategoryVo* vo in list) {
                item = [[TreeNode alloc] init];
                item.itemName = vo.microname;
                item.itemId = vo.categoryId;
                [wself.categoryList addObject:item];
            }
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


#pragma mark 显示分类管理页面
- (void)showKindMenuView {
    self.kindMenuView = [[KindMenuView alloc] init];
    self.kindMenuView.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self.view addSubview:self.kindMenuView.view];
    [self.kindMenuView showMoveIn];
    [self.kindMenuView initDelegate:self event:0 isShowManagerBtn:YES];
    [self.kindMenuView loadData:nil nodes:nil endNodes:self.categoryList];
}

#pragma mark - 代理事件

#pragma mark 导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self showKindMenuView];
    }
}



#pragma mark 点击分类管理的某一类
- (void)singleCheck:(NSInteger)event item:(id<INameItem>)item {
    
    TreeNode *node = (TreeNode *)item;
    //WechatGoodManagementListView *wechatGoodsManagementListView = [[WechatGoodManagementListView alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodManagementListView"] bundle:nil ];
    //[self.view addSubview:wechatGoodsManagementListView.view];
    if ([node.itemId isEqualToString:@"noCategory"]) {
        node.itemId = @"0";
    }
    self.categoryId = node.itemId;
    self.searchType = 2;
    //清掉原有数据 seaechCode只有搜索框输入才有值
    self.searchCode = @"";
    //输入框清空
    //    self.goodsSearchBarView.keyWordTxt.text = @"";
    //第一页开始请求
    self.createTime = 0;
    [self selectMicGoodsList];
    
}


#pragma mark 搜索框搜索事件
- (void)searchBarImputFinish:(NSString *)keyWord {
    self.searchCode = keyWord;
    self.scanCode = @"";
    self.searchType = 1;
    self.createTime = 0;
    [self selectMicGoodsList];
}

- (void)searchBarScanStart {
    [self showScanView];
}
- (void)showScanView {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma mark LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.scanCode = scanString;
    self.searchType = 1;
    self.searchCode = @"";
    self.createTime = 0;
    self.searchBar.txtField.text = self.scanCode;
    [self selectMicGoodsList];
    self.searchCode = @"";
    
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWechatHomeSetGoodCell*cell = [LSWechatHomeSetGoodCell wechatGoodCellAtTableView:tableView];
    MicroWechatGoodsVo *goodsVo = [self.datas objectAtIndex:indexPath.row];
    cell.goodsVo = goodsVo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MicroWechatGoodsVo *goodsVo = [self.datas objectAtIndex:indexPath.row];
    if (self.callBlock) {
        self.callBlock(goodsVo);
    }
    
}

#pragma mark - 初始化布局
- (void)setup {
    self.shopId = [[Platform Instance] getkey:SHOP_ID];
    //设置导航栏
    CGFloat y = 0;
    self.titleBox.ls_top = 0;
    //设置搜索框
    y = y + self.titleBox.ls_height;
    self.searchBar.ls_top = y;
    //设置商品总数
    y = y + self.searchBar.ls_height;
    CGFloat h = self.view.ls_height - self.searchBar.ls_bottom;
    self.tableView.frame = CGRectMake(0, y, self.view.ls_width, h);
    
}
#pragma mark - setter ang getter

//设置标题
- (NavigateTitle2 *)titleBox {
    if (!_titleBox) {
        _titleBox=[NavigateTitle2 navigateTitle:self];
        [_titleBox initWithName:@"微店商品" backImg:Head_ICON_BACK moreImg:Head_ICON_CATE];
        _titleBox.lblRight.text = @"分类";
        [self.view addSubview:_titleBox];
    }
    return _titleBox;
}

//设置搜索框
- (LSSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [LSSearchBar searchBar];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"条形码/简码/拼音码";
        if ([NSString isNotBlank:self.searchCode]) {
            _searchBar.txtField.text = self.searchCode;
        }
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}


// 请求参数
- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    //搜索类型
    [_param setValue:@(self.searchType) forKey:@"searchType"];
    //扫码关键字
    if ([NSString isNotBlank:self.scanCode]) {
        [_param setValue:self.scanCode forKey:@"barcode"];
    }
    //搜索关键字
    if ([NSString isNotBlank:self.searchBar.txtField.text]) {
        [_param setValue:self.searchBar.txtField.text forKey:@"searchCode"];
    }
    //分类id
    if ([NSString isNotBlank:self.categoryId]) {
        [_param setValue:self.categoryId forKey:@"categoryId"];
    }
    //分页时间
    if (self.createTime != 0) {
        [_param setValue:@(self.createTime) forKey:@"createTime"];
    }
    //查询门店
    [_param setValue:self.shopId forKey:@"shopId"];
    return _param;
}
//设置表格
- (UITableView *)tableView {
    if (!_tableView) {
        __weak typeof(self) wself = self;
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 88.0f;
        UIView* view=[ViewFactory generateFooter:60];
        view.backgroundColor=[UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:view];
        [self.view addSubview:_tableView];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [wself.tableView ls_addHeaderWithCallback:^{
            wself.createTime = 0;
            [wself selectMicGoodsList];
        }];
        [wself.tableView ls_addFooterWithCallback:^{
            [wself selectMicGoodsList];
        }];
    }
    return _tableView;
}
//微店商品数据源
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

@end
