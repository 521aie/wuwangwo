//
//  GoodsChoiceView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

//
//  GoodsListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsSingleChoiceView2.h"
#import "StyleGoodsVo.h"
#import "GoodsChoiceCell.h"
#import "ObjectUtil.h"
#import "UIImageView+WebCache.h"
#import "NSString+Estimate.h"
#import "NavigateTitle2.h"
#import "SearchBar3.h"
#import "GoodsEditView.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "ViewFactory.h"
#import "GoodsGiftVo.h"
#import "TreeNode.h"
#import "KxMenu.h"
#import "GoodsSkuVo.h"
#import "ScanViewController.h"
#import "LSFooterView.h"

@interface GoodsSingleChoiceView2 ()<LSScanViewDelegate, LSFooterViewDelegate, INavigateEvent, ISearchBarEvent, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic, strong) SearchBar3 *searchBar;
@property (nonatomic, strong) LSFooterView *footerView;/**<>*/

//@property (nonatomic, retain) GoodsBatchChoiceView *goodsBatchChoiceView;
@property (nonatomic, strong) GoodsService *goodsService;
@property (nonatomic,retain) NSMutableArray *categoryList;
@property (nonatomic,strong) NSArray *menuItems;

/**
 1表示为从搜索框搜索，当查询出来为一条信息时，跳转到下一个页面
 */
@property (nonatomic) short isJump;
@end

@implementation GoodsSingleChoiceView2

- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self configSubviews];
    [_mainGrid headerBeginRefreshing];
}


- (void)configSubviews {
    
    _titleBox = [NavigateTitle2 navigateTitle:self];
    [_titleBox initWithName:@"选择商品" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:_titleBox];
    
    // 搜索框
    _searchBar = [SearchBar3 searchBar3];
    _searchBar.ls_top = _titleBox.ls_bottom;
    [_searchBar initDeleagte:self withName:@"店内码" placeholder:@""];
    [_searchBar showCondition:YES];
    [self.view addSubview:_searchBar];

    // 列表
    _mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.ls_bottom, SCREEN_W, SCREEN_H-_searchBar.ls_bottom) style:UITableViewStylePlain];
    _mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainGrid.backgroundColor = [UIColor clearColor];
    _mainGrid.tableFooterView = [ViewFactory generateFooter:88];
    _mainGrid.rowHeight = 88;
    _mainGrid.delegate = self;
    _mainGrid.dataSource = self;
    [self.view addSubview:_mainGrid];
    __weak typeof(self) weakSelf = self;
    [weakSelf.mainGrid addHeaderWithCallback:^{
        self.createTime = @"";
        [weakSelf selectStyleGoodsList];
    }];
    [weakSelf.mainGrid addFooterWithCallback:^{
        [weakSelf selectStyleGoodsList];
    }];
    
    _footerView = [LSFooterView footerView];
    [_footerView initDelegate:self btnsArray:@[kFootScan]];
    [self.view addSubview:_footerView];
}

- (void)loaddatas:(NSString *)shopId callBack:(SelectGoodsBack)callBack {
    self.selectBlock = callBack;
    self.searchBar.txtKeyWord.text = @"";
    self.searchType = @"1";
    self.searchCodeType = @"3";
    self.shopId = shopId;
}

// INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        _selectBlock(nil);
    }
}

// ISearchBarEvent
- (void)selectCondition {
    CGRect rect = CGRectMake(47, self.searchBar.frame.origin.y, 80, 32);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:self.menuItems];
}

- (void)imputFinish:(NSString *)keyWord {
    if (keyWord.length > 50) {
        [AlertBox show:@"检索字数不能超过50字，请重新输入!"]; return ;
    }
    self.searchCode = keyWord;
    self.searchType = @"1";
    self.createTime = @"";
    _isJump = 1;
    [self selectStyleGoodsList];
}

// LSFooterViewDelegate
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self scanStart];
    }
}


#pragma mark - 条形码扫描
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

// LSScanViewDelegate
- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

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



// UITableViewDelegate、 UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"goods" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj {
    StyleGoodsVo* editObj = (StyleGoodsVo*) obj;
    _selectBlock(editObj);
}

#pragma mark table部分
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsChoiceCell *detailItem = (GoodsChoiceCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsChoiceCellIndentifier];
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsChoiceCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        StyleGoodsVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.name;
        detailItem.lblInnerCode.text = item.innerCode;
        
        NSString* attributeName = @"";
        for (GoodsSkuVo* sku in item.goodsSkuVoList) {
            if ([sku.attributeName isEqualToString:@"颜色"]) {
                attributeName = sku.attributeVal;
                break;
            }
        }
        
        for (GoodsSkuVo* sku in item.goodsSkuVoList) {
            if ([sku.attributeName isEqualToString:@"尺码"]) {
                attributeName = [attributeName stringByAppendingString:[NSString stringWithFormat:@" %@", sku.attributeVal]];
                break;
            }
        }
        detailItem.lblAttributeVal.text = attributeName;
        
        
        //暂无图片
        UIImage* placeholder = [UIImage imageNamed:@"img_default.png"];
        
        if (item.filePath != nil && ![item.filePath isEqualToString:@""]) {
            [detailItem.img.layer setMasksToBounds:YES];
            
            [detailItem.img.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
            
            NSURL* url = [NSURL URLWithString:[NSString urlFilterRan:item.filePath]];
            
            [detailItem.img sd_setImageWithURL:url placeholderImage:placeholder];
            
        }
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count == 0 ? 0 :self.datas.count;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求 -

- (void)selectStyleGoodsList {
    __weak GoodsSingleChoiceView2* weakSelf = self;
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
        StyleGoodsVo* editObj = [self.datas objectAtIndex:0];
        _selectBlock(editObj);
    }
    _isJump = 0;
    [self.mainGrid reloadData];
    
    self.mainGrid.ls_show = YES;
}

@end

