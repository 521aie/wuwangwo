//
//  GoodsBatchChoiceView2.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsBatchChoiceView2.h"
#import "StyleGoodsVo.h"
#import "ObjectUtil.h"
#import "UIImageView+WebCache.h"
#import "NSString+Estimate.h"
#import "NavigateTitle2.h"
#import "SearchBar3.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "GoodsSearchBarView.h"
#import "ViewFactory.h"
#import "GoodsGiftVo.h"
#import "GoodsFooterListView.h"
#import "TreeNode.h"
#import "GoodsBatchChoiceCell.h"
#import "GoodsSkuVo.h"
#import "KxMenu.h"
#import "ScanViewController.h"
#import "ISearchBarEvent.h"
//#import "FooterMultiView.h"
#import "LSFooterView.h"
#import "NavigateTitle2.h"

@interface GoodsBatchChoiceView2 ()<LSScanViewDelegate,INavigateEvent,UIActionSheetDelegate, LSFooterViewDelegate, ISearchBarEvent, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic, strong) SearchBar3 *searchBar;
@property (nonatomic, strong) GoodsService *goodsService;
@property (nonatomic, strong) LSFooterView *footerView;/**<>*/
@property (nonatomic,retain) NSMutableArray *categoryList;
@property (nonatomic,retain) NSMutableArray *styleGoodsList;
@property (nonatomic,strong) NSArray *menuItems;

/**
 1表示为从搜索框搜索，当查询出来为一条信息时，跳转到下一个页面
 */
@property (nonatomic) short isJump;

@end

@implementation GoodsBatchChoiceView2

- (instancetype)init {
    self = [super init];
    if (self) {
        _goodsService = [ServiceFactory shareInstance].goodsService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self configSubviews];
    [self loaddatas];
}


- (void)configSubviews {
    
    _titleBox = [NavigateTitle2 navigateTitle:self];
    [_titleBox initWithName:@"选择商品" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:_titleBox];
    
    // 搜索框
    _searchBar = [SearchBar3 searchBar3];
    _searchBar.frame = CGRectMake(0, _titleBox.ls_bottom, SCREEN_W, 44.0);
    [_searchBar initDeleagte:self withName:@"店内码" placeholder:@""];
    [_searchBar showCondition:YES];
    [self.view addSubview:_searchBar];
    
    // TableView
    _mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.ls_bottom, SCREEN_W, SCREEN_H-_searchBar.ls_bottom) style:UITableViewStylePlain];
    _mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainGrid.backgroundColor = [UIColor clearColor];
    _mainGrid.tableFooterView = [ViewFactory generateFooter:88];
    _mainGrid.rowHeight = 64;
    _mainGrid.delegate = self;
    _mainGrid.dataSource = self;
    [self.view addSubview:_mainGrid];
    __weak typeof(self) weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.createTime = @"";
        [weakSelf selectStyleGoodsList];
    }];
    [weakSelf.mainGrid ls_addFooterWithCallback:^{
        [weakSelf selectStyleGoodsList];
    }];
    
    _footerView = [LSFooterView footerView];
    [_footerView initDelegate:self btnsArray:@[kFootSelectAll,kFootSelectNo]];
    [self.view addSubview:_footerView];
}

- (void)loaddatas {
    [self.titleBox.lblRight setHidden:YES];
    [self.titleBox.imgMore setHidden:YES];
    [self.mainGrid headerBeginRefreshing];
}

- (void)loaddatas:(NSString *)shopId callBack:(SelectBatchBack)callBack
{
    _selectBatchBack = callBack;
    self.searchBar.txtKeyWord.text = @"";
    self.searchType = @"1";
    self.searchCodeType = @"3";
    self.shopId = shopId;
    _styleGoodsList = [[NSMutableArray alloc] init];
}

- (void)selectStyleGoodsList {
    
    __weak GoodsBatchChoiceView2* weakSelf = self;
    [_goodsService selectStyleGoods:self.searchType shopId:self.shopId searchCodeType:self.searchCodeType searchCode:self.searchCode categoryId:self.categoryId createTime:self.createTime completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
    }];
}

- (void)responseSuccess:(id)json {
    
    if ([NSString isBlank:self.createTime]) {
        _styleGoodsList = [[NSMutableArray alloc] init];
        [self.titleBox initWithName:@"选择商品" backImg:Head_ICON_BACK moreImg:nil];
    }
    
    NSMutableArray *array = [json objectForKey:@"styleGoodsVoList"];
    if ([NSString isBlank:self.createTime]) {
        self.datas = [[NSMutableArray alloc] init];
    }
    if ([ObjectUtil isNotNull:array] && array.count > 0) {
        for (NSDictionary* dic in array) {
            [self.datas addObject:[StyleGoodsVo convertToStyleGoodsVo:dic]];
        }
    }
    
    if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
        self.createTime = [[json objectForKey:@"createTime"] stringValue];
    }
    
    if (self.datas.count == 1 && _isJump == 1) {
        _selectBatchBack(self.datas);
    }
    _isJump = 0;
    [self.mainGrid reloadData];
    
    self.mainGrid.ls_show = YES;
}

- (void)clearCheckStatus {
    for (StyleGoodsVo* tempVo in self.datas) {
        tempVo.isCheck = @"0";
    }
    [_styleGoodsList removeAllObjects];
    [self.titleBox initWithName:@"选择商品" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleBox.lblRight setHidden:YES];
    [self.titleBox.imgMore setHidden:YES];
    [self.mainGrid reloadData];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event==1) {
        _selectBatchBack(nil);
    } else {
        if (_styleGoodsList.count != 0) {
            _selectBatchBack(_styleGoodsList);
        }
    }
}

#pragma mark - 相关协议方法
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectAll]) {
        _styleGoodsList = [[NSMutableArray alloc] init];
        if (self.datas.count > 0) {
            for (StyleGoodsVo *vo in self.datas) {
                vo.isCheck =@"1";
                [_styleGoodsList addObject:vo];
            }
        }
        if (_styleGoodsList.count > 0) {
            [self.titleBox initWithName:@"选择商品" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
            self.titleBox.lblRight.text = @"确认";
            [self.titleBox.lblRight setHidden:NO];
            [self.titleBox.imgMore setHidden:NO];
        }
        
        [self.mainGrid reloadData];
        
    } else if ([footerType isEqualToString:kFootSelectNo]) {
        if (self.datas.count > 0) {
            for (StyleGoodsVo *vo in self.datas) {
                vo.isCheck =@"0";
            }
        }
        [_styleGoodsList removeAllObjects];
        [self.titleBox initWithName:@"选择商品" backImg:Head_ICON_BACK moreImg:nil];
        [self.titleBox.lblRight setHidden:YES];
        [self.titleBox.imgMore setHidden:YES];
        [self.mainGrid reloadData];
    }
}


// LSScanViewDelegate 扫一扫
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    _isJump = 1;
    self.searchBar.lblName.text = @"条形码";
    self.searchBar.txtKeyWord.text = scanString;
    self.categoryId = @"";
    self.searchType = @"1";
    self.createTime = @"";
    self.searchCode = scanString;
    self.searchCodeType = @"2";
    [self selectStyleGoodsList];

}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

// ISearchBarEvent
- (void)scanStart
{
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord {
    if (keyWord.length > 50) {
        [AlertBox show:@"检索字数不能超过50字，请重新输入!"];
        return ;
    }
    
    self.searchCode = keyWord;
    self.searchType = @"1";
    self.createTime = @"";
    _isJump = 1;
    [self selectStyleGoodsList];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"goods" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsBatchChoiceCell *cell = [GoodsBatchChoiceCell goodsBatchChoiceCellWithTableView:tableView];
    StyleGoodsVo *styleGoodsVo = [self.datas objectAtIndex:indexPath.row];
    cell.styleGoodsVo = styleGoodsVo;
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count == 0 ? 0 :self.datas.count;
}


- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj {
    StyleGoodsVo* editObj = (StyleGoodsVo*) obj;
    if ([editObj.isCheck isEqualToString:@"1"]) {
        editObj.isCheck = @"0";
        [_styleGoodsList removeObject:editObj];
    } else {
        editObj.isCheck = @"1";
        [_styleGoodsList addObject:editObj];
    }
    
    if (_styleGoodsList.count != 0) {
        [self.titleBox initWithName:@"选择商品" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        self.titleBox.lblRight.text = @"确认";
        [self.titleBox.lblRight setHidden:NO];
        [self.titleBox.imgMore setHidden:NO];
    } else {
        [self.titleBox initWithName:@"选择商品" backImg:Head_ICON_BACK moreImg:nil];
        [self.titleBox.lblRight setHidden:YES];
        [self.titleBox.imgMore setHidden:YES];
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
    
    KxMenuItem *item = (KxMenuItem *)sender;
    [self.searchBar changeLimitCondition:item.title];
    if ([item.title isEqualToString:@"款号"]) {
        self.searchCodeType = @"1";
    } else if ([item.title isEqualToString:@"条形码"]) {
        self.searchCodeType = @"2";
    } else if ([item.title isEqualToString:@"店内码"]) {
        self.searchCodeType = @"3";
    } else if ([item.title isEqualToString:@"简码"]) {
        self.searchCodeType = @"4";
    } else if ([item.title isEqualToString:@"拼音码"]) {
        self.searchCodeType = @"5";
    }
}

#pragma mark - searchbar
- (void)selectCondition {
    CGRect rect = CGRectMake(47, self.searchBar.frame.origin.y, 80, 32);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:self.menuItems];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
