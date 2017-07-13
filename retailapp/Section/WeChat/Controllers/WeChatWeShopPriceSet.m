//
//  WeChatWeShopPriceSet.m
//  retailapp
//
//  Created by diwangxie on 16/5/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WeChatWeShopPriceSet.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "GoodsRender.h"
#import "SymbolNumberInputBox.h"
#import "AlertBox.h"
#import "BaseService.h"
#import "ServiceFactory.h"
#import "Wechat_StyleVo.h"
#import "WechatGoodsManagementStyleView.h"
#import "LSWechatGoodListViewController.h"
#import "NameItemVO.h"

#define STYLE_STRATEGYTYPE 1
#define STYLE_DISCOUNTRATE 2

@interface WeChatWeShopPriceSet ()
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic, strong) BaseService             *service;       //网络服务
@property (nonatomic,strong) NSMutableArray * tempList;
/**
 *  商超版微店售价策略 此页面是商超服鞋共通页面 修改请慎重
 */
@property (nonatomic, strong) NSMutableArray *microSaleStrategyList;
@end

@implementation WeChatWeShopPriceSet


-(void)loadDate:(NSMutableArray *) styleList{
    self.styleList=[[NSMutableArray alloc] init];
    self.styleList=styleList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _service = [ServiceFactory shareInstance].baseService;
    _tempList=[[NSMutableArray alloc] init];
    [self initTitleBox];
    [self initView];
}

- (void)initTitleBox {
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"批量设置微店价格" backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
    [self.titleDiv addSubview:self.titleBox];
}

//
- (void)initView {
    [self.lstStrategyType initLabel:@"微店售价策略" withHit:nil delegate:self];
//    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
//         [self.lstStrategyType initData:[GoodsRender obtainMicroSaleStrategy:1] withVal:@"1"];
//        [self.lstDiscountRate visibal:NO];
//    } else {
        [self.lstStrategyType initData:@"按零售价打折" withVal:@"2"];
//    }
   
    self.lstStrategyType.tag=STYLE_STRATEGYTYPE;
    
    [self.lstDiscountRate initLabel:@"折扣率（%）" withHit:nil isrequest:YES delegate:self];
    self.lstDiscountRate.tag=STYLE_DISCOUNTRATE;
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (BOOL)checkDataChange {
    return self.lstStrategyType.isChange || self.lstDiscountRate.isChange;
}


- (void)onItemListClick:(EditItemList *)obj {
    if (obj.tag==STYLE_STRATEGYTYPE) {
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
            [OptionPickerBox initData:[GoodsRender listBatchMicroSaleStrategy]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
            [OptionPickerBox changeImgManager:@"setting_data_clear.png"];
        } else {
            [OptionPickerBox initData:self.microSaleStrategyList itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];

        }

        
    }else if (obj.tag==STYLE_DISCOUNTRATE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
    }
}


-(BOOL) pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == STYLE_STRATEGYTYPE) {
        [self.lstStrategyType changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemId] isEqualToString:@"1"]) {
            [self.lstDiscountRate visibal:NO];
        }else{
            [self.lstDiscountRate visibal:YES];
        }
        return YES;
    }
    return NO;
}


- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType==STYLE_DISCOUNTRATE) {
        [self.lstDiscountRate changeData:[NSString stringWithFormat:@"%.2f",[val doubleValue]] withVal:val];
    }
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

- (void)save {
    if ([self.lstStrategyType getStrVal].intValue==2) {
        if ([NSString isBlank:[self.lstDiscountRate getStrVal]]) {
            [AlertBox show:@"请输入折扣率!"];
            return;
        }
        if ([self.lstDiscountRate getStrVal ].doubleValue > 100) {
            [AlertBox show:@"折扣率不能超过100%!"];
            return;
        }
    }
    for (Wechat_StyleVo *vo in _styleList) {
        [self.tempList addObject:vo.styleId];
    }
    
    __weak typeof(self) weakSelf = self;
    NSString *url = nil;
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
        url = @"microStyle/setBatchStylePrice";
        weakSelf.shopId = [[Platform Instance] getkey:SHOP_ID];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        [param setValue:weakSelf.shopId forKey:@"shopId"];
        [param setValue:weakSelf.tempList forKey:@"styleIdList"];
        [param setValue:weakSelf.goodsIdList forKey:@"goodsIdList"];
        [param setValue:[self.lstStrategyType getStrVal] forKey:@"saleStrategy"];
        if (self.lstDiscountRate.hidden == NO) {
            [param setValue:[NSNumber numberWithDouble:[self.lstDiscountRate getStrVal].doubleValue] forKey:@"microDiscountRate"];
        }
        
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            WechatGoodsManagementStyleView *homeVC = [[WechatGoodsManagementStyleView alloc] init];
            UIViewController *target = nil;
            for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
                if ([controller isKindOfClass:[homeVC class]]) { //这里判断是否为你想要跳转的页面
                    target = controller;
                }
            }
            if (target) {
                [self.navigationController popToViewController:target animated:YES]; //跳转
            }
            
            if([[json objectForKey:@"notConformCount"] integerValue]>0){
                [AlertBox show:[NSString stringWithFormat:@"有%@件款式不符合总部最低折扣价。",[json objectForKey:@"notConformCount"]]];
            }
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];

    } else {//商超
        url = @"microGoods/updateBatchMicroGoodsPrice";
        weakSelf.shopId=[[Platform Instance] getkey:SHOP_ID];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:weakSelf.shopId forKey:@"shopId"];
        [param setValue:weakSelf.goodsIdList forKey:@"goodsIdList"];
        [param setValue:[self.lstStrategyType getStrVal] forKey:@"saleStrategy"];
        if (self.lstDiscountRate.hidden == NO) {
            [param setValue:[NSNumber numberWithDouble:[self.lstDiscountRate getStrVal].doubleValue] forKey:@"microDiscountRate"];
        }
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            [weakSelf gotoWechatGoodsListViewController];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
    
    
}

#pragma mark 前往微店商品列表
- (void)gotoWechatGoodsListViewController {
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LSWechatGoodListViewController class]]) {
            LSWechatGoodListViewController *vc = (LSWechatGoodListViewController *)obj;
            vc.createTime = 0;
            vc.searchCode = @"";
            [vc selectMicGoodsList];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popToViewController:vc animated:NO];

        }
    }];
}

#pragma mark 微店售价策略数据源
- (NSMutableArray *)microSaleStrategyList {
    if (!_microSaleStrategyList) {
        NameItemVO *itemVo = nil;
        _microSaleStrategyList = [NSMutableArray array];
        itemVo = [[NameItemVO alloc] initWithVal:@"与零售价相同" andId:@"1"];
        [_microSaleStrategyList addObject:itemVo];
        itemVo = [[NameItemVO alloc] initWithVal:@"按零售价打折" andId:@"2"];
        [_microSaleStrategyList addObject:itemVo];
    }
    return _microSaleStrategyList;
}

#pragma mark 获得微店售价策略名称
- (NSString *)microSaleStrategyName:(NSString *)itemId {
    for (NameItemVO *itemVo in self.microSaleStrategyList) {
        if ([itemId isEqualToString:itemVo.itemId]) {
            return itemVo.itemName;
        }
    }
    return nil;
}

@end
