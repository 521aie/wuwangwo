//
//  StyleGoodsPriceView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StyleGoodsPriceView.h"
#import "XHAnimalUtil.h"
#import "LSEditItemList.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "StyleGoodsVo.h"
#import "GoodsModuleEvent.h"
#import "SymbolNumberInputBox.h"
#import "StyleGoodsBatchView.h"
#import "UIHelper.h"

@interface StyleGoodsPriceView ()

@property (nonatomic, retain) GoodsService* goodsService;

@property (nonatomic, strong) NSMutableArray* goodsIdList;

@property (nonatomic, strong) NSMutableArray* colorList;

@property (nonatomic, strong) NSString* lastVer;

@property (nonatomic, strong) NSString* styleId;

@property (nonatomic, strong) NSString* synShopId;

@property (nonatomic) int type;

@property (nonatomic) int action;

@end

@implementation StyleGoodsPriceView

- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self initHead];
    [self configViews];
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
    
    self.lsPurPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsPurPrice];
    
    self.lsHangTagPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsHangTagPrice];
    
    self.lsRetailPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsRetailPrice];
    
    self.lsMemberPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsMemberPrice];
    
    self.lsWhoPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsWhoPrice];

}

-(void) loaddatas
{
    [self clearDo];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) loaddatas:(NSMutableArray *)styleGoodsList type:(int) type lastVer:(NSString *)lastVer styleId:(NSString *)styleId synShopId:(NSString *)synShopId action:(int)action callBack:(styleGoodsPriceBack)callBack
{
    self.styleGoodsPriceBack = callBack;
    //type == 1 时，按商品更新价格， type == 0 时，按颜色更新价格
    _lastVer = lastVer;
    _styleId = styleId;
    _synShopId = synShopId;
    _type = type;
    if (_type == 1) {
        _goodsIdList = [[NSMutableArray alloc] init];
        for (StyleGoodsVo* vo in styleGoodsList) {
            [_goodsIdList addObject:vo.goodsId];
        }
    }else{
        _colorList = [[NSMutableArray alloc] init];
        for (StyleGoodsVo* vo in styleGoodsList) {
            [_colorList addObject:vo.styleColorName];
        }
    }    
}

- (void)clearDo {
    
    [self.lsPurPrice initData:nil withVal:@""];
    
    [self.lsHangTagPrice initData:nil withVal:@""];
    
    [self.lsRetailPrice initData:nil withVal:@""];
    
    [self.lsMemberPrice initData:nil withVal:@""];
    
    [self.lsWhoPrice initData:nil withVal:@""];
}

-(void) initMainView
{
    [self.lsPurPrice initLabel:@"参考进货价" withHit:nil delegate:self];
    [self.lsPurPrice visibal:NO];
//    if ([[Platform Instance] getShopMode] == 1 || ([[Platform Instance] getShopMode] == 3 && [[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"])) {
//        [self.lsPurPrice visibal:YES];
//    }else{
//        [self.lsPurPrice visibal:NO];
//    }
    
    [self.lsHangTagPrice initLabel:@"吊牌价" withHit:nil isrequest:YES delegate:self];
    if ([[Platform Instance] getShopMode] == 1 || ([[Platform Instance] getShopMode] == 3 && [[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"])) {
        if (_type == 1) {
            [self.lsHangTagPrice visibal:NO];
        }else{
            [self.lsHangTagPrice visibal:YES];
        }
    }else{
        [self.lsHangTagPrice visibal:NO];
    }
    
    [self.lsRetailPrice initLabel:@"零售价" withHit:nil isrequest:YES delegate:self];
    
    [self.lsMemberPrice initLabel:@"会员价" withHit:nil delegate:self];
    
    [self.lsWhoPrice initLabel:@"批发价" withHit:nil delegate:self];
    
    self.lsPurPrice.tag = STYLE_GOODS_PRICE_PURPRICE;
    self.lsHangTagPrice.tag = STYLE_GOODS_PRICE_HANGTAGPRICE;
    self.lsRetailPrice.tag = STYLE_GOODS_PRICE_RETAILPRICE;
    self.lsMemberPrice.tag = STYLE_GOODS_PRICE_MEMBERPRICE;
    self.lsWhoPrice.tag = STYLE_GOODS_PRICE_WHOPRICE;
}

-(void) initHead
{
    [self configTitle:@"价格信息" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        self.styleGoodsPriceBack(nil);
    }else{
        [self save];
    }
}

-(void)onItemListClick:(LSEditItemList *)obj
{
    if (obj.tag == STYLE_GOODS_PRICE_PURPRICE || obj.tag == STYLE_GOODS_PRICE_HANGTAGPRICE || obj.tag == STYLE_GOODS_PRICE_RETAILPRICE || obj.tag == STYLE_GOODS_PRICE_MEMBERPRICE || obj.tag == STYLE_GOODS_PRICE_WHOPRICE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
    }
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (val.doubleValue>=999999.99) {
        
        val = @"999999.99";
        
    }else{
        
        if ([NSString isBlank:val]) {
            val = nil;
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
    }
    
    if (eventType==STYLE_GOODS_PRICE_PURPRICE) {
        
        [self.lsPurPrice changeData:val withVal:val];
    }else if (eventType==STYLE_GOODS_PRICE_HANGTAGPRICE) {
        
        [self.lsHangTagPrice changeData:val withVal:val];
    }else if (eventType==STYLE_GOODS_PRICE_RETAILPRICE) {
        
        [self.lsRetailPrice changeData:val withVal:val];
        if ([NSString isBlank:[self.lsMemberPrice getStrVal]]) {
            [self.lsMemberPrice changeData:val withVal:val];
        }
        if ([NSString isBlank:[self.lsWhoPrice getStrVal]]) {
            [self.lsWhoPrice changeData:val withVal:val];
        }
    }else if (eventType==STYLE_GOODS_PRICE_MEMBERPRICE) {
        
        [self.lsMemberPrice changeData:val withVal:val];
    }else if (eventType==STYLE_GOODS_PRICE_WHOPRICE) {
        
        [self.lsWhoPrice changeData:val withVal:val];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(BOOL) isValid
{
    if (!self.lsHangTagPrice.isHidden && [NSString isBlank:[self.lsHangTagPrice getStrVal]]) {
        [AlertBox show:@"吊牌价不能为空，请输入!"];
        return NO;
    }
    
    if (!self.lsRetailPrice.isHidden && [NSString isBlank:[self.lsRetailPrice getStrVal]]) {
        [AlertBox show:@"零售价不能为空，请输入!"];
        return NO;
    }
    
    return YES;
}

-(void) save
{
    if (![self isValid]) {
        return;
    }
    
    __weak StyleGoodsPriceView* weakSelf = self;
    if (_type == 1) {
        [_goodsService setStyleGoodsPriceByGoods:_styleId lastVer:_lastVer synShopId:_synShopId
                                   purchasePrice:[NSString isBlank:[weakSelf.lsPurPrice getStrVal]]? @"0.00":[weakSelf.lsPurPrice getStrVal]
                                     memberPrice:[NSString isBlank:[weakSelf.lsMemberPrice getStrVal]]? [weakSelf.lsRetailPrice getStrVal]:[weakSelf.lsMemberPrice getStrVal]
                                    wholesalePrice:[NSString isBlank:[weakSelf.lsWhoPrice getStrVal]]? [weakSelf.lsRetailPrice getStrVal]:[weakSelf.lsWhoPrice getStrVal]
                                     retailPrice:[NSString isBlank:[weakSelf.lsRetailPrice getStrVal]]? @"0.00":[weakSelf.lsRetailPrice getStrVal]
                                     goodsIdList:_goodsIdList completionHandler:^(id json) {
                                         if (!(weakSelf)) {
                                             return ;
                                         }
                                         weakSelf.lastVer = [json objectForKey:@"lastVer"];
                                         weakSelf.styleGoodsPriceBack(weakSelf.lastVer);
//                                         [weakSelf.parent showView:STYLE_GOODS_BATCH_VIEW];
//                                         [weakSelf.parent.styleGoodsBatchView loaddatasFromPriceView:weakSelf.lastVer];
                                     } errorHandler:^(id json) {
                                         [AlertBox show:json];
                                     }];
    }else{
        [_goodsService setStyleGoodsPriceByColor:_styleId lastVer:_lastVer synShopId:_synShopId
                                    purchasePrice:[NSString isBlank:[weakSelf.lsPurPrice getStrVal]]? @"0.00":[weakSelf.lsPurPrice getStrVal]
                                    hangTagPrice:[weakSelf.lsHangTagPrice getStrVal]
                                    memberPrice:[NSString isBlank:[weakSelf.lsMemberPrice getStrVal]]? [weakSelf.lsRetailPrice getStrVal]:[weakSelf.lsMemberPrice getStrVal]
                                    wholesalePrice:[NSString isBlank:[weakSelf.lsWhoPrice getStrVal]]? [weakSelf.lsRetailPrice getStrVal]:[weakSelf.lsWhoPrice getStrVal]
                                    retailPrice:[NSString isBlank:[weakSelf.lsRetailPrice getStrVal]]? @"0.00":[weakSelf.lsRetailPrice getStrVal]
                                    colorValList:_colorList completionHandler:^(id json) {
                                        if (!(weakSelf)) {
                                            return ;
                                        }
                                        weakSelf.lastVer = [json objectForKey:@"lastVer"];
                                         weakSelf.styleGoodsPriceBack(weakSelf.lastVer);
//                                        [weakSelf.parent showView:STYLE_GOODS_BATCH_VIEW];
//                                        [weakSelf.parent.styleGoodsBatchView loaddatasFromPriceView:weakSelf.lastVer];
                                    } errorHandler:^(id json) {
                                        [AlertBox show:json];
                                    }];
    }
}


@end
