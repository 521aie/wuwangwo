//
//  SaleCouponEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SaleCouponEditView.h"
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
#import "SalesCouponVo.h"
#import "XHAnimalUtil.h"
#import "LSMarketListController.h"
#import "SalesStyleAreaView.h"
#import "SalesGoodsAreaView.h"
#import "DateUtils.h"
#import "DatePickerBox.h"
#import "EditItemMemo.h"
//#import "MemoInputBox.h"
#import "MemoInputView.h"

#define BUY_STYLE_COUNT 100

@interface SaleCouponEditView ()

@property (nonatomic, strong) MarketService* marketService;

/**
 优惠券Vo
 */
@property (nonatomic, strong) SalesCouponVo* salesCouponVo;

/**
 优惠券ID
 */
@property (nonatomic, strong) NSString* salesCouponId;

/**
 促销ID
 */
@property (nonatomic, strong) NSString* salesId;

@property (nonatomic, strong) NSString* shopId;

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
 1: 优惠券出券款式信息 2: 优惠券出券商品信息 3: 优惠券使用款式信息 4: 优惠券使用商品信息
 */
@property (nonatomic, strong) NSString *type;

@property (nonatomic) short isDoingAct;

/**
 是否页面刷新，1表示：是
 */
@property (nonatomic) short isFresh;

/**
 1表示添加状态，2表示编辑状态
 */
@property (nonatomic) short status;

@end

@implementation SaleCouponEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil salesCouponId:(NSString*) salesCouponId salesId:(NSString*) salesId action:(int) action shopId:(NSString*) shopId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _salesCouponId = salesCouponId;
        _salesId = salesId;
        _action = action;
        _shopId = shopId;
        _marketService = [ServiceFactory shareInstance].marketService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configHelpButton:HELP_MARKET_COUPON_DETAIL];
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

- (void)loaddatas
{
    [self.btnDel setHidden:_action == ACTION_CONSTANTS_ADD];
    if (_action == ACTION_CONSTANTS_ADD) {
        _status = 1;
        self.titleBox.lblTitle.text = @"添加";
        [self clearDo];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }else{
        _status = 2;
        self.titleBox.lblTitle.text = @"优惠券规则";
        [self selectSaleCouponDetail];
    }
}

#pragma 从促销款式or商品一览返回
- (void)loaddatasFromGoodsOrStyleListView
{
    _action = ACTION_CONSTANTS_EDIT;
    [self selectSaleCouponDetail];
}

#pragma 查询优惠券详情
- (void)selectSaleCouponDetail
{
    __weak SaleCouponEditView* weakSelf = self;
    [_marketService selectSalesCouponDetail:_salesCouponId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma 后台数据返回封装
- (void)responseSuccess:(id)json
{
    _salesCouponVo = [SalesCouponVo convertToSalesCouponVo:[json objectForKey:@"salesCouponVo"]];
    self.titleBox.lblTitle.text = @"优惠券规则";
    
    [self fillModel];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)isEdit:(BOOL) flg
{
    if (flg) {
        [self.lsCouponWorth editEnable:YES];
        [self.lsCount editEnable:YES];
        [self.txtremark editEnable:YES];
        [self.lsCouponCreateNum editEnable:YES];
        [self.lsCouponCreateFee editEnable:YES];
        [self.lsGroupType editEnable:YES];
        [self.lsBuyStyleCount editEnable:YES];
        [self.rdoIsCreateGoodsArea isEditable:YES];
        [self.lsCouponUseNum editEnable:YES];
        [self.lsCouponUseFee editEnable:YES];
        [self.lsUseStartTime editEnable:YES];
        [self.lsUseEndTime editEnable:YES];
        [self.rdoIsUseGoodsArea isEditable:YES];
        [self.btnDel setHidden:NO];
    } else {
        [self.lsCouponWorth editEnable:NO];
        [self.lsCount editEnable:NO];
        [self.txtremark editEnable:NO];
        [self.lsCouponCreateNum editEnable:NO];
        [self.lsCouponCreateFee editEnable:NO];
        [self.lsGroupType editEnable:NO];
        [self.lsBuyStyleCount editEnable:NO];
        [self.rdoIsCreateGoodsArea isEditable:NO];
        [self.lsCouponUseNum editEnable:NO];
        [self.lsCouponUseFee editEnable:NO];
        [self.lsUseStartTime editEnable:NO];
        [self.lsUseEndTime editEnable:NO];
        [self.rdoIsUseGoodsArea isEditable:NO];
        [self.btnDel setHidden:YES];
    }
}

#pragma 详情页面数据显示
- (void)fillModel
{
    [self.lsCouponWorth initData:[NSString stringWithFormat:@"%.2f", _salesCouponVo.worth] withVal:[NSString stringWithFormat:@"%.2f", _salesCouponVo.worth]];
    
    [self.lsCount initData:[NSString stringWithFormat:@"%tu", _salesCouponVo.number] withVal:[NSString stringWithFormat:@"%tu", _salesCouponVo.number]];
    
    [self.txtremark initData:_salesCouponVo.remark];
    
    if ([ObjectUtil isNull:_salesCouponVo.couponCreateNumber]) {
        [self.lsCouponCreateNum initData:@"不限" withVal:nil];
    } else {
        [self.lsCouponCreateNum initData:[_salesCouponVo.couponCreateNumber stringValue] withVal:[_salesCouponVo.couponCreateNumber stringValue]];
    }
    
    if ([ObjectUtil isNull:_salesCouponVo.couponCreateFee]) {
        [self.lsCouponCreateFee initData:@"不限" withVal:nil];
    } else {
        [self.lsCouponCreateFee initData:[NSString stringWithFormat:@"%.2f", [_salesCouponVo.couponCreateFee doubleValue]]withVal:[NSString stringWithFormat:@"%.2f", [_salesCouponVo.couponCreateFee doubleValue]]];
    }
    
    [self.lsGroupType initData:[MarketRender obtainGroupType:_salesCouponVo.groupType] withVal:[NSString stringWithFormat:@"%d", _salesCouponVo.groupType]];
    [self.lsBuyStyleCount initData:[NSString stringWithFormat:@"%tu", _salesCouponVo.containStyleNum] withVal:[NSString stringWithFormat:@"%tu", _salesCouponVo.containStyleNum]];
    if (_salesCouponVo.groupType == 3) {
        [self.lsBuyStyleCount visibal:YES];
    } else {
        [self.lsBuyStyleCount visibal:NO];
    }
    
    [self.lsUseStartTime initData:[DateUtils formateTime2:_salesCouponVo.startDate*1000] withVal:[DateUtils formateTime2:_salesCouponVo.startDate*1000]];
    
    [self.lsUseEndTime initData:[DateUtils formateTime2:_salesCouponVo.endDate*1000] withVal:[DateUtils formateTime2:_salesCouponVo.endDate*1000]];
    
    if (_salesCouponVo.generateGoodsScope == 1) {
        //1表示所有范围，开关关闭。2表示部分，开关打开
        [self.rdoIsCreateGoodsArea initData:@"0"];
    } else {
        [self.rdoIsCreateGoodsArea initData:@"1"];
    }
    
    if ([[self.rdoIsCreateGoodsArea getStrVal] isEqualToString:@"1"]) {
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
            [self.lsCreateStyleArea visibal:YES];
        } else {
            [self.lsCreateStyleArea visibal:NO];
        }
        [self.lsCreateGoodsArea visibal:YES];
    } else {
        [self.lsCreateStyleArea visibal:NO];
        [self.lsCreateGoodsArea visibal:NO];
    }
    
    if ([ObjectUtil isNull:_salesCouponVo.couponUseNumber]) {
        [self.lsCouponUseNum initData:@"不限" withVal:nil];
    } else {
        [self.lsCouponUseNum initData:[_salesCouponVo.couponUseNumber stringValue] withVal:[_salesCouponVo.couponUseNumber stringValue]];
    }
    
    if ([ObjectUtil isNull:_salesCouponVo.couponUseFee]) {
        [self.lsCouponUseFee initData:@"不限" withVal:nil];
    } else {
        [self.lsCouponUseFee initData:[NSString stringWithFormat:@"%.2f", [_salesCouponVo.couponUseFee doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_salesCouponVo.couponUseFee doubleValue]]];
    }
    
    if (_salesCouponVo.userGoodsScope == 1) {
        //1表示所有范围，开关关闭。2表示部分，开关打开
        [self.rdoIsUseGoodsArea initData:@"0"];
    } else {
        [self.rdoIsUseGoodsArea initData:@"1"];
    }
    
    if ([[self.rdoIsUseGoodsArea getStrVal] isEqualToString:@"1"]) {
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
            [self.lsUseStyleArea visibal:YES];
        } else {
            [self.lsUseStyleArea visibal:NO];
        }
        [self.lsUseGoodsArea visibal:YES];
    } else {
        [self.lsUseStyleArea visibal:NO];
        [self.lsUseGoodsArea visibal:NO];
    }
    
    if ([self.isCanDeal isEqualToString:@"0"]) {
        [self isEdit:NO];
    }
    
    if (_salesCouponVo.isDoingAct == 1) {
//        _isDoingAct = _salesCouponVo.isDoingAct;
        [self.lsCouponWorth editEnable:NO];
        [self.btnDel setHidden:YES];
    }
}

#pragma 添加页面数据初始化
- (void)clearDo
{
    [self.lsCouponWorth initData:nil withVal:nil];
    [self.lsCount initData:nil withVal:nil];
    [self.txtremark initData:nil];
    
    [self.lsCouponCreateNum initData:@"不限" withVal:nil];
    [self.lsCouponCreateFee initData:@"不限" withVal:nil];
    [self.lsGroupType initData:[MarketRender obtainGroupType:1] withVal:@"1"];
    [self.lsBuyStyleCount visibal:NO];
    [self.lsBuyStyleCount initData:nil withVal:nil];
    [self.rdoIsCreateGoodsArea initData:@"0"];
    [self.lsCreateStyleArea visibal:NO];
    [self.lsCreateGoodsArea visibal:NO];
    
    [self.lsCouponUseNum initData:@"不限" withVal:nil];
    [self.lsCouponUseFee initData:@"不限" withVal:nil];
    [self.lsUseStartTime initData:[DateUtils formateDate2:[NSDate date]] withVal:[DateUtils formateDate2:[NSDate date]]];
    [self.lsUseEndTime initData:[DateUtils formateDate2:[NSDate date]] withVal:[DateUtils formateDate2:[NSDate date]]];
    [self.rdoIsUseGoodsArea initData:@"0"];
    [self.lsUseStyleArea visibal:NO];
    [self.lsUseGoodsArea visibal:NO];

}

#pragma 页面数据初始化
- (void)initMainView
{
    self.TitBase.lblName.text = @"基本设置";
    [self.lsCouponWorth initLabel:@"优惠券面额(元)" withHit:nil isrequest:YES delegate:self];
    [self.lsCount initLabel:@"数量" withHit:nil isrequest:YES delegate:self];
    [self.txtremark initLabel:@"优惠券说明" isrequest:nil delegate:self];
    
    self.TitCreateCoupon.lblName.text = @"出券规则设置";
    [self.lsCouponCreateNum initLabel:@"出券条件(购买数量)" withHit:nil delegate:self];
    [self.lsCouponCreateFee initLabel:@"出券条件(购买金额)" withHit:nil delegate:self];
    [self.lsGroupType initLabel:@"购买组合方式" withHit:nil delegate:self];
    [self.lsBuyStyleCount initLabel:@"▪︎ 包含款数" withHit:nil isrequest:YES delegate:self];
    [self.rdoIsCreateGoodsArea initLabel:@"出券指定商品范围" withHit:nil delegate:self];
    [self.lsCreateStyleArea initLabel:@"▪︎ 出券款式范围" withHit:nil delegate:self];
    self.lsCreateStyleArea.lblVal.placeholder = @"";
    [self.lsCreateStyleArea.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.lsCreateGoodsArea initLabel:@"▪︎ 出券商品范围" withHit:nil delegate:self];
    self.lsCreateGoodsArea.lblVal.placeholder = @"";
    [self.lsCreateGoodsArea.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    self.TitUseCoupon.lblName.text = @"使用规则设置";
    [self.lsCouponUseNum initLabel:@"使用条件(购买数量)" withHit:nil delegate:self];
    [self.lsCouponUseFee initLabel:@"使用条件(购买金额)" withHit:nil delegate:self];
    [self.lsUseStartTime initLabel:@"使用开始日期" withHit:nil delegate:self];
    [self.lsUseEndTime initLabel:@"使用结束日期" withHit:nil delegate:self];
    [self.rdoIsUseGoodsArea initLabel:@"使用指定商品范围" withHit:nil delegate:self];
    [self.lsUseStyleArea initLabel:@"▪︎ 使用款式范围" withHit:nil delegate:self];
    self.lsUseStyleArea.lblVal.placeholder = @"";
    [self.lsUseStyleArea.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.lsUseGoodsArea initLabel:@"▪︎ 使用商品范围" withHit:nil delegate:self];
    self.lsUseGoodsArea.lblVal.placeholder = @"";
    [self.lsUseGoodsArea.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    //优惠券详情
    self.lsCouponWorth.tag = SALE_COUPON_EDIT_COUPONWORTH;                      //优惠券面额
    self.lsCount.tag = SALE_COUPON_EDIT_COUNT;                                  //数量
    self.lsCouponCreateNum.tag = SALE_COUPON_EDIT_COUPONCREATENUM;              //出券条件(购买数量)
    self.lsCouponCreateFee.tag = SALE_COUPON_EDIT_COUPONCREATEFEE;              //出券条件(购买金额)
    self.lsGroupType.tag = SALE_COUPON_EDIT_GROUPTYPE;                          //购买组合方式
    self.rdoIsCreateGoodsArea.tag = SALE_COUPON_EDIT_ISCREATEGOODSAREA;         //出券指定商品范围
    self.lsCreateStyleArea.tag = SALE_COUPON_EDIT_CREATESTYLEAREA;              //出券款式范围
    self.lsCreateGoodsArea.tag = SALE_COUPON_EDIT_CREATEGOODSAREA;              //出券商品范围
    self.lsCouponUseNum.tag = SALE_COUPON_EDIT_COUPONUSENUM;                    //使用条件(购买数量)
    self.lsCouponUseFee.tag = SALE_COUPON_EDIT_COUPONUSEFEE;                    //使用条件(购买金额)
    self.rdoIsUseGoodsArea.tag = SALE_COUPON_EDIT_ISUSEGOODSAREA;               //使用指定商品范围
    self.lsUseStyleArea.tag = SALE_COUPON_EDIT_USESTYLEAREA;                    //使用款式范围
    self.lsUseGoodsArea.tag = SALE_COUPON_EDIT_USEGOODSAREA;                    //使用商品范围
    self.lsUseStartTime.tag = SALE_COUPON_EDIT_STARTTIME;                       //使用开始时间
    self.lsUseEndTime.tag = SALE_COUPON_EDIT_ENDTIME;                           //使用结束时间
    self.lsBuyStyleCount.tag = BUY_STYLE_COUNT;
    self.txtremark.tag = SALE_COUPON_EDIT_REMARK;

}

//param mark add to solve input below

- (void)onItemMemoListClick:(EditItemMemo *)obj {
    
    MemoInputView *vc = [[MemoInputView alloc] init];
    [vc limitShow:SALE_COUPON_EDIT_REMARK delegate:self title:@"优惠券说明" val:[self.txtremark getStrVal] limit:100];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

//完成Memo输入.
- (void)finishInput:(int)event content:(NSString *)content {
    [self.txtremark changeData:content];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark 下拉框事件
- (void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag == SALE_COUPON_EDIT_COUPONWORTH || obj.tag == SALE_COUPON_EDIT_COUPONCREATEFEE || obj.tag == SALE_COUPON_EDIT_COUPONUSEFEE){
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    } else if (obj.tag == SALE_COUPON_EDIT_COUNT || obj.tag == SALE_COUPON_EDIT_COUPONUSENUM || obj.tag == SALE_COUPON_EDIT_COUPONCREATENUM){
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
    }else if (obj.tag == SALE_COUPON_EDIT_GROUPTYPE){
        [OptionPickerBox initData:[MarketRender listGroupType]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj.tag == SALE_COUPON_EDIT_CREATESTYLEAREA){
        _saveWay = @"2";
        _type = @"1";
        if (!(!_saveFlg && _action == ACTION_CONSTANTS_EDIT)) {
            [self save];
        } else {
            // 点击“出券款式范围” 保存后跳转到款式范围页面
            SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:_salesCouponId discountType:@"3" shopId:_shopId action:SALES_COUPON_LIST_VIEW];
            if ([self.isCanDeal isEqualToString:@"1"]) {
                salesStyleAreaView.isCanDeal = @"1";
            } else {
                salesStyleAreaView.isCanDeal = @"0";
            }
            salesStyleAreaView.titleName = @"出券款式范围";
            [self.navigationController pushViewController:salesStyleAreaView animated:NO];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
    } else if (obj.tag == SALE_COUPON_EDIT_CREATEGOODSAREA){
        _saveWay = @"2";
        _type = @"2";
        if (!(!_saveFlg && _action == ACTION_CONSTANTS_EDIT)) {
            [self save];
        } else {
            // 点击“出券商品范围” 保存后跳转到商品范围页面
            SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:_salesCouponId discountType:@"3" shopId:_shopId action:SALES_COUPON_LIST_VIEW];
            if ([self.isCanDeal isEqualToString:@"1"]) {
                salesGoodsAreaView.isCanDeal = @"1";
            } else {
                salesGoodsAreaView.isCanDeal = @"0";
            }
            salesGoodsAreaView.titleName = @"出券商品范围";
            [self.navigationController pushViewController:salesGoodsAreaView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
    } else if (obj.tag == SALE_COUPON_EDIT_USESTYLEAREA){
        _saveWay = @"2";
        _type = @"3";
        if (!(!_saveFlg && _action == ACTION_CONSTANTS_EDIT)) {
            [self save];
        } else {
            // 点击“使用款式范围” 保存后跳转到款式范围页面
            SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:_salesCouponId discountType:@"4" shopId:_shopId action:SALES_COUPON_LIST_VIEW];
            if ([self.isCanDeal isEqualToString:@"1"]) {
                salesStyleAreaView.isCanDeal = @"1";
            } else {
                salesStyleAreaView.isCanDeal = @"0";
            }
            salesStyleAreaView.titleName = @"使用款式范围";
            [self.navigationController pushViewController:salesStyleAreaView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
    } else if (obj.tag == SALE_COUPON_EDIT_USEGOODSAREA){
        _saveWay = @"2";
        _type = @"4";
        if (!(!_saveFlg && _action == ACTION_CONSTANTS_EDIT)) {
            [self save];
        } else {
            // 点击“使用商品范围” 保存后跳转到商品范围页面
            SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:_salesCouponId discountType:@"4" shopId:_shopId action:SALES_COUPON_LIST_VIEW];
            if ([self.isCanDeal isEqualToString:@"1"]) {
                salesGoodsAreaView.isCanDeal = @"1";
            } else {
                salesGoodsAreaView.isCanDeal = @"0";
            }
            salesGoodsAreaView.titleName = @"使用商品范围";
            [self.navigationController pushViewController:salesGoodsAreaView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
    } else if (obj.tag == SALE_COUPON_EDIT_STARTTIME) {
        NSDate *date=[DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox show:obj.lblName.text date:date client:self event:(int)obj.tag];
    } else if (obj.tag == SALE_COUPON_EDIT_ENDTIME) {
        NSDate *date=[DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox show:obj.lblName.text date:date client:self event:(int)obj.tag];
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
    if (eventType == SALE_COUPON_EDIT_GROUPTYPE) {
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

//选择日期
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    
    if (event == SALE_COUPON_EDIT_STARTTIME) {
        
        NSString* dateStr=[DateUtils formateDate2:date];
        [self.lsUseStartTime changeData:dateStr withVal:dateStr];
    }else if (event == SALE_COUPON_EDIT_ENDTIME){
        NSString* dateStr=[DateUtils formateDate2:date];
        [self.lsUseEndTime changeData:dateStr withVal:dateStr];
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

        if (eventType==SALE_COUPON_EDIT_COUPONWORTH) {

            [self.lsCouponWorth changeData:val withVal:val];
            
        } else if (eventType==SALE_COUPON_EDIT_COUPONCREATEFEE) {
            if (val.doubleValue == 0) {
//                val = @"0.00";
                [self.lsCouponCreateFee changeData:@"不限" withVal:nil];
            } else {
                val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
                [self.lsCouponCreateFee changeData:val withVal:val];
            }
        } else if (eventType==SALE_COUPON_EDIT_COUPONUSEFEE) {
            if (val.doubleValue == 0) {
//                val = @"0.00";
                [self.lsCouponUseFee changeData:@"不限" withVal:nil];
            } else {
                val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
                [self.lsCouponUseFee changeData:val withVal:val];
                
            }
        } else if (eventType==SALE_COUPON_EDIT_COUNT) {
            
            if ([NSString isBlank:val]) {
                val = nil;
            } else {
                val = [NSString stringWithFormat:@"%d",val.intValue];
            }
            
            [self.lsCount changeData:val withVal:val];
            
        } else if (eventType==SALE_COUPON_EDIT_COUPONCREATENUM) {
            if (val.intValue == 0) {
//                val = @"0";
                [self.lsCouponCreateNum changeData:@"不限" withVal:nil];
            } else {
                val = [NSString stringWithFormat:@"%d",val.intValue];
                [self.lsCouponCreateNum changeData:val withVal:val];
            }
            
        } else if (eventType==SALE_COUPON_EDIT_COUPONUSENUM) {
            if (val.intValue == 0) {
//                val = @"0";
                [self.lsCouponUseNum changeData:@"不限" withVal:nil];
            } else {
                val = [NSString stringWithFormat:@"%d",val.intValue];
                [self.lsCouponUseNum changeData:val withVal:val];
            }
        }
    }
}

#pragma 开关事件
- (void)onItemRadioClick:(EditItemRadio*)obj
{
    BOOL result = [[obj getStrVal] isEqualToString:@"1"];
    
    if (obj.tag == SALE_COUPON_EDIT_ISCREATEGOODSAREA) {
        if (result) {
            if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
                [self.lsCreateStyleArea visibal:YES];
            } else {
                [self.lsCreateStyleArea visibal:NO];
            }
            [self.lsCreateGoodsArea visibal:YES];
        } else {
            [self.lsCreateStyleArea visibal:NO];
            [self.lsCreateGoodsArea visibal:NO];
        }
    } else if (obj.tag == SALE_COUPON_EDIT_ISUSEGOODSAREA) {
        if (result) {
            if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
                [self.lsUseStyleArea visibal:YES];
            } else {
                [self.lsUseStyleArea visibal:NO];
            }
            [self.lsUseGoodsArea visibal:YES];
        } else {
            [self.lsUseStyleArea visibal:NO];
            [self.lsUseGoodsArea visibal:NO];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}

#pragma mark 导航栏事件
- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        // 返回到促销活动页面
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

#pragma mark 保存事件
- (void)save
{
    if (![self isValid]){
        return;
    }
    
    // 返回刷新
    _isFresh = 1;
    
    __weak SaleCouponEditView* weakSelf = self;
    if (_action == ACTION_CONSTANTS_ADD) {
        _salesCouponVo = [[SalesCouponVo alloc] init];
        _salesCouponVo.salesId = _salesId;
        _salesCouponVo.worth = [self.lsCouponWorth getStrVal].doubleValue;
        _salesCouponVo.number = [self.lsCount getStrVal].integerValue;
        _salesCouponVo.remark = [self.txtremark getStrVal];
        if ([NSString isBlank:[self.lsCouponCreateNum getStrVal]]) {
            _salesCouponVo.couponCreateNumber = nil;
        } else {
            _salesCouponVo.couponCreateNumber = [NSNumber numberWithInteger:[self.lsCouponCreateNum getStrVal].integerValue];
        }
        
        if ([NSString isBlank:[self.lsCouponCreateFee getStrVal]]) {
            _salesCouponVo.couponCreateFee = nil;
        } else {
            _salesCouponVo.couponCreateFee = [NSNumber numberWithDouble:[self.lsCouponCreateFee getStrVal].doubleValue];
        }
        
        _salesCouponVo.groupType = [self.lsGroupType getStrVal].integerValue;
        if ([NSString isNotBlank:[self.lsBuyStyleCount getStrVal]]) {
            _salesCouponVo.containStyleNum = [self.lsBuyStyleCount getStrVal].integerValue
            ;
        }
        if ([self.rdoIsCreateGoodsArea getStrVal].integerValue == 0) {
            _salesCouponVo.generateGoodsScope = 1;
        } else {
            _salesCouponVo.generateGoodsScope = 2;
        }
        
        if ([NSString isBlank:[self.lsCouponUseNum getStrVal]]) {
            _salesCouponVo.couponUseNumber = nil;
        } else {
            _salesCouponVo.couponUseNumber = [NSNumber numberWithInteger:[self.lsCouponUseNum getStrVal].integerValue];
        }
        
        if ([NSString isBlank:[self.lsCouponUseFee getStrVal]]) {
            _salesCouponVo.couponUseFee = nil;
        } else {
            _salesCouponVo.couponUseFee = [NSNumber numberWithDouble:[self.lsCouponUseFee getStrVal].doubleValue];
        }
        
        if ([self.rdoIsUseGoodsArea getStrVal].integerValue == 0) {
            _salesCouponVo.userGoodsScope = 1;
        } else {
            _salesCouponVo.userGoodsScope = 2;
        }
        
        _salesCouponVo.startDate = ([DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 00:00:00", [self.lsUseStartTime getStrVal]]])/1000;
        
        _salesCouponVo.endDate = ([DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59", [self.lsUseEndTime getStrVal]]])/1000;
        
        [_marketService saveCouponDetail:[SalesCouponVo getDictionaryData:_salesCouponVo] operateType:@"add" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            if ([_saveWay isEqualToString:@"1"]) {
                // 点击右上角“保存”按钮保存，返回到优惠券列表页面
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LSMarketListController class]]) {
                        LSMarketListController *listView = (LSMarketListController *)vc;
                        [listView loadDatasFromSalesRegulationEditView:ACTION_CONSTANTS_ADD salesId:_salesId];
                    }
                }
                [self.navigationController popViewControllerAnimated:NO];
            } else {
                _salesCouponId = [json objectForKey:@"couponId"];
                if ([_type isEqualToString:@"1"]) {
                    // 点击“出券款式范围” 保存后跳转到款式范围页面
                    SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:_salesCouponId discountType:@"3" shopId:_shopId action:SALES_COUPON_LIST_VIEW];
                    self.isCanDeal = @"1";
//                    _isDoingAct = 0;
                    salesStyleAreaView.isCanDeal = @"1";
                    salesStyleAreaView.operateMode = @"edit";
                    salesStyleAreaView.titleName = @"出券款式范围";
                    [self.navigationController pushViewController:salesStyleAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                } else if ([_type isEqualToString:@"2"]) {
                    // 点击“出券商品范围” 保存后跳转到商品范围页面
                    SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:_salesCouponId discountType:@"3" shopId:_shopId action:SALES_COUPON_LIST_VIEW];
                    self.isCanDeal = @"1";
//                    _isDoingAct = 0;
                    salesGoodsAreaView.isCanDeal = @"1";
                    salesGoodsAreaView.operateMode = @"edit";
                    salesGoodsAreaView.titleName = @"出券商品范围";
                    [self.navigationController pushViewController:salesGoodsAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                } else if ([_type isEqualToString:@"3"]) {
                    // 点击“使用款式范围” 保存后跳转到款式范围页面
                    SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:_salesCouponId discountType:@"4" shopId:_shopId action:SALES_COUPON_LIST_VIEW];
                    self.isCanDeal = @"1";
//                    _isDoingAct = 0;
                    salesStyleAreaView.isCanDeal = @"1";
                    salesStyleAreaView.operateMode = @"edit";
                    salesStyleAreaView.titleName = @"使用款式范围";
                    [self.navigationController pushViewController:salesStyleAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                } else if ([_type isEqualToString:@"4"]) {
                    // 点击“使用商品范围” 保存后跳转到商品范围页面
                    SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:_salesCouponId discountType:@"4" shopId:_shopId action:SALES_COUPON_LIST_VIEW];
                    self.isCanDeal = @"1";
//                    _isDoingAct = 0;
                    salesGoodsAreaView.isCanDeal = @"1";
                    salesGoodsAreaView.operateMode = @"edit";
                    salesGoodsAreaView.titleName = @"使用商品范围";
                    [self.navigationController pushViewController:salesGoodsAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                }
            }
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else{
        _salesCouponVo.salesId = _salesId;
        _salesCouponVo.worth = [self.lsCouponWorth getStrVal].doubleValue;
        _salesCouponVo.number = [self.lsCount getStrVal].integerValue;
        _salesCouponVo.remark = [self.txtremark getStrVal];
        if ([NSString isBlank:[self.lsCouponCreateNum getStrVal]]) {
            _salesCouponVo.couponCreateNumber = nil;
        } else {
            _salesCouponVo.couponCreateNumber = [NSNumber numberWithInteger:[self.lsCouponCreateNum getStrVal].integerValue];
        }
        
        if ([NSString isBlank:[self.lsCouponCreateFee getStrVal]]) {
            _salesCouponVo.couponCreateFee = nil;
        } else {
            _salesCouponVo.couponCreateFee = [NSNumber numberWithDouble:[self.lsCouponCreateFee getStrVal].doubleValue];
        }
        
        _salesCouponVo.groupType = [self.lsGroupType getStrVal].integerValue;
        if ([NSString isNotBlank:[self.lsBuyStyleCount getStrVal]]) {
            _salesCouponVo.containStyleNum = [self.lsBuyStyleCount getStrVal].integerValue
            ;
        }
        
        if ([self.rdoIsCreateGoodsArea getStrVal].integerValue == 0) {
            _salesCouponVo.generateGoodsScope = 1;
        } else {
            _salesCouponVo.generateGoodsScope = 2;
        }
        
        if ([NSString isBlank:[self.lsCouponUseNum getStrVal]]) {
            _salesCouponVo.couponUseNumber = nil;
        } else {
            _salesCouponVo.couponUseNumber = [NSNumber numberWithInteger:[self.lsCouponUseNum getStrVal].integerValue];
        }
        
        if ([NSString isBlank:[self.lsCouponUseFee getStrVal]]) {
            _salesCouponVo.couponUseFee = nil;
        } else {
            _salesCouponVo.couponUseFee = [NSNumber numberWithDouble:[self.lsCouponUseFee getStrVal].doubleValue];
        }
        
        if ([self.rdoIsUseGoodsArea getStrVal].integerValue == 0) {
            _salesCouponVo.userGoodsScope = 1;
        } else {
            _salesCouponVo.userGoodsScope = 2;
        }
        
        _salesCouponVo.startDate = ([DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 00:00:00", [self.lsUseStartTime getStrVal]]])/1000;
        
        _salesCouponVo.endDate = ([DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59", [self.lsUseEndTime getStrVal]]])/1000;
        
        [_marketService saveCouponDetail:[SalesCouponVo getDictionaryData:_salesCouponVo] operateType:@"edit" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            if ([_saveWay isEqualToString:@"1"]) {
                // 点击右上角“保存”按钮保存，返回到优惠券列表页面
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LSMarketListController class]]) {
                        LSMarketListController *listView = (LSMarketListController *)vc;
                        [listView loadDatasFromSalesRegulationEditView:ACTION_CONSTANTS_EDIT salesId:_salesId];
                    }
                }
                [self.navigationController popViewControllerAnimated:NO];
            } else {
                if ([_type isEqualToString:@"1"]) {
                    // 点击“出券款式范围” 保存后跳转到款式范围页面
                    SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:_salesCouponId discountType:@"3" shopId:_shopId action:SALES_COUPON_LIST_VIEW];
                    if ([self.isCanDeal isEqualToString:@"1"]) {
                        salesStyleAreaView.isCanDeal = @"1";
                    } else {
                        salesStyleAreaView.isCanDeal = @"0";
                    }
                    salesStyleAreaView.titleName = @"出券款式范围";
                    [self.navigationController pushViewController:salesStyleAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                } else if ([_type isEqualToString:@"2"]) {
                    // 点击“出券商品范围” 保存后跳转到商品范围页面
                    SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:_salesCouponId discountType:@"3" shopId:_shopId action:SALES_COUPON_LIST_VIEW];
                    if ([self.isCanDeal isEqualToString:@"1"]) {
                        salesGoodsAreaView.isCanDeal = @"1";
                    } else {
                        salesGoodsAreaView.isCanDeal = @"0";
                    }
                    salesGoodsAreaView.titleName = @"出券商品范围";
                    [self.navigationController pushViewController:salesGoodsAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                } else if ([_type isEqualToString:@"3"]) {
                    // 点击“使用款式范围” 保存后跳转到款式范围页面
                    SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:_salesCouponId discountType:@"4" shopId:_shopId action:SALES_COUPON_LIST_VIEW];
                    if ([self.isCanDeal isEqualToString:@"1"]) {
                        salesStyleAreaView.isCanDeal = @"1";
                    } else {
                        salesStyleAreaView.isCanDeal = @"0";
                    }
                    salesStyleAreaView.titleName = @"使用款式范围";
                    [self.navigationController pushViewController:salesStyleAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                } else if ([_type isEqualToString:@"4"]) {
                    // 点击“使用商品范围” 保存后跳转到商品范围页面
                    SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:_salesCouponId discountType:@"4" shopId:_shopId action:SALES_COUPON_LIST_VIEW];
                    if ([self.isCanDeal isEqualToString:@"1"]) {
                        salesGoodsAreaView.isCanDeal = @"1";
                    } else {
                        salesGoodsAreaView.isCanDeal = @"0";
                    }
                    salesGoodsAreaView.titleName = @"使用商品范围";
                    [self.navigationController pushViewController:salesGoodsAreaView animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                }
            }
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
    
}

#pragma mark save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.lsCouponWorth getStrVal]]) {
        [AlertBox show:@"优惠券面额(元)不能为空，请输入!"];
        return NO;
    }
    
    if ([self.lsCouponWorth getStrVal].doubleValue <= 0) {
        [AlertBox show:@"优惠券面额(元)必须大于0，请重新输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsCount getStrVal]]) {
        [AlertBox show:@"数量不能为空，请输入!"];
        return NO;
    }
    
    if ([self.lsCount getStrVal].integerValue <= 0) {
        [AlertBox show:@"数量必须大于0，请重新输入!"];
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
    
    if ([NSString isBlank:[self.lsCouponCreateNum getStrVal]] && [NSString isBlank:[self.lsCouponCreateFee getStrVal]]) {
        [AlertBox show:@"出券条件(购买数量)和出券条件(购买金额)必须填写一项，请输入!"];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.lsCouponCreateNum getStrVal]] && !self.lsBuyStyleCount.isHidden && [self.lsBuyStyleCount getStrVal].intValue > [self.lsCouponCreateNum getStrVal].intValue) {
        [AlertBox show:@"包含款数不能大于出券条件(购买数量)，请重新输入!"];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.lsCouponCreateNum getStrVal]] && [self.lsCouponCreateNum getStrVal].integerValue <= 0) {
        [AlertBox show:@"出券条件(购买数量)必须大于0，请重新输入!"];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.lsCouponCreateFee getStrVal]] && [self.lsCouponCreateFee getStrVal].doubleValue <= 0) {
        [AlertBox show:@"出券条件(购买金额)必须大于0，请重新输入!"];
        return NO;
    }
    
    
    if ([NSString isBlank:[self.lsCouponUseNum getStrVal]] && [NSString isBlank:[self.lsCouponUseFee getStrVal]]) {
        [AlertBox show:@"使用条件(购买数量)和使用条件(购买金额)必须填写一项，请输入!"];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.lsCouponUseNum getStrVal]] && [self.lsCouponUseNum getStrVal].integerValue <= 0) {
        [AlertBox show:@"使用条件(购买数量)必须大于0，请重新输入!"];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.lsCouponUseFee getStrVal]] && [self.lsCouponUseFee getStrVal].doubleValue <= 0) {
        [AlertBox show:@"使用条件(购买金额)必须大于0，请重新输入!"];
        return NO;
    }
    
    if ([DateUtils formateDateTime3:[self.lsUseEndTime getStrVal]] < [DateUtils formateDateTime3:[self.lsUseStartTime getStrVal]]) {
        [AlertBox show:@"使用结束日期不能小于使用开始日期，请重新选择!"];
        return NO;
    }
    
    return YES;
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:@"确认要删除该规则吗？"];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        __weak SaleCouponEditView* weakSelf = self;
        if (self.action == ACTION_CONSTANTS_EDIT) {
            [_marketService deleteSalesCouponDetail:_salesCouponId completionHandler:^(id json) {
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
- (void)delFinish
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

-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"详情" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_SaleCouponEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SaleCouponEditView_Change object:nil];
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
