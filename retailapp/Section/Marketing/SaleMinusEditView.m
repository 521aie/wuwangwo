//
//  SaleMinusEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SaleMinusEditView.h"
#import "EditItemRadio.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "ItemTitle.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "MarketRender.h"
#import "MarketModuleEvent.h"
#import "OptionPickerBox.h"
#import "SymbolNumberInputBox.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "SalesMatchRuleMinusVo.h"
#import "LSMarketListController.h"
#import "SalesStyleAreaView.h"
#import "SalesGoodsAreaView.h"

#define BUY_STYLE_COUNT 100

@interface SaleMinusEditView ()

@property (nonatomic, strong) MarketService* marketService;

@property (nonatomic, strong) SalesMatchRuleMinusVo* salesMatchRuleMinusVo;

@property (nonatomic, strong) NSString* minusRuleId;

@property (nonatomic, strong) NSString* salesId;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic) int action;

@property (nonatomic) BOOL saveFlg;

/**
 1: 右上角保存按键保存 2: 点击款式/商品信息保存
 */
@property (nonatomic, strong) NSString *saveWay;

/**
 1: 优惠券出券款式信息 2: 优惠券出券商品信息 3: 优惠券使用款式信息 4: 优惠券使用商品信息
 */
@property (nonatomic, strong) NSString *type;

/**
 是否页面刷新，1表示：是
 */
@property (nonatomic) short isFresh;

/**
 1表示添加状态，2表示编辑状态
 */
@property (nonatomic) short status;

@end

@implementation SaleMinusEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil minusRuleId:(NSString*) minusRuleId salesId:(NSString*) salesId action:(int) action shopId:(NSString*) shopId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _minusRuleId = minusRuleId;
        _salesId = salesId;
        _action = action;
        _shopId = shopId;
        _marketService = [ServiceFactory shareInstance].marketService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configHelpButton:HELP_MARKET_FULL_CUT_DETAIL];
    [self initNotifaction];
    [self initHead];
    [self initMainView];
    [self loaddatas];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loaddatas
{
    [self.btnDel setHidden:_action == ACTION_CONSTANTS_ADD];
    if (_action == ACTION_CONSTANTS_ADD) {
        _status = 1;
        self.titleBox.lblTitle.text = @"添加";
        [self clearDo];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }else{
        _status = 2;
        [self selectSalesMinusDetail];
    }
}

#pragma 从促销款式or商品一览返回
-(void) loaddatasFromGoodsOrStyleListView
{
    _action = ACTION_CONSTANTS_EDIT;
    [self selectSalesMinusDetail];
}

#pragma 检索满减详情
-(void) selectSalesMinusDetail
{
    __weak SaleMinusEditView* weakSelf = self;
    [_marketService selectSalesMatchRuleMinusDetail:_minusRuleId completionHandler:^(id json) {
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
    _salesMatchRuleMinusVo = [SalesMatchRuleMinusVo convertToSalesMatchRuleMinusVo:[json objectForKey:@"salesMatchRuleMinusVo"]];
    self.titleBox.lblTitle.text = @"满减规则";
    
    [self fillModel];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) isEdit:(BOOL) flg
{
    if (flg) {
        [self.lsGoodsCount editEnable:YES];
        [self.lsMoney editEnable:YES];
        [self.lsGroupType editEnable:YES];
        [self.lsBuyStyleCount editEnable:YES];
        [self.rdoIsGoodsArea isEditable:YES];
        [self.lsMinusMoney editEnable:YES];
        [self.lsMaxMinusMoney editEnable:YES];
        [self.btnDel setHidden:NO];
    } else {
        [self.lsGoodsCount editEnable:NO];
        [self.lsMoney editEnable:NO];
        [self.lsGroupType editEnable:NO];
        [self.lsBuyStyleCount editEnable:NO];
        [self.rdoIsGoodsArea isEditable:NO];
        [self.lsMinusMoney editEnable:NO];
        [self.lsMaxMinusMoney editEnable:NO];
        [self.btnDel setHidden:YES];
    }
}

#pragma 详情数据显示
-(void) fillModel
{
    if ([ObjectUtil isNull:_salesMatchRuleMinusVo.goodsNumber]) {
        [self.lsGoodsCount initData:@"不限" withVal:nil];
    }else{
        [self.lsGoodsCount initData:[_salesMatchRuleMinusVo.goodsNumber stringValue] withVal:[_salesMatchRuleMinusVo.goodsNumber stringValue]];
    }
    
    if ([ObjectUtil isNull:_salesMatchRuleMinusVo.amountCondition]) {
        [self.lsMoney initData:@"不限" withVal:nil];
    }else{
        [self.lsMoney initData:[NSString stringWithFormat:@"%.2f", [_salesMatchRuleMinusVo.amountCondition doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_salesMatchRuleMinusVo.amountCondition doubleValue]]];
    }
    
    [self.lsGroupType initData:[MarketRender obtainGroupType:_salesMatchRuleMinusVo.groupType] withVal:[NSString stringWithFormat:@"%tu", _salesMatchRuleMinusVo.groupType]];
    [self.lsBuyStyleCount initData:[NSString stringWithFormat:@"%tu", _salesMatchRuleMinusVo.containStyleNum] withVal:[NSString stringWithFormat:@"%tu", _salesMatchRuleMinusVo.containStyleNum]];
    if (_salesMatchRuleMinusVo.groupType == 3) {
        [self.lsBuyStyleCount visibal:YES];
    } else {
        [self.lsBuyStyleCount visibal:NO];
    }
    
    if (_salesMatchRuleMinusVo.goodsScope == 1) {
        //1表示所有范围，开关关闭。2表示部分，开关打开
        [self.rdoIsGoodsArea initData:@"0"];
    }else{
        [self.rdoIsGoodsArea initData:@"1"];
    }
    
    if ([[self.rdoIsGoodsArea getStrVal] isEqualToString:@"1"]) {
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
            //判断商超、服鞋模式
            [self.lsStyleArea visibal:YES];
        }else{
            [self.lsStyleArea visibal:NO];
        }
        [self.lsGoodsArea visibal:YES];
    }else{
        [self.lsStyleArea visibal:NO];
        [self.lsGoodsArea visibal:NO];
    }
    
    [self.lsMinusMoney initData:[NSString stringWithFormat:@"%.2f", _salesMatchRuleMinusVo.deduction] withVal:[NSString stringWithFormat:@"%.2f", _salesMatchRuleMinusVo.deduction]];
    
    if ([ObjectUtil isNull:_salesMatchRuleMinusVo.maxDeduction]) {
        [self.lsMaxMinusMoney initData:@"不封顶" withVal:nil];
    }else{
        [self.lsMaxMinusMoney initData:[NSString stringWithFormat:@"%.2f", [_salesMatchRuleMinusVo.maxDeduction doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_salesMatchRuleMinusVo.maxDeduction doubleValue]]];
    }
    
    if ([self.isCanDeal isEqualToString:@"0"]) {
        [self isEdit:NO];
    }
}

#pragma 添加页面初始化
-(void) clearDo
{
    [self.lsGoodsCount initData:@"不限" withVal:nil];
    [self.lsMoney initData:@"不限" withVal:nil];
    [self.lsGroupType initData:[MarketRender obtainGroupType:1] withVal:@"1"];
    [self.lsBuyStyleCount visibal:NO];
    [self.lsBuyStyleCount initData:nil withVal:nil];
    [self.rdoIsGoodsArea initData:@"0"];
    [self.lsStyleArea initData:nil withVal:nil];
    [self.lsGoodsArea initData:nil withVal:nil];
    [self.lsMinusMoney initData:nil withVal:nil];
    [self.lsMaxMinusMoney initData:@"不封顶" withVal:nil];
    [self.lsGoodsArea visibal:NO];
    [self.lsStyleArea visibal:NO];

}

#pragma 页面数据初始化
-(void) initMainView
{
    self.TitSalesRegulation.lblName.text = @"促销规则设置";
    [self.lsGoodsCount initLabel:@"购买数量" withHit:nil delegate:self];
    [self.lsMoney initLabel:@"购买金额(元)" withHit:nil delegate:self];
    [self.lsGroupType initLabel:@"购买组合方式" withHit:nil delegate:self];
    [self.lsBuyStyleCount initLabel:@"▪︎ 包含款数" withHit:nil isrequest:YES delegate:self];
    [self.rdoIsGoodsArea initLabel:@"指定商品范围" withHit:nil delegate:self];
    
    [self.lsStyleArea initLabel:@"▪︎ 款式范围" withHit:nil delegate:self];
    self.lsStyleArea.lblVal.placeholder = @"";
    [self.lsStyleArea.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    [self.lsGoodsArea initLabel:@"▪︎ 商品范围" withHit:nil delegate:self];
    self.lsGoodsArea.lblVal.placeholder = @"";
    [self.lsGoodsArea.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    self.TitMinusMoney.lblName.text = @"扣减额度设置";
    [self.lsMinusMoney initLabel:@"扣减金额(元)" withHit:nil isrequest:YES delegate:self];
    [self.lsMaxMinusMoney initLabel:@"最多扣减金额(元)" withHit:nil delegate:self];

    self.lsGoodsCount.tag = SALES_MINUS_EDIT_GOODSCOUNT;
    self.lsGroupType.tag = SALES_MINUS_EDIT_GROUPTYPE;
    self.rdoIsGoodsArea.tag = SALES_MINUS_EDIT_ISGOODSAREA;
    self.lsStyleArea.tag = SALES_MINUS_EDIT_STYLEAREA;
    self.lsGoodsArea.tag = SALES_MINUS_EDIT_GOODSAREA;
    self.lsMinusMoney.tag = SALES_MINUS_EDIT_MINUSMONEY;
    self.lsMaxMinusMoney.tag = SALES_MINUS_EDIT_MAXMINUSMONEY;
    self.lsMoney.tag = SALES_MINUS_EDIT_MONEY;
    self.lsBuyStyleCount.tag = BUY_STYLE_COUNT;
}

#pragma mark 下拉框封装、显示、条跳转
-(void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag == SALES_MINUS_EDIT_MINUSMONEY || obj.tag == SALES_MINUS_EDIT_MAXMINUSMONEY || obj.tag == SALES_MINUS_EDIT_MONEY){
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    } else if (obj.tag == SALES_MINUS_EDIT_GOODSCOUNT) {
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
    }else if (obj.tag == SALES_MINUS_EDIT_GROUPTYPE) {
        [OptionPickerBox initData:[MarketRender listGroupType]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj.tag == SALES_MINUS_EDIT_STYLEAREA) {
        _saveWay = @"2";
        _type = @"1";
        if (!(!_saveFlg && _action == ACTION_CONSTANTS_EDIT)) {
             // 点击“款式范围” 保存后跳转到款式范围页面
            [self save];
        }else{
             // 点击“款式范围” 跳转到款式范围页面
            SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:_minusRuleId discountType:@"5" shopId:_shopId action:SALES_MINUS_LIST_VIEW];
            salesStyleAreaView.isCanDeal = self.isCanDeal;
            [self.navigationController pushViewController:salesStyleAreaView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
    } else if (obj.tag == SALES_MINUS_EDIT_GOODSAREA) {
        _saveWay = @"2";
        _type = @"2";
        if (!(!_saveFlg && _action == ACTION_CONSTANTS_EDIT)) {
             // 点击“商品范围” 保存后跳转到商品范围页面
            [self save];
        } else {
             // 点击“商品范围” 跳转到商品范围页面
            SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:_minusRuleId discountType:@"5" shopId:_shopId action:SALES_MINUS_LIST_VIEW];
            salesGoodsAreaView.isCanDeal = self.isCanDeal;
            [self.navigationController pushViewController:salesGoodsAreaView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
    } else if (obj.tag == BUY_STYLE_COUNT) {
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:0];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

// 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == SALES_MINUS_EDIT_GROUPTYPE) {
        [self.lsGroupType changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemId] isEqualToString:@"3"]) {
            [self.lsBuyStyleCount visibal:YES];
            [self.lsBuyStyleCount initData:nil withVal:nil];
        } else {
            [self.lsBuyStyleCount visibal:NO];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType == BUY_STYLE_COUNT) {
        
        if ([NSString isBlank:val]) {
            val = nil;
        } else {
            val = [NSString stringWithFormat:@"%d",val.intValue];
        }
        
        [self.lsBuyStyleCount changeData:val withVal:val];
    } else {
        if ([NSString isBlank:val]) {
            val = @"";
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
        
        if (eventType==SALES_MINUS_EDIT_MONEY) {
            if (val.doubleValue == 0) {
//                val = @"0.00";
                [self.lsMoney changeData:@"不限" withVal:nil];
            } else {
                [self.lsMoney changeData:val withVal:val];
            }
            
        }else if (eventType==SALES_MINUS_EDIT_MINUSMONEY) {
            
            [self.lsMinusMoney changeData:val withVal:val];
            
        }else if (eventType==SALES_MINUS_EDIT_MAXMINUSMONEY) {
            
            if (val.doubleValue == 0) {
//                val = @"0.00";
                [self.lsMaxMinusMoney changeData:@"不封顶" withVal:nil];
            } else {
                [self.lsMaxMinusMoney changeData:val withVal:val];
                
            }
            
        }else if (eventType==SALES_MINUS_EDIT_GOODSCOUNT) {
            
            if (val.intValue == 0) {
                val = @"0";
            }else{
                val = [NSString stringWithFormat:@"%.d",val.intValue];
            }

            if ([val isEqualToString:@"0"]) {
                [self.lsGoodsCount changeData:@"不限" withVal:nil];
            } else {
                [self.lsGoodsCount changeData:val withVal:val];
            }
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 开关按钮
-(void) onItemRadioClick:(EditItemRadio*)obj
{
    BOOL result = [[obj getStrVal] isEqualToString:@"1"];
    
    if (obj.tag == SALES_MINUS_EDIT_ISGOODSAREA) {
        if (result) {
            if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
                //判断商超、服鞋模式
                [self.lsStyleArea visibal:YES];
            }
            [self.lsGoodsArea visibal:YES];
        }else{
            [self.lsStyleArea visibal:NO];
            [self.lsGoodsArea visibal:NO];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark 导航栏
-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        // 返回到满减活动列表页面
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
    } else {
        // 点击右上角“保存”按钮保存
        _saveWay = @"1";
        [self save];
    }
}

#pragma mark 保存操作
-(void)save
{
    // 页面check
    if (![self isValid]){
        return;
    }
    
    // 返回刷新
    _isFresh = 1;
    
    __weak SaleMinusEditView* weakSelf = self;
    if (_action == ACTION_CONSTANTS_ADD) {
        _salesMatchRuleMinusVo = [[SalesMatchRuleMinusVo alloc] init];
        _salesMatchRuleMinusVo.salesId = _salesId;
        if ([NSString isBlank:[self.lsGoodsCount getStrVal]]) {
            _salesMatchRuleMinusVo.goodsNumber = nil;
        }else{
            _salesMatchRuleMinusVo.goodsNumber = [NSNumber numberWithInteger:[self.lsGoodsCount getStrVal].integerValue];
        }
        
        if ([NSString isBlank:[self.lsMoney getStrVal]]) {
            _salesMatchRuleMinusVo.amountCondition = nil;
        }else{
            _salesMatchRuleMinusVo.amountCondition = [NSNumber numberWithDouble:[self.lsMoney getStrVal].doubleValue];
        }
        
        _salesMatchRuleMinusVo.groupType = [self.lsGroupType getStrVal].integerValue;
        if ([NSString isNotBlank:[self.lsBuyStyleCount getStrVal]]) {
            _salesMatchRuleMinusVo.containStyleNum = [self.lsBuyStyleCount getStrVal].integerValue
            ;
        }
        
        if ([self.rdoIsGoodsArea getStrVal].integerValue == 0) {
            _salesMatchRuleMinusVo.goodsScope = 1;
        }else{
            _salesMatchRuleMinusVo.goodsScope = 2;
        }
        
        _salesMatchRuleMinusVo.deduction = [self.lsMinusMoney getStrVal].doubleValue;
        
        if ([NSString isBlank:[self.lsMaxMinusMoney getStrVal]]) {
            _salesMatchRuleMinusVo.maxDeduction = nil;
        }else{
            _salesMatchRuleMinusVo.maxDeduction = [NSNumber numberWithDouble:[self.lsMaxMinusMoney getStrVal].doubleValue];
        }
        
        [_marketService saveSalesMatchRuleMinusDetail:[SalesMatchRuleMinusVo getDictionaryData:_salesMatchRuleMinusVo] operateType:@"add" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            if ([_saveWay isEqualToString:@"1"]) {
                // 点击右上角“保存”按钮保存，返回到满减列表页面
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LSMarketListController class]]) {
                        LSMarketListController *listView = (LSMarketListController *)vc;
                        [listView loadDatasFromSalesRegulationEditView:ACTION_CONSTANTS_ADD salesId:_salesId];
                    }
                }
                [self.navigationController popViewControllerAnimated:NO];
            } else {
                _minusRuleId = [json objectForKey:@"minusRuleId"];
                if ([_type isEqualToString:@"1"]) {
                    // 点击“款式范围” 保存后跳转到款式范围页面
                    SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:_minusRuleId discountType:@"5" shopId:_shopId action:SALES_MINUS_LIST_VIEW];
                    self.isCanDeal = @"1";
                    salesStyleAreaView.isCanDeal = @"1";
                    salesStyleAreaView.operateMode = @"edit";
                    [self.navigationController pushViewController:salesStyleAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                } else if ([_type isEqualToString:@"2"]) {
                    // 点击“商品范围” 保存后跳转到商品范围页面
                    SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:_minusRuleId discountType:@"5" shopId:_shopId action:SALES_MINUS_LIST_VIEW];
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
        _salesMatchRuleMinusVo.salesId = _salesId;
        if ([NSString isBlank:[self.lsGoodsCount getStrVal]]) {
            _salesMatchRuleMinusVo.goodsNumber = nil;
        }else{
            _salesMatchRuleMinusVo.goodsNumber = [NSNumber numberWithInteger:[self.lsGoodsCount getStrVal].integerValue];
        }
        
        if ([NSString isBlank:[self.lsMoney getStrVal]]) {
            _salesMatchRuleMinusVo.amountCondition = nil;
        }else{
            _salesMatchRuleMinusVo.amountCondition = [NSNumber numberWithDouble:[self.lsMoney getStrVal].doubleValue];
        }
        
        _salesMatchRuleMinusVo.groupType = [self.lsGroupType getStrVal].integerValue;
        if ([NSString isNotBlank:[self.lsBuyStyleCount getStrVal]]) {
            _salesMatchRuleMinusVo.containStyleNum = [self.lsBuyStyleCount getStrVal].integerValue
            ;
        }
        
        if ([self.rdoIsGoodsArea getStrVal].integerValue == 0) {
            _salesMatchRuleMinusVo.goodsScope = 1;
        }else{
            _salesMatchRuleMinusVo.goodsScope = 2;
        }
        
        _salesMatchRuleMinusVo.deduction = [self.lsMinusMoney getStrVal].doubleValue;
        
        if ([NSString isBlank:[self.lsMaxMinusMoney getStrVal]]) {
            _salesMatchRuleMinusVo.maxDeduction = nil;
        }else{
            _salesMatchRuleMinusVo.maxDeduction = [NSNumber numberWithDouble:[self.lsMaxMinusMoney getStrVal].doubleValue];
        }
        
        [_marketService saveSalesMatchRuleMinusDetail:[SalesMatchRuleMinusVo getDictionaryData:_salesMatchRuleMinusVo] operateType:@"edit" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            if ([_saveWay isEqualToString:@"1"]) {
                // 点击右上角“保存”按钮保存，返回到满减列表页面
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LSMarketListController class]]) {
                        LSMarketListController *listView = (LSMarketListController *)vc;
                        [listView loadDatasFromSalesRegulationEditView:ACTION_CONSTANTS_EDIT salesId:_salesId];
                    }
                }
                [self.navigationController popViewControllerAnimated:NO];
            } else {
                _minusRuleId = [json objectForKey:@"minusRuleId"];
                if ([_type isEqualToString:@"1"]) {
                    // 点击“款式范围” 保存后跳转到款式范围页面
                    SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:_minusRuleId discountType:@"5" shopId:_shopId action:SALES_MINUS_LIST_VIEW];
                    salesStyleAreaView.isCanDeal = self.isCanDeal;
                    [self.navigationController pushViewController:salesStyleAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                } else if ([_type isEqualToString:@"2"]) {
                    // 点击“商品范围” 保存后跳转到商品范围页面
                    SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:_minusRuleId discountType:@"5" shopId:_shopId action:SALES_MINUS_LIST_VIEW];
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
-(BOOL)isValid
{
    if ([NSString isBlank:[self.lsGoodsCount getStrVal]] && [NSString isBlank:[self.lsMoney getStrVal]]) {
        [AlertBox show:@"购买数量和购买金额(元)必须填写一项，请输入!"];
        return NO;
    }
    
    if ([[self.lsGroupType getStrVal] isEqualToString:@"3"] && [NSString isBlank:[self.lsBuyStyleCount getStrVal]]) {
        [AlertBox show:@"包含款数不能为空，请输入!"];
        return NO;
    }
    
    if ([[self.lsGroupType getStrVal] isEqualToString:@"3"] && [NSString isNotBlank:[self.lsBuyStyleCount getStrVal]] && [self.lsBuyStyleCount getStrVal].intValue == 0) {
        [AlertBox show:@"包含款数必须大于0，请重新输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsMinusMoney getStrVal]]) {
        [AlertBox show:@"扣减金额(元)不能为空，请输入!"];
        return NO;
    }
    
    if ([self.lsMinusMoney getStrVal].doubleValue <= 0) {
        [AlertBox show:@"扣减金额(元)必须大于0，请重新输入!"];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.lsMaxMinusMoney getStrVal]] && [self.lsMaxMinusMoney getStrVal].doubleValue <= 0) {
        [AlertBox show:@"最多扣减金额(元)必须大于0，请重新输入!"];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.lsMaxMinusMoney getStrVal]] && ((int)([self.lsMaxMinusMoney getStrVal].doubleValue*100)) %((int)([self.lsMinusMoney getStrVal].doubleValue*100)) != 0) {
        [AlertBox show:@"最多扣减金额(元)必须是扣减金额(元)的倍数，请重新输入!"];
        return NO;
    }
    
    return YES;
}

#pragma 删除按钮
-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:@"确认要删除该规则吗？"];
}

#pragma delete
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        __weak SaleMinusEditView* weakSelf = self;
        if (self.action == ACTION_CONSTANTS_EDIT) {
            [_marketService deleteSalesMatchRuleMinusDetail:_minusRuleId completionHandler:^(id json) {
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

#pragma finish delete
-(void) delFinish
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LSMarketListController class]]) {
            LSMarketListController *listView = (LSMarketListController *)vc;
            [listView loadDatasFromSalesRegulationEditView:ACTION_CONSTANTS_DEL salesId:_salesId];
        }
    }
    [self.navigationController popViewControllerAnimated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
}

#pragma 导航栏
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"满减规则" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_SaleMinusEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SaleMinusEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self.titleBox editTitle:YES act:self.action];
    }else{
        [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
        _saveFlg = [UIHelper currChange:self.container];
    }
}

@end
