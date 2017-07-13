//
//  SalesGoodsAreaView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalesGoodsAreaView.h"
#import "NavigateTitle2.h"
#import "GoodsStyleListCell.h"
//#import "ObjectUtil.h"
//#import "GoodsFooterListView.h"
#import "LSFooterView.h"
#import "SearchBar3.h"
#import "MyUILabel.h"
#import "GoodsStyleEditView.h"
#import "GoodsStyleBatchSelectView.h"
#import "EditItemList.h"
//#import "StyleTopSelectView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "StyleVo.h"
#import "DateUtils.h"
#import "XHAnimalUtil.h"
#import "GoodsStyleInfoView.h"
#import "GridColHead5.h"
#import "WechatSalePackStyleSelectView.h"
//#import "Platform.h"
#import "SaleGoodVo.h"
#import "ListStyleVo.h"
#import "SalePackStyleVo.h"
#import "GoodsAreaCell.h"
#import "GoodsAreaOfStyleCell.h"
#import "KxMenu.h"
#import "GoodsBatchChoiceView2.h"
#import "GoodsBatchChoiceView1.h"
#import "StyleGoodsVo.h"
#import "GoodsSkuVo.h"
#import "UIHelper.h"
#import "SalesGoodsBatchView.h"
#import "SaleCouponEditView.h"
#import "PiecesDiscountEditView.h"
#import "BindingDiscountEditView.h"
#import "SaleMinusEditView.h"
#import "SaleSendOrSwapEditView.h"
#import "GoodsVo.h"
#import "ScanViewController.h"
#import "ISampleListEvent.h"


@interface SalesGoodsAreaView ()<LSScanViewDelegate, INavigateEvent, ISearchBarEvent, LSFooterViewDelegate, ISampleListEvent, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic, strong) SearchBar3 *searchBar;
@property (nonatomic, strong) MarketService* marketService;
@property (nonatomic, strong) LSFooterView *footerView;/**<>*/

@property (nonatomic, strong) WechatService* wechatService;

@property (nonatomic, strong) NSMutableDictionary* condition;
@property (nonatomic, strong) NSString *lastDateTime;
@property (nonatomic, strong) NSString *searchCode;
@property (nonatomic, strong) NSString *discountId;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSString *discountType;
@property (nonatomic, strong) NSString *searchType;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic) int goodsCount;
@property (nonatomic) BOOL tipFlg;
@property (nonatomic) int showViewCount;
@property (nonatomic) int oldGoodsCount;
@property (nonatomic) BOOL delOrEditFlg;
@property (nonatomic,strong) NSArray *menuItems;
@property (nonatomic, strong) NSMutableArray *goodsIdList;
@property (nonatomic) NSInteger action;
@property (nonatomic) short searchWay;
@property (nonatomic, strong) SaleGoodVo *tempVo;
@end

@implementation SalesGoodsAreaView

- (instancetype)initWith:(NSString *)discountId discountType:(NSString *)discountType shopId:(NSString *)shopId action:(NSInteger)action {
    self = [super init];
    if (self) {
        _discountId = discountId;
        _discountType = discountType;
        _shopId = shopId;
        _action = action;
        _tipFlg = NO;
        _delOrEditFlg = NO;
        _lastDateTime = nil;
        _marketService = [ServiceFactory shareInstance].marketService;
        _wechatService = [ServiceFactory shareInstance].wechatService;
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
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"商品范围" backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text = @"保存";
    [self.view addSubview:self.titleBox];
    
    // 搜索框
    self.searchBar = [SearchBar3 searchBar3];
    self.searchBar.frame = CGRectMake(0, self.titleBox.ls_bottom, SCREEN_W, 44.0);
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        [self.searchBar initDeleagte:self withName:@"店内码" placeholder:@""];
        [self.searchBar showCondition:YES];
    } else {
        [self.searchBar initDeleagte:self withName:@"店内码" placeholder:@"条形码/简码/拼音码"];
        [self.searchBar showCondition:NO];
    }
    [self.view addSubview:self.searchBar];
    
    _mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.ls_bottom, SCREEN_W, SCREEN_H-_searchBar.ls_bottom) style:UITableViewStylePlain];
    _mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainGrid.backgroundColor = [UIColor clearColor];
    _mainGrid.tableFooterView = [ViewFactory generateFooter:88];
    _mainGrid.delegate = self;
    _mainGrid.dataSource = self;
    [self.view addSubview:_mainGrid];
    __weak typeof(self) weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.lastDateTime = nil;
        [weakSelf selectGoodsList];
    }];
    
    [weakSelf.mainGrid ls_addFooterWithCallback:^{
        [weakSelf selectGoodsList];
    }];
    
    if ([self.isCanDeal isEqualToString:@"1"]) {
        _footerView  = [LSFooterView footerView];
        [_footerView initDelegate:self btnsArray:@[kFootBatch,kFootAdd]];
        [self.view addSubview:_footerView];
    }
}


- (void)loaddatas {
    if ([NSString isNotBlank:self.titleName]) {
        self.titleBox.lblTitle.text = self.titleName;
    }
    _searchBar.txtKeyWord.text = @"";
    
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        _searchType = @"3";
    }else{
        _searchType = nil;
    }
    
    [self selectGoodsList];
}

#pragma mark - 相关协议方法
// LSFooterViewDelegate
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self addEvent];
    } else if ([footerType isEqualToString:kFootBatch]) {
        [self batchEvent];
    }
}

#pragma 从批量操作页面返回
- (void)loadDatasFromBatchOperateView {
    _delOrEditFlg = YES;
    _lastDateTime = nil;
    [self.mainGrid headerBeginRefreshing];
}

#pragma 从批量选择页面返回
- (void)loadDatasFromBatchSelectView {
    _lastDateTime = nil;
    [self.mainGrid headerBeginRefreshing];
}

#pragma 促销商品list查询
- (void)selectGoodsList {
    
    __weak SalesGoodsAreaView* weakSelf = self;
    [_marketService selectGoodsList:_searchCode discountId:_discountId discountType:_discountType lastDateTime:_lastDateTime searchType:_searchType completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma 后台返回数据封装
- (void)responseSuccess:(id)json {
    NSMutableArray *array = [json objectForKey:@"saleGoodVoList"];
    if (_lastDateTime == nil || [_lastDateTime isEqualToString:@""]) {
        self.datas = [[NSMutableArray alloc] init];
    }
    if ([ObjectUtil isNotNull:array]) {
        for (NSDictionary* dic in array) {
            [self.datas addObject:[SaleGoodVo convertToSaleGoodVo:dic]];
        }
    }
    
    if ([NSString isNotBlank:_searchBar.txtKeyWord.text] && _searchWay == 1 && (self.datas == nil || self.datas.count == 0) && [self.isCanDeal isEqualToString:@"1"]) {
        [AlertBox show:@"您查询的商品不在本次促销范围内，如需添加，请点击页面底部的添加按钮!"];
    }
    
    _searchWay = 0;
    
    if ([ObjectUtil isNotNull:[json objectForKey:@"lastDateTime"]]) {
        _lastDateTime = [[json objectForKey:@"lastDateTime"] stringValue];
    }
    
    _goodsCount = [[json objectForKey:@"goodNum"] intValue];
    
    if (!_delOrEditFlg) {
        if (_showViewCount == 0) {
            //第一次进入页面_showViewCount为0。保留原先的款式数量，设置_showViewCount为1
            _oldGoodsCount = [[json objectForKey:@"goodNum"] intValue];
            //未保存 字段不显示
            _tipFlg = NO;
            _showViewCount = 1;
        } else {
            // 不是第一次进入页面，比较初始的款式数量和现在的对比
            if (_oldGoodsCount == _goodsCount) {
                //未保存 字段不显示
                _tipFlg = NO;
            } else {
                //未保存 字段显示
                _tipFlg = YES;
                [self.titleBox initWithName:@"商品范围" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
                if ([NSString isNotBlank:self.titleName]) {
                    self.titleBox.lblTitle.text = self.titleName;
                }
            }
        }
    } else {
        //未保存 字段显示
        _tipFlg = YES;
        [self.titleBox initWithName:@"商品范围" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        if ([NSString isNotBlank:self.titleName]) {
            self.titleBox.lblTitle.text = self.titleName;
        }
    }
    
    if ([self.operateMode isEqualToString:@"add"]) {
        //未保存 字段显示
        _tipFlg = YES;
        [self.titleBox initWithName:@"商品范围" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        if ([NSString isNotBlank:self.titleName]) {
            self.titleBox.lblTitle.text = self.titleName;
        }
    }
    
    [self.mainGrid reloadData];
    self.mainGrid.ls_show = YES;
}

#pragma 点击添加事件

- (void)batchEvent {
    SalesGoodsBatchView *salesGoodsBatchView = [[SalesGoodsBatchView alloc] initWith:_datas discountId:_discountId discountType:_discountType lastDateTime:_lastDateTime searchCode:_searchCode];
    [self.navigationController pushViewController:salesGoodsBatchView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (void)addEvent {
    __weak SalesGoodsAreaView* weakSelf = self;
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        GoodsBatchChoiceView2 *goodsBatchChoiceView2 = [[GoodsBatchChoiceView2 alloc] init];
        [goodsBatchChoiceView2 loaddatas:[[Platform Instance] getkey:SHOP_ID] callBack:^(NSMutableArray *styleGoodsList) {
            if (styleGoodsList) {
                NSMutableArray* goodsList = [[NSMutableArray alloc] init];
                for (StyleGoodsVo* tempVo in styleGoodsList) {
                    SaleGoodVo* saleGoodVo = [[SaleGoodVo alloc] init];
                    saleGoodVo.goodName = tempVo.name;
                    saleGoodVo.goodId = tempVo.goodsId;
                    saleGoodVo.goodCode = tempVo.innerCode;
                    saleGoodVo.goodPic = tempVo.filePath;
                    saleGoodVo.createTime = tempVo.createTime;
                    saleGoodVo.goodsSkuList = tempVo.goodsSkuVoList;
                    [goodsList addObject:saleGoodVo];
                }
                [_marketService saveSalesGoodsBySearch:[SaleGoodVo converToDicArr:goodsList] discountId:_discountId discountType:_discountType completionHandler:^(id json) {
                    if (!(weakSelf)) {
                        return ;
                    }
                    [weakSelf loadDatasFromBatchSelectView];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
            }
            [weakSelf popToLatestViewController:kCATransitionFromTop];
        }];
        [weakSelf pushController:goodsBatchChoiceView2 from:kCATransitionFromBottom];
    } else {
        GoodsBatchChoiceView1 *goodsBatchChoiceView1 = [[GoodsBatchChoiceView1 alloc] init];
        [goodsBatchChoiceView1 loaddatas:[[Platform Instance] getkey:SHOP_ID] callBack:^(NSMutableArray *goodsList) {
            if (goodsList) {
                NSMutableArray* styleGoodsList = [[NSMutableArray alloc] init];
                for (GoodsVo* tempVo in goodsList) {
                    SaleGoodVo* saleGoodVo = [[SaleGoodVo alloc] init];
                    saleGoodVo.goodName = tempVo.goodsName;
                    saleGoodVo.goodId = tempVo.goodsId;
                    saleGoodVo.goodCode = tempVo.barCode;
                    saleGoodVo.goodPic = tempVo.filePath;
                    saleGoodVo.createTime = tempVo.createTime;
                    [styleGoodsList addObject:saleGoodVo];
                }
                [_marketService saveSalesGoodsBySearch:[SaleGoodVo converToDicArr:styleGoodsList] discountId:_discountId discountType:_discountType completionHandler:^(id json) {
                    if (!(weakSelf)) {
                        return ;
                    }
                    [weakSelf loadDatasFromBatchSelectView];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
            }
            [weakSelf popToLatestViewController:kCATransitionFromTop];
        }];
        [weakSelf pushController:goodsBatchChoiceView1 from:kCATransitionFromBottom];
    }
}

#pragma 删除临时表事件
- (void)deleteTempTable
{
    __weak SalesGoodsAreaView* weakSelf = self;
    [_wechatService deleteTempSelectStyles:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma 导航栏事件
- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        //删除业务临时表
        [self deleteTempTable];
        //返回到前一个编辑页面
        [self backToEditView];
    }else{
        __weak SalesGoodsAreaView* weakSelf = self;
        [_marketService addSaleGoodsList:_discountId discountType:_discountType completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            //删除业务临时表
            [weakSelf deleteTempTable];
            //返回到前一个编辑页面
            [weakSelf backToEditView];
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

#pragma 返回到编辑页面
- (void)backToEditView
{
    if (_action == PIECES_DISCOUNT_LIST_VIEW) {
        //返回到N件打折详情页面
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[PiecesDiscountEditView class]]) {
                PiecesDiscountEditView *listView = (PiecesDiscountEditView *)vc;
                [listView loaddatasFromGoodsOrStyleListView];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else if (_action == BINDING_DISCOUNT_LIST_VIEW){
        //返回到捆绑打折详情页面
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[BindingDiscountEditView class]]) {
                BindingDiscountEditView *listView = (BindingDiscountEditView *)vc;
                [listView loaddatasFromGoodsOrStyleListView];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        
    } else if (_action == SALES_SEND_OR_SWAP_LIST_VIEW){
        //返回到满送详情页面
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SaleSendOrSwapEditView class]]) {
                SaleSendOrSwapEditView *listView = (SaleSendOrSwapEditView *)vc;
                [listView loaddatasFromGoodsOrStyleListView];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        
    } else if (_action == SALES_MINUS_LIST_VIEW){
        //返回到满减详情页面
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SaleMinusEditView class]]) {
                SaleMinusEditView *listView = (SaleMinusEditView *)vc;
                [listView loaddatasFromGoodsOrStyleListView];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        
    } else if (_action == SALES_COUPON_LIST_VIEW){
        //返回到优惠券详情页面
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SaleCouponEditView class]]) {
                SaleCouponEditView *listView = (SaleCouponEditView *)vc;
                [listView loaddatasFromGoodsOrStyleListView];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else if (_action == SPECIAL_OFFER_EDIT_VIEW) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}


#pragma mark - 条形码扫描

- (void)showScanEvent
{
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (void)scanStart
{
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
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

#pragma 点击删除商品按钮事件
- (void)delObjEvent:(NSString *)event obj:(id)obj
{
    _tempVo = (SaleGoodVo*) obj;
    _goodsIdList = [[NSMutableArray alloc] init];
    [_goodsIdList addObject:_tempVo.goodId];
    [UIHelper alert:self.view andDelegate:self andTitle:@"确认要删除该商品吗？"];
}

#pragma 删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        __weak SalesGoodsAreaView* weakSelf = self;
        [_marketService deleteSalesGoods:_goodsIdList discountId:_discountId discountType:_discountType completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            _delOrEditFlg = YES;
            _lastDateTime = nil;
            [weakSelf selectGoodsList];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

#pragma mark 搜索框检索
- (void)imputFinish:(NSString *)keyWord
{
    if (keyWord.length > 50) {
        [AlertBox show:@"检索字数不能超过50字，请重新输入!"];
        return ;
    }
    
    _searchWay = 1;
    
    _searchCode = keyWord;
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 102) {
        _searchType = @"0";
    }
    _lastDateTime = nil;
    [self.mainGrid headerBeginRefreshing];
}

#pragma table head
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead5 *headItem = (GridColHead5 *) [self.mainGrid dequeueReusableCellWithIdentifier:GridColHead2Indentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead5" owner:self options:nil].lastObject;
    }
    
    [headItem initColHead:[NSString stringWithFormat:@"合计%d款", _goodsCount]];
    
    if (_tipFlg) {
        headItem.lblTip.hidden = NO;
        headItem.lblTip.clipsToBounds = YES;
        headItem.lblTip.layer.cornerRadius = 2.0;
        self.titleBox.imgMore.hidden = NO;
        self.titleBox.lblRight.hidden = NO;
    }else{
        headItem.lblTip.hidden = YES;
        self.titleBox.imgMore.hidden = YES;
        self.titleBox.lblRight.hidden = YES;
        
    }
    
    return headItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

#pragma table部分
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        GoodsAreaOfStyleCell *detailItem = (GoodsAreaOfStyleCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsAreaOfStyleCellIndentifier];
        
        if (!detailItem) {
            detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsAreaOfStyleCell" owner:self options:nil].lastObject;
        }
        
        detailItem.delegate = self;
        if ([ObjectUtil isNotEmpty:self.datas]) {
            SaleGoodVo *item = [self.datas objectAtIndex:indexPath.row];
            detailItem.saleGoodVo = item;
            detailItem.lblName.text = item.goodName;
            detailItem.lblCode.text = item.goodCode;
            NSString* attributeName = @"";
            for (GoodsSkuVo* sku in item.goodsSkuList) {
                if ([sku.attributeName isEqualToString:@"颜色"]) {
                    attributeName = sku.attributeVal;
                    break;
                }
            }
            
            for (GoodsSkuVo* sku in item.goodsSkuList) {
                if ([sku.attributeName isEqualToString:@"尺码"]) {
                    attributeName = [attributeName stringByAppendingString:[NSString stringWithFormat:@" %@", sku.attributeVal]];
                    break;
                }
            }
            detailItem.skuInfo.text = attributeName;
            [detailItem.lblName setVerticalAlignment:VerticalAlignmentTop];
            //暂无图片
            UIImage* placeholder = [UIImage imageNamed:@"img_default.png"];
            
            if (item.goodPic != nil && ![item.goodPic isEqualToString:@""]) {
                [detailItem.img.layer setMasksToBounds:YES];
                
                [detailItem.img.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
                
                NSURL* url = [NSURL URLWithString:[NSString urlFilterRan:item.goodPic]];
                
                [detailItem.img sd_setImageWithURL:url placeholderImage:placeholder];
                
            }
            
            if ([self.isCanDeal isEqualToString:@"0"]) {
                [detailItem.btnDel setHidden:YES];
                [detailItem.btnDel setEnabled:NO];
                [detailItem.imgDel setHidden:YES];
            }
            detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return detailItem;
            
        }
    }else if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 102){
        GoodsAreaCell *detailItem = (GoodsAreaCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsAreaCellIndentifier];
        
        if (!detailItem) {
            detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsAreaCell" owner:self options:nil].lastObject;
        }
        
        detailItem.delegate = self;
        if ([ObjectUtil isNotEmpty:self.datas]) {
            SaleGoodVo *item = [self.datas objectAtIndex:indexPath.row];
            detailItem.saleGoodVo = item;
            detailItem.lblName.text = item.goodName;
            detailItem.lblCode.text = item.goodCode;
            
            [detailItem.lblName setVerticalAlignment:VerticalAlignmentTop];
            //暂无图片
            UIImage* placeholder = [UIImage imageNamed:@"img_default.png"];
            
            if (item.goodPic != nil && ![item.goodPic isEqualToString:@""]) {
                [detailItem.img.layer setMasksToBounds:YES];
                
                [detailItem.img.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
                
                NSURL* url = [NSURL URLWithString:[NSString urlFilterRan:item.goodPic]];
                
                [detailItem.img sd_setImageWithURL:url placeholderImage:placeholder];
                
            }
            
            if ([self.isCanDeal isEqualToString:@"0"]) {
                [detailItem.btnDel setHidden:YES];
                [detailItem.btnDel setEnabled:NO];
                [detailItem.imgDel setHidden:YES];
            }
            
            detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return detailItem;
        }
    }
    
    abort();
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (void)pushMenuItem:(id)sender
{
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

#pragma mark - searchbar
- (void)selectCondition {
    CGRect rect = CGRectMake(47, self.searchBar.frame.origin.y, 80, 32);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:self.menuItems];
}


@end
