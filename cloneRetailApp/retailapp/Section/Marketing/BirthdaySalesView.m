//
//  BirthdaySalesView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "BirthdaySalesView.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "EditItemRadio2.h"
#import "ItemTitle.h"
#import "MarketModuleEvent.h"
#import "OptionPickerBox.h"
#import "MarketRender.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "MemberBirSaleVo.h"
#import "Platform.h"

@interface BirthdaySalesView ()

@property (nonatomic, strong) MarketService* marketService;

@end

@implementation BirthdaySalesView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _marketService = [ServiceFactory shareInstance].marketService;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configHelpButton:HELP_MARKET_BIRTHDAY_PROMOTION];
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

#pragma 查询生日促销
- (void)loaddatas
{
    self.action = ACTION_CONSTANTS_EDIT;
    __weak BirthdaySalesView* weakSelf = self;
    [_marketService selectMemberBirthdaySales:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

#pragma 后台返回数据封装
- (void)responseSuccess:(id)json
{
    self.memberBirSaleVo = [MemberBirSaleVo convertToMemberBirSaleVo:[json objectForKey:@"memberBirSaleVo"]];
    
    if (self.memberBirSaleVo == nil || self.memberBirSaleVo.status == 2) {
        [self clearDo];
    }else{
       [self fillModel];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 页面添加数据初始化
- (void)clearDo
{
    [self.rdoIsUsed initData:@"0"];
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        [self.lsShopPriceScheme initData:[MarketRender obtainBirShopPriceScheme:2 isShow:YES] withVal:@"2"];
    } else {
        [self.lsShopPriceScheme initData:[MarketRender obtainBirShopPriceScheme:1 isShow:NO] withVal:@"1"];
    }
    
    [self.lsDiscountRate initData:nil withVal:nil];
    [self.lsGoodsCount initData:nil withVal:nil];
    [self.lsPurchaseNumber initData:@"1" withVal:@"1"];
    [self.rdoIsMemberMonth initData:@"0"];
    [self.rdoIsAppointDate initData:@"1"];
    [self.lsAfterBir initData:@"0天" withVal:@"0"];
    [self.lsBeforeBir initData:@"0天" withVal:@"0"];
    
    [self showView:NO];
}

#pragma 页面详情数据显示
- (void)fillModel
{
    if (self.memberBirSaleVo.status == 1) {
        [self.rdoIsUsed initData:@"1"];
    } else {
        [self.rdoIsUsed initData:@"0"];
    }
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        [self.lsShopPriceScheme initData:[MarketRender obtainBirShopPriceScheme:self.memberBirSaleVo.priceScheme isShow:YES] withVal:[NSString stringWithFormat:@"%d", self.memberBirSaleVo.priceScheme]];
    } else {
       [self.lsShopPriceScheme initData:[MarketRender obtainBirShopPriceScheme:self.memberBirSaleVo.priceScheme isShow:NO] withVal:[NSString stringWithFormat:@"%d", self.memberBirSaleVo.priceScheme]];
    }
    
    [self.lsDiscountRate initData:[NSString stringWithFormat:@"%.2f", self.memberBirSaleVo.rate] withVal:[NSString stringWithFormat:@"%.2f", self.memberBirSaleVo.rate]];
    [self.lsGoodsCount initData:[NSString stringWithFormat:@"%tu", self.memberBirSaleVo.goodsCount] withVal:[NSString stringWithFormat:@"%tu", self.memberBirSaleVo.goodsCount]];
    [self.lsPurchaseNumber initData:[NSString stringWithFormat:@"%tu", self.memberBirSaleVo.purchaseNumber] withVal:[NSString stringWithFormat:@"%tu", self.memberBirSaleVo.purchaseNumber]];
    [self.lsAfterBir initData:[NSString stringWithFormat:@"%tu天", self.memberBirSaleVo.birthdayAfterDays] withVal:[NSString stringWithFormat:@"%tu", self.memberBirSaleVo.birthdayAfterDays]];
    [self.lsBeforeBir initData:[NSString stringWithFormat:@"%tu天", self.memberBirSaleVo.birthdayBeforeDays] withVal:[NSString stringWithFormat:@"%tu", self.memberBirSaleVo.birthdayBeforeDays]];
    if (self.memberBirSaleVo.validityType == 1) {
        [self.rdoIsMemberMonth initData:@"1"];
        [self.rdoIsAppointDate initData:@"0"];
    } else {
        [self.rdoIsMemberMonth initData:@"0"];
        [self.rdoIsAppointDate initData:@"1"];
    }
    
    if (self.memberBirSaleVo.status == 1) {
        [self showView:YES];
        if (self.memberBirSaleVo.validityType == 1) {
            [self.lsAfterBir visibal:NO];
            [self.lsBeforeBir visibal:NO];
        } else {
            [self.lsAfterBir visibal:YES];
            [self.lsBeforeBir visibal:YES];
        }
    } else {
        [self showView:NO];
    }
}

#pragma 页面数据是否显示
- (void)showView:(BOOL)isShow
{
    if (isShow) {
        [self.TitSalesRegulation visibal:YES];
        [self.lsShopPriceScheme visibal:YES];
        [self.lsDiscountRate visibal:YES];
        [self.lsGoodsCount visibal:YES];
        [self.lsPurchaseNumber visibal:YES];
        [self.TitValidDate visibal:YES];
        [self.rdoIsMemberMonth visibal:YES];
        [self.rdoIsAppointDate visibal:YES];
        [self.lsAfterBir visibal:YES];
        [self.lsBeforeBir visibal:YES];
    } else {
        [self.TitSalesRegulation visibal:NO];
        [self.lsShopPriceScheme visibal:NO];
        [self.lsDiscountRate visibal:NO];
        [self.lsGoodsCount visibal:NO];
        [self.lsPurchaseNumber visibal:NO];
        [self.TitValidDate visibal:NO];
        [self.rdoIsMemberMonth visibal:NO];
        [self.rdoIsAppointDate visibal:NO];
        [self.lsAfterBir visibal:NO];
        [self.lsBeforeBir visibal:NO];
    }
}

#pragma 页面初始化
- (void)initMainView
{
    [self.rdoIsUsed initLabel:@"开启会员生日打折促销" withHit:@"" delegate:self];
    [self.rdoIsUsed.line setHidden:YES];
    self.TitSalesRegulation.lblName.text = @"促销规则设置";
    [self.lsShopPriceScheme initLabel:@"价格方案" withHit:nil delegate:self];
    [self.lsDiscountRate initLabel:@"折扣率(%)" withHit:nil isrequest:YES delegate:self];
    [self.lsGoodsCount initLabel:@"限购总数量" withHit:nil isrequest:YES delegate:self];
    [self.lsPurchaseNumber initLabel:@"限购总次数" withHit:nil isrequest:YES delegate:self];
    
    self.TitValidDate.lblName.text = @"有效期设置";
    [self.rdoIsMemberMonth initLabel:@"在会员生日月有效" withHit:nil delegate:self];
    [self.rdoIsAppointDate initLabel:@"在指定时间有效" withHit:nil delegate:self];
    [self.lsBeforeBir initLabel:@"▪︎ 会员生日前" withHit:nil delegate:self];
    [self.lsAfterBir initLabel:@"▪︎ 会员生日后" withHit:nil delegate:self];
    
    self.rdoIsUsed.tag = BIRTHDAY_SALES_ISUSED;
    self.lsShopPriceScheme.tag = BIRTHDAY_SALES_SHOPPRICESCHEME;
    self.lsDiscountRate.tag = BIRTHDAY_SALES_DISCOUNTRATE;
    self.lsGoodsCount.tag = BIRTHDAY_SALES_GOODSCOUNT;
    self.lsPurchaseNumber.tag = BIRTHDAY_SALES_PURCHASENUMBER;
    self.rdoIsMemberMonth.tag = BIRTHDAY_SALES_ISMEMBERMONTH;
    self.rdoIsAppointDate.tag = BIRTHDAY_SALES_ISAPPOINTDATE;
    self.lsBeforeBir.tag = BIRTHDAY_SALES_BEFOREBIR;
    self.lsAfterBir.tag = BIRTHDAY_SALES_AFTERBIR;
}

#pragma 下拉框事件
- (void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag == BIRTHDAY_SALES_SHOPPRICESCHEME){
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
            [OptionPickerBox initData:[MarketRender listBirShopPriceScheme:YES]itemId:[obj getStrVal]];
        }else{
            [OptionPickerBox initData:[MarketRender listBirShopPriceScheme:NO]itemId:[obj getStrVal]];
        }
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag == BIRTHDAY_SALES_GOODSCOUNT){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:8 digitLimit:0];
    }else if (obj.tag == BIRTHDAY_SALES_PURCHASENUMBER){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:8 digitLimit:0];
    }else if (obj.tag == BIRTHDAY_SALES_DISCOUNTRATE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
    }else if (obj.tag == BIRTHDAY_SALES_BEFOREBIR){
        [OptionPickerBox initData:[MarketRender listBirDate]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag == BIRTHDAY_SALES_AFTERBIR){
        [OptionPickerBox initData:[MarketRender listBirDate]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

// 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == BIRTHDAY_SALES_SHOPPRICESCHEME) {
        [self.lsShopPriceScheme changeData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == BIRTHDAY_SALES_BEFOREBIR){
        [self.lsBeforeBir changeData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == BIRTHDAY_SALES_AFTERBIR){
        [self.lsAfterBir changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

#pragma 开关事件
- (void)onItemRadioClick:(EditItemRadio*)obj
{
    BOOL result = [[obj getStrVal] isEqualToString:@"1"];
    
    if (obj.tag == BIRTHDAY_SALES_ISMEMBERMONTH) {
        if (result) {
            [self.rdoIsAppointDate changeData:@"0"];
            [self.lsAfterBir visibal:NO];
            [self.lsBeforeBir visibal:NO];
        } else {
            [self.rdoIsAppointDate changeData:@"1"];
            [self.lsAfterBir visibal:YES];
            [self.lsBeforeBir visibal:YES];
        }
    } else if (obj.tag == BIRTHDAY_SALES_ISAPPOINTDATE) {
        if (result) {
            [self.rdoIsMemberMonth changeData:@"0"];
            [self.lsAfterBir visibal:YES];
            [self.lsBeforeBir visibal:YES];
        } else {
            [self.rdoIsMemberMonth changeData:@"1"];
            [self.lsAfterBir visibal:NO];
            [self.lsBeforeBir visibal:NO];
        }
    } else if (obj.tag == BIRTHDAY_SALES_ISUSED){
        if (result) {
            [self showView:YES];
            if ([[self.rdoIsMemberMonth getStrVal] isEqualToString:@"1"]) {
                [self.lsAfterBir visibal:NO];
                [self.lsBeforeBir visibal:NO];
            }
        } else {
            [self showView:NO];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    
    if (eventType==BIRTHDAY_SALES_DISCOUNTRATE) {
        
        if (val.doubleValue>100.00) {
            [AlertBox show:@"折扣率(%)不能大于100.00，请重新输入"];
            return ;
        }else{
            if ([NSString isBlank:val]) {
                val = @"";
            } else {
                val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
            }
        }
        
        [self.lsDiscountRate changeData:val withVal:val];
        
    } else if (eventType==BIRTHDAY_SALES_GOODSCOUNT) {
        
        if ([NSString isBlank:val]) {
            val = @"";
        } else {
            val = [NSString stringWithFormat:@"%d",val.intValue];
        }
        
        [self.lsGoodsCount changeData:val withVal:val];
    } else if (eventType==BIRTHDAY_SALES_PURCHASENUMBER) {
        
        if ([NSString isBlank:val]) {
            val = @"";
        } else {
            val = [NSString stringWithFormat:@"%d",val.intValue];
        }
        
        [self.lsPurchaseNumber changeData:val withVal:val];
    }
    
}

#pragma 导航栏事件
- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        // 返回到营销信息主页
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        
    }else{
        [self save];
    }
}

#pragma 保存事件
- (void)save
{
    if (![self isValid]){
        return;
    }
    
    NSString* type = nil;
    if (self.memberBirSaleVo == nil) {
        self.memberBirSaleVo = [[MemberBirSaleVo alloc] init];
        type = @"add";
    } else {
        type = @"edit";
    }
    
    if ([[self.rdoIsUsed getStrVal] isEqualToString:@"1"]) {
        self.memberBirSaleVo.status = 1;
    } else {
        self.memberBirSaleVo.status = 2;
    }

    self.memberBirSaleVo.priceScheme = [self.lsShopPriceScheme getStrVal].integerValue;
    
    self.memberBirSaleVo.rate = [self.lsDiscountRate getStrVal].doubleValue;
    self.memberBirSaleVo.goodsCount = [self.lsGoodsCount getStrVal].integerValue;
    self.memberBirSaleVo.purchaseNumber = [self.lsPurchaseNumber getStrVal].integerValue;
    if ([[self.rdoIsMemberMonth getStrVal] isEqualToString:@"1"]) {
        self.memberBirSaleVo.validityType = 1;
    } else {
        self.memberBirSaleVo.validityType = 2;
    }
    if ([NSString isNotBlank:[self.lsBeforeBir getStrVal]]) {
        self.memberBirSaleVo.birthdayBeforeDays = [self.lsBeforeBir getStrVal].integerValue;
    }
    if ([NSString isNotBlank:[self.lsAfterBir getStrVal]]) {
        self.memberBirSaleVo.birthdayAfterDays = [self.lsAfterBir getStrVal].integerValue;
    }
    
    __weak BirthdaySalesView* weakSelf = self;
    [_marketService saveMemberBirthdaySales:[MemberBirSaleVo getDictionaryData:self.memberBirSaleVo] operateType:type completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self.navigationController popViewControllerAnimated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

#pragma save-data
- (BOOL)isValid
{
    if ([[self.rdoIsUsed getStrVal] isEqualToString:@"1"] && [NSString isBlank:[self.lsDiscountRate getStrVal]]) {
        [AlertBox show:@"折扣率(%)不能为空，请输入!"];
        return NO;
    }
    
    if ([[self.rdoIsUsed getStrVal] isEqualToString:@"1"] && [NSString isBlank:[self.lsGoodsCount getStrVal]]) {
        [AlertBox show:@"限购总数量不能为空，请输入!"];
        return NO;
    }
    
    if ([[self.rdoIsUsed getStrVal] isEqualToString:@"1"] && [self.lsGoodsCount getStrVal].intValue == 0) {
        [AlertBox show:@"限购总数量必须大于0，请重新输入!"];
        return NO;
    }
    
    if ([[self.rdoIsUsed getStrVal] isEqualToString:@"1"] && [NSString isBlank:[self.lsPurchaseNumber getStrVal]]) {
        [AlertBox show:@"限购总次数不能为空，请输入!"];
        return NO;
    }
    
    if ([[self.rdoIsUsed getStrVal] isEqualToString:@"1"] && [self.lsPurchaseNumber getStrVal].intValue == 0) {
        [AlertBox show:@"限购总次数必须大于0，请输入!"];
        return NO;
    }
    
    return YES;
}

- (void)initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"会员生日促销" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_GoodsStyleEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_GoodsStyleEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

@end
