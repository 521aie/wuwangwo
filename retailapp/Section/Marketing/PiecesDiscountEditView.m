//
//  PiecesDiscountEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PiecesDiscountEditView.h"
#import "ItemTitle.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "UIHelper.h"
#import "MarketRender.h"
#import "NavigateTitle2.h"
#import "PiecesDiscountEditCell.h"
#import "ObjectUtil.h"
#import "MarketModuleEvent.h"
#import "OptionPickerBox.h"
#import "SymbolNumberInputBox.h"
#import "INameItem.h"
#import "UIView+Sizes.h"
#import "SaleRegulationAddView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SalesNpDiscountVo.h"
#import "XHAnimalUtil.h"
#import "DiscountGoodsVo.h"
#import "LSMarketListController.h"
#import "SalesStyleAreaView.h"
#import "SalesGoodsAreaView.h"

#define BUY_STYLE_COUNT 100

@interface PiecesDiscountEditView ()

@property (nonatomic, strong) MarketService* marketService;

@property (nonatomic, strong) NSMutableArray *datas;

/**
 N件打折Vo
 */
@property (nonatomic, strong) SalesNpDiscountVo *salesNpDiscountVo;

/**
 打折规则Vo
 */
@property (nonatomic, strong) DiscountGoodsVo *discountGoodsVo;

/**
 N件打折ID
 */
@property (nonatomic, strong) NSString* npDiscountId;

@property (nonatomic, strong) NSString* shopId;

/**
 促销ID
 */
@property (nonatomic, strong) NSString* salesId;

@property (nonatomic) int action;

/**
 是否保存
 */
@property (nonatomic) BOOL saveFlg;

/**
 1: 右上角保存按键保存 2: 点击款式/商品信息保存
 */
@property (nonatomic, strong) NSString *saveWay;

/**
 1: 款式信息 2: 商品信息
 */
@property (nonatomic, strong) NSString *type;

/**
 是否页面刷新 1表示：是
 */
@property (nonatomic) short isFresh;

/**
 是否从范围页面返回，1表示：是
 */
@property (nonatomic) short fromAreaView;

/**
 1表示添加状态，2表示编辑状态
 */
@property (nonatomic) short status;

@end

@implementation PiecesDiscountEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil npDiscountId:(NSString *)npDiscountId salesId:(NSString*) salesId action:(int) action shopId:(NSString*) shopId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _npDiscountId = npDiscountId;
        _action = action;
        _shopId = shopId;
        _salesId = salesId;
        self.datas = [[NSMutableArray alloc] init];
        _marketService = [ServiceFactory shareInstance].marketService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configHelpButton:HELP_MARKET_PART_N_DISCOUNT_DETAIL];
    [self initNotifaction];
    [self initHead];
    [self initMainView];
    [self loaddatas];
    [UIHelper clearColor:self.headInfoView];
    [UIHelper clearColor:self.footInfoView];
    [UIHelper refreshUI:self.footInfoView];
    self.mainGrid.tableFooterView = self.footInfoView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loaddatas
{
    [self.btnDel setHidden:_action == ACTION_CONSTANTS_ADD];
    if (_action == ACTION_CONSTANTS_ADD) {
        _status = 1;
        self.titleBox.lblTitle.text = @"添加";
        [self clearDo];
        [self showHeadInfoView];
    }else{
        _status = 2;
        [self selectSaleNpDiscountDetail];
    }
}

#pragma 从打折规则页面返回
- (void)loaddatasFromSaleRegulationAddView:(DiscountGoodsVo*) discountGoodsVo
{
    [_datas addObject:discountGoodsVo];
    [self.mainGrid reloadData];
    [self.titleBox editTitle:YES act:self.action];
    [self showFootInfoView];
}

#pragma 从促销商品、款式范围返回
- (void)loaddatasFromGoodsOrStyleListView
{
    _saveFlg = YES;
    _action = ACTION_CONSTANTS_EDIT;
    _fromAreaView = 1; // 表示从返回页面返回
    [self selectSaleNpDiscountDetail];
}

#pragma 查询N件打折详情
- (void)selectSaleNpDiscountDetail
{
    __weak PiecesDiscountEditView* weakSelf = self;
    [_marketService selectSalesNpDiscountDetail:_npDiscountId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma 后台返回数据封装
- (void)responseSuccess:(id)json
{
    _salesNpDiscountVo = [SalesNpDiscountVo convertToSalesNpDiscountVo:[json objectForKey:@"salesNpDiscountVo"]];
    self.titleBox.lblTitle.text = @"第N件打折规则";
    [self fillModel];
    self.datas = _salesNpDiscountVo.discountVoList;
    [self.mainGrid reloadData];
    [self showHeadInfoView];
    [self showFootInfoView];
    
    // 当从范围页面返回时，取消和保存按钮不显示，返回按钮显示
    if (_fromAreaView == 1) {
        [self.titleBox editTitle:NO act:self.action];
        _fromAreaView = 0;
    }
}

- (void)isEdit:(BOOL) flg
{
    if (flg) {
        [self.lsGroupType editEnable:YES];
        [self.lsBuyStyleCount editEnable:YES];
        [self.rdoIsGoodsArea isEditable:YES];
        [self.lsExceedRate editEnable:YES];
        [self.rdoRateMax isEditable:YES];
        [self.btnDel setHidden:NO];
    } else {
        [self.lsGroupType editEnable:NO];
        [self.lsBuyStyleCount editEnable:NO];
        [self.rdoIsGoodsArea isEditable:NO];
        [self.lsExceedRate editEnable:NO];
        [self.rdoRateMax isEditable:NO];
        [self.btnDel setHidden:YES];
    }
}

#pragma 添加页面初始化
- (void)clearDo
{
    [self.lsGroupType initData:[MarketRender obtainGroupType:1] withVal:[NSString stringWithFormat:@"1"]];
    [self.lsBuyStyleCount visibal:NO];
    [self.lsBuyStyleCount initData:nil withVal:nil];
    [self.rdoIsGoodsArea initData:@"0"];
    [self.rdoRateMax initData:@"0"];
    
    [self.lsExceedRate initData:@"100.00" withVal:@"100.00"];
    [self.lsExceedRate visibal:NO];
    [self.lsStyleArea visibal:NO];
    [self.lsGoodsArea visibal:NO];
}

#pragma 详情页面显示
- (void)fillModel
{
    [self.lsGroupType initData:[MarketRender obtainGroupType:_salesNpDiscountVo.groupType] withVal:[NSString stringWithFormat:@"%tu", _salesNpDiscountVo.groupType]];
    [self.lsBuyStyleCount initData:[NSString stringWithFormat:@"%tu", _salesNpDiscountVo.containStyleNum] withVal:[NSString stringWithFormat:@"%tu", _salesNpDiscountVo.containStyleNum]];
    if (_salesNpDiscountVo.groupType == 3) {
        [self.lsBuyStyleCount visibal:YES];
    } else {
        [self.lsBuyStyleCount visibal:NO];
    }
    if (_salesNpDiscountVo.goodsScope == 1) {
        //1表示所有范围，开关关闭。2表示部分，开关打开
        [self.rdoIsGoodsArea initData:@"0"];
    } else {
        [self.rdoIsGoodsArea initData:@"1"];
    }
    if ([[self.rdoIsGoodsArea getStrVal] isEqualToString:@"0"]) {
        [self.lsStyleArea visibal:NO];
        [self.lsGoodsArea visibal:NO];
    } else {
        [self.lsStyleArea visibal:YES];
        [self.lsGoodsArea visibal:YES];
        
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
            [self.lsStyleArea visibal:YES];
        } else {
            [self.lsStyleArea visibal:NO];
        }
    }
    
    [self.rdoRateMax initData:[NSString stringWithFormat:@"%d", _salesNpDiscountVo.isDiscountCap]];
    
    if ([[self.rdoRateMax getStrVal] isEqualToString:@"1"]) {
        [self.lsExceedRate visibal:YES];
        [self.lsExceedRate initData:[NSString stringWithFormat:@"%.2f", _salesNpDiscountVo.exceedRate] withVal:[NSString stringWithFormat:@"%.2f", _salesNpDiscountVo.exceedRate]];
    } else {
        [self.lsExceedRate visibal:NO];
        [self.lsExceedRate initData:[NSString stringWithFormat:@"%.2f", _salesNpDiscountVo.exceedRate] withVal:[NSString stringWithFormat:@"%.2f", _salesNpDiscountVo.exceedRate]];
    }
    
    
    if ([self.isCanDeal isEqualToString:@"0"]) {
        [self isEdit:NO];
    }
}

#pragma 页面数据初始化
- (void)initMainView
{
    self.TitBase.lblName.text = @"促销规则设置";
    [self.lsGroupType initLabel:@"购买组合方式" withHit:nil delegate:self];
    [self.lsBuyStyleCount initLabel:@"▪︎ 包含款数" withHit:nil isrequest:YES delegate:self];
    [self.rdoIsGoodsArea initLabel:@"指定商品范围" withHit:nil delegate:self];
    [self.lsStyleArea initLabel:@"▪︎ 款式范围" withHit:nil delegate:self];
    self.lsStyleArea.lblVal.placeholder = @"";
    [self.lsStyleArea.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.lsGoodsArea initLabel:@"▪︎ 商品范围" withHit:nil delegate:self];
    self.lsGoodsArea.lblVal.placeholder = @"";
    [self.lsGoodsArea.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    self.TitSalesRegulation.lblName.text = @"折扣率设置";
    [self.rdoRateMax initLabel:@"折扣封顶" withHit:nil delegate:self];
    [self.lsExceedRate initLabel:@"▪︎ 超出的商品折扣率(%)" withHit:nil isrequest:YES delegate:self];
    
    self.lsGroupType.tag = PIECES_DISCOUNT_EDIT_GROUPTYPE;
    self.rdoIsGoodsArea.tag = PIECES_DISCOUNT_EDIT_ISGOODSAREA;
    self.lsStyleArea.tag = PIECES_DISCOUNT_EDIT_STYLEAREA;
    self.lsGoodsArea.tag = PIECES_DISCOUNT_EDIT_GOODSAREA;
    self.lsExceedRate.tag = PIECES_DISCOUNT_EDIT_EXCEEDRATE;
    self.lsBuyStyleCount.tag = BUY_STYLE_COUNT;
    self.rdoRateMax.tag = PIECES_DISCOUNT_EDIT_RATEMAX;
    
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        [self.lsStyleArea visibal:YES];
    } else {
        [self.lsStyleArea visibal:NO];
    }
}

#pragma table head 部分
- (void)showHeadInfoView
{
    [UIHelper refreshUI:self.headInfoView];
    self.mainGrid.tableHeaderView = self.headInfoView;
}

#pragma table foot 部分
- (void)showFootInfoView
{
    if (self.datas.count >= 6) {
        [self.addView setLs_height:0];
        self.addView.hidden = YES;
    } else {
        [self.addView setLs_height:48];
        self.addView.hidden = NO;
    }
    if ([self.isCanDeal isEqualToString:@"0"]) {
        [self.addView setLs_height:0];
        self.addView.hidden = YES;
    }
    
    [UIHelper refreshUI:self.footInfoView];
    self.mainGrid.tableFooterView = self.footInfoView;
}

#pragma mark 导航栏事件
- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        // 返回到促销活动一览
        if (_isFresh == 1) {
            if (_status == 1) {
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LSMarketListController class]]) {
                        LSMarketListController *listView = (LSMarketListController *)vc;
                        [listView loadDatasFromSalesRegulationEditView:ACTION_CONSTANTS_ADD salesId:_salesId];
                    }
                }
            } else if (_status == 2) {
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LSMarketListController class]]) {
                        LSMarketListController *listView = (LSMarketListController *)vc;
                        [listView loadDatasFromSalesRegulationEditView:ACTION_CONSTANTS_EDIT salesId:_salesId];
                    }
                }
            }
        }
        
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        _saveWay = @"1";
        [self save];
    }
}

#pragma mark 下拉框事件
- (void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag == PIECES_DISCOUNT_EDIT_GROUPTYPE){
        [OptionPickerBox initData:[MarketRender listGroupType]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj.tag == PIECES_DISCOUNT_EDIT_EXCEEDRATE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
    } else if (obj.tag == PIECES_DISCOUNT_EDIT_STYLEAREA){
        _saveWay = @"2";
        _type = @"1";
        if (!(!_saveFlg && _action == ACTION_CONSTANTS_EDIT)) {
            [self save];
        } else {
            // 跳转到款式范围页面
            SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:_npDiscountId discountType:@"1" shopId:_shopId action:PIECES_DISCOUNT_LIST_VIEW];
            salesStyleAreaView.isCanDeal = self.isCanDeal;
            [self.navigationController pushViewController:salesStyleAreaView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
    } else if (obj.tag == PIECES_DISCOUNT_EDIT_GOODSAREA){
        _saveWay = @"2";
        _type = @"2";
        if (!(!_saveFlg && _action == ACTION_CONSTANTS_EDIT)) {
            [self save];
        } else {
            // 跳转到商品范围页面
            SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:_npDiscountId discountType:@"1" shopId:_shopId action:PIECES_DISCOUNT_LIST_VIEW];
            salesGoodsAreaView.isCanDeal = self.isCanDeal;
            [self.navigationController pushViewController:salesGoodsAreaView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
    } else if (obj.tag == BUY_STYLE_COUNT) {
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:0];
    }
    
    [self showHeadInfoView];
}

#pragma 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == PIECES_DISCOUNT_EDIT_GROUPTYPE) {
        [self.lsGroupType changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemId] isEqualToString:@"3"]) {
            [self.lsBuyStyleCount visibal:YES];
            [self.lsBuyStyleCount initData:nil withVal:nil];
        } else {
            [self.lsBuyStyleCount visibal:NO];
        }
    }
    [self showHeadInfoView];
    return YES;
}

#pragma mark - SymbolNumberInputClient协议
- (void) numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType==PIECES_DISCOUNT_EDIT_EXCEEDRATE) {
        
        if (val.doubleValue>100.00) {
            [AlertBox show:@"超出的商品折扣率(%)不能超过100.00，请重新输入!"];
            return;
            
        }else{
            if ([NSString isBlank:val]) {
                val = nil;
            } else {
                val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
            }
        }
        
        [self.lsExceedRate changeData:val withVal:val];
    } else if (eventType == BUY_STYLE_COUNT) {
        if ([NSString isBlank:val]) {
            val = nil;
        } else {
            val = [NSString stringWithFormat:@"%d",val.intValue];
        }

        [self.lsBuyStyleCount changeData:val withVal:val];
    }
}

#pragma 开关事件
- (void)onItemRadioClick:(EditItemRadio*)obj
{
    BOOL result = [[obj getStrVal] isEqualToString:@"1"];
    
    if (obj.tag == PIECES_DISCOUNT_EDIT_ISGOODSAREA) {
        if (result) {
            if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
                //判断商超、服鞋模式
                [self.lsStyleArea visibal:YES];
            }
             [self.lsGoodsArea visibal:YES];
        } else {
            [self.lsStyleArea visibal:NO];
            [self.lsGoodsArea visibal:NO];
        }
    } else if (obj.tag == PIECES_DISCOUNT_EDIT_RATEMAX) {
        if (result) {
            [self.lsExceedRate visibal:YES];
        } else {
            [self.lsExceedRate visibal:NO];
        }
    }
    
    [self showHeadInfoView];
    [self showFootInfoView];
}

#pragma 点击删除打折规则事件
- (void)delObjEvent:(NSString *)event obj:(id)obj
{
    _discountGoodsVo = (DiscountGoodsVo*) obj;
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle:[NSString stringWithFormat:@"确认删除折扣率设置[%.2f％]吗?", _discountGoodsVo.rate]
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles: @"确认", nil];
    menu.tag = 2;
    [menu showInView:self.view];
}

#pragma 添加打折规则
- (IBAction)addRegulation:(id)sender
{
    SaleRegulationAddView* saleRegulationAddView = [[SaleRegulationAddView alloc] initWithNibName:[SystemUtil getXibName:@"SaleRegulationAddView"] bundle:nil goodsCount:(int)(self.datas.count + 1) fromViewTag:PIECES_DISCOUNT_EDIT_VIEW discountId:_npDiscountId countList:nil];
    [self.navigationController pushViewController:saleRegulationAddView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma table部分
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PiecesDiscountEditCell *detailItem = (PiecesDiscountEditCell *)[self.mainGrid dequeueReusableCellWithIdentifier:PiecesDiscountEditCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"PiecesDiscountEditCell" owner:self options:nil].lastObject;
    }
    
    detailItem.delegate = self;
    if ([ObjectUtil isNotEmpty:self.datas]) {
        DiscountGoodsVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.discountGoodsVo = item;
        detailItem.lblName.text = [NSString stringWithFormat:@"购买第%d件", (int)(indexPath.row + 1)];
        detailItem.lblRate.text = [NSString stringWithFormat:@"折扣率:%.2f％", item.rate];
        if ([self.isCanDeal isEqualToString:@"0"]) {
            [detailItem.btnDel setHidden:YES];
            [detailItem.btnDel setEnabled:NO];
        }
        
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

#pragma mark UITableView无section列表
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

#pragma 保存事件
- (void)save
{
    if (![self isValid]){
        return;
    }
    
    // 返回刷新
    _isFresh = 1;
    
    __weak PiecesDiscountEditView* weakSelf = self;
    if (_action == ACTION_CONSTANTS_ADD) {
        _salesNpDiscountVo = [[SalesNpDiscountVo alloc] init];
        _salesNpDiscountVo.salesId = _salesId;
        _salesNpDiscountVo.isDiscountCap = [self.rdoRateMax getStrVal].intValue;
        if (!self.lsExceedRate.isHidden) {
            _salesNpDiscountVo.exceedRate = [self.lsExceedRate getStrVal].doubleValue;
        } else {
            _salesNpDiscountVo.exceedRate = 100.00;
        }
        _salesNpDiscountVo.goodsCount = self.datas.count;
        _salesNpDiscountVo.groupType = [self.lsGroupType getStrVal].integerValue;
        if ([NSString isNotBlank:[self.lsBuyStyleCount getStrVal]]) {
            _salesNpDiscountVo.containStyleNum = [self.lsBuyStyleCount getStrVal].integerValue
            ;
        }
        if ([self.rdoIsGoodsArea getStrVal].integerValue == 0) {
            _salesNpDiscountVo.goodsScope = 1;
        } else {
            _salesNpDiscountVo.goodsScope = 2;
        }
        
        int count = 1;
        for (DiscountGoodsVo* tempVo in _datas) {
            tempVo.sortCode = count;
            count ++;
        }
        
        [_marketService saveSalesNpDiscountDetail:[SalesNpDiscountVo getDictionaryData:_salesNpDiscountVo] discountGoodsVoList:[DiscountGoodsVo converToDicArr:self.datas] operateType:@"add" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            if ([_saveWay isEqualToString:@"1"]) {
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LSMarketListController class]]) {
                        LSMarketListController *listView = (LSMarketListController *)vc;
                        [listView loadDatasFromSalesRegulationEditView:ACTION_CONSTANTS_ADD salesId:_salesId];
                    }
                }
                [self.navigationController popViewControllerAnimated:NO];
            } else {
                _npDiscountId = [json objectForKey:@"npDiscountId"];
                if ([_type isEqualToString:@"1"]) {
                    SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:_npDiscountId discountType:@"1" shopId:_shopId action:PIECES_DISCOUNT_LIST_VIEW];
                    self.isCanDeal = @"1";
                    salesStyleAreaView.isCanDeal = @"1";
                    salesStyleAreaView.operateMode = @"edit";
                    [self.navigationController pushViewController:salesStyleAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                } else {
                    SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:_npDiscountId discountType:@"1" shopId:_shopId action:PIECES_DISCOUNT_LIST_VIEW];
                    self.isCanDeal = @"1";
                    salesGoodsAreaView.isCanDeal = @"1";
                    salesGoodsAreaView.operateMode = @"edit";
                    [self.navigationController pushViewController:salesGoodsAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                }
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else{
        _salesNpDiscountVo.salesId = _salesId;
        _salesNpDiscountVo.isDiscountCap = [self.rdoRateMax getStrVal].intValue;
        if (!self.lsExceedRate.isHidden) {
            _salesNpDiscountVo.exceedRate = [self.lsExceedRate getStrVal].doubleValue;
        } else {
            _salesNpDiscountVo.exceedRate = 100.00;
        }
        _salesNpDiscountVo.goodsCount = self.datas.count;
        _salesNpDiscountVo.groupType = [self.lsGroupType getStrVal].integerValue;
        if ([NSString isNotBlank:[self.lsBuyStyleCount getStrVal]]) {
            _salesNpDiscountVo.containStyleNum = [self.lsBuyStyleCount getStrVal].integerValue
            ;
        }
        if ([self.rdoIsGoodsArea getStrVal].integerValue == 0) {
            _salesNpDiscountVo.goodsScope = 1;
        } else {
            _salesNpDiscountVo.goodsScope = 2;
        }
        
        int count = 1;
        for (DiscountGoodsVo* tempVo in _datas) {
            tempVo.sortCode = count;
            count ++;
        }
        
        [_marketService saveSalesNpDiscountDetail:[SalesNpDiscountVo getDictionaryData:_salesNpDiscountVo] discountGoodsVoList:[DiscountGoodsVo converToDicArr:self.datas] operateType:@"edit" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            if ([_saveWay isEqualToString:@"1"]) {
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LSMarketListController class]]) {
                        LSMarketListController *listView = (LSMarketListController *)vc;
                        [listView loadDatasFromSalesRegulationEditView:ACTION_CONSTANTS_EDIT salesId:_salesId];
                    }
                }
                [self.navigationController popViewControllerAnimated:NO];
            } else {
                if ([_type isEqualToString:@"1"]) {
                    SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:_npDiscountId discountType:@"1" shopId:_shopId action:PIECES_DISCOUNT_LIST_VIEW];
                        salesStyleAreaView.isCanDeal = self.isCanDeal;
                    [self.navigationController pushViewController:salesStyleAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                } else {
                    SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:_npDiscountId discountType:@"1" shopId:_shopId action:PIECES_DISCOUNT_LIST_VIEW];
                        salesGoodsAreaView.isCanDeal = self.isCanDeal;
                    [self.navigationController pushViewController:salesGoodsAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                }
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

#pragma save-data
- (BOOL)isValid
{
    if ([[self.lsGroupType getStrVal] isEqualToString:@"3"] && [NSString isBlank:[self.lsBuyStyleCount getStrVal]]) {
        [AlertBox show:@"包含款数不能为空，请输入!"];
        return NO;
    }
    
    if ([[self.lsGroupType getStrVal] isEqualToString:@"3"] && [NSString isNotBlank:[self.lsBuyStyleCount getStrVal]] && [self.lsBuyStyleCount getStrVal].intValue == 0) {
        [AlertBox show:@"包含款数必须大于0，请重新输入!"];
        return NO;
    }
    
    if (_datas.count == 0) {
        [AlertBox show:@"请先添加促销规则!"];
        return NO;
    }
    
    if (!self.lsExceedRate.isHidden && [NSString isBlank:[self.lsExceedRate getStrVal]]) {
        [AlertBox show:@"超出的商品折扣率(%)不能为空，请输入!"];
        return NO;
    }

    return YES;
}

#pragma 点击删除事件
- (IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:@"确认要删除该规则吗？"];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2) {
        if(buttonIndex==0){
            [_datas removeObject:_discountGoodsVo];
            _saveFlg = YES;
            [self.titleBox editTitle:YES act:self.action];
            [self showFootInfoView];
            [self.mainGrid reloadData];
        }
    } else {
        if(buttonIndex==0){
            __weak PiecesDiscountEditView* weakSelf = self;
            if (self.action == ACTION_CONSTANTS_EDIT) {
                [_marketService deleteSalesNpDiscountDetail:_npDiscountId completionHandler:^(id json) {
                    if (!(weakSelf)) {
                        return ;
                    }
                    [self delFinish];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
            }
        }
    }
    
}

#pragma finish delete
- (void)delFinish
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LSMarketListController class]]) {
            LSMarketListController *listView = (LSMarketListController *)vc;
            [listView loadDatasFromEditView:ACTION_CONSTANTS_DEL];
        }
    }
    [self.navigationController popViewControllerAnimated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
}

- (void)initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.headInfoView event:Notification_UI_PiecesDiscountEditView_Change];
    [UIHelper initNotification:self.footInfoView event:Notification_UI_PiecesDiscountEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_PiecesDiscountEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self.titleBox editTitle:YES act:self.action];
    } else {
        if (!_saveFlg) {
            [self.titleBox editTitle:[UIHelper currChange:self.headInfoView] || [UIHelper currChange:self.footInfoView] act:self.action];
        } else {
            [self.titleBox editTitle:YES act:self.action];
        }
        
        if ([UIHelper currChange:self.headInfoView] || [UIHelper currChange:self.footInfoView]) {
            _saveFlg = YES;
        }
    }

}

@end
