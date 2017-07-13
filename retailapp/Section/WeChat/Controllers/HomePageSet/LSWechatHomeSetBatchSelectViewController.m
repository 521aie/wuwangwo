//
//  LSWechatHomeSetBatchSelectViewController.m
//  retailapp
//
//  Created by guozhi on 16/9/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSWechatHomeSetBatchSelectViewController.h"
#import "NavigateTitle2.h"
#import "ObjectUtil.h"
#import "ViewFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "TreeNode.h"
#import "MicroWechatGoodsVo.h"
#import "XHAnimalUtil.h"
#import "GoodsBatchChoiceCell.h"
#import "LSSearchBar.h"
#import "LSFooterView.h"
#import "ScanViewController.h"
#import "LSWechatGoodListViewController.h"
#import "WeChatWeShopPriceSet.h"
#import "CategoryVo.h"
#import "MJExtension.h"
#import "KindMenuView.h"

@interface LSWechatHomeSetBatchSelectViewController ()<INavigateEvent,UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate, LSSearchBarDelegate, LSFooterViewDelegate, LSScanViewDelegate, SingleCheckHandle>
/**
 *  标题
 */
@property (nonatomic, strong) NavigateTitle2 *titleBox;
/**
 *  表格
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  搜索框
 */
@property (strong, nonatomic)  LSSearchBar *searchBar;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *datas;
/**
 *  底部全选全不选
 */
@property (nonatomic, strong) LSFooterView *footerView;
@property (nonatomic, strong) MicroWechatGoodsVo *goodsVo;
/**
 *  扫码获得的内容
 */
@property (nonatomic, copy) NSString *scanCode;
/**
 *  分页时间 默认手机0
 */
@property (nonatomic, assign) long long createTime;
/**
 *  获得微店商品列表数据参数
 */
@property (nonatomic, strong) NSMutableDictionary *param;
/**
 *  选中的微店商品goodsId列表
 */
@property (nonatomic, strong) NSMutableArray *goodsIdList;

@property (nonatomic,strong) NSMutableArray* categoryList;
@property (nonatomic,strong ) KindMenuView *kindMenuView;

@end

@implementation LSWechatHomeSetBatchSelectViewController
- (instancetype)initWithBlock:(WechatGoodsList )callBack {
    if (self = [super init]) {
        self.callBack = callBack;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self selectMicGoodsList];
    [self selectCategory];
    [self configHelpButton:HELP_WECHAT_HOME_SETTING];
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        NSString *rightTitle = self.titleBox.lblRight.text;
        if ([rightTitle isEqualToString:@"分类"]) {
             [self showKindMenuView];
        } else if ([rightTitle isEqualToString:@"确认"]) {
            NSMutableArray *wechatGoodsList = [NSMutableArray array];
            for (MicroWechatGoodsVo *wechatGoodVo in self.datas) {
                if ([wechatGoodVo.isCheck isEqualToString:@"1"]) {
                    [wechatGoodsList addObject:wechatGoodVo];
                }
            }
            if (self.callBack) {
                self.callBack(wechatGoodsList);
            }
        }
        
    }
}

#pragma mark 显示分类管理页面
- (void)showKindMenuView {
    self.kindMenuView = [[KindMenuView alloc] init];
    self.kindMenuView.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self.view addSubview:self.kindMenuView.view];
    [self.kindMenuView showMoveIn];
    [self.kindMenuView initDelegate:self event:0 isShowManagerBtn:NO];
    [self.kindMenuView loadData:nil nodes:nil endNodes:self.categoryList];
}
#pragma mark 点击分类管理的某一类
- (void)singleCheck:(NSInteger)event item:(id<INameItem>)item {
    
    TreeNode *node = (TreeNode *)item;
    if ([node.itemId isEqualToString:@"noCategory"]) {
        node.itemId = @"0";
    }
    self.categoryId = node.itemId;
    self.searchType = 2;
    //清掉原有数据 seaechCode只有搜索框输入才有值
    self.searchCode = @"";
    self.createTime = 0;
    [self selectMicGoodsList];
    
}
#pragma mark - 网络请求
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


#pragma mark - 代理事件

#pragma mark 搜索框搜索事件
- (void)searchBarImputFinish:(NSString *)keyWord {
    self.searchCode = keyWord;
    self.searchType = 1;
    self.createTime = 0;
    [self selectMicGoodsList];
}

- (void)searchBarScanStart {
    [self showScanView];
}

#pragma mark - 页面切换
#pragma mark 前往微店商品列表
- (void)gotoWechatGoodsListViewController {
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LSWechatGoodListViewController class]]) {
            LSWechatGoodListViewController *vc = (LSWechatGoodListViewController *)obj;
            vc.createTime = 0;
            vc.searchCode = @"";
            [vc selectMicGoodsList];
        }
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark 底部工具栏点击事件
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    self.searchBar.txtField.text = @"";
    if ([footerType isEqualToString:kFootSelectAll]) {
        [self changeStatus:@"1"];
    } else if ([footerType isEqualToString:kFootSelectNo]) {
        [self changeStatus:@"0"];
    }
    [self updateNavigateRightTitle];
}

//0是全不选 1是全选
- (void)changeStatus:(NSString *)status {
    if (self.datas.count > 0) {
        for (MicroWechatGoodsVo *vo in self.datas) {
            vo.isCheck = status;
        }
    }
    [self.tableView reloadData];
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
    self.searchBar.txtField.text = scanString;
    self.searchBar.searchCode = self.scanCode;
    [self selectMicGoodsList];
    self.searchCode = @"";
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

#pragma UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsBatchChoiceCell *cell = [GoodsBatchChoiceCell goodsBatchChoiceCellWithTableView:tableView];
    MicroWechatGoodsVo *wechatGoodsVo = [self.datas objectAtIndex:indexPath.row];
    cell.wechatGoodsVo = wechatGoodsVo;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MicroWechatGoodsVo *vo = [self.datas objectAtIndex:indexPath.row];
    if ([vo.isCheck isEqualToString:@"1"]) {
        vo.isCheck = @"0";
    }else{
        vo.isCheck = @"1";
    }
    [self updateNavigateRightTitle];
    [self.tableView reloadData];
}

#pragma mark 更新导航右侧标题
- (void)updateNavigateRightTitle {
    BOOL isCheck = NO;
    for (MicroWechatGoodsVo *wechatGoodVo in self.datas) {
        if ([wechatGoodVo.isCheck isEqualToString:@"1"]) {
            isCheck = YES;
        }
    }
    if (isCheck) {
        [self.titleBox initWithName:@"选择商品" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        self.titleBox.lblRight.text = @"确认";
    } else {
        [_titleBox initWithName:@"选择微店商品" backImg:Head_ICON_CANCEL moreImg:Head_ICON_CATE];
        _titleBox.lblRight.text = @"分类";
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
    //设置微店商品列表
    y = y + self.searchBar.ls_height;
    CGFloat h = self.view.ls_height - self.searchBar.ls_bottom;
    self.tableView.frame = CGRectMake(0, y, self.view.ls_width, h);
    //设置底部工具栏
    self.footerView.ls_bottom = self.view.ls_height;
}
#pragma mark - setter ang getter

//设置标题
- (NavigateTitle2 *)titleBox {
    if (!_titleBox) {
        _titleBox=[NavigateTitle2 navigateTitle:self];
        [_titleBox initWithName:@"选择微店商品" backImg:Head_ICON_CANCEL moreImg:Head_ICON_CATE];
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
        [self.view addSubview:_searchBar];
        if ([NSString isNotBlank:self.searchCode]) {
            _searchBar.txtField.text = self.searchCode;
        }
    }
    return _searchBar;
}



//设置底部工具栏
- (LSFooterView *)footerView {
    if (!_footerView) {
        _footerView = [LSFooterView footerView];
        [_footerView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
        [self.view addSubview:_footerView];
    }
    return _footerView;
}

// 请求参数
- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    //搜索类型
    [_param setValue:@(self.searchType) forKey:@"searchType"];
    //搜索关键字
    if ([NSString isNotBlank:self.searchCode]) {
        [_param setValue:self.searchCode forKey:@"searchCode"];
    }
    //扫码关键字
    if ([NSString isNotBlank:self.scanCode]) {
        [_param setValue:self.scanCode forKey:@"barcode"];
    }
    //分类id
    if ([NSString isNotBlank:self.categoryId]) {
        [_param setValue:self.categoryId forKey:@"categoryId"];
    }
    //分页时间
    if (self.createTime != 0) {
        [_param setValue:@(self.createTime) forKey:@"createTime"];
    }
     [_param setValue:@(self.searchType) forKey:@"searchType"];
    
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
        UIView* view=[ViewFactory generateFooter:60];
        view.backgroundColor=[UIColor clearColor];
        _tableView.rowHeight = 64.0f;
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
//微店商品goodsIdList初始化
- (NSMutableArray *)goodsIdList {
    if (_goodsIdList == nil) {
        _goodsIdList = [NSMutableArray array];
    }
    return _goodsIdList;
}



@end
