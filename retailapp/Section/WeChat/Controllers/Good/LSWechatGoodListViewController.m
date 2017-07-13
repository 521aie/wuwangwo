//
//  LSWechatGoodListViewController.m
//  retailapp
//
//  Created by guozhi on 16/8/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSWechatGoodListViewController.h"
#import "LSWechatModuleController.h"
#import "CategoryVo.h"
#import "EditItemList.h"
#import "FooterListView3.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "SearchBar.h"
#import "GoodsVo.h"
#import "LSGoodsListViewController.h"
#import "ViewFactory.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "GoodsModuleEvent.h"
#import "SelectOrgShopListView.h"
#import "ShopVo.h"
#import "XHAnimalUtil.h"
#import "Platform.h"
#import "CategoryVo.h"
#import "JsonHelper.h"
#import "TreeNode.h"
#import "KindMenuView.h"
#import "GoodsCategoryListView.h"
#import "GoodsFooterListView.h"
#import "KindMenuView.h"
#import "GoodsChoiceView.h"
#import "WechatGoodsTopSelectView.h"
#import "WechatGoodsDetailsView.h"
#import "Wechat_MircoGoodsVo.h"
#import "ScanViewController.h"
#import "MicroWechatGoodsVo.h"
#import "LSWechatGoodCell.h"
#import "MJExtension.h"
#import "LSSearchBar.h"
#import "LSFooterView.h"
#import "LSWechatGoodBatchSelectViewController.h"
#import "LSOneClickView.h"
#import "LSSelectCategoryListViewController.h"
#import "LSWechatGoodManageViewController.h"

@interface LSWechatGoodListViewController ()<LSScanViewDelegate, LSScanViewDelegate, FooterListEvent, INavigateEvent, ISearchBarEvent, IEditItemListEvent, SingleCheckHandle, LSSearchBarDelegate, LSFooterViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NavigateTitle2 *titleBox;
@property (nonatomic, strong) LSSearchBar *searchBar;
@property (nonatomic, strong) LSFooterView *footerView;
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

@implementation LSWechatGoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self selectCategory];
    [self selectMicGoodsList];
    [self configHelpButton:HELP_WECHAT_GOODS_INFO];
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
        //点击分类某一类查询
        if (self.searchType == 2) {
            if (wself.datas.count == 0) {
                 [AlertBox show:@"该分类下暂无商品！"];
            }
        } else if (wself.datas.count < 2 && [NSString isNotBlank:self.searchBar.txtField.text]) {//搜索框查询
            [wself remoteWithArray:wself.datas];
        }
        
        [wself.tableView reloadData];
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
    
}

/**
 按输入条件查询
 根据条件输入框内容进行相对应的在微店销售商品的前方精确查询。
 如果只查询出一条数据，页面跳转到微店商品详情页面。
 如果没有查询到数据，弹出“商品未在微店销售，确定要在微店设置销售吗？”
 点击确定按钮，如果查询商品在商品信息中存在且只有一条数据，直接进入微店商品详情页面；如果有多条数据，则进入选择商品共通页面。
 点击确定按钮，如果查询商品在商品信息中不存在，则弹出“未查询到商品，请先在商品管理里添加该商品！”
 */
- (void)remoteWithArray:(NSMutableArray *)goodsArray {
    //查出一条商品纪录
    if (goodsArray.count == 1) {
        MicroWechatGoodsVo* vo = [goodsArray objectAtIndex:0];
        [self gotoWechatGoodDetailWithShopId:self.shopId goodsId:vo.goodsId];
    }else if (goodsArray.count == 0){
        //未查出商品纪录
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该商品未在微店销售，确认要在微店设置销售吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectGoodsList];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/*
 点击确定按钮，如果查询商品在商品信息中存在且只有一条数据，直接进入微店商品详情页面；如果有多条数据，则进入选择商品共通页面
 */

#pragma mark 查询商品列表
- (void)selectGoodsList {
    NSString *url = @"goods/list";
    __weak typeof(self) wself = self;
    self.searchCode = self.scanCode;
    [self.view resignFirstResponder];
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray *goodsArray=[[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:json[@"goodsVoList"]]) {
            goodsArray = [GoodsVo mj_objectArrayWithKeyValuesArray:json[@"goodsVoList"]];
        }
        
        if (goodsArray.count == 1) {
            GoodsVo *vo=[goodsArray objectAtIndex:0];
            //一条数据进入微店商品详情
            [wself gotoWechatGoodDetailWithShopId:wself.shopId goodsId:vo.goodsId];
        }else if (goodsArray.count == 0){
            [AlertBox show:@"未查询到商品，请先在商品管理里添加该商品！"];
        }else{
            
            GoodsChoiceView *vc = [[GoodsChoiceView alloc]initWithNibName:[SystemUtil getXibName:@"GoodsChoiceView" ] bundle:nil];
            vc.searchType = @"1";
            vc.searchCode = self.searchBar.txtField.text;
            __weak typeof(self) wself = self;
            [vc loaddatas:self.shopId callBack:^(NSMutableArray *goodList) {
                if (nil==goodList) {
                    [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                    [wself.navigationController popViewControllerAnimated:NO];
                }else{
                    GoodsVo *vo=(GoodsVo *)[goodList objectAtIndex:0];
                    [wself gotoWechatGoodDetailWithShopId:wself.shopId goodsId:vo.goodsId];
                }
            }];
            [wself.navigationController pushViewController:vc animated:NO];
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
        
    } errorHandler:^(id json) {
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


#pragma mark - 页面切换
#pragma mark 前往微店商品详情页面
- (void)gotoWechatGoodDetailWithShopId:(NSString *)shopId goodsId:(NSString *)goodsId {
    WechatGoodsDetailsView *vc = [[WechatGoodsDetailsView alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodsDetailsView"] bundle:nil];
    vc.shopId = shopId;
    vc.goodsId = goodsId;
    vc.action = ACTION_CONSTANTS_EDIT;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
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

#pragma mark 添加商品
- (void)showAddEvent {
    GoodsChoiceView *vc = [[GoodsChoiceView alloc]init];
    vc.searchType = @"1";
    __weak typeof(self) wself = self;
    [vc loaddatas:self.shopId callBack:^(NSMutableArray *goodList) {
        if (nil ==  goodList) {
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popViewControllerAnimated:NO];
        }else if (goodList.count == 1){
            GoodsVo *vo=(GoodsVo *)[goodList objectAtIndex:0];
            [self gotoWechatGoodDetailWithShopId:self.shopId goodsId:vo.goodsId];
        } else if (goodList.count > 1) {
            
            NSMutableArray *goodIdList = [NSMutableArray array];
            for (GoodsVo *goodsVo in goodList) {
                [goodIdList addObject:goodsVo.goodsId];
            }
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setValue:goodIdList forKey:@"goodsIdList"];
            [param setValue:self.shopId forKey:@"shopId"];
            NSString *url = @"microGoods/saveBatch";//批量添加商品到微店
            [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
                [wself.tableView headerBeginRefreshing];//请求成功后刷新数据
                [wself.navigationController popToViewController:self animated:NO];//添加成功后跳转到列表页面
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
            
        }
    }];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma mark 批量事件
- (void)showBatchEvent {
    if (self.datas.count == 0) {
        [AlertBox show:@"请至少选择一件商品进行批量操作！"];
        return;
    }
    LSWechatGoodBatchSelectViewController *vc = [[LSWechatGoodBatchSelectViewController alloc] init];
    vc.shopId = self.shopId;
    vc.categoryId = self.categoryId;
    vc.searchCode = self.searchBar.txtField.text;
    vc.searchType = self.searchType;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
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
#pragma mark 底部工具栏点击事件
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self showScanView];
    } else if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootBatch]) {
        [self showBatchEvent];
    } else if ([footerType isEqualToString:kFootOneClick]) {
        [self showOneClickEvent];
    }
}

- (void)showOneClickEvent {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"所有商品" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = @"microGoods/quickSetCount";
        [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
            if ([ObjectUtil isNotNull:json[@"count"]]) {//正在一键上架时不返回值
                int count = [json[@"count"] intValue];
                if (count == 0) {
                    [AlertBox show:@"没有可上架的商品！"];
                } else {
                    [self showOneClickAlert:count];
                }
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"按分类上架" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LSSelectCategoryListViewController *vc = [[LSSelectCategoryListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
}


- (void)showOneClickAlert:(int)count {
    NSString *str = [NSString stringWithFormat:@"此次共有%d种商品（不包含散装称重商品）按“与零售价相同”的售价策略上架到微店销售！上架需要花费几分钟时间，请耐心等待～～\n为了保证商品数据的一致性，一键上架过程中，将无法添加或修改商品信息，建议此操作在非营业时间进行！", count];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) wself = self;
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = @"microGoods/quickSetSale";
        [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
            if ([ObjectUtil isNotNull:json[@"quickSetStatus"]]) {
                if ([json[@"quickSetStatus"] intValue] == 1) {//正在一键上架时才返回值1
                    for (UIViewController *vc in wself.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LSWechatGoodManageViewController class]]) {
                            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                            [self.navigationController popToViewController:vc animated:NO];
                            LSWechatGoodManageViewController *wechatGoodVc = (LSWechatGoodManageViewController *)vc;
                            wechatGoodVc.oneClickView.hidden = NO;
                        }
                    }
                }
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
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

#pragma mark UITableView
- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj {
    _tempVo = (MicroWechatGoodsVo*) obj;
    [self gotoWechatGoodDetailWithShopId:self.shopId goodsId:_tempVo.goodsId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWechatGoodCell *cell = [LSWechatGoodCell wechatGoodCellAtTableView:tableView];
    MicroWechatGoodsVo *goodsVo = [self.datas objectAtIndex:indexPath.row];
    cell.goodsVo = goodsVo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MicroWechatGoodsVo *goodsVo = [self.datas objectAtIndex:indexPath.row];
    [self gotoWechatGoodDetailWithShopId:self.shopId goodsId:goodsVo .goodsId];
}

#pragma mark - 初始化布局
- (void)setup {
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
    //设置底部工具栏
    self.footerView.ls_bottom = self.view.ls_height;
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

//设置底部工具栏
- (LSFooterView *)footerView {
    if (!_footerView) {
        _footerView = [LSFooterView footerView];
        [_footerView initDelegate:self btnsArray:@[kFootScan, kFootBatch, kFootOneClick, kFootAdd]];
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
