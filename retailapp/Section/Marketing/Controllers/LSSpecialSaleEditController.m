//
//  LSSpecialSaleEditController.m
//  retailapp
//
//  Created by guozhi on 2016/10/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_SPECIAL_PROGRAM 1
#define TAG_LST_SPECIAL_PRICE 2
#define TAG_LST_DISCOUNT_RATE 3
#import "LSSpecialSaleEditController.h"
#import "LSEditItemTitle.h"
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "AlertBox.h"
#import "SymbolNumberInputBox.h"
#import "LSMarketListController.h"
#import "LSSalePriceVo.h"
#import "SalesStyleAreaView.h"
#import "SalesGoodsAreaView.h"
@interface LSSpecialSaleEditController ()<INavigateEvent, IEditItemListEvent, IEditItemRadioEvent, INavigateEvent, OptionPickerClient, SymbolNumberInputClient>
/** 标题 */
@property (nonatomic, strong) NavigateTitle2 *navigateTitle;
/** 特价规则设置 */
@property (nonatomic, strong) LSEditItemTitle *itemTitle;
/** 特价方案 */
@property (nonatomic, strong) EditItemList *lstSpecialProgram;
/** 折扣率 */
@property (nonatomic, strong) EditItemList *lstDiscountRate;
/** 特价 */
@property (nonatomic, strong) EditItemList *lstSpecialPrice;
/** 指定商品范围 */
@property (nonatomic, strong) EditItemRadio *rdoGoodsRange;
/** 款式范围 */
@property (nonatomic, strong) EditItemList *lstStyleRange;
/** 商品范围 */
@property (nonatomic, strong) EditItemList *lstGoodsRange;
/** <#注释#> */
@property (nonatomic, strong) LSSalePriceVo *salePriceVo;
/** 容器 */
@property (nonatomic, strong) UIView *container;
/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 获活动ID */
@property (nonatomic, copy) NSString *salesId;
/** 添加还是编辑 */
@property (nonatomic, assign) int action;
/** 删除按钮 */
@property (nonatomic, strong) UIView *btnView;
/**
 1: 右上角保存按键保存 2: 点击款式/商品信息保存
 */
@property (nonatomic, copy) NSString *saveWay;

/**
 1: 特检规则款式范围  2:特价规则商品范围
 */
@property (nonatomic, copy) NSString *type;

/**
 是否保存
 */
@property (nonatomic, assign) BOOL saveFlg;

/** <#注释#> */
@property (nonatomic, copy) NSString *salePriceId;




@end

@implementation LSSpecialSaleEditController

- (instancetype)initWithSalesId:(NSString *)salesId salePriceId:(NSString *)salePriceId action:(int)action {
    if (self = [super init]) {
        self.salesId = salesId;
        self.action = action;
        self.salePriceId = salePriceId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    [self initNotification];
    [self initData];
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self loadData];
    }
    [self configHelpButton:HELP_MARKET_SPECIAL_MANAGEMENT_DETAIL];
    [UIHelper refreshView:self.container scrollView:self.scrollView];
}
- (void)initMainView {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //设置标题
    self.navigateTitle = [NavigateTitle2 navigateTitle:self];
    if (self.action ==ACTION_CONSTANTS_EDIT) {
         [self.navigateTitle initWithName:@"特价规则" backImg:Head_ICON_BACK moreImg:nil];
    } else {
         [self.navigateTitle initWithName:@"添加" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    }
   
    [self.view addSubview:self.navigateTitle];
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = self.navigateTitle.ls_bottom;
    CGFloat scrollViewW = self.view.ls_width;
    CGFloat scrollViewH = self.view.ls_height - self.navigateTitle.ls_height;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollViewW, scrollViewH)];
    self.container.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.container];
    
    self.itemTitle = [LSEditItemTitle editItemTitle];
    [self.itemTitle configTitle:@"特价规则设置"];
    [self.container addSubview:self.itemTitle];
    
    self.lstSpecialProgram = [EditItemList editItemList];
    [self.lstSpecialProgram initLabel:@"特价方案" withHit:nil delegate:self];
    self.lstSpecialProgram.tag = TAG_LST_SPECIAL_PROGRAM;
    [self.container addSubview:self.lstSpecialProgram];
    
    self.lstDiscountRate = [EditItemList editItemList];
    [self.lstDiscountRate initLabel:@"▪︎ 折扣率(%)" withHit:nil isrequest:YES delegate:self];
    self.lstDiscountRate.tag = TAG_LST_DISCOUNT_RATE;
    [self.container addSubview:self.lstDiscountRate];
    
    self.lstSpecialPrice  = [EditItemList editItemList];
    [self.lstSpecialPrice initLabel:@"▪︎ 特价(元)" withHit:nil isrequest:YES delegate:self];
    self.lstSpecialPrice.tag = TAG_LST_SPECIAL_PRICE;
    [self.container addSubview:self.lstSpecialPrice];
    
    self.rdoGoodsRange = [EditItemRadio itemRadio];
    [self.rdoGoodsRange initLabel:@"指定商品范围" withHit:nil delegate:self];
    [self.container addSubview:self.rdoGoodsRange];
    
    self.lstStyleRange = [EditItemList editItemList];
    [self.lstStyleRange initLabel:@"▪︎ 款式范围" withHit:nil delegate:self];
    self.lstStyleRange.imgMore.image = [UIImage imageNamed:@"ico_next"];
    self.lstStyleRange.lblVal.hidden = YES;
    [self.container addSubview:self.lstStyleRange];
    
    self.lstGoodsRange = [EditItemList editItemList];
    [self.lstGoodsRange initLabel:@"▪︎ 商品范围" withHit:nil delegate:self];
    self.lstGoodsRange.lblVal.hidden = YES;
    self.lstGoodsRange.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [self.container addSubview:self.lstGoodsRange];
    
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.ls_width, 64)];
    self.btnView.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 10, self.btnView.ls_width - 20, 44);
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_full_r"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:btn];
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self isEdit:[self.isCanDeal isEqualToString:@"1"]];
    }
    [self.container addSubview:self.btnView];
   
}

- (void)isEdit:(BOOL)flg {
    [self.lstSpecialProgram editEnable:flg];
    [self.lstDiscountRate editEnable:flg];
    [self.lstSpecialPrice editEnable:flg];
    [self.rdoGoodsRange isEditable:flg];
    self.btnView.hidden = !flg;
}
- (void)btnClick:(UIButton *)btn {
    __weak typeof(self) wself = self;
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要删除该促销规则吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:wself.salePriceVo.id forKey:@"salePriceId"];
        [param setValue:@(wself.salePriceVo.lastVer) forKey:@"lastver"];
        NSString *url = @"salePrice/delete";
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            for (UIViewController *vc in wself.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LSMarketListController class]]) {
                    LSMarketListController *listView = (LSMarketListController *)vc;
                    [listView loadDatasFromEditView:ACTION_CONSTANTS_DEL];
                }
            }
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popViewControllerAnimated:NO];
 
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

- (void)initData {
    [self.lstSpecialProgram initData:@"设置折扣率" withVal:@"1"];
    [self.lstSpecialPrice visibal:NO];
    [self.rdoGoodsRange initData:@"1"];
    [self.lstDiscountRate initData:nil withVal:nil];
    [self.lstSpecialPrice initData:nil withVal:nil];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
        [self.lstStyleRange visibal:NO];
    }
    if (self.action == ACTION_CONSTANTS_ADD) {
        self.btnView.hidden = YES;
    }
    
}
#pragma mark - 初始化通知
- (void)initNotification {
    [UIHelper initNotification:self.container event:Notification_UI_KindPayEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_KindPayEditView_Change object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 页面里面的值改变时调用
- (void)dataChange:(NSNotification *)notification {
    
    [self.navigateTitle editTitle:[UIHelper currChange:self.container] act:self.action];
     _saveFlg = [UIHelper currChange:self.container];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        // 点击右上角“保存”按钮保存
        _saveWay = @"1";
        [self save];
       
    
    }
}

- (void)loadData {
    __weak typeof(self) wself = self;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.salePriceId forKey:@"salePriceId"];
    NSString *url = @"salePrice/detail";
    self.container.hidden = YES;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.container.hidden = NO;
        wself.salePriceVo = [LSSalePriceVo mj_objectWithKeyValues:json[@"salePriceVo"]];
        [wself fillData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

- (void)fillData {
    if (self.salePriceVo.saleSchema == 2) {//设置特价
         [self.lstSpecialProgram initData:@"设置特价" withVal:@"2"];
        [self.lstSpecialPrice initData:[NSString stringWithFormat:@"%.2f", self.salePriceVo.discountPriceRate] withVal:[NSString stringWithFormat:@"%.2f", self.salePriceVo.discountPriceRate]];
        [self.lstDiscountRate visibal:NO];
        [self.lstSpecialPrice visibal:YES];
    } else {
        [self.lstSpecialProgram initData:@"设置折扣率" withVal:@"1"];
        [self.lstDiscountRate initData:[NSString stringWithFormat:@"%.2f", self.salePriceVo.discountPriceRate] withVal:[NSString stringWithFormat:@"%.2f", self.salePriceVo.discountPriceRate]];
        [self.lstSpecialPrice visibal:NO];
         [self.lstDiscountRate visibal:YES];
    }
    //指定商品范围
    if (self.salePriceVo.goodsScope == 1) {//1是关 2是开
        [self.rdoGoodsRange initData:@"0"];
    } else {
        [self.rdoGoodsRange initData:@"1"];
    }
    
    [self onItemRadioClick:self.rdoGoodsRange];
     [self.navigateTitle editTitle:[UIHelper currChange:self.container] act:self.action];
    if (self.action ==ACTION_CONSTANTS_EDIT) {
        self.navigateTitle.lblTitle.text = @"特价规则";
    } else {
        self.navigateTitle.lblTitle.text = @"添加";
    }

    
}

- (void)onItemListClick:(EditItemList *)obj {
    if (obj == self.lstSpecialProgram) {//特检方案
        NSMutableArray *optionList = [NSMutableArray array];
        NameItemVO *nameItem= [[NameItemVO alloc] initWithVal:@"设置折扣率" andId:@"1"];
        [optionList addObject:nameItem];
        nameItem = [[NameItemVO alloc] initWithVal:@"设置特价" andId:@"2"];;
        [optionList addObject:nameItem];
        [OptionPickerBox initData:optionList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];

    } else if (obj == self.lstSpecialPrice) {//特价
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];

    } else if (obj == self.lstDiscountRate) {//折扣率
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];

    } else if (obj == self.lstStyleRange) {//款式范围
        // 点击“款式范围” 跳转到款式范围页面
        _saveWay = @"2";
        _type = @"1";
        if (!(!_saveFlg && _action == ACTION_CONSTANTS_EDIT)) {
            // 点击“款式范围” 保存后跳转到款式范围页面
            [self save];
        }else{
            // 点击“款式范围” 跳转到款式范围页面
            SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:self.salePriceId discountType:@"70" shopId:_shopId action:SPECIAL_OFFER_EDIT_VIEW];
            salesStyleAreaView.isCanDeal = self.isCanDeal;
            [self.navigationController pushViewController:salesStyleAreaView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }

    } else if (obj == self.lstGoodsRange) { //商品范围
        _saveWay = @"2";
        _type = @"2";
        if (!(!_saveFlg && _action == ACTION_CONSTANTS_EDIT)) {
            // 点击“商品范围” 保存后跳转到商品范围页面
            [self save];
        } else {
            // 点击“商品范围” 跳转到商品范围页面
            SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:self.salePriceId discountType:@"70" shopId:_shopId action:SPECIAL_OFFER_EDIT_VIEW];
            salesGoodsAreaView.isCanDeal = self.isCanDeal;
            [self.navigationController pushViewController:salesGoodsAreaView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }

    }
    
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_SPECIAL_PROGRAM) {
        [self.lstSpecialProgram changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[self.lstSpecialProgram getStrVal] isEqualToString:@"1"]) {
            [self.lstSpecialPrice visibal:NO];
            [self.lstDiscountRate visibal:YES];
        } else {
            [self.lstDiscountRate visibal:NO];
            [self.lstSpecialPrice visibal:YES];
        }

    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
    return YES;
}

- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    if (eventType == TAG_LST_SPECIAL_PRICE) {
        [self.lstSpecialPrice changeData:val withVal:val];
    } else if (eventType == TAG_LST_DISCOUNT_RATE) {
        [self.lstDiscountRate changeData:val withVal:val];
    }
}

- (void)onItemRadioClick:(id)obj {
    if (obj == self.rdoGoodsRange) {
        if ([self.rdoGoodsRange getVal]) {
            [self.lstGoodsRange visibal:YES];
            if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
                [self.lstStyleRange visibal:YES];
            }
        } else {
            [self.lstGoodsRange visibal:NO];
            [self.lstStyleRange visibal:NO];
        }
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}

- (BOOL)isVaild {
    if (self.lstDiscountRate.hidden == NO && [NSString isBlank: [self.lstDiscountRate getStrVal]]) {
        [AlertBox show:@"折扣率不能为空，请输入！"];
        return NO;
        
        
    }
    if (self.lstSpecialPrice.hidden == NO && [NSString isBlank: [self.lstSpecialPrice getStrVal]]) {
        [AlertBox show:@"特价不能为空，请输入！"];
        return NO;
    }
    return YES;
}

- (void)save {
    if (![self isVaild]) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //特价方案 1是设置折扣率  2是设置特检
    [dict setValue:[self.lstSpecialProgram getStrVal] forKey:@"saleSchema"];
    //指定商品范围 1是关 2是开
    if ([self.rdoGoodsRange getVal]) {
         [dict setValue:@2 forKey:@"goodsScope"];
    } else {
         [dict setValue:@1 forKey:@"goodsScope"];
    }
    //折扣率特价
    if (self.lstDiscountRate.hidden == NO) {
        [dict setValue:[self.lstDiscountRate getStrVal] forKey:@"discountPriceRate"];
    } else {//特价
        [dict setValue:[self.lstSpecialPrice getStrVal] forKey:@"discountPriceRate"];
    }
    //设置活动Id
    [dict setValue:self.salesId forKey:@"salesId"];
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [dict setValue:@(self.salePriceVo.lastVer) forKey:@"lastVer"];
        [dict setValue:self.salePriceVo.id forKey:@"id"];
        [dict setValue:self.salePriceVo.opUserId forKey:@"opUserId"];
    }
    
    [param setValue:dict forKey:@"salePriceVo"];
    if (self.action == ACTION_CONSTANTS_ADD) {
        [param setValue:@"add" forKey:@"operateType"];
    } else {
         [param setValue:@"edit" forKey:@"operateType"];
    }
    
    NSString *url = @"salePrice/save";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        for (UIViewController *vc in wself.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LSMarketListController class]]) {
                LSMarketListController *listView = (LSMarketListController *)vc;
                [listView loadDatasFromEditView:ACTION_CONSTANTS_EDIT];
            }
        }
        if ([_saveWay isEqualToString:@"1"]) {
            // 点击右上角“保存”按钮保存，返回到满送列表页面
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popViewControllerAnimated:NO];
        } else {
            wself.salePriceId = json[@"salePriceVo"][@"id"];
            [wself loadData];
            self.action = ACTION_CONSTANTS_EDIT;
            if ([_type isEqualToString:@"1"]) {
                // 点击“款式范围” 保存后跳转到款式范围页面
                SalesStyleAreaView* salesStyleAreaView = [[SalesStyleAreaView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleAreaView"] bundle:nil discountId:wself.salePriceId discountType:@"70" shopId:_shopId action:SPECIAL_OFFER_EDIT_VIEW];
                self.isCanDeal = @"1";
                salesStyleAreaView.isCanDeal = @"1";
                salesStyleAreaView.operateMode = @"edit";
                [self.navigationController pushViewController:salesStyleAreaView animated:NO];
                [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            }else if ([_type isEqualToString:@"2"]) {
                // 点击“商品范围” 保存后跳转到商品范围页面
                SalesGoodsAreaView* salesGoodsAreaView = [[SalesGoodsAreaView alloc] initWith:wself.salePriceId discountType:@"70" shopId:_shopId action:SPECIAL_OFFER_EDIT_VIEW];
                self.isCanDeal = @"1";
                salesGoodsAreaView.isCanDeal = @"1";
                salesGoodsAreaView.operateMode = @"edit";
                [self.navigationController pushViewController:salesGoodsAreaView animated:NO];
                [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            }
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    
    
}


@end
