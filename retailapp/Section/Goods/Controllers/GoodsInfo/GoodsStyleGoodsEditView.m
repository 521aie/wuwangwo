//
//  GoodsStyleGoodsEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsStyleGoodsEditView.h"
#import "UIHelper.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "EditItemText2.h"
#import "GoodsModuleEvent.h"
#import "SymbolNumberInputBox.h"
#import "StyleGoodsVo.h"
#import "XHAnimalUtil.h"
#import "GoodsSkuVo.h"
#import "ColorHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "GoodsStyleGoodsListView.h"
#import "ScanViewController.h"
#import "ISearchBarEvent.h"

@interface GoodsStyleGoodsEditView () <EditItemText2Delegate, ISearchBarEvent,LSScanViewDelegate>

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic) int action;

@property (nonatomic, strong) StyleGoodsVo *styleGoodsVo;

@property (nonatomic, strong) NSString* styleId;

@property (nonatomic, strong) NSString* lastVer;

@property (nonatomic, strong) NSString* synShopId;

@end

@implementation GoodsStyleGoodsEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self configViews];
    [self initNotifaction];
    [self initHead];
    [self initMainView];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    [self loaddatas];
}
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.txtColour = [LSEditItemText editItemText];
    [self.container addSubview:self.txtColour];
    
    self.txtSize = [LSEditItemText editItemText];
    [self.container addSubview:self.txtSize];
    
    self.txtSkcCode = [LSEditItemText editItemText];
    [self.container addSubview:self.txtSkcCode];
    
    self.txtInnerCode = [LSEditItemText editItemText];
    [self.container addSubview:self.txtInnerCode];
    
    self.txtBarCode = [EditItemText2 editItemText];
    [self.container addSubview:self.txtBarCode];
    
    self.lsPurPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsPurPrice];
    
    self.txtHangTagPrice = [LSEditItemText editItemText];
    [self.container addSubview:self.txtHangTagPrice];
    
    self.lsRetailPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsRetailPrice];
    
    self.lsMemberPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsMemberPrice];
    
    self.lsWhoPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsWhoPrice];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    [btn addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnDel = btn.superview;
    
    
    
}

- (void)loaddatas
{
    if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_DELETE]) {
        [self.btnDel setHidden:YES];
    }
    [self fillModel];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)loaddatas:(StyleGoodsVo *)styleGoodsVo styleId:(NSString *)styleId lastVer:(NSString *)lastVer synShopId:(NSString *)synShopId action:(int)action callBack:(styleGoodsEditBack)callBack
{
    self.styleGoodsEditBack = callBack;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.action = action;
    _synShopId = synShopId;
    _styleId = styleId;
    _lastVer = lastVer;
    _styleGoodsVo = styleGoodsVo;
}


- (void)isEdit:(BOOL) flg
{
    if (flg) {
        [self.lsPurPrice editEnable:YES];
        [self.lsRetailPrice editEnable:YES];
        [self.lsMemberPrice editEnable:YES];
        [self.lsWhoPrice editEnable:YES];
        [self.txtBarCode editEnabled:YES];
        [self.txtBarCode initPosition:1];
    } else {
        [self.lsPurPrice editEnable:NO];
        [self.lsRetailPrice editEnable:NO];
        [self.lsMemberPrice editEnable:NO];
        [self.lsWhoPrice editEnable:NO];
        [self.txtBarCode editEnabled:NO];
        [self.txtBarCode initPosition:0];
    }
}

- (void)fillModel
{
    for (GoodsSkuVo* sku in _styleGoodsVo.goodsSkuVoList) {
        if ([sku.attributeName isEqualToString:@"颜色"]) {
            [self.txtColour initData:sku.attributeVal];
            break;
        }
    }
    for (GoodsSkuVo* sku in _styleGoodsVo.goodsSkuVoList) {
        if ([sku.attributeName isEqualToString:@"尺码"]) {
            [self.txtSize initData:sku.attributeVal];
            break;
        }
    }
   
    [self.txtInnerCode initData:_styleGoodsVo.innerCode];
    
    [self.txtBarCode initData:_styleGoodsVo.barCode];
    
    [self.txtSkcCode initData:_styleGoodsVo.skcCode];
    
    [self.lsPurPrice initData:[NSString stringWithFormat:@"%.2f", _styleGoodsVo.purchasePrice] withVal:[NSString stringWithFormat:@"%.2f", _styleGoodsVo.purchasePrice]];
    
    [self.txtHangTagPrice initData:[NSString stringWithFormat:@"%.2f", _styleGoodsVo.hangTagPrice]];
    
    [self.lsRetailPrice initData:[NSString stringWithFormat:@"%.2f", _styleGoodsVo.retailPrice] withVal:[NSString stringWithFormat:@"%.2f", _styleGoodsVo.retailPrice]];
    
    [self.lsMemberPrice initData:[NSString stringWithFormat:@"%.2f", _styleGoodsVo.memberPrice] withVal:[NSString stringWithFormat:@"%.2f", _styleGoodsVo.memberPrice]];
    
    [self.lsWhoPrice initData:[NSString stringWithFormat:@"%.2f", _styleGoodsVo.wholesalePrice] withVal:[NSString stringWithFormat:@"%.2f", _styleGoodsVo.wholesalePrice]];
    
    if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_EDIT]) {
        [self isEdit:NO];
    }
}

- (void)initMainView
{
    [self.txtColour initLabel:@"颜色" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtColour editEnabled:NO];
    
    [self.txtSize initLabel:@"尺码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtSize editEnabled:NO];
    
    [self.txtSkcCode initLabel:@"SKC码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtSkcCode editEnabled:NO];
    
    [self.txtInnerCode initLabel:@"店内码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtInnerCode editEnabled:NO];
    [self.txtBarCode initLabel:@"条形码" withHit:nil withType:nil showTag:0 delegate:self];
    [self.txtBarCode.btnButton setImage:[UIImage imageNamed:@"goods_scan"] forState:UIControlStateNormal];
    [self.txtBarCode initPosition:1];
    [self.txtBarCode initMaxNum:22];
    self.txtBarCode.btnButton.imageView.bounds = CGRectMake(0, 0, 24, 24);
    self.txtBarCode.btnButton.imageEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    self.txtBarCode.btnButton.backgroundColor = [UIColor clearColor];
    if ([[Platform Instance] getShopMode] == 1 || ([[Platform Instance] getShopMode] == 3 && [[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"])) {
        [self.txtBarCode editEnabled:YES];
    }else{
        [self.txtBarCode editEnabled:NO];
    }
    [self.lsPurPrice initLabel:@"参考进货价(元)" withHit:nil isrequest:NO delegate:self];
//    if ([[Platform Instance] lockAct:ACTION_REF_PURCHASE_PRICE]) {//没有权限时参考进货价不显示
//        [self.lsPurPrice visibal:NO];
//    }
    [self.lsPurPrice visibal:NO];
    [self.txtHangTagPrice initLabel:@"吊牌价" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtHangTagPrice editEnabled:NO];
    
    [self.lsRetailPrice initLabel:@"零售价" withHit:nil isrequest:YES delegate:self];
    
    [self.lsMemberPrice initLabel:@"会员价" withHit:nil isrequest:NO delegate:self];
    
    [self.lsWhoPrice initLabel:@"批发价" withHit:nil isrequest:NO delegate:self];
    
    self.lsPurPrice.tag = GOODS_STYLE_GOODS_EDIT_PURPRICE;
    self.lsRetailPrice.tag = GOODS_STYLE_GOODS_EDIT_RETAILPRICE;
    self.lsMemberPrice.tag = GOODS_STYLE_GOODS_EDIT_MEMBERPRICE;
    self.lsWhoPrice.tag = GOODS_STYLE_GOODS_EDIT_WHOPRICE;
}

#pragma mark - 条形码扫描
- (void)showButtonTag:(NSInteger)tag {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popToViewController:self animated:NO];
    [self.txtBarCode changeData:scanString];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}


- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        self.styleGoodsEditBack(nil, 0, @"0");
    }else{
        [self save];
    }
}

- (void)onItemListClick:(LSEditItemList *)obj
{
    if (obj.tag == GOODS_STYLE_GOODS_EDIT_PURPRICE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }else if (obj.tag == GOODS_STYLE_GOODS_EDIT_RETAILPRICE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }else if (obj.tag == GOODS_STYLE_GOODS_EDIT_MEMBERPRICE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }else if (obj.tag == GOODS_STYLE_GOODS_EDIT_WHOPRICE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }
    
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if ([NSString isBlank:val]) {
        val = nil;
    } else {
        val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
    }
    
    if (eventType==GOODS_STYLE_GOODS_EDIT_PURPRICE) {

        [self.lsPurPrice changeData:val withVal:val];
    }else if (eventType==GOODS_STYLE_GOODS_EDIT_RETAILPRICE) {
        
        [self.lsRetailPrice changeData:val withVal:val];
        
        //会员价不输入时默认零售价
        if ([NSString isBlank:[self.lsMemberPrice getStrVal]]) {
            [self.lsMemberPrice changeData:val withVal:val];
        }
        
        //批发价不输入时m默认零售价
        if ([NSString isBlank:[self.lsWhoPrice getStrVal]]) {
            [self.lsWhoPrice changeData:val withVal:val];
        }
        
    }else if (eventType==GOODS_STYLE_GOODS_EDIT_MEMBERPRICE) {

        [self.lsMemberPrice changeData:val withVal:val];
    }else if (eventType==GOODS_STYLE_GOODS_EDIT_WHOPRICE) {

        [self.lsWhoPrice changeData:val withVal:val];
    }
}

- (void)initHead
{
    [self configTitle:@"商品详情" leftPath:Head_ICON_BACK rightPath:nil];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_GoodsStyleGoodsEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_GoodsStyleGoodsEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    [self editTitle:[UIHelper currChange:self.container] act:self.action];
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    
    _styleGoodsVo.barCode = [self.txtBarCode getStrVal];
    _styleGoodsVo.purchasePrice = [NSString isBlank:[self.lsPurPrice getStrVal]]? 0.00:[self.lsPurPrice getStrVal].doubleValue;
    _styleGoodsVo.retailPrice = [self.lsRetailPrice getStrVal].doubleValue;
    //会员价不输入时默认零售价
    if ([NSString isNotBlank:[self.lsMemberPrice getStrVal]]) {
        _styleGoodsVo.memberPrice = [self.lsMemberPrice getStrVal].doubleValue;
    } else {
        _styleGoodsVo.memberPrice = _styleGoodsVo.retailPrice;
    }
    //批发价不输入时默认零售价
    if ([NSString isNotBlank:[self.lsWhoPrice getStrVal]]) {
        _styleGoodsVo.wholesalePrice = [self.lsWhoPrice getStrVal].doubleValue;
    } else {
        _styleGoodsVo.wholesalePrice = _styleGoodsVo.retailPrice;
    }
    __weak GoodsStyleGoodsEditView* weakSelf = self;
    [_goodsService updateStyleGoods:_styleId lastVer:_lastVer synShopId:_synShopId styleGoodsVo:[StyleGoodsVo getDictionaryData:_styleGoodsVo] completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        _lastVer = [json objectForKey:@"lastVer"];
        self.styleGoodsEditBack(_styleGoodsVo, ACTION_CONSTANTS_EDIT, _lastVer);
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (BOOL)isValid
{
    if ([NSString isBlank:[self.lsRetailPrice getStrVal]]) {
        [AlertBox show:@"零售价不能为空，请输入!"];
        return NO;
    }
    
    
    return YES;
}

- (void)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:@"确认要删除该商品吗？"];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        __weak GoodsStyleGoodsEditView* weakSelf = self;
        [_goodsService deleteStyleGoods:_styleId lastVer:_lastVer goodsId:_styleGoodsVo.goodsId completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            _lastVer = [json objectForKey:@"lastVer"];
            [self delFinish];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)delFinish
{
    self.styleGoodsEditBack(_styleGoodsVo, ACTION_CONSTANTS_DEL, _lastVer);
}

@end
