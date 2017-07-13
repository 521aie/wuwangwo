//
//  LSMarketListController.m
//  retailapp
//
//  Created by guozhi on 2016/10/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#define DH_IMAGE_CELL_ITEM_HEIGHT 88
#define DH_HEAD_HEIGHT 44
#import "LSMarketListController.h"
#import "NavigateTitle2.h"
#import "NameValueItemVO.h"
#import "SaleActVo.h"
#import "ObjectUtil.h"
#import "GridColHead4.h"
#import "ViewFactory.h"
#import "LSFooterView.h"
#import "GridFooter.h"
#import "SaleActVo.h"
#import "SalesNpDiscountVo.h"
#import "DiscountGoodsVo.h"
#import "EditItemList.h"
#import "MarketSalesEditView.h"
#import "PiecesDiscountEditView.h"
#import "BindingDiscountEditView.h"
#import "SaleSendOrSwapEditView.h"
#import "SaleMinusEditView.h"
#import "SaleCouponEditView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SalesCouponVo.h"
#import "XHAnimalUtil.h"
#import "SalesNpDiscountVo.h"
#import "DiscountGoodsVo.h"
#import "SalesBindDiscountVo.h"
#import "SelectOrgShopListView.h"
#import "SalesMatchRuleMinusVo.h"
#import "SalesMatchRuleSendVo.h"
#import "SelectShopListView.h"
#import "OptionPickerBox.h"
#import "MarketRender.h"
#import "LSFilterView.h"
#import "LSMarkAddView.h"
#import "LSMarkCell.h"
#import "LSSalePriceVo.h"
#import "LSSpecialSaleEditController.h"

@interface LSMarketListController ()<LSFooterViewDelegate, INavigateEvent, ISampleListEvent, UITableViewDelegate, UITableViewDataSource, LSFilterViewDelegate, IEditItemListEvent>

@property (nonatomic, strong) MarketService *marketService;
/** 标题 */
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LSFooterView *footView;
@property (nonatomic, strong) NSMutableArray *datas;
// table head 数据
@property (nonatomic, strong) NSMutableArray *headList;
// table detail 数据
@property (nonatomic,strong) NSMutableDictionary *detailMap;
/** 促销活动list */
@property (nonatomic, strong) NSMutableArray *salesList;
/** 优惠券促销规则list */
@property (nonatomic, strong) NSMutableArray *salesCouponList;
/** N件打折规则list */
@property (nonatomic, strong) NSMutableArray *salesNpDisVoList;
/** 捆绑打折规则list */
@property (nonatomic, strong) NSMutableArray *salesBindDiscountVoList;
/** 满减规则list */
@property (nonatomic, strong) NSMutableArray *matchRuleMinusVoList;
/** 满送规则list */
@property (nonatomic, strong) NSMutableArray *matchRuleSendVoList;
/** 特价管理list */
@property (nonatomic, strong) NSMutableArray *salePriceVoList;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
/** 门店 优惠券使用 */
@property (nonatomic, strong) EditItemList *lstShop;


/** 筛选页面数据 */
@property (nonatomic, strong) NSMutableArray<LSFilterModel *> *filterDatas;
/** 使用范围 */
@property (nonatomic, strong) LSFilterModel *filterShopRange;
/** 门店 */
@property (nonatomic, strong) LSFilterModel *filterShop;
/** 状态 */
@property (nonatomic, strong) LSFilterModel *filterStatus;


/** 活动信息 */
@property (nonatomic, retain) SaleActVo* tempVo;
/** 1表示从规则为添加页面跳转，0表示不是从规则添加页面跳转 */
@property (nonatomic) short isAddRegulationView;
@property (nonatomic, retain) NSString *addSalesId;
@property (nonatomic) NSInteger listCount;
@property (nonatomic, assign) int action;
/** 筛选页面 */
@property (nonatomic, strong) LSFilterView *filterView;
@end

@implementation LSMarketListController
- (instancetype)initWithAction:(int)action {
    if (self = [super init]) {
        self.action = action;
        _marketService = [[MarketService alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self configHelpButton];
    [self selectSaleList];
}

- (void)configHelpButton {
    if (self.action == SPECIAL_OFFER_LIST_VIEW) {//特价管理
        [self configHelpButton:HELP_MARKET_SPECIAL_MANAGEMENT_LIST];
    } else if (self.action == PIECES_DISCOUNT_LIST_VIEW) {//第N件打折
        [self configHelpButton:HELP_MARKET_PART_N_DISCOUNT_LIST];
    } else if (self.action == BINDING_DISCOUNT_LIST_VIEW) {//捆绑打折
        [self configHelpButton:HELP_MARKET_BUNDLED_DISCOUNT_LIST];
    } else if (self.action == SALES_SEND_OR_SWAP_LIST_VIEW) {//满送/换购
        [self configHelpButton:HELP_MARKET_FULL_DELIVERY_LIST];
    } else if (self.action == SALES_MINUS_LIST_VIEW) {//满送
        [self configHelpButton:HELP_MARKET_FULL_CUT_LIST];
    } else if (self.action == SALES_COUPON_LIST_VIEW) {//优惠券
        [self configHelpButton:HELP_MARKET_COUPON_LIST];
    }
    
}

#pragma mark - 配置试图
- (void)configViews {
    //配置标题
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
    if (self.action == PIECES_DISCOUNT_LIST_VIEW) {
        // N件打折
        self.titleBox.lblTitle.text = @"第N件打折";
    }else if (self.action == BINDING_DISCOUNT_LIST_VIEW){
        // 捆绑打折
        self.titleBox.lblTitle.text = @"捆绑打折";
    }else if (self.action == SALES_SEND_OR_SWAP_LIST_VIEW){
        // 满送or换购
        self.titleBox.lblTitle.text = @"满送/换购";
    }else if (self.action == SALES_MINUS_LIST_VIEW){
        // 满减
        self.titleBox.lblTitle.text = @"满减";
    }else if (self.action == SALES_COUPON_LIST_VIEW){
        // 优惠券
        self.titleBox.lblTitle.text = @"优惠券";
        //门店
        if ([[Platform Instance] getShopMode] == 3) {
            self.lstShop = [EditItemList editItemList];
            [self.lstShop initLabel:@"门店" withHit:nil delegate:self];
            self.lstShop.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
            self.lstShop.imgMore.image = [UIImage imageNamed:@"ico_next"];
            [self.lstShop initData:@"全部" withVal:@"0"];
            [self.view addSubview:self.lstShop];
        }
    } else if (self.action == SPECIAL_OFFER_LIST_VIEW){
        // 特价管理
        self.titleBox.lblTitle.text = @"特价管理";
    }
    [self.view addSubview:self.titleBox];
    
    //配置表格
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    self.tableView.tableFooterView = view;
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        [wself selectSaleList];
    }];
    [self.view addSubview:self.tableView];
    
    //配置底部工具栏
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootAdd]];
    [self.view addSubview:self.footView];
    
    //配置筛选按钮
    if (!(self.action == SALES_COUPON_LIST_VIEW)) {//优惠券没有筛选按钮
        self.filterView = [LSFilterView addFilterViewToView:self.view delegate:self datas:self.filterDatas];
    }
}

#pragma mark - 配置约束
- (void)configConstraints {
    __weak typeof(self) wself = self;
    //配置标题约束
    [self.titleBox makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(wself.view);
        make.height.equalTo(64);
    }];
    
    //配置门店约束
    if (self.action == SALES_COUPON_LIST_VIEW && ([[Platform Instance] getShopMode] == 3)){//优惠券
        [self.lstShop makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(wself.view);
            make.top.equalTo(wself.titleBox.bottom);
            make.height.equalTo(48);
        }];
    }
    
    //配置表格约束
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        if (self.action == SALES_COUPON_LIST_VIEW && ([[Platform Instance] getShopMode] == 3)){//优惠券
            make.top.equalTo(wself.lstShop.bottom);
        } else {
            make.top.equalTo(wself.titleBox.bottom);
        }
        make.bottom.equalTo(wself.view.bottom);
    }];
    //配置底部工具栏
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
}

- (void)onItemListClick:(EditItemList *)obj {
    
    if (obj == self.lstShop) {
        //跳转页面至选择门店
        SelectShopListView *selectShopListView = [[SelectShopListView alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:selectShopListView animated:NO];
        __weak typeof(self) wself = self;
        [selectShopListView loadShopList:self.filterShop.selectItem.itemId withType:2 withViewType:CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popToViewController:wself animated:NO];
            if (shop) {
                [wself.lstShop initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                [wself selectSaleList];
            }
        }];
    }
}

#pragma amrk - 网络请求
#pragma mark 请求参数
- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param removeAllObjects];
    NSString *shopId = nil;
    if (self.action == SALES_COUPON_LIST_VIEW) {//优惠券不显示右侧筛选按钮
        if ([[Platform Instance] getShopMode] != 3) {
            shopId = [[Platform Instance] getkey:SHOP_ID];
        } else if ([[self.lstShop getDataLabel] isEqualToString:@"全部"]) {
            shopId = @"";
        } else {
            shopId = [self.lstShop getStrVal];
        }
        [_param setValue:shopId forKey:@"shopId"];
    } else {
        if ([self.filterDatas containsObject:self.filterShop]) {
            if ([self.filterShop.selectItem.itemName isEqualToString:@"全部"]) {
                shopId = @"";
            } else {
                shopId = self.filterShop.selectItem.itemId;
            }
        } else {
            shopId = [[Platform Instance] getkey:SHOP_ID];
        }
        [_param setValue:shopId forKey:@"shopId"];
        if ([self.filterDatas containsObject:self.filterShopRange]) {
            NSString *fitRange = self.filterShopRange.selectItem.itemId;
            [_param setValue:fitRange forKey:@"fitRange"];
        } else {//有可能这个选项在筛选页面不显示 也就是没有开微店这时传全部1
            [_param setValue:@"1" forKey:@"fitRange"];
        }
        NSString *status = self.filterStatus.selectItem.itemId;
        [_param setValue:@(status.integerValue) forKey:@"salesStatus"];
    }
    return _param;
}

#pragma mark 加载数据
- (void) selectSaleList {
    __weak typeof(self) wself = self;
    NSString *url = nil;
    if (self.action == PIECES_DISCOUNT_LIST_VIEW) {
        // N件打折
        url = @"salesNpDiscount/list";
        
    }else if (self.action == BINDING_DISCOUNT_LIST_VIEW){
        // 捆绑打折
        url = @"salesBindDiscount/list";
    }else if (self.action == SALES_SEND_OR_SWAP_LIST_VIEW){
        // 满送or换购
        url = @"salesMatchRuleSend/list";
    }else if (self.action == SALES_MINUS_LIST_VIEW){
        // 满减
        url = @"salesMatchRuleMinus/list";
    }else if (self.action == SALES_COUPON_LIST_VIEW){
        // 优惠券
        url = @"salesCoupon/list";
    } else if (self.action == SPECIAL_OFFER_LIST_VIEW){
        // 特价管理
        url = @"salePrice/list";
    }
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself responseSuccess:json];
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    _salesList = [SaleActVo mj_objectArrayWithKeyValuesArray:json[@"saleActVoList"]];
    // 获取策略数量
    if (self.action == PIECES_DISCOUNT_LIST_VIEW &&[self.filterDatas containsObject:self.filterShop] && [self.filterShop.selectItem.itemId isEqualToString:@"0"]) {
        self.listCount = _salesList.count;
    }
    [self initHeadData:_salesList];
    self.detailMap = [NSMutableDictionary dictionary];
    NSMutableArray *details = nil;
    if (self.action == PIECES_DISCOUNT_LIST_VIEW) {
        // N件打折
        self.titleBox.lblTitle.text = @"第N件打折";
        _salesNpDisVoList = [SalesNpDiscountVo converToArr:[json objectForKey:@"salesNpDisVoList"]];
        for (NameValueItemVO* vo in self.headList) {
            details=[NSMutableArray array];
            for (SalesNpDiscountVo* item in _salesNpDisVoList) {
                if ([vo.itemId isEqualToString:item.salesId]) {
                    [details addObject:item];
                }
            }
            [self.detailMap setValue:details forKey:vo.itemId];
        }
    }else if (self.action == BINDING_DISCOUNT_LIST_VIEW){
        // 捆绑打折
        self.titleBox.lblTitle.text = @"捆绑打折";
        _salesBindDiscountVoList = [SalesBindDiscountVo converToArr:[json objectForKey:@"salesBindDiscountVoList"]];
        
        for (NameValueItemVO* vo in self.headList) {
            details=[NSMutableArray array];
            for (SalesBindDiscountVo* item in _salesBindDiscountVoList) {
                if ([vo.itemId isEqualToString:item.salesId]) {
                    [details addObject:item];
                }
            }
            [self.detailMap setValue:details forKey:vo.itemId];
        }
    }else if (self.action == SALES_SEND_OR_SWAP_LIST_VIEW){
        // 满送or换购
        self.titleBox.lblTitle.text = @"满送/换购";
        _matchRuleSendVoList = [SalesMatchRuleSendVo converToArr:[json objectForKey:@"salesMatchRuleSendVoList"]];
        for (NameValueItemVO *vo in self.headList) {
            details = [NSMutableArray array];
            for (SalesMatchRuleSendVo* item in _matchRuleSendVoList) {
                if ([vo.itemId isEqualToString:item.salesId]) {
                    [details addObject:item];
                }
            }
            [self.detailMap setValue:details forKey:vo.itemId];
        }
    }else if (self.action == SALES_MINUS_LIST_VIEW){
        // 满减
        self.titleBox.lblTitle.text = @"满减";
        _matchRuleMinusVoList = [SalesMatchRuleMinusVo converToArr:[json objectForKey:@"salesMatchRuleMinusVoList"]];
        
        for (NameValueItemVO* vo in self.headList) {
            details=[NSMutableArray array];
            for (SalesMatchRuleMinusVo* item in _matchRuleMinusVoList) {
                if ([vo.itemId isEqualToString:item.salesId]) {
                    [details addObject:item];
                }
            }
            [self.detailMap setValue:details forKey:vo.itemId];
        }
    }else if (self.action == SALES_COUPON_LIST_VIEW){
        // 优惠券
        self.titleBox.lblTitle.text = @"优惠券";
        _salesCouponList = [SalesCouponVo converToArr:[json objectForKey:@"salesCouponVoList"]];
        
        for (NameValueItemVO* vo in self.headList) {
            details=[NSMutableArray array];
            for (SalesCouponVo* item in _salesCouponList) {
                if ([vo.itemId isEqualToString:item.salesId]) {
                    [details addObject:item];
                }
            }
            [self.detailMap setValue:details forKey:vo.itemId];
        }
    } else if (self.action == SPECIAL_OFFER_LIST_VIEW){
        // 特价管理
        _salePriceVoList = [LSSalePriceVo mj_objectArrayWithKeyValuesArray:json[@"salePriceVos"]];
        
        for (NameValueItemVO* vo in self.headList) {
            details=[NSMutableArray array];
            for (LSSalePriceVo* item in _salePriceVoList) {
                if ([vo.itemId isEqualToString:item.salesId]) {
                    [details addObject:item];
                }
            }
            [self.detailMap setValue:details forKey:vo.itemId];
        }
    }
    if (_isAddRegulationView == 1) {
        if ([ObjectUtil isNotEmpty:self.headList]) {
            int index = [GlobalRender getPos:self.headList itemId:_addSalesId];
            CGFloat offset = index*DH_HEAD_HEIGHT;
            if ([[Platform Instance] getShopMode] == 3 || ([[Platform Instance] getShopMode] == 1 && self.action != SALES_COUPON_LIST_VIEW)) {
                offset = offset + 48;
            }
            for (NSUInteger i=0;i<index;++i) {
                NameValueItemVO *nodeTemp = [self.headList objectAtIndex:i];
                if([ObjectUtil isNotNull:nodeTemp]) {
                    NSArray *menus = [self.detailMap objectForKey:nodeTemp.itemId];
                    if ([ObjectUtil isNotEmpty:menus]) {
                        if (_action == SALES_COUPON_LIST_VIEW) {
                            // 读取优惠券活动是否在进行中
                            short flg = 0;
                            for (SaleActVo* temp in _salesList) {
                                if ([temp.saleActId isEqualToString:[nodeTemp obtainItemId]]) {
                                    flg = temp.couponActive;
                                    break;
                                }
                            }
                            
                            if ([[nodeTemp obtainItemValue] isEqualToString:@"0"] || flg == 1) {
                                offset += DH_IMAGE_CELL_ITEM_HEIGHT*menus.count;
                            } else {
                                offset += DH_IMAGE_CELL_ITEM_HEIGHT*(menus.count + 1);
                            }
                        } else {
                            if ([[nodeTemp obtainItemValue] isEqualToString:@"0"]) {
                                offset += DH_IMAGE_CELL_ITEM_HEIGHT*menus.count;
                            } else {
                                offset += DH_IMAGE_CELL_ITEM_HEIGHT*(menus.count + 1);
                            }
                        }
                    }
                }
            }
            if (!(self.action == SALES_COUPON_LIST_VIEW)) {//优惠券有问题暂时不移动位置
                [self.tableView setContentOffset:CGPointMake(0, offset-DH_HEAD_HEIGHT) animated:YES];
            }
            
        }
        _isAddRegulationView = 0;
    }
    [self.tableView reloadData];
}


#pragma mark - 筛选页面数据 -
- (NSMutableArray<LSFilterModel *> *)filterDatas {
    if (_filterDatas == nil) {
        _filterDatas = [NSMutableArray array];
       
        //适用范围
        if ([[Platform Instance] getShopMode] == 3 || ([[Platform Instance] getShopMode] != 3 && [[Platform Instance] getMicroShopStatus] == 2)) {
            [_filterDatas addObject:self.filterShopRange];
        }
        
        //门店选择
        if ([[Platform Instance] getShopMode] == 3) {
            [_filterDatas addObject:self.filterShop];
        }
        
        //状态
        [_filterDatas addObject:self.filterStatus];
    }
    return _filterDatas;
}


//  适用范围
- (LSFilterModel *)filterShopRange {
   
    if (_filterShopRange == nil) {
        
        LSFilterItem *item = nil;
        LSFilterItem *selectItem = [LSFilterItem filterItem:@"全部" itemId:@"1"];
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:selectItem];
        
        item = [LSFilterItem filterItem:@"实体门店" itemId:@"2"];
        [items addObject:item];

        // 机构显示微店选项，门店和单店需判断微店是否开通
        if ([[Platform Instance] getShopMode] == 3 || [[Platform Instance] getMicroShopStatus] == 2) {
            item = [LSFilterItem filterItem:@"微店" itemId:@"3"];
            [items addObject:item];
        }
        
        _filterShopRange = [LSFilterModel filterModel:LSFilterModelTypeDefult items:items selectItem:selectItem title:@"适用范围"];
    }
    return _filterShopRange;
}

//  门店
- (LSFilterModel *)filterShop {
    if (_filterShop == nil) {
        LSFilterItem *selectItem = [LSFilterItem filterItem:@"全部" itemId:@"0"];
        _filterShop = [LSFilterModel filterModel:LSFilterModelTypeRight items:nil selectItem:selectItem title:@"门店"];
    }
    return _filterShop;
}

//  状态
- (LSFilterModel *)filterStatus {
    if (_filterStatus == nil) {
        LSFilterItem *item = nil;
        LSFilterItem *selectItem = [LSFilterItem filterItem:@"全部" itemId:@"0"];
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:selectItem];
        item = [LSFilterItem filterItem:@"未开始" itemId:@"1"];
        [items addObject:item];
        item = [LSFilterItem filterItem:@"进行中" itemId:@"2"];
        [items addObject:item];
        item = [LSFilterItem filterItem:@"已失效" itemId:@"3"];
        [items addObject:item];
        item = [LSFilterItem filterItem:@"已过期" itemId:@"4"];
        [items addObject:item];
        _filterStatus = [LSFilterModel filterModel:LSFilterModelTypeDefult items:items selectItem:selectItem title:@"状态"];
    }
    return _filterStatus;
}

#pragma mark <LSFootViewDelegate>
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        // 跳转到促销活动添加页面
        if(self.action==PIECES_DISCOUNT_LIST_VIEW){
            MarketSalesEditView* marketSalesEditView = [[MarketSalesEditView alloc] initWithNibName:[SystemUtil getXibName:@"MarketSalesEditView"] bundle:nil saleActId:nil action:ACTION_CONSTANTS_ADD fromView:_action];
            [self.navigationController pushViewController:marketSalesEditView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        }else{
            MarketSalesEditView* marketSalesEditView = [[MarketSalesEditView alloc] initWithNibName:[SystemUtil getXibName:@"MarketSalesEditView"] bundle:nil saleActId:nil action:ACTION_CONSTANTS_ADD fromView:_action];
            [self.navigationController pushViewController:marketSalesEditView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        }
        
    }
}


- (void)filterViewdidClickModel:(LSFilterModel *)filterModel {
    if (filterModel == self.filterShop) {
        //跳转页面至选择门店
        SelectShopListView *selectShopListView = [[SelectShopListView alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:selectShopListView animated:NO];
        __weak typeof(self) wself = self;
        [selectShopListView loadShopList:self.filterShop.selectItem.itemId withType:2 withViewType:CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popToViewController:wself animated:NO];
            if (shop) {
                LSFilterItem *item = [LSFilterItem filterItem:[shop obtainItemName] itemId:[shop obtainItemId]];
                wself.filterShop.selectItem = item;
            }
        }];
    }
//    else if (filterModel == self.filterShopRange) {//使用范围
//        
//        if ([self.filterShopRange.selectItem.itemId isEqualToString:@"3"]) {
//            [_filterDatas removeObject:self.filterShop];
//        } else {
//            if ([[Platform Instance] getShopMode] == 3) {
//                if (![_filterDatas containsObject:self.filterShop]) {
//                    [_filterDatas insertObject:self.filterShop atIndex:1];
//                }
//            }
//        }
//        [self.filterView refreshData];
//    }
}


- (NSMutableArray<LSFilterModel *> *)filterViewDidClickResetBtm {
//    if ([[Platform Instance] getShopMode] == 3) {
//        if (![_filterDatas containsObject:self.filterShop]) {
//            [_filterDatas insertObject:self.filterShop atIndex:1];
//        }
//    }
    return _filterDatas;
}
- (void)filterViewDidClickComfirmBtn {
    [self selectSaleList];
}
#pragma 导航栏事件
-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        // 返回到营销信息主页
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma 从促销活动页面返回
-(void) loadDatasFromEditView:(int) action
{
    if (action == ACTION_CONSTANTS_ADD) {
        [self.tableView setContentOffset:CGPointMake(0, 0)animated:YES];
        [self.tableView headerBeginRefreshing];
    } else {
        [self selectSaleList];
    }
}

#pragma mark 从促销规则页面返回
-(void) loadDatasFromSalesRegulationEditView:(int) action salesId:(NSString*) salesId
{
    if (action == ACTION_CONSTANTS_ADD) {
        _isAddRegulationView = 1;
        _addSalesId = salesId;
        NSString* shopId = nil;
        NSString* fitRange = nil;
        if ([[Platform Instance] getShopMode] == 3) {
            if ([self.param[@"shopId"] isEqualToString:@"0"]) {
                shopId = @"";
            } else {
                shopId = self.param[@"shopId"];
            }
        }else{
            shopId = [[Platform Instance] getkey:SHOP_ID];
        }
        if ([self.filterDatas containsObject:self.filterShopRange]) {
            fitRange = self.filterShopRange.selectItem.itemId;
        } else {
            fitRange = @"1";
        }
        __weak typeof(self) wself = self;
        if (self.action == PIECES_DISCOUNT_LIST_VIEW) {
            // N件打折
            [_marketService selectSalesNpDiscountList:shopId fitRange:fitRange completionHandler:^(id json) {
                [wself responseSuccess:json];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else if (self.action == BINDING_DISCOUNT_LIST_VIEW){
            // 捆绑打折
            [_marketService selectSalesBindingDiscountList:shopId fitRange:fitRange completionHandler:^(id json) {
                [wself responseSuccess:json];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else if (self.action == SALES_SEND_OR_SWAP_LIST_VIEW){
            // 满送or换购
            [_marketService selectSalesMatchRuleSendList:shopId fitRange:fitRange completionHandler:^(id json) {
                [wself responseSuccess:json];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else if (self.action == SALES_MINUS_LIST_VIEW){
            // 满减
            [_marketService selectSalesMatchRuleMinusList:shopId fitRange:fitRange completionHandler:^(id json) {
                [wself responseSuccess:json];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else if (self.action == SALES_COUPON_LIST_VIEW){
            // 优惠券
            [_marketService selectSalesCouponList:shopId fitRange:fitRange completionHandler:^(id json) {
                [wself responseSuccess:json];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
        
    } else if (action == ACTION_CONSTANTS_EDIT){
        [self selectSaleList];
    } else if (action == ACTION_CONSTANTS_DEL){
        [self selectSaleList];
    }
}

#pragma table head添加点击事件
- (void)showAddEvent:(NSString *)event
{
    NSString *shopId = self.param[@"shopId"];
    if (self.action == PIECES_DISCOUNT_LIST_VIEW) {
        // N件打折
        PiecesDiscountEditView* piecesDiscountEditView = [[PiecesDiscountEditView alloc] initWithNibName:[SystemUtil getXibName:@"PiecesDiscountEditView"] bundle:nil npDiscountId:nil salesId:event action:ACTION_CONSTANTS_ADD shopId:shopId];
        [self.navigationController pushViewController:piecesDiscountEditView animated:NO];
    }else if (self.action == BINDING_DISCOUNT_LIST_VIEW){
        // 捆绑打折
        BindingDiscountEditView* bindingDiscountEditView = [[BindingDiscountEditView alloc] initWithNibName:[SystemUtil getXibName:@"BindingDiscountEditView"] bundle:nil bindDiscountId:nil salesId:event action:ACTION_CONSTANTS_ADD shopId:shopId];
        [self.navigationController pushViewController:bindingDiscountEditView animated:NO];
    }else if (self.action == SALES_SEND_OR_SWAP_LIST_VIEW){
        // 满送or换购
        SaleSendOrSwapEditView* saleSendOrSwapEditView = [[SaleSendOrSwapEditView alloc] initWithNibName:[SystemUtil getXibName:@"SaleSendOrSwapEditView"] bundle:nil fullSendId:nil salesId:event action:ACTION_CONSTANTS_ADD shopId:shopId];
        [self.navigationController pushViewController:saleSendOrSwapEditView animated:NO];
    }else if (self.action == SALES_MINUS_LIST_VIEW){
        // 满减
        SaleMinusEditView* saleMinusEditView = [[SaleMinusEditView alloc] initWithNibName:[SystemUtil getXibName:@"SaleMinusEditView"] bundle:nil minusRuleId:nil salesId:event action:ACTION_CONSTANTS_ADD shopId:shopId];
        [self.navigationController pushViewController:saleMinusEditView animated:NO];
        
    }else if (self.action == SALES_COUPON_LIST_VIEW){
        // 优惠券
        SaleCouponEditView* saleCouponEditView = [[SaleCouponEditView alloc] initWithNibName:[SystemUtil getXibName:@"SaleCouponEditView"] bundle:nil salesCouponId:nil salesId:event action:ACTION_CONSTANTS_ADD shopId:shopId];
        [self.navigationController pushViewController:saleCouponEditView animated:NO];
    } else if (self.action == SPECIAL_OFFER_LIST_VIEW) {//特价管理
        LSSpecialSaleEditController *vc = [[LSSpecialSaleEditController alloc] initWithSalesId:event salePriceId:nil action:ACTION_CONSTANTS_ADD];
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma table head编辑点击事件
- (void)showEditObjId:(NSString *)objId event:(NSString *)event
{
    MarketSalesEditView* marketSalesEditView = [[MarketSalesEditView alloc] initWithNibName:[SystemUtil getXibName:@"MarketSalesEditView"] bundle:nil saleActId:objId action:ACTION_CONSTANTS_EDIT fromView:_action];
    marketSalesEditView.isCanDeal = event;
    [self.navigationController pushViewController:marketSalesEditView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma table head 封装事件
- (void)initHeadData:(NSMutableArray *) headList {
    
    self.headList=[NSMutableArray array];
    for (SaleActVo *vo in headList) {
        NameValueItemVO* item=[[NameValueItemVO alloc] initWithVal:vo.name val:[NSString stringWithFormat:@"%d", vo.isCanDeal] andId:vo.saleActId];
        [self.headList addObject:item];
    }
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
    return temps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NameValueItemVO *head = [self.headList objectAtIndex:indexPath.section];
    NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
    LSMarkCell *cell = [LSMarkCell markCellWithTableView:tableView];
    if (self.action == PIECES_DISCOUNT_LIST_VIEW) {
        // N件打折
        SalesNpDiscountVo *item  = [temps objectAtIndex:indexPath.row];
        cell.name = item.name;
    } else if (self.action == BINDING_DISCOUNT_LIST_VIEW){
        // 捆绑打折
        SalesNpDiscountVo *item  = [temps objectAtIndex:indexPath.row];
        cell.name = item.name;
    } else if (self.action == SALES_SEND_OR_SWAP_LIST_VIEW){
        // 满送or换购
        SalesMatchRuleSendVo *item  = [temps objectAtIndex:indexPath.row];
        cell.name = item.name;
    } else if (self.action == SALES_MINUS_LIST_VIEW){
        // 满减
        SalesMatchRuleMinusVo *item  = [temps objectAtIndex:indexPath.row];
        cell.name = item.name;
    } else if (self.action == SALES_COUPON_LIST_VIEW){
        // 优惠券
        SalesCouponVo* item=[temps objectAtIndex:indexPath.row];
        cell.name = item.name;
    } else if (self.action == SPECIAL_OFFER_LIST_VIEW){
        // 优惠券
        LSSalePriceVo *item=[temps objectAtIndex:indexPath.row];
        cell.name = item.name;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    GridColHead4 *headItem = (GridColHead4 *)[tableView dequeueReusableCellWithIdentifier:GridColHead4Indentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead4" owner:self options:nil].lastObject;
    }
    
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem initColHead:head.itemName col2:head.itemId event:[head obtainItemValue].intValue];
    if ([[head obtainItemValue] isEqualToString:@"0"]) {
        [headItem.btnAdd setEnabled:NO];
        [headItem.btnAdd setHidden:YES];
    }
    headItem.delegate = self;
    return headItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    if ([[head obtainItemValue] isEqualToString:@"1"]) {
        return 88;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    if ([[head obtainItemValue] isEqualToString:@"1"]) {
        LSMarkAddView *addView = [LSMarkAddView markAddView];
        __weak typeof(self) wself = self;
        [addView setText:@"添加此促销内活动规则..." addBlock:^{
            [wself showMarkEvent:section];
        }];
        return addView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
#pragma mark - 添加促销活动
- (void)showMarkEvent:(NSInteger)section {
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    NSString *shopId = self.param[@"shopId"];
    if (self.action == PIECES_DISCOUNT_LIST_VIEW) {
        // N件打折
        PiecesDiscountEditView* piecesDiscountEditView = [[PiecesDiscountEditView alloc] initWithNibName:[SystemUtil getXibName:@"PiecesDiscountEditView"] bundle:nil npDiscountId:nil salesId:head.itemId action:ACTION_CONSTANTS_ADD shopId:shopId];
        [self.navigationController pushViewController:piecesDiscountEditView animated:NO];
    }else if (self.action == BINDING_DISCOUNT_LIST_VIEW){
        // 捆绑打折
        BindingDiscountEditView* bindingDiscountEditView = [[BindingDiscountEditView alloc] initWithNibName:[SystemUtil getXibName:@"BindingDiscountEditView"] bundle:nil bindDiscountId:nil salesId:head.itemId action:ACTION_CONSTANTS_ADD shopId:shopId];
        [self.navigationController pushViewController:bindingDiscountEditView animated:NO];
    }else if (self.action == SALES_SEND_OR_SWAP_LIST_VIEW){
        // 满送or换购
        SaleSendOrSwapEditView* saleSendOrSwapEditView = [[SaleSendOrSwapEditView alloc] initWithNibName:[SystemUtil getXibName:@"SaleSendOrSwapEditView"] bundle:nil fullSendId:nil salesId:head.itemId action:ACTION_CONSTANTS_ADD shopId:shopId];
        [self.navigationController pushViewController:saleSendOrSwapEditView animated:NO];
    }else if (self.action == SALES_MINUS_LIST_VIEW){
        // 满减
        SaleMinusEditView* saleMinusEditView = [[SaleMinusEditView alloc] initWithNibName:[SystemUtil getXibName:@"SaleMinusEditView"] bundle:nil minusRuleId:nil salesId:head.itemId action:ACTION_CONSTANTS_ADD shopId:shopId];
        [self.navigationController pushViewController:saleMinusEditView animated:NO];
        
    }else if (self.action == SALES_COUPON_LIST_VIEW){
        // 优惠券
        SaleCouponEditView* saleCouponEditView = [[SaleCouponEditView alloc] initWithNibName:[SystemUtil getXibName:@"SaleCouponEditView"] bundle:nil salesCouponId:nil salesId:head.itemId action:ACTION_CONSTANTS_ADD shopId:shopId];
        [self.navigationController pushViewController:saleCouponEditView animated:NO];
    } else if (self.action == SPECIAL_OFFER_LIST_VIEW) {//特价管理
        LSSpecialSaleEditController *vc = [[LSSpecialSaleEditController alloc] initWithSalesId:head.itemId salePriceId:nil action:ACTION_CONSTANTS_ADD];
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NameValueItemVO *head = [self.headList objectAtIndex:indexPath.section];
    NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
    NSString *shopId = self.param[@"shopId"];
    if (self.action == PIECES_DISCOUNT_LIST_VIEW) {
        // N件打折
        SalesNpDiscountVo* editObj = [temps objectAtIndex:indexPath.row];
        PiecesDiscountEditView* piecesDiscountEditView = [[PiecesDiscountEditView alloc] initWithNibName:[SystemUtil getXibName:@"PiecesDiscountEditView"] bundle:nil npDiscountId:editObj.npDiscountId salesId:head.itemId action:ACTION_CONSTANTS_EDIT shopId:shopId];
        piecesDiscountEditView.isCanDeal = [head obtainItemValue];
        [self.navigationController pushViewController:piecesDiscountEditView animated:NO];
    }else if (self.action == BINDING_DISCOUNT_LIST_VIEW){
        // 捆绑打折
        SalesBindDiscountVo* editObj = [temps objectAtIndex:indexPath.row];
        BindingDiscountEditView* bindingDiscountEditView = [[BindingDiscountEditView alloc] initWithNibName:[SystemUtil getXibName:@"BindingDiscountEditView"] bundle:nil bindDiscountId:editObj.bindDiscountId salesId:head.itemId action:ACTION_CONSTANTS_EDIT shopId:shopId];
        bindingDiscountEditView.isCanDeal = [head obtainItemValue];
        [self.navigationController pushViewController:bindingDiscountEditView animated:NO];
    }else if (self.action == SALES_SEND_OR_SWAP_LIST_VIEW){
        // 满送or换购
        SalesMatchRuleSendVo* editObj = [temps objectAtIndex:indexPath.row];
        SaleSendOrSwapEditView* saleSendOrSwapEditView = [[SaleSendOrSwapEditView alloc] initWithNibName:[SystemUtil getXibName:@"SaleSendOrSwapEditView"] bundle:nil fullSendId:editObj.fullSendId salesId:head.itemId action:ACTION_CONSTANTS_EDIT shopId:shopId];
        saleSendOrSwapEditView.isCanDeal = [head obtainItemValue];
        [self.navigationController pushViewController:saleSendOrSwapEditView animated:NO];
    }else if (self.action == SALES_MINUS_LIST_VIEW){
        // 满减
        SalesMatchRuleMinusVo* editObj = [temps objectAtIndex:indexPath.row];
        SaleMinusEditView* saleMinusEditView = [[SaleMinusEditView alloc] initWithNibName:[SystemUtil getXibName:@"SaleMinusEditView"] bundle:nil minusRuleId:editObj.minusRuleId salesId:head.itemId action:ACTION_CONSTANTS_EDIT shopId:shopId];
        saleMinusEditView.isCanDeal = [head obtainItemValue];
        [self.navigationController pushViewController:saleMinusEditView animated:NO];
    }else if (self.action == SALES_COUPON_LIST_VIEW){
        // 优惠券
        SalesCouponVo *editObj = [temps objectAtIndex:indexPath.row];
        SaleCouponEditView* saleCouponEditView = [[SaleCouponEditView alloc] initWithNibName:[SystemUtil getXibName:@"SaleCouponEditView"] bundle:nil salesCouponId:editObj.couponRuleId salesId:head.itemId action:ACTION_CONSTANTS_EDIT shopId:shopId];
        saleCouponEditView.isCanDeal = [head obtainItemValue];
        [self.navigationController pushViewController:saleCouponEditView animated:NO];
        
    } else if (self.action == SPECIAL_OFFER_LIST_VIEW) {//特价管理
        LSSalePriceVo *editObj = [temps objectAtIndex:indexPath.row];
        LSSpecialSaleEditController *vc = [[LSSpecialSaleEditController alloc] initWithSalesId:head.itemId salePriceId:editObj.id action:ACTION_CONSTANTS_EDIT];
        vc.isCanDeal = [head obtainItemValue];
        vc.shopId = shopId;
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}



@end

