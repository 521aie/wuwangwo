//
//  SpecialOfferAddView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SpecialOfferAddView.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "OptionPickerBox.h"
#import "MarketModuleEvent.h"
#import "RetailTable2.h"
#import "ItemTitle.h"
#import "EditItemMemo.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "EditItemRadio.h"
#import "PriceRuleVo.h"
#import "MarketRender.h"
#import "DateUtils.h"
#import "Platform.h"
#import "SymbolNumberInputBox.h"
#import "DatePickerBox.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "ServiceFactory.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "PriceInfoVo.h"
#import "SelectOrgShopListView.h"
#import "GoodsVo.h"
#import "StyleVo.h"
#import "GoodsBatchChoiceView2.h"
#import "GoodsBatchChoiceView1.h"
#import "StyleBatchChoiceView2.h"
@interface SpecialOfferAddView ()

@property (nonatomic, strong) MarketService* marketService;

@property (nonatomic) int action;

@property (nonatomic) int fromViewTag;

/**
 特价规则信息
 */
@property (nonatomic, strong) PriceRuleVo *priceRuleVo;

/**
 特价信息
 */
@property (nonatomic, strong) PriceInfoVo *priceInfoVo;

@property (nonatomic, strong) NSMutableArray* shopList;

@property (nonatomic, strong) NSMutableArray* goodsList;

@property (nonatomic, strong) NSMutableArray* styleList;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic, strong) ShopVo* tempVo;

/** 
 保存前一次选择的价格方案
 */
@property (nonatomic) short discountType;

@end

@implementation SpecialOfferAddView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil goodsList:(NSMutableArray*) goodsList styleList:(NSMutableArray*) styleList action:(int) action fromView:(int)viewTag shopId:(NSString *)shopId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _goodsList = goodsList;
        _styleList = styleList;
        _action = action;
        _fromViewTag = viewTag;
        _shopId = shopId;
        _shopList = [[NSMutableArray alloc] init];
        _marketService = [ServiceFactory shareInstance].marketService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self clearDo];
}

#pragma 页面添加初始化
-(void) clearDo
{
    if ([[Platform Instance] getShopMode] == 1 || [[Platform Instance] getShopMode] == 2) {
        [self.TitShop visibal:NO];
        [self.rdoIsShopArea visibal:NO];
        [self.shopView setLs_height:0];
        self.shopView.alpha = 0;
        [self.RTShopList visibal:NO];
    }else{
        [self.TitShop visibal:YES];
        [self.rdoIsShopArea visibal:YES];
        [self.shopView setLs_height:48];
        self.shopView.alpha = 1;
        [self.RTShopList visibal:YES];
    }
    
    [self.rdoIsMember initData:@"0"];
    
    [self.rdoIsShop initData:@"1"];
    
    // 非总部机构用户登录添加特价活动应不显示“适用微店”标签
    if ([[Platform Instance] getMicroShopStatus] == 2 && ([[Platform Instance] getShopMode] == 1 || ([[Platform Instance] getShopMode] == 3 && [[[Platform Instance] getkey:PARENT_ID] integerValue] == 0 && [[Platform Instance] isTopOrg]))) {
        [self.rdoIsWeiXin visibal:YES];
        [self.rdoIsWeiXin initData:@"1"];
        [self.rdoIsShop isEditable:YES];
    }else{
        [self.rdoIsWeiXin visibal:NO];
        [self.rdoIsWeiXin initData:@"0"];
        [self.rdoIsShop isEditable:NO];
    }

    [self.lsShopPriceScheme visibal:YES];
    [self.lsSalePrice visibal:NO];
    [self.lsDiscountRate visibal:YES];
    [self.lsSaleScheme initData:@"设置折扣率" withVal:@"1"];
    
    [self.lsShopPriceScheme initData:@"在零售价基础上打折" withVal:@"1"];
    _discountType = 1;
    
    [self.lsSalePrice initData:nil withVal:@""];
    
    [self.lsDiscountRate initData:nil withVal:@""];
    
    [self.lsStartTime initData:[DateUtils formateDate2:[NSDate date]] withVal:[DateUtils formateDate2:[NSDate date]]];
    
    [self.lsEndTime initData:[DateUtils formateDate2:[NSDate date]] withVal:[DateUtils formateDate2:[NSDate date]]];
    
    [self.rdoIsShopArea initData:@"1"];
    self.lblShopNum.text = @"合计0个门店";
    [self.RTShopList loadData:nil detailCount:0];
    
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        [self.lsShopPriceScheme visibal:YES];
    }else{
        [self.lsShopPriceScheme visibal:NO];
    }
    
}

#pragma 页面数据初始化
-(void) initMainView
{
    self.TitSpecial.lblName.text = @"特价设置";
    
    [self.rdoIsMember initLabel:@"会员专享" withHit:nil delegate:self];
    
    [self.rdoIsShop initLabel:@"适用实体门店" withHit:nil delegate:self];
    
    [self.rdoIsWeiXin initLabel:@"适用微店" withHit:nil delegate:self];
    
    [self.lsSaleScheme initLabel:@"特价方案" withHit:nil delegate:self];
    
    [self.lsShopPriceScheme initLabel:@"▪︎ 价格方案" withHit:nil delegate:self];
    
    [self.lsDiscountRate initLabel:@"▪︎ 折扣率(%)" withHit:nil isrequest:YES delegate:self];
    
    [self.lsSalePrice initLabel:@"▪︎ 特价(元)" withHit:nil isrequest:YES delegate:self];
    
    self.TitValidDate.lblName.text = @"有效期设置";
    
    [self.lsStartTime initLabel:@"开始日期" withHit:nil delegate:self];
    
    [self.lsEndTime initLabel:@"结束日期" withHit:nil delegate:self];
    
    self.TitShop.lblName.text = @"促销门店设置";
    
    [self.rdoIsShopArea initLabel:@"指定门店范围" withHit:nil delegate:self];
    
    self.lblShopNum.text = @"合计0个门店";
    
    [self.RTShopList initDelegate:self event:SPECIAL_OFFER_MANAGE_EDIT_SHOP_EVENT kindName:@"" addName:@"添加活动门店..."];
    [self.RTShopList loadData:nil  detailCount:0];
    self.RTShopList.viewTag = SPECIAL_OFFER_EDIT_VIEW;
    
    self.lsSaleScheme.tag = SPECIAL_OFFER_MANAGE_EDIT_SALESCHEME;
    self.lsShopPriceScheme.tag = SPECIAL_OFFER_MANAGE_EDIT_SHOPPRICESCHEME;
    self.lsDiscountRate.tag = SPECIAL_OFFER_MANAGE_EDIT_DISCOUNTRATE;
    self.lsSalePrice.tag = SPECIAL_OFFER_MANAGE_EDIT_SALEPRICE;
    self.rdoIsMember.tag = SPECIAL_OFFER_MANAGE_EDIT_ISMEMBER;
    self.lsStartTime.tag = SPECIAL_OFFER_MANAGE_EDIT_STARTTIME;
    self.lsEndTime.tag = SPECIAL_OFFER_MANAGE_EDIT_ENDTIME;
    self.rdoIsShopArea.tag = SPECIAL_OFFER_MANAGE_EDIT_ISSHOP;
    self.rdoIsShop.tag = SPECIAL_OFFER_MANAGE_EDIT_RDOSHOP;
}

#pragma navigateTitle
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"添加" backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text = @"保存";
    self.titleBox.lblRight.hidden = NO;
    [self.titleDiv addSubview:self.titleBox];
}

-(IBAction)addShopAreaButton:(id)sender
{
    [self showAddEvent:nil];
}

#pragma 跳转到至选择门店页面
-(void) showAddEvent:(NSString *)event
{
    if (_shopList.count >= 50) {
        [AlertBox show:@"促销门店数量已达到上限，请先删除再添加!"];
        return ;
    }
    
    //跳转页面至选择门店
    SelectOrgShopListView* selectOrgShopListView = [[SelectOrgShopListView alloc] init];
    [self.navigationController pushViewController:selectOrgShopListView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    __weak SpecialOfferAddView* weakSelf = self;
    [selectOrgShopListView loadData:[[Platform Instance] getkey:SHOP_ID] withModuleType:3 withCheckMode:MUTIl_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        if (selectArr) {
            for (id<ITreeItem> tempVo in selectArr) {
                if ([tempVo obtainItemType] == 2) {
                    ShopVo* vo1 = [[ShopVo alloc] init];
                    vo1.shopName = [tempVo obtainItemName];
                    vo1.code = [NSString stringWithFormat:@"门店编号：%@", [tempVo obtainItemValue]];
                    vo1.shopId = [tempVo obtainItemId];
                    
                    //判断原来shop列表中是否已经存在
                    BOOL flg = NO;
                    for (ShopVo* temp in weakSelf.shopList) {
                        if ([vo1.shopId isEqualToString:temp.shopId]) {
                            flg = YES;
                            break;
                        }
                    }
                    if (!flg) {
                        [weakSelf.shopList addObject:vo1];
                    }
                    
                }
            }
            
            [weakSelf.RTShopList loadData:weakSelf.shopList detailCount:[weakSelf.shopList count]];
            weakSelf.lblShopNum.text = [NSString stringWithFormat:@"合计%lu个门店", (unsigned long)weakSelf.shopList.count];
            [UIHelper refreshUI:weakSelf.container scrollview:weakSelf.scrollView];
        }
    }];
}

#pragma 点击cell事件
- (void)showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    return ;
}

#pragma 点击机构/门店删除按键
-(void) delObjEvent:(NSString *)event obj:(id)obj
{
    _tempVo = (ShopVo*) obj;
    for (ShopVo* temp in self.shopList) {
        if ([[temp obtainItemId] isEqualToString:[_tempVo obtainItemId]]) {
            [self.shopList removeObject:temp];
            break ;
        }
    }
    [self.RTShopList loadData:self.shopList detailCount:[self.shopList count]];
    self.lblShopNum.text = [NSString stringWithFormat:@"合计%lu个门店", (unsigned long)self.shopList.count];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 下拉框事件
-(void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag == SPECIAL_OFFER_MANAGE_EDIT_SALESCHEME){
        [OptionPickerBox initData:[MarketRender listSaleScheme]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj.tag == SPECIAL_OFFER_MANAGE_EDIT_SHOPPRICESCHEME){
        [OptionPickerBox initData:[MarketRender listShopPriceScheme]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj.tag == SPECIAL_OFFER_MANAGE_EDIT_DISCOUNTRATE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
    } else if (obj.tag == SPECIAL_OFFER_MANAGE_EDIT_SALEPRICE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    } else if (obj.tag == SPECIAL_OFFER_MANAGE_EDIT_STARTTIME || obj.tag == SPECIAL_OFFER_MANAGE_EDIT_ENDTIME) {
        NSDate *date=[DateUtils parseDateTime4:obj.lblVal.text];
        
        [DatePickerBox show:obj.lblName.text date:date client:self event:(int)obj.tag];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

// 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == SPECIAL_OFFER_MANAGE_EDIT_SALESCHEME) {
        [self.lsSaleScheme changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemId] isEqualToString:@"1"]) {
            [self.lsDiscountRate visibal:YES];
            [self.lsSalePrice visibal:NO];
            if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
                [self.lsShopPriceScheme visibal:YES];
            }
            [self.lsShopPriceScheme changeData:[MarketRender obtainShopPriceScheme:_discountType] withVal:[NSString stringWithFormat:@"%d", _discountType]];
        }else{
            [self.lsDiscountRate visibal:NO];
            [self.lsSalePrice visibal:YES];
            [self.lsShopPriceScheme visibal:NO];
        }
    }else if (eventType == SPECIAL_OFFER_MANAGE_EDIT_SHOPPRICESCHEME){
        [self.lsShopPriceScheme changeData:[item obtainItemName] withVal:[item obtainItemId]];
        _discountType = [item obtainItemId].integerValue;
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

//选择日期
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    
    if (event == SPECIAL_OFFER_MANAGE_EDIT_STARTTIME) {
        
        NSString* dateStr=[DateUtils formateDate2:date];
        [self.lsStartTime changeData:dateStr withVal:dateStr];
    }else if (event == SPECIAL_OFFER_MANAGE_EDIT_ENDTIME){
        NSString* dateStr=[DateUtils formateDate2:date];
        [self.lsEndTime changeData:dateStr withVal:dateStr];
    }
    return YES;
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if ([NSString isBlank:val]) {
        val = nil;
    } else {
        val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
    }
    
    if (eventType==SPECIAL_OFFER_MANAGE_EDIT_SALEPRICE) {
        
        [self.lsSalePrice changeData:val withVal:val];
        
    }else if (eventType==SPECIAL_OFFER_MANAGE_EDIT_DISCOUNTRATE) {
        
        if (val.doubleValue>100.00) {
            [AlertBox show:@"折扣率(%)不能超过100.00，请重新输入!"];
            return;
            
        }else{
            
            if ([NSString isBlank:val]) {
                val = nil;
            } else {
                val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
            }
        }
        
        [self.lsDiscountRate changeData:val withVal:val];
    }
    
}

#pragma 开关事件
-(void) onItemRadioClick:(EditItemRadio*)obj
{
    BOOL result = [[obj getStrVal] isEqualToString:@"1"];
    
    if (obj.tag == SPECIAL_OFFER_MANAGE_EDIT_ISSHOP) {
        if (result) {
            self.shopView.hidden = NO;
            self.RTShopList.hidden = NO;
        }else{
            self.shopView.hidden = YES;
            self.RTShopList.hidden = YES;
        }
    } else if (obj.tag == SPECIAL_OFFER_MANAGE_EDIT_RDOSHOP) {
        if (result) {
            if ([[Platform Instance] getShopMode] != 1) {
                [self.TitShop visibal:YES];
                [self.rdoIsShopArea visibal:YES];
                if ([[self.rdoIsShopArea getStrVal] isEqualToString:@"1"]) {
                    self.shopView.hidden = NO;
                    self.RTShopList.hidden = NO;
                } else {
                    self.shopView.hidden = YES;
                    self.RTShopList.hidden = YES;
                }
            }
        } else {
            [self.TitShop visibal:NO];
            [self.rdoIsShopArea visibal:NO];
            self.shopView.hidden = YES;
            self.RTShopList.hidden = YES;
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}

#pragma 导航栏事件
-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        // 返回到特价信息一览页面
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        // 保存特价信息
        [self save];
    }
}

#pragma 保存事件
-(void)save
{
    if (![self isValid]){
        return;
    }
    
    __weak SpecialOfferAddView* weakSelf = self;
    
    
    _priceRuleVo = [[PriceRuleVo alloc] init];
    _priceRuleVo.isMember = [self.rdoIsMember getStrVal].integerValue;
    _priceRuleVo.isShop = [self.rdoIsShop getStrVal].integerValue;
    _priceRuleVo.isWeiXin = [self.rdoIsWeiXin getStrVal].integerValue;
    _priceRuleVo.saleScheme = [self.lsSaleScheme getStrVal].integerValue;
    _priceRuleVo.shopPriceScheme = [self.lsShopPriceScheme getStrVal].integerValue;
    if ([NSString isNotBlank:[self.lsDiscountRate getStrVal]]) {
        _priceRuleVo.discountRate = [self.lsDiscountRate getStrVal].doubleValue;
    }
    
    if ([NSString isNotBlank:[self.lsSalePrice getStrVal]]) {
        _priceRuleVo.salePrice = [self.lsSalePrice getStrVal].doubleValue;
    }

    _priceRuleVo.startTime = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 00:00:00", [self.lsStartTime getStrVal]]];

    _priceRuleVo.endTime = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59", [self.lsEndTime getStrVal]]];
    
    NSMutableArray* shopIdList = [[NSMutableArray alloc] init];
    if (_shopList != nil && _shopList.count > 0) {
        for (ShopVo* vo in _shopList) {
            [shopIdList addObject:vo.shopId];
        }
    }
    
    NSString* shopFlg = nil;
    if ([[Platform Instance] getShopMode] == 3) {
        if ([self.rdoIsShopArea getStrVal].integerValue == 0) {
            shopFlg = @"1";
        }else{
            shopFlg = @"2";
        }
    }else{
        shopFlg = @"1";
    }
    
    if (_fromViewTag == SPECIAL_OFFER_GOODS_LIST_VIEW) {
        
        NSMutableArray* goodsIdList = [[NSMutableArray alloc] init];
        for (GoodsVo* vo in _goodsList) {
            [goodsIdList addObject:vo.goodsId];
        }
        
        [_marketService saveGoods:[PriceRuleVo getDictionaryData:_priceRuleVo] goodsIdList:goodsIdList shopsIdList:shopIdList operateType:@"add" shopFlag:shopFlg completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            if ([[Platform Instance] getkey:SHOP_MODE].intValue == 101) {
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[GoodsBatchChoiceView2 class]]) {
                        GoodsBatchChoiceView2 *listView = (GoodsBatchChoiceView2 *)vc;
                        [listView clearCheckStatus];
                    }
                }
            } else {
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[GoodsBatchChoiceView1 class]]) {
                        GoodsBatchChoiceView1 *listView = (GoodsBatchChoiceView1 *)vc;
                        [listView clearCheckStatus];
                    }
                }
            }
            [self.navigationController popViewControllerAnimated:NO];
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else{
        NSMutableArray* styleIdList = [[NSMutableArray alloc] init];
        for (StyleVo* vo in _styleList) {
            [styleIdList addObject:vo.styleId];
        }
        
        [_marketService saveStyles:[PriceRuleVo getDictionaryData:_priceRuleVo] styleIdList:styleIdList shopsIdList:shopIdList operateType:@"add" shopFlag:shopFlg completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[StyleBatchChoiceView2 class]]) {
                    StyleBatchChoiceView2 *listView = (StyleBatchChoiceView2 *)vc;
                    [listView clearCheckStatus];
                }
            }
            [self.navigationController popViewControllerAnimated:NO];
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

#pragma 页面check
-(BOOL) isValid
{
    if (!self.rdoIsShop.isHidden && !self.rdoIsWeiXin.isHidden && [[self.rdoIsShop getStrVal] isEqualToString:@"0"] && [[self.rdoIsWeiXin getStrVal] isEqualToString:@"0"]) {
        [AlertBox show:@"适用实体门店开关和适用微店开关不能同时关闭，请重新选择!"];
        return NO;
    }
    
    if ([[self.lsSaleScheme getStrVal] isEqualToString:@"1"] && [NSString isBlank:[self.lsDiscountRate getStrVal]]) {
        [AlertBox show:@"折扣率(%)不能为空，请输入!"];
        return NO;
    }
    
    if ([[self.lsSaleScheme getStrVal] isEqualToString:@"2"] && [NSString isBlank:[self.lsSalePrice getStrVal]]) {
        [AlertBox show:@"特价不能为空，请输入!"];
        return NO;
    }
    
    if ([[Platform Instance] getShopMode] == 3 && [[self.rdoIsShop getStrVal] isEqualToString:@"1"] && [[self.rdoIsShopArea getStrVal] isEqualToString:@"1"] && self.shopList.count == 0) {
        [AlertBox show:@"请选择指定门店范围!"];
        return NO;
    }
    
    long long date = [DateUtils formateDateTime3:[DateUtils formateDate2:[NSDate date]]];
    if ([DateUtils formateDateTime3:[self.lsEndTime getStrVal]] < date) {
        [AlertBox show:@"结束日期不能小于当前日期，请重新选择!"];
        return NO;
    }
    
    if ([DateUtils formateDateTime3:[self.lsEndTime getStrVal]] < [DateUtils formateDateTime3:[self.lsStartTime getStrVal]]) {
        [AlertBox show:@"结束日期不能小于开始日期，请重新选择!"];
        return NO;
    }
    
    return YES;
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_GoodsStyleEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_GoodsStyleEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

@end
