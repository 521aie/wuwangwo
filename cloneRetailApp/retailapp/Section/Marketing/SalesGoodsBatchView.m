//
//  SalesGoodsBatchView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalesGoodsBatchView.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "GoodsBatchChoiceCell.h"
#import "ObjectUtil.h"
#import "SearchBar3.h"
#import "ViewFactory.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "KxMenu.h"
#import "SaleGoodVo.h"
#import "SalesGoodsAreaView.h"
#import "ScanViewController.h"
#import "GoodsSkuVo.h"
#import "ISampleListEvent.h"
#import "FooterMultiView.h"
#import "OptionPickerClient.h"
#import "ISearchBarEvent.h"
#import "NavigateTitle2.h"
#import "LSFooterView.h"

@interface SalesGoodsBatchView ()<LSScanViewDelegate,INavigateEvent,ISampleListEvent,UIActionSheetDelegate,LSFooterViewDelegate, ISearchBarEvent, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic, strong) LSFooterView *footerView;
@property (nonatomic, strong) SearchBar3 *searchBar;
@property (nonatomic, strong) MarketService *marketService;

@property (nonatomic, retain) NSMutableArray *datas;
/**
 打折ID
 */
@property (nonatomic, strong) NSString* discountId;
/**
 打折类别
 */
@property (nonatomic, strong) NSString* discountType;
/**
 搜索框数据
 */
@property (nonatomic, strong) NSString *searchCode;
/**
 分页参数
 */
@property (nonatomic, strong) NSString* lastDateTime;
/**
 版本号
 */
@property (nonatomic, strong) NSString *lastVer;
@property (nonatomic,strong) NSArray *menuItems;
@property (nonatomic, strong) NSString *searchType;
@property (nonatomic, retain) NSMutableArray *salesGoodsList;
@end

@implementation SalesGoodsBatchView

- (instancetype)initWith:(NSMutableArray *)goodsList discountId:(NSString *)discountId discountType:(NSString *)discountType lastDateTime:(NSString *)lastDateTime searchCode:(NSString *)searchCode {
    self = [super init];
    if (self) {
        _datas = goodsList;
        _discountId = discountId;
        _discountType = discountType;
        _searchCode = searchCode;
        _lastDateTime = lastDateTime;
        _salesGoodsList = [[NSMutableArray alloc] init];
        _marketService = [ServiceFactory shareInstance].marketService;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    [self loadDatas];
}

- (void)configSubviews {
    
     _titleBox = [NavigateTitle2 navigateTitle:self];
    [_titleBox initWithName:@"选择商品" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    _titleBox.lblRight.text = @"操作";
    [self.view addSubview:_titleBox];
    
    // 搜索框
    _searchBar = [SearchBar3 searchBar3];
    _searchBar.frame = CGRectMake(0, _titleBox.ls_bottom, SCREEN_W, 44.0);
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        [_searchBar initDeleagte:self withName:@"店内码" placeholder:@""];
        [_searchBar showCondition:YES];
    } else {
        [_searchBar initDeleagte:self withName:@"店内码" placeholder:@"条形码/简码/拼音码"];
        [_searchBar showCondition:NO];
    }
    [self.view addSubview:_searchBar];
    
    _mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.ls_bottom, SCREEN_W, SCREEN_H-_searchBar.ls_bottom) style:UITableViewStylePlain];
    _mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainGrid.backgroundColor = [UIColor clearColor];
    _mainGrid.tableFooterView = [ViewFactory generateFooter:88];
    _mainGrid.rowHeight = 64.0;
    _mainGrid.delegate = self;
    _mainGrid.dataSource = self;
    [self.view addSubview:_mainGrid];
     __weak typeof(self) weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        _lastDateTime = nil;
        [weakSelf selectGoodsList];
    }];
    [weakSelf.mainGrid ls_addFooterWithCallback:^{
        [weakSelf selectGoodsList];
    }];
    
    _footerView = [LSFooterView footerView];
    [_footerView initDelegate:self btnsArray:@[kFootSelectAll,kFootSelectNo]];
    [self.view addSubview:_footerView];
}



- (void)loadDatas {
    if (self.datas != nil && self.datas.count > 0) {
        for (SaleGoodVo* vo in self.datas) {
            vo.isCheck = @"0";
        }
    }
    self.searchBar.txtKeyWord.text = _searchCode;
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        _searchType = @"3";
    } else {
        _searchType = nil;
    }
    
    [self.mainGrid reloadData];
    self.mainGrid.ls_show = YES;
}

#pragma 查询促销商品list
- (void)selectGoodsList
{
    __weak SalesGoodsBatchView* weakSelf = self;
    [_marketService selectGoodsList:_searchCode discountId:_discountId discountType:_discountType lastDateTime:_lastDateTime searchType:_searchType completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma 后台返回数据封装
- (void)responseSuccess:(id)json
{
    NSMutableArray *array = [json objectForKey:@"saleGoodVoList"];
    if (_lastDateTime == nil || [_lastDateTime isEqualToString:@""]) {
        self.datas = [[NSMutableArray alloc] init];
    }
    if ([ObjectUtil isNotNull:array]) {
        for (NSDictionary* dic in array) {
            [self.datas addObject:[SaleGoodVo convertToSaleGoodVo:dic]];
        }
    }
    
    if ([ObjectUtil isNotNull:[json objectForKey:@"lastDateTime"]]) {
        _lastDateTime = [[json objectForKey:@"lastDateTime"] stringValue];
    }
    
    [self.mainGrid reloadData];
    
    self.mainGrid.ls_show = YES;
}


#pragma 导航栏事件
- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        // 返回到促销商品list页面
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        if (_salesGoodsList.count == 0) {
            [AlertBox show:@"请先选择商品!"];
            return;
        }
        // 批量操作
        UIActionSheet *menu = [[UIActionSheet alloc]
                               initWithTitle: @"请选择批量操作"
                               delegate:self
                               cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                               otherButtonTitles: @"删除", nil];
        [menu showInView:self.view];
    }
}

#pragma actionSheet事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        static UIAlertView *alertView;
        if (alertView != nil) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            alertView = nil;
        }
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除所有选中商品吗?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
        [alertView show];
    }
}

#pragma alter 事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        __weak SalesGoodsBatchView* weakSelf = self;
        NSMutableArray* goodsIdList = [[NSMutableArray alloc] init];
        for (SaleGoodVo* vo in _salesGoodsList) {
            [goodsIdList addObject:vo.goodId];
        }
        [_marketService deleteSalesGoods:goodsIdList discountId:_discountId discountType:_discountType completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[SalesGoodsAreaView class]]) {
                    SalesGoodsAreaView *listView = (SalesGoodsAreaView *)vc;
                    [listView loadDatasFromBatchOperateView];
                }
            }
            [weakSelf popToLatestViewController:kCATransitionFromTop];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectAll]) {
        
        _salesGoodsList = [[NSMutableArray alloc] initWithCapacity:self.datas.count];
        for (SaleGoodVo *vo in self.datas) {
            vo.isCheck = @"1";
            [_salesGoodsList addObject:vo];
        }
        [self.mainGrid reloadData];
        
    } else if ([footerType isEqualToString:kFootSelectNo]) {
        
        for (SaleGoodVo *vo in self.datas) {
            vo.isCheck = @"0";
        }
        [_salesGoodsList removeAllObjects];
        [self.mainGrid reloadData];
    }
}


// ISearchBarEvent
- (void)selectCondition {
    CGRect rect = CGRectMake(47, self.searchBar.frame.origin.y, 80, 32);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:self.menuItems];
}

- (void)imputFinish:(NSString *)keyWord {
    if (keyWord.length > 50) {
        [AlertBox show:@"检索字数不能超过50字，请重新输入!"];
        return ;
    }
    _searchCode = keyWord;
    _lastDateTime = nil;
    [self.mainGrid headerBeginRefreshing];
}

// 条形码扫描
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.searchBar.lblName.text = @"条形码";
    self.searchBar.txtKeyWord.text = scanString;
    self.lastDateTime = @"";
    self.searchCode = scanString;
    self.searchType = @"5";
    [self selectGoodsList];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}



// UITableViewDelegate 、 UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count == 0 ? 0 :self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsBatchChoiceCell *cell = [GoodsBatchChoiceCell goodsBatchChoiceCellWithTableView:tableView];
    SaleGoodVo *saleGoodVo = self.datas[indexPath.row];
    cell.saleGoodVo = saleGoodVo;;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SaleGoodVo *vo = [self.datas objectAtIndex:indexPath.row];
    if ([vo.isCheck isEqualToString:@"1"]) {
        vo.isCheck = @"0";
        [_salesGoodsList removeObject:vo];
    } else {
        [_salesGoodsList addObject:vo];
        vo.isCheck = @"1";
    }
    
//    BOOL isCheck = NO;
    for (SaleGoodVo* vo in self.datas) {
        if ([vo.isCheck isEqualToString:@"1"]) {
            [self.titleBox.imgMore setHidden:NO];
            [self.titleBox.lblRight setHidden:NO];
//            isCheck =YES;
            break ;
        }
    }
        
    [self.mainGrid reloadData];
}

- (NSArray *)menuItems {
    if (!_menuItems) {
        _menuItems = @[[KxMenuItem menuItem:@"款号"
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
                                     action:@selector(pushMenuItem:)],];
    }
    return _menuItems;
}

- (void)pushMenuItem:(id)sender {
    KxMenuItem* item = (KxMenuItem*)sender;
    [self.searchBar changeLimitCondition:item.title];
    if ([item.title isEqualToString:@"款号"]) {
        self.searchType = @"1";
    } else if ([item.title isEqualToString:@"条形码"]) {
        self.searchType = @"2";
    } else if ([item.title isEqualToString:@"店内码"]) {
        self.searchType = @"3";
    } else if ([item.title isEqualToString:@"拼音码"]) {
        self.searchType = @"4";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
