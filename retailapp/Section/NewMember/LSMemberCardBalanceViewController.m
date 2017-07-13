//
//  LSMemberCardBalanceViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardBalanceViewController.h"
#import "NavigateTitle2.h"
#import "EditItemText.h"
#import "EditItemList.h"
#import "SymbolNumberInputBox.h"
#import "LSAlertHelper.h"
#import "LSMemberGoodsGiftVo.h"
#import "NSNumber+Extension.h"

@interface LSMemberCardBalanceViewController ()<INavigateEvent ,IEditItemListEvent ,SymbolNumberInputClient>

@property (nonatomic ,assign) NSInteger actionType;/*<操作类型>*/
@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) EditItemText *exchangeType;/*<兑换类型>*/
@property (nonatomic ,strong) EditItemList *money;/*<金额>*/
@property (nonatomic ,strong) EditItemList *needIntegral;/*<所需积分>*/
@property (nonatomic ,strong) UIButton *detBtn;/*<删除>*/
@property (nonatomic ,strong) LSMemberGoodsGiftVo *giftPojo;/*<卡余额vo>*/
@end

@implementation LSMemberCardBalanceViewController

- (instancetype)init:(NSInteger)type vo:(id)obj {
    
    self = [super init];
    if (self) {
        self.actionType = type;
        self.giftPojo = (LSMemberGoodsGiftVo *)obj;
        if (obj == nil) {
            self.giftPojo = [[LSMemberGoodsGiftVo alloc] init];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configSubViews];
    [self fillData];
    [self configHelpButton:HELP_MEMBER_INTEGRAL_EXCHANGE_SETTING];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configSubViews {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    if (self.actionType == ACTION_CONSTANTS_ADD) {
//        [self.titleBox initWithName:@"添加" backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
        [self.titleBox initWithName:@"添加兑换设置" backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_ADD];
    }
    else if (self.actionType == ACTION_CONSTANTS_EDIT) {
        [self.titleBox initWithName:@"卡余额详情" backImg:Head_ICON_BACK moreImg:nil];
    }
    [self.view addSubview:self.titleBox];
    

    self.exchangeType = [[EditItemText alloc] initWithFrame:CGRectMake(0, self.titleBox.ls_bottom, SCREEN_W, 48.0)];
    [self.exchangeType initLabel:@"兑换类型" withHit:@"" isrequest:NO type:0];
    [self.exchangeType editEnabled:NO];
    [self.view addSubview:self.exchangeType];
    
    self.money = [[EditItemList alloc] initWithFrame:CGRectMake(0, self.exchangeType.ls_bottom, SCREEN_W, 48.0)];
    [self.money initLabel:@"金额(元)" withHit:@"" isrequest:YES delegate:self];
    self.money.tag = 11;
    [self.view addSubview:self.money];
    
    self.needIntegral = [[EditItemList alloc] initWithFrame:CGRectMake(0, self.money.ls_bottom, SCREEN_W, 48.0)];
    [self.needIntegral initLabel:@"兑换所需积分" withHit:@"" isrequest:YES delegate:self];
    self.needIntegral.tag = 12;
    [self.view addSubview:self.needIntegral];
    
    if (self.actionType == ACTION_CONSTANTS_EDIT) {
        self.detBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.detBtn setTitle:@"删除" forState:0];
        [self.detBtn setBackgroundColor:[ColorHelper getRedColor]];
        [self.detBtn.titleLabel setTextColor:RGB(192, 0, 0)];
        [self.detBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        self.detBtn.frame = CGRectMake(12, self.needIntegral.ls_bottom + 10.0, SCREEN_W - 24, 44);
        self.detBtn.layer.cornerRadius = 4.0;
        [self.view addSubview:self.detBtn];
    }
}


- (void)fillData {
    
    [self.exchangeType initData:@"卡余额"];
    NSString *money = [self.giftPojo.cardFee convertToStringWithFormat:@"##0.00"];
    [self.money initData:money withVal:money];
    [self.needIntegral initData:self.giftPojo.point.stringValue withVal:self.giftPojo.point.stringValue];
    if ([[Platform Instance] getShopMode] != 3) {
        //积分兑换设置 关，积分商品数量设置 开时
        //卡余额详情页面的金额、兑换所需积分不可修改，隐藏删除按钮；积分商品详情页面的兑换所需积分不可修改，隐藏删除按钮
        if ([[Platform Instance] lockAct:ACTION_POINT_EXCHANGE_SET] && ![[Platform Instance] lockAct:ACTION_GIFT_GOODS_COUNT_SETTING] ) {
            [self.money editEnable:NO];
            [self.needIntegral editEnable:NO];
            [self.detBtn removeFromSuperview];
        }
    }
}

// 删除当前卡余额兑换规则
- (void)deleteAction {
    
    [LSAlertHelper showSheet:[NSString stringWithFormat:@"确认要删除[%@]卡余额吗?" ,self.money.currentVal] cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
        [self deleteCurrentIntergralRule];
    }];
}

#pragma mark - 协议方法

// INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        // 添加或者编辑状态有未保存信息时，点击“取消按钮”提示是否放弃更改
        if ([self hasChanged]) {
            [LSAlertHelper showAlert:@"提示" message:@"内容有变更尚未保存，确定要退出吗？" cancle:@"取消" block:nil ensure:@"确定" block:^{
                [self popToLatestViewController:kCATransitionFromLeft];
            }];
        }
        else {
            [self popToLatestViewController:kCATransitionFromLeft];
        }
    }
    else if (event == DIRECT_RIGHT) {
       
        if (self.actionType == ACTION_CONSTANTS_EDIT) {
            [self updateIntegralRule];
        }
        else if (self.actionType == ACTION_CONSTANTS_ADD) {
            [self saveIntegralRule];
        }
    }
}

//  IEditItemListEvent 协议方法
- (void)onItemListClick:(EditItemList *)obj {
    
    [SymbolNumberInputBox initData:obj.lblVal.text];
    if ([obj isEqual:self.money]) {
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:0];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:YES event:obj.tag];
    }
    else if ([obj isEqual:self.needIntegral]) {
        [SymbolNumberInputBox limitInputNumber:8 digitLimit:0];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:YES event:obj.tag];
    }
}

// SymbolNumberInputClient 协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    
    if (eventType == self.money.tag) {
        NSString *money = [val formatWith2FractionDigits];
        [self.money changeData:money withVal:money];
    }
    else if (eventType == self.needIntegral.tag) {
        [self.needIntegral changeData:val withVal:val];
    }
    
    if (self.actionType == ACTION_CONSTANTS_EDIT) {
        
        if (self.money.baseChangeStatus || self.needIntegral.baseChangeStatus) {
            
            [self.titleBox editTitle:YES act:ACTION_CONSTANTS_ADD];
        }
        else {
            [self.titleBox editTitle:NO act:0];
        }
    }
}

// 保存页面数据到model
- (void)savePageData {
    self.giftPojo.cardFee = [self.money.currentVal convertToNumber];
    self.giftPojo.name = [NSString stringWithFormat:@"卡余额(+%@元)" ,self.giftPojo.cardFee];
    self.giftPojo.point = [self.needIntegral.currentVal convertToNumber];
}

#pragma mark - 网络请求

// 保存积分兑换卡余额规则
- (void)saveIntegralRule {
    
    if ([self isVaild]) {
        [self savePageData];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[self.giftPojo toJsonString] forKey:@"giftStr"];
        NSString *url = @"customer/giftCashSave";
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            if ([json[@"returnCode"] isEqualToString:@"success"]) {
                [self reloadIntegralGoodList];
            }
        } errorHandler:^(id json) {
             [LSAlertHelper showAlert:json];
        }];
    }
}

// 更新积分兑换卡余额规则
- (void)updateIntegralRule {
    [self savePageData];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[self.giftPojo toJsonString] forKey:@"giftStr"];
    
    [BaseService getRemoteLSDataWithUrl:@"customer/giftCashUpdate" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"returnCode"] isEqualToString:@"success"]) {
            [self reloadIntegralGoodList];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 删除当前积分兑换卡余额规则
- (void)deleteCurrentIntergralRule {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.giftPojo.sId forKey:@"id"];
    [BaseService getRemoteLSDataWithUrl:@"customer/v1/removeGiftSet" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"returnCode"] isEqualToString:@"success"]) {
            [self reloadIntegralGoodList];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 返回更新积分兑换设置页面，并更新商品列表
// 返回更新积分兑换设置页面，并更新商品列表
- (void)reloadIntegralGoodList {
    
    NSArray *array = [self.navigationController viewControllers];
    for (UIViewController *vc in array) {
        if ([vc isKindOfClass:NSClassFromString(@"LSMemberIntegralSetViewController")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [vc performSelector:@selector(getGoodGiftList:) withObject:@"" afterDelay:0.1];
#pragma clang diagnostic pop
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark - check

- (BOOL)hasChanged {
    if (self.money.baseChangeStatus || self.needIntegral.baseChangeStatus) {
        return YES;
    }
    return NO;
}

- (BOOL)isVaild {
    
    if ([NSString isBlank:self.money.currentVal]) {
        [LSAlertHelper showAlert:@"金额(元)不能为空！" block:nil];
        return NO;
    }
    else if (self.money.currentVal.floatValue == 0 ) {
        [LSAlertHelper showAlert:@"金额(元)不能为零！" block:nil];
        return NO;
    }
    
    if ([NSString isBlank:self.needIntegral.currentVal]) {
        [LSAlertHelper showAlert:@"兑换所需积分不能为空！" block:nil];
        return NO;
    }
    else if (self.needIntegral.currentVal.floatValue == 0 ) {
        [LSAlertHelper showAlert:@"兑换所需积分不能为零！" block:nil];
        return NO;
    }
    return YES;
}

@end
