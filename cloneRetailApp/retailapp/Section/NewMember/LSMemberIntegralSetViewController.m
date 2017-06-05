//
//  LSMemberIntegralSetViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberIntegralSetViewController.h"
#import "LSMemberGoodSelectViewController.h"
#import "LSMemberCardBalanceViewController.h"
#import "LSMemberGoodDetailViewController.h"
#import "LSMemberExchangeableNumSetViewController.h"
#import "ScanViewController.h"
#import "NavigateTitle2.h"
#import "SMHeaderItem.h"
#import "SearchBar3.h"
#import "SearchBar.h"
#import "LSFooterView.h"
#import "LSMemberCardBalanceCell.h"
#import "LSMemberGoodCell.h"
#import "LSAlertHelper.h"
#import "LSMemberGoodsGiftVo.h"
#import "KxMenu.h"
#import "TDFComplexConditionFilter.h"
#import "SymbolNumberInputBox.h"
#import "LSMemberConst.h"

@interface LSMemberIntegralSetViewController ()<INavigateEvent ,ISearchBarEvent ,LSFooterViewDelegate ,LSScanViewDelegate ,UITableViewDelegate ,UITableViewDataSource ,TDFConditionFilterDelegate ,SymbolNumberInputClient>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) UITableView *tableView;/*<>*/
@property (nonatomic ,strong) SearchBar3 *searchBar1;/*<服鞋搜索框>*/
@property (nonatomic ,strong) SearchBar *searchBar2;/*<商超搜索框>*/
@property (nonatomic ,strong) LSFooterView *footerView;/*<>*/
@property (nonatomic, strong) TDFComplexConditionFilter *filterView;/**<筛选页面>*/
@property (nonatomic, strong) NSArray *filterModels;/**<筛选页面需要数据>*/
@property (nonatomic ,strong) NSArray *searchTypeItems;/*<searchType 数组>*/
@property (nonatomic ,strong) NSString *searchType;/*<选择的searchType>*/
@property (nonatomic ,strong) NSDictionary *headerTitleDic;/*<section header titles>*/
@property (nonatomic, strong) SMHeaderItem *balanceHeader;/**<卡余额header>*/
@property (nonatomic, strong) SMHeaderItem *goodHeader;/**<商品header>*/
@property (nonatomic, strong) NSArray *goodsArray;/**<可兑换商品array>*/
@property (nonatomic, strong) NSArray *balanceArray;/**<可兑换卡余额array>*/
@property (nonatomic, strong) NSString *keyWords;/**<搜索框关键字>*/
@property (nonatomic, assign) BOOL batchOptional;/**<可批量选择的>*/
@end

@implementation LSMemberIntegralSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchType = @"店内码";
    [self configSubViews];
    [self getGoodGiftList:@""];
    [self configHelpButton:HELP_MEMBER_INTEGRAL_EXCHANGE_SETTING];
}


- (NSArray *)filterModels {
    
    if (!_filterModels) {
    
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:3];
        // 订单状态筛选
        TDFRegularCellModel *orderStatusModel = [[TDFRegularCellModel alloc] initWithOptionName:@"兑换类型" hideStatus:NO];
        NSMutableArray *optionArray = [NSMutableArray arrayWithCapacity:3];
        [optionArray addObject:[TDFFilterItem filterItem:@"全部" itemValue:[NSNull null]]];
        [optionArray addObject:[TDFFilterItem filterItem:@"卡余额" itemValue:@1]];
        [optionArray addObject:[TDFFilterItem filterItem:@"积分商品" itemValue:@2]];
        orderStatusModel.optionItems = [optionArray copy];
        orderStatusModel.resetItemIndex = 0; // 默认选项“待处理”
        [tempArray addObject:orderStatusModel];
        
        // 机构用户隐藏兑换数量设置
        if ([[Platform Instance] getShopMode] != 3) {
            TDFInterValCellModel *vendibleNum1 = [[TDFInterValCellModel alloc] initWithOptionName:@"实体门店可兑数量区间" hideStatus:NO];
            vendibleNum1.lowPlaceholder =  @"最低数";
            vendibleNum1.highPlaceholder = @"最高数";
            [tempArray addObject:vendibleNum1];
            
            // 连锁门店和单店 需判断微店是否关闭
            if ([[Platform Instance] getMicroShopStatus] == 2) {
                TDFInterValCellModel *vendibleNum2 = [[TDFInterValCellModel alloc] initWithOptionName:@"微店可兑数量区间" hideStatus:NO];
                vendibleNum2.lowPlaceholder =  @"最低数";
                vendibleNum2.highPlaceholder = @"最高数";
                [tempArray addObject:vendibleNum2];
            }
        }

        _filterModels = [tempArray copy];
    }
    return _filterModels;
}

- (void)configSubViews {

    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"兑换设置" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
    // searchBar, 服鞋
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        self.searchBar1 = [SearchBar3 searchBar3];
        self.searchBar1.ls_top = self.titleBox.ls_bottom;
        [self.searchBar1 showCondition:YES];
        [self.searchBar1 initDeleagte:self withName:@"店内码" placeholder:@""];
        [self.view addSubview:self.searchBar1];
    } else if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) { //商超
        self.searchBar2 = [[SearchBar alloc] initWithFrame:CGRectMake(0, self.titleBox.ls_bottom, SCREEN_W, 44.0)];
        [self.searchBar2 awakeFromNib];
        [self.searchBar2 initDeleagte:self placeholder:@"条形码/简码/拼音码"];
        [self.view addSubview:self.searchBar2];
    }

    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_W, SCREEN_H-108) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 88.0;
    self.tableView.sectionHeaderHeight = 30.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.footerView = [LSFooterView footerView];

    if ([[Platform Instance] getShopMode] == 3) {
        [self.footerView initDelegate:self btnsArray:@[kFootScan,kFootAdd]];
    } else {
        if (![[Platform Instance] lockAct:ACTION_POINT_EXCHANGE_SET] && [[Platform Instance] lockAct:ACTION_GIFT_GOODS_COUNT_SETTING]) {
            //积分兑换设置 开，积分商品数量设置 关时
            //批量兑换设置页面点操作按钮，隐藏弹出的批量选择框中的实体门店和微店设置可兑换数量选项,目前即隐藏批量按钮
            [self.footerView initDelegate:self btnsArray:@[kFootScan,kFootAdd]];
        } else if ([[Platform Instance] lockAct:ACTION_POINT_EXCHANGE_SET] && ![[Platform Instance] lockAct:ACTION_GIFT_GOODS_COUNT_SETTING]) {
            //积分兑换设置 关，积分商品数量设置 开时
            //隐藏兑换设置列表底部的添加按钮
            [self.footerView initDelegate:self btnsArray:@[kFootScan,kFootBatch]];
        } else {
            [self.footerView initDelegate:self btnsArray:@[kFootScan,kFootBatch,kFootAdd]];
        }
    }

    [self.view addSubview:self.footerView];
    
    self.filterView = [[TDFComplexConditionFilter alloc] initFilter:@"筛选条件" image:@"ico_filter_normal" highlightImage:@"ico_filter_highlighted"];
    self.filterView.delegate = self;
    [self.filterView addToView:self.view withDatas:self.filterModels];
}


- (NSArray *)searchTypeItems {
    if (!_searchTypeItems) {
        
        _searchTypeItems = @[[KxMenuItem menuItem:@"款号"
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

// 进入积分商品库存设置页面：type标示设置微店还是实体
- (void)toExchangeableNumSetPage:(NSInteger)type {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected==YES"];
    NSArray *arr1 = [_balanceArray filteredArrayUsingPredicate:predicate];
    NSArray *arr2 = [_goodsArray filteredArrayUsingPredicate:predicate];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:2];
    if (arr1) {
        [tempArray addObjectsFromArray:arr1];
    }
    if (arr2) {
        [tempArray addObjectsFromArray:arr2];
    }
    
    // check 不支持卡余额设置可兑换数量
    predicate = [NSPredicate predicateWithFormat:@"type==1"];
    NSArray *giftBalanceArray = [tempArray filteredArrayUsingPredicate:predicate];
    if (giftBalanceArray.count>0) {
        [LSAlertHelper showAlert:@"不支持卡余额设置可兑换数量，请重新选择！"];return;
    }
    
    NSString *gifts = [LSMemberGoodsGiftVo jsonStringFromVoList:tempArray];
    LSMemberExchangeableNumSetViewController *vc = [[LSMemberExchangeableNumSetViewController alloc] initWith:type gifts:gifts];
    __weak typeof(self) wself = self;
    vc.callBackBlock = ^{
        [wself.footerView updateButtons:@[kFootScan,kFootBatch,kFootAdd]];
        [wself.titleBox initWithName:@"兑换设置" backImg:Head_ICON_BACK moreImg:nil];
        wself.titleBox.lblRight.text = @"";
        wself.batchOptional = NO;
        wself.goodHeader.selectButton.selected = NO;
        wself.balanceHeader.selectButton.selected = NO;
//        [wself batchSelecte:NO];
        [wself getGoodGiftList:@""];
    };
    [self pushController:vc from:kCATransitionFromRight];
}

#pragma mark - 协议方法
//  ISearchBarEvent, 弹出选择搜索类型选择类别
- (void)selectCondition {
    CGRect rect = CGRectMake(47, self.searchBar1.frame.origin.y, 80, 32);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:self.searchTypeItems];
}


//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        if ([self.titleBox.lblLeft.text isEqualToString:@"返回"]) {
            [self popToLatestViewController:kCATransitionFromLeft];
        } else if ([self.titleBox.lblLeft.text isEqualToString:@"取消"]) {
//            [self.footerView updateButtons:@[kFootScan,kFootBatch,kFootAdd]];
            if ([[Platform Instance] getShopMode] == 3) {
                [self.footerView updateButtons:@[kFootScan,kFootAdd]];
            } else {
                if (![[Platform Instance] lockAct:ACTION_POINT_EXCHANGE_SET] && [[Platform Instance] lockAct:ACTION_GIFT_GOODS_COUNT_SETTING] ) {
                    [self.footerView updateButtons:@[kFootScan,kFootAdd]];
                } else if ([[Platform Instance] lockAct:ACTION_POINT_EXCHANGE_SET] && ![[Platform Instance] lockAct:ACTION_GIFT_GOODS_COUNT_SETTING] ) {
                    [self.footerView updateButtons:@[kFootScan,kFootBatch]];
                }else {
                    [self.footerView updateButtons:@[kFootScan,kFootBatch,kFootAdd]];
                }
            }
            [self.titleBox initWithName:@"兑换设置" backImg:Head_ICON_BACK moreImg:nil];
            self.titleBox.lblRight.text = @"";
            _batchOptional = NO;
            [self batchSelecte:NO];
        }
    } else if (event == DIRECT_RIGHT) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected==YES"];
        NSArray *arr1 = [_balanceArray filteredArrayUsingPredicate:predicate];
        NSArray *arr2 = [_goodsArray filteredArrayUsingPredicate:predicate];
        if (arr1.count + arr2.count == 0) {
            [LSAlertHelper showAlert:@"请先选择卡余额或积分商品! "]; return;
        }
        __weak typeof(self) wself = self;
        
        NSArray *titles = nil;
        if ([[Platform Instance] getMicroShopStatus] == 2) {
            titles = @[@"设置实体门店可兑换数量",@"设置微店可兑换数量"];
        } else {
            titles = @[@"设置实体门店可兑换数量"];
        }
        [LSAlertHelper showSheet:@"请选择批量操作" cancle:@"取消" cancleBlock:nil
                     selectItems:titles selectdblock:^(NSInteger index) {
                         [wself toExchangeableNumSetPage:index+1];
        }];
    }
}

- (void)pushMenuItem:(id)sender {
    
    KxMenuItem *item = (KxMenuItem *)sender;
    [self.searchBar1 changeLimitCondition:item.title];
    if ([item.title isEqualToString:@"款号"]) {
        self.searchType = @"款号";
    } else if ([item.title isEqualToString:@"条形码"]) {
        self.searchType = @"条形码";
    } else if ([item.title isEqualToString:@"店内码"]) {
        self.searchType = @"店内码";
    } else if ([item.title isEqualToString:@"拼音码"]) {
        self.searchType = @"拼音码";
    }
}

// LSFooterViewDelegate
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [LSAlertHelper showSheet:nil cancle:@"取消" cancleBlock:nil selectItems:@[@"积分兑换商品",@"积分兑换卡余额"] selectdblock:^(NSInteger index) {
            if (index == 0) {
                LSMemberGoodSelectViewController *vc = [[LSMemberGoodSelectViewController alloc] init];
                [self pushController:vc from:kCATransitionFromRight];
            }
            else if (index == 1) {
                LSMemberCardBalanceViewController *vc = [[LSMemberCardBalanceViewController alloc] init:ACTION_CONSTANTS_ADD vo:nil];
                [self pushController:vc from:kCATransitionFromRight];
            }
        }];
    } else if ([footerType isEqualToString:kFootScan]) {
        [self scanStart];
    } else if ([footerType isEqualToString:kFootBatch]) {
        // 切换界面到 批量"选择兑换设置"界面
//        if (self.headerTitleDic.count == 0) {
//            [LSAlertHelper showAlert:@"请先添加可兑换商品或卡余额!"]; return;
//        }
        [self.footerView updateButtons:@[kFootSelectAll,kFootSelectNo]];
        [self.titleBox initWithName:@"选择兑换设置" backImg:Head_ICON_CANCEL moreImg:Head_ICON_CONFIRM];
        self.titleBox.lblRight.text = @"操作";
        _batchOptional = YES;
        [self.tableView reloadData];
    } else if ([footerType isEqualToString:kFootSelectAll]) {
        [self batchSelecte:YES];
    } else if ([footerType isEqualToString:kFootSelectNo]) {
        [self batchSelecte:NO];
    }
}

// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord {
    _keyWords = keyWord;
    [self getGoodGiftList:keyWord];
}

#pragma mark - 扫一扫
// ISearchBarEvent
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self pushController:vc from:kCATransitionFromRight];
}

// 扫一扫
// LSScanViewDelegate
- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [LSAlertHelper showAlert:message block:nil];
}

- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    
    if ([NSString isNotBlank:scanString]) {
        if (self.searchBar1) {
            self.searchBar1.txtKeyWord.text = scanString;
        } else {
            self.searchBar2.keyWordTxt.text = scanString;
        }
        [self getGoodGiftList:scanString];
    }
}

// TDFConditionFilterDelegate
- (BOOL)tdf_filterWillShow {
    return [self.view endEditing:YES];
}

- (void)tdf_filterCompleted {
    [self getGoodGiftList:_keyWords];
}

- (void)tdf_filter:(TDFComplexConditionFilter *)filter actionWithCellModel:(TDFFilterMoel *)model {
    
    if (model.type == TDF_IntervalFilterCell) {
        TDFInterValCellModel *intervalModel = (TDFInterValCellModel *)model;
        NSString *title = [intervalModel noticeTitle];
        NSString *data = [intervalModel currentNumberString];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
        [SymbolNumberInputBox initData:data];
        [SymbolNumberInputBox show:title client:self isFloat:NO isSymbol:NO event:[self.filterModels indexOfObject:model]];
    }
}

// SymbolNumberInputClient
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    
    TDFInterValCellModel *model = self.filterModels[eventType];
    if (model.currentAction == TDF_Action_EditLowRange) {
        model.lowRange = val;
    } else {
        model.highRange = val;
    }
    // 实体门店可兑数量区间与微店可兑数量区间查询互斥，当实体门店可兑数量区间输入值时，需同时将微店可兑数量区间清空，反之相同。
    if ([model isEqual:self.filterModels.lastObject]) {
        // 微店可兑换积分区间
        TDFInterValCellModel *model = [self.filterModels objectAtIndex:self.filterModels.count-2];
        [model resetSelf];
        
    } else if ([model isEqual:[self.filterModels objectAtIndex:self.filterModels.count-2]]) {
        // 实体门店可兑换数量区间
        TDFInterValCellModel *model = self.filterModels.lastObject;
        [model resetSelf];
    }
}

#pragma mark - UITableView

- (void)batchSelecte:(BOOL)selected {
    _goodHeader.selectButton.selected = selected;
    _balanceHeader.selectButton.selected = selected;
    [_balanceArray setValue:@(selected) forKeyPath:@"selected"];
    [_goodsArray setValue:@(selected) forKeyPath:@"selected"];
    [self.tableView reloadData];
}

- (SMHeaderItem *)balanceHeader {
    if (!_balanceHeader) {
        __weak typeof(self) wself = self;
        _balanceHeader = [SMHeaderItem sm_headerItem:_batchOptional callBackBlack:^(UIButton *sender) {
            [_balanceArray setValue:@(sender.selected) forKeyPath:@"selected"];
            [wself.tableView reloadData];
        }];
         _balanceHeader.lblVal.text = @"卡余额";
    }
    _balanceHeader.selectButton.hidden = !_batchOptional;
    return _balanceHeader;
}

- (SMHeaderItem *)goodHeader {
    if (!_goodHeader) {
        __weak typeof(self) wself = self;
        _goodHeader = [SMHeaderItem sm_headerItem:_batchOptional callBackBlack:^(UIButton *sender) {
            [_goodsArray setValue:@(sender.selected) forKeyPath:@"selected"];
            [wself.tableView reloadData];
        }];
        _goodHeader.lblVal.text = @"积分商品";
    }
    _goodHeader.selectButton.hidden = !_batchOptional;
    return _goodHeader;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.headerTitleDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[self.headerTitleDic allKeys][section] isEqualToString:@"giftMoney"]) {
        return _balanceArray.count;
    }
    return _goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[self.headerTitleDic allKeys][indexPath.section] isEqualToString:@"giftMoney"]) {
        
        LSMemberCardBalanceCell *cell1 = [LSMemberCardBalanceCell mb_balanceCellWith:tableView optional:_batchOptional];
        [cell1 setData:_balanceArray[indexPath.row]];
        return cell1;
    }
    else {
        LSMemberGoodCell *cell2 = [LSMemberGoodCell mb_goodCellWith:tableView optional:_batchOptional];
        [cell2 setGiftGoodVo:_goodsArray[indexPath.row]];
        return cell2;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *title = self.headerTitleDic.allValues[section];
    if ([self.balanceHeader.lblVal.text isEqualToString:title]) {
        return self.balanceHeader;
    }
    return self.goodHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_batchOptional) {
        if ([[self.headerTitleDic allKeys][indexPath.section] isEqualToString:@"giftMoney"]) {
            LSMemberCardBalanceViewController *vc = [[LSMemberCardBalanceViewController alloc] init:ACTION_CONSTANTS_EDIT vo:_balanceArray[indexPath.row]];
            [self pushController:vc from:kCATransitionFromRight];
        } else {
            LSMemberGoodDetailViewController *vc = [[LSMemberGoodDetailViewController alloc] init:ACTION_CONSTANTS_EDIT selectObj:_goodsArray[indexPath.row]];
            [self pushController:vc from:kCATransitionFromRight];
        }
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected==YES"];
        if ([[self.headerTitleDic allKeys][indexPath.section] isEqualToString:@"giftMoney"]) {
           
            LSMemberCardBalanceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectButton.selected = !cell.selectButton.selected;
            LSMemberGoodsGiftVo *vo = _balanceArray[indexPath.row];
            vo.selected = !vo.selected;
            NSArray *array = [_balanceArray filteredArrayUsingPredicate:predicate];
            if (array.count == _balanceArray.count) {
                self.balanceHeader.selectButton.selected = YES;
            } else if (array.count == 0) {
                self.balanceHeader.selectButton.selected = NO;
            }
            
        } else {
            LSMemberGoodCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectButton.selected = !cell.selectButton.selected;
            LSMemberGoodsGiftVo *vo = _goodsArray[indexPath.row];
            vo.selected = !vo.selected;
            NSArray *array = [_goodsArray filteredArrayUsingPredicate:predicate];
            if (array.count == _goodsArray.count) {
                self.goodHeader.selectButton.selected = YES;
            } else if (array.count == 0) {
                self.goodHeader.selectButton.selected = NO;
            }
        }
    }
}

// 搜索到一条信息，直接进入对应的详情页
- (void)searchSingleResultAction:(LSMemberGoodsGiftVo *)giftVo {
    
    if (giftVo.type.integerValue == 1) {
        LSMemberCardBalanceViewController *vc = [[LSMemberCardBalanceViewController alloc] init:ACTION_CONSTANTS_EDIT vo:giftVo];
        [self pushController:vc from:kCATransitionFromRight];
    } else if (giftVo.type.integerValue == 2) {
        LSMemberGoodDetailViewController *vc = [[LSMemberGoodDetailViewController alloc] init:ACTION_CONSTANTS_EDIT selectObj:giftVo];
        [self pushController:vc from:kCATransitionFromRight];
    }
}

#pragma mark - 网络请求

// 获取积分兑换余额与商品列表
- (void)getGoodGiftList:(NSString *)keyWord {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        [param setValue:self.searchType forKey:@"searchType"];
    }
    // 搜索关键字
    [param setValue:keyWord forKey:@"searchCode"];
    // 兑换类型：null-全部，1-积分兑换余额 2-积分兑换商品
    TDFRegularCellModel *exchangeType = self.filterModels.firstObject;
    [param setValue:exchangeType.currentValue forKey:@"giftType"];
    
    // 先判断是否有 可兑换数量区间Model
    if ([[Platform Instance] getShopMode] != 3) {
       
        // 实体门店可兑换区间设置
        TDFInterValCellModel *entity = self.filterModels[1];
        if ([NSString isNotBlank:entity.lowRange] || [NSString isNotBlank:entity.highRange]) {
            id minGiftStrore = [NSString isNotBlank:entity.lowRange]?@(entity.lowRange.integerValue):[NSNull null];
            id maxGiftStore = [NSString isNotBlank:entity.highRange]?@(entity.highRange.integerValue):[NSNull null];
            [param setValue:minGiftStrore forKey:@"minGiftStore"];
            [param setValue:maxGiftStore forKey:@"maxGiftStore"];
        }
       
        if ([[Platform Instance] getMicroShopStatus] == 2) {
            // 微店可兑换数量区间设置
            TDFInterValCellModel *wechat = self.filterModels.lastObject;
            if ([NSString isNotBlank:wechat.lowRange] || [NSString isNotBlank:wechat.highRange]) {
                
                id minWeiXinGiftStore = [NSString isNotBlank:wechat.lowRange]?@(wechat.lowRange.integerValue):[NSNull null];
                id maxWeiXinGiftStore = [NSString isNotBlank:wechat.highRange]?@(wechat.highRange.integerValue):[NSNull null];
                [param setValue:minWeiXinGiftStore forKey:@"minWeiXinGiftStore"];
                [param setValue:maxWeiXinGiftStore forKey:@"maxWeiXinGiftStore"];
            }
        }
    }
    
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:@"gift/goodsGiftListForSet" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"returnCode"] isEqualToString:@"success"]) {
            
            NSArray *tempArr = [LSMemberGoodsGiftVo voListFromJsonArray:json[@"goodsGiftList"]];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
            NSMutableArray *gArr = [[NSMutableArray alloc] init]; // 可兑换商品
            NSMutableArray *bArr = [[NSMutableArray alloc] init]; // 可兑换卡余额
            [tempArr enumerateObjectsUsingBlock:^(LSMemberGoodsGiftVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.type.integerValue == 1) {
                    [bArr addObject:obj];
                    [dic setValue:@"卡余额" forKey:@"giftMoney"];
                } else if (obj.type.integerValue == 2) {
                    [gArr addObject:obj];
                    [dic setValue:@"积分商品" forKey:@"giftGood"];
                }
            }];
            
            wself.goodsArray = [gArr copy];
            wself.balanceArray = [bArr copy];
            
            // 搜索时 keyword才会不为空
            if ([NSString isNotBlank:keyWord]) {
                // 只搜索到一条信息，直接进入对应的详情页
                if (tempArr.count == 1) {
                    [wself performSelector:@selector(searchSingleResultAction:) withObject:tempArr[0] afterDelay:0.5];
                }
            }
           
            wself.headerTitleDic = [dic copy];
            if (wself.batchOptional) {
                wself.goodHeader.selectButton.selected = NO;
                wself.balanceHeader.selectButton.selected = NO;
            }
            [wself.tableView reloadData];
            wself.tableView.ls_show = YES;
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

@end
