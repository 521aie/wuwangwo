//
//  WechatSetView.m
//  retailapp
//
//  Created by zhangzt on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatSetView.h"
#import "LSEditItemText.h"
#import "LSEditItemRadio.h"
#import "LSEditItemList.h"


#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "LSWechatModuleController.h"
#import "WechatService.h"
#import "ServiceFactory.h"
#import "EditItemText.h"

#import "AlertBox.h"

#import "EditItemRadio.h"
#import "EditItemList.h"
#import "SymbolNumberInputBox.h"

#import "JsonHelper.h"
#import "MicroBasicSetVo.h"
#import "GoodsRender.h"

#import "OptionPickerBox.h"
#import "SelectStoreListView.h"

//参数设置
#define BALABCE 1
#define AUTO 2
#define AWOLL 3
#define FEE 4

@interface WechatSetView ()<IEditItemRadioEvent,IEditItemListEvent,SymbolNumberInputClient>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIView *container;

//微店名称
@property (nonatomic, strong)LSEditItemText *wechatName;
// 微店可销售数量设置
@property (nonatomic, strong)LSEditItemRadio *rdoEnabledStock;
//自动确认收货(天数)
@property (nonatomic, strong)LSEditItemList *lsAutoReceipt;
//允许退货
@property (nonatomic, strong)LSEditItemRadio *rdoAllowRefund;
//启用货到付款
@property (nonatomic, strong)LSEditItemRadio *rdoEnabledCOD;
//启用会员卡支付
@property (nonatomic, strong)LSEditItemRadio *rdoEnabledCardPay;
//启用积分兑换
@property (nonatomic, strong)LSEditItemRadio *rdoEnabledCredits;

//不一定启用
//手续费
@property (nonatomic, strong)LSEditItemList *lsProcedureFee;
//兑换仓库
@property (nonatomic, strong)LSEditItemList *lsExchangeWarehouse;
//启用主题销售包
@property (nonatomic, strong)LSEditItemRadio *rdoEnabledPackage;

@property (nonatomic, strong) WechatService *wechatService;

@property (nonatomic, strong) MicroBasicSetVo *microBasicSetVo;

@property (nonatomic, strong) NSMutableDictionary *receivedic;

@property (nonatomic) NSInteger shopmodel;//店铺模式

@end

@implementation WechatSetView



- (void)viewDidLoad {
    [super viewDidLoad];
    self.wechatService = [ServiceFactory shareInstance].wechatService;
    self.shopmodel = [[Platform Instance] getShopMode];
    self.receivedic = [NSMutableDictionary dictionary];
    
    [self initNavigate];
    [self configViews];
    [self initMainView];
    [self registerNotification];
    [self loadData];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)initNavigate {
    [self configTitle:@"微店设置" leftPath:Head_ICON_BACK  rightPath:nil];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.wechatName = [LSEditItemText editItemText];
    [self.container addSubview:self.wechatName];
    
    self.rdoEnabledStock = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoEnabledStock];
    
    self.lsAutoReceipt = [LSEditItemList editItemList];
    [self.container addSubview:self.lsAutoReceipt];
    
    self.rdoAllowRefund = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoAllowRefund];
    
    self.rdoEnabledCOD = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoEnabledCOD];
    
    self.rdoEnabledCardPay = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoEnabledCardPay];
    
    self.rdoEnabledCredits = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoEnabledCredits];
}

- (void)registerNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification*)notification {
    [self editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 获取网络数据微店设置状态
-(void)loadData{
    __weak WechatSetView *weakSelf = self;
    //微店基本设置
    [_wechatService WechatBaseSetcompletionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        self.receivedic = json;
        
        // 设置微店 名称
        NSString *wechatName = [json valueForKey:@"microName"];
        if ([NSString isNotBlank:wechatName]) {
            [self.wechatName initData:wechatName];
        }
        
        // 微店可销售数量设置
        self.microBasicSetVo = [MicroBasicSetVo converToVo:[json objectForKey:@"startVirturlStockVo"]];
        if (self.microBasicSetVo.value.intValue == 1) {
            [self.rdoEnabledStock initData:@"1"];
        } else {
            [self.rdoEnabledStock initData:@"0"];
        }
        
        //营业手续费
        self.microBasicSetVo = [MicroBasicSetVo converToVo:[json objectForKey:@"operatingFreeVo"]];
        [self.lsProcedureFee initData:self.microBasicSetVo.value withVal:self.microBasicSetVo.value];
        
        //自动确认收货
        self.microBasicSetVo = [MicroBasicSetVo converToVo:[json objectForKey:@"autoConfirmGoodVo"]];
        [self.lsAutoReceipt initData:self.microBasicSetVo.value withVal:self.microBasicSetVo.value];
        
        //允许退货
        self.microBasicSetVo = [MicroBasicSetVo converToVo:[json objectForKey:@"allowReturnGoodVo"]];
        if (self.microBasicSetVo.value.intValue == 1) {
            [self.rdoAllowRefund initData:@"1"];
        } else {
            [self.rdoAllowRefund initData:@"0"];
        }
        
        //启动会员卡支付
        self.microBasicSetVo = [MicroBasicSetVo converToVo:[json objectForKey:@"startMemberCardPayVo"]];
        if (self.microBasicSetVo.value.intValue == 1) {
            [self.rdoEnabledCardPay initData:@"1"];
        } else {
            [self.rdoEnabledCardPay initData:@"0"];
        }
        
        //启动积分兑换
        self.microBasicSetVo = [MicroBasicSetVo converToVo:[json objectForKey:@"startIntegralConvertVo"]];
        if (self.microBasicSetVo.value.intValue == 1) {
            [self.rdoEnabledCredits initData:@"1"];
        } else {
            [self.rdoEnabledCredits initData:@"0"];
        }
        
//        if ([[self.rdoEnabledCredits getStrVal] intValue] == 1) {
//            self.lsExchangeWarehouse.hidden = NO;
//            self.microBasicSetVo = [MicroBasicSetVo converToVo:[json objectForKey:@"exchangeWarehouseVo"]];
//            [self.lsExchangeWarehouse initData:[json objectForKey:@"wareHouseName"] withVal:self.microBasicSetVo.value];
//        } else {
//            self.lsExchangeWarehouse.hidden = YES;
//        }
//        if ([[Platform Instance] getShopMode] == 1) {
//            [self.lsExchangeWarehouse visibal:NO];
//        }
        
        
        //启动主题销售包
        self.microBasicSetVo = [MicroBasicSetVo converToVo:[json objectForKey:@"startThemePackageVo"]];
        if (self.microBasicSetVo.value.intValue == 1) {
            [self.rdoEnabledPackage initData:@"1"];
        } else {
            [self.rdoEnabledPackage initData:@"0"];
        }
        
        //启动货到付款
//        if ([[Platform Instance] getShopMode] == 1) {
        self.microBasicSetVo = [MicroBasicSetVo converToVo:[json objectForKey:@"startCashOnThingVo"]];
        if (self.microBasicSetVo.value.intValue == 1) {
            [self.rdoEnabledCOD initData:@"1"];
        } else {
            [self.rdoEnabledCOD initData:@"0"];
        }
        
//        }
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}

- (void)initMainView {
    
    [self.wechatName initLabel:@"微店名称" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.wechatName initData:[[Platform Instance] getkey:SHOP_NAME]];
    [self.container sendSubviewToBack:self.wechatName];
    
//    if (self.shopmodel == 1) {
//        [self.rdoEnabledPlace visibal:NO];
    //    [self.lsBalancePositive visibal:YES];
//        [self.lsProcedureFee visibal:NO];
//        [self.rdoEnabledPackage visibal:NO];
        
//    } else {
//        [self.rdoEnabledPlace visibal:YES];
    //    [self.lsBalancePositive visibal:NO];
     //   [self.lsProcedureFee visibal:NO];
//    }
    
    // 开店默认开微店后，隐藏主题销售包选项
    if ([[Platform Instance] getShopMode] != 3) {
        [self.rdoEnabledPackage visibal:NO];
    }
    
//    if([[Platform Instance] getShopMode] == 2 || [[Platform Instance] getShopMode] == 3){
        [self.rdoEnabledStock initLabel:@"微店交易需判断可销售数量" withHit:@"开启后，微店商品交易时需判断可销售数量；关闭后，微店商品可无限量销售" delegate:self];
//    }else{
//        [self.rdoEnabledStock initLabel:@"启用微店虚拟库存" withHit:@"开启后，微店商品交易时需判断是否有库存" delegate:self];
//    }
   // [self.lsReduceStockWay initLabel:@"▪︎ 减库存方式"  withHit:@"买家拍下商品即减少库存" isrequest:YES delegate:self];
    
    [self.lsProcedureFee initLabel:@"营业手续费(‰)" withHit:@"订单成交后所需缴纳的手续费或税率，由发货门店承担" isrequest:YES delegate:self];
    
   // [self.lsBalancePositive initLabel:@"▪︎ 供货方临时余额转正" withHit:@"确认收货后，临时余额在第几天转正" isrequest:YES delegate:self];
    [self.lsAutoReceipt initLabel:@"自动确认收货(天)" withHit:@"订单发货后，如客户未确认收货，系统在第几天自动确认收货" isrequest:YES delegate:self];
    [self.rdoAllowRefund initLabel:@"允许退货" withHit:@"开启后，微店客户可申请退货" delegate:self];
    [self.rdoEnabledCOD initLabel:@"启用货到付款" withHit:@"开启后，微店支持货到付款" delegate:self];
    [self.rdoEnabledCOD editable:YES];
    
    //启用货到付款开关只有单店才表示
//    if ([[Platform Instance] getShopMode] == 1) {
//        self.rdoEnabledCOD.hidden = NO;
//    } else {
//        self.rdoEnabledCOD.hidden = YES;
//    }
    
    [self.rdoEnabledCardPay initLabel:@"启用会员卡支付" withHit:@"开启后，微店支持会员卡支付，充值" delegate:self];
   // [self.rdoEnabledCardPay isEditable:NO];
    
    [self.rdoEnabledCredits initLabel:@"启用积分兑换" withHit:@"开启后，微店支持积分兑换" delegate:self];
    [self.rdoEnabledCredits initData:@"0"];
    
    //兑换仓库
//    [self.lsExchangeWarehouse initIndent:@"兑换仓库" withHit:@"积分兑换商品出品仓库" isrequest:YES delegate:self];
//    if ([[Platform Instance] getShopMode] != 3) {
//        [self.lsExchangeWarehouse visibal:NO];
//    }
//    self.lsExchangeWarehouse.imgMore.image=[UIImage imageNamed:@"ico_next.png"];
//    [self.lsExchangeWarehouse initData:@"请选择" withVal:nil];
//    self.lsExchangeWarehouse.tag = 10;
//    self.lsExchangeWarehouse.hidden = YES;
    
    //启用微店积分商品库存
//    [self.rdoWechatStock initLabel:@"启用微店积分商品库存" withHit:@"开启后只有微店积分商品库存数大于0的积分商品才能在微店进行兑换，请先在微店-微店积分商品库存中设置积分商品可兑换库存数" delegate:self];
//    [self.rdoWechatStock initData:@"0"];
//    self.rdoWechatStock.hidden = YES;
    
    [self.rdoEnabledPackage initLabel:@"启用主题销售包" withHit:@"开启后，可选择主题销售包中得商品在微店销售" delegate:self];
    
 //   self.lsBalancePositive.tag = BALABCE;
    self.lsAutoReceipt.tag = AUTO;
    self.lsProcedureFee.tag = FEE;
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)direct {
    if (direct == LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    } else if (buttonIndex == 1){
        [self save];
    }
}

- (void)onItemRadioClick:(LSEditItemRadio*)obj {
   
    if (obj == self.rdoEnabledStock){
        // 打开“微店交易需判断可销售数量”要提示用户
        if ([obj isEqual:self.rdoEnabledStock] && obj.baseChangeStatus) {
            
            [obj changeData:[obj getVal]?@"0":@"1"];
            [LSAlertHelper showAlert:@"您修改了\"微店交易需判断可销售数量\"开关的状态，可能会造成微店可销售数量不准确，确认要修改吗？" block:^{
   
            } block:^{
                NSString *cValue = [obj getVal] ? @"0" : @"1";
                [obj changeData:cValue];
            }];
        }
    }
    else if (obj == self.rdoEnabledCredits) {
        if ([[self.rdoEnabledCredits getStrVal] intValue] == 1) {
//            self.lsExchangeWarehouse.hidden = NO;
            [self.lsExchangeWarehouse initData:@"请选择" withVal:nil];
        } else {
//            self.lsExchangeWarehouse.hidden = YES;
        }
    }
//    if ([[Platform Instance] getShopMode] ==1) {
//        [self.lsExchangeWarehouse visibal:NO];
//    }
//    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}

- (void)onItemListClick:(LSEditItemList*)obj {
    if (obj.tag == BALABCE) {
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
    } else if (obj.tag == AUTO) {
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
    } else if (obj.tag == AWOLL){
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
    } else if (obj.tag == FEE) {
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
    } else if (obj == self.lsExchangeWarehouse) {
        //兑换仓库
        SelectStoreListView *storeList = [[SelectStoreListView alloc] init];
        __weak typeof(self) weakSelf = self;
        [storeList loadData:[obj getStrVal] withOrgId:[[Platform Instance] getkey:ORG_ID] withIsSelf:YES callBack:^(id<INameCode> item) {
            if (item) {
                [obj changeData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:storeList animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        storeList = nil;
    }
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType==BALABCE) {
        if ([val integerValue]>=100 || [val integerValue] == 0) {
            [AlertBox show:@"天数范围为1—99!"];
            return;
        }
       // [self.lsBalancePositive changeData:val withVal:val];
        
    }else if (eventType==AUTO) {
        if ([val integerValue]>=61 || [val integerValue] == 0) {
            [AlertBox show:@"天数范围为1—60!"];
            return;
        }
        [self.lsAutoReceipt changeData:val withVal:val];
        
    }else if (eventType==FEE) {
//        if ([val integerValue]>10 || [val integerValue] == 0) {
//            [AlertBox show:@"手续费范围为1—10!"];
//            return;
//        }
        [self.lsProcedureFee changeData:val withVal:val];
    }

    
}

- (void)save
{
    NSMutableArray *sendlist = [NSMutableArray array];
    NSArray* arr = [self.receivedic allKeys];
    for(NSString* str in arr)
    {
        if ([str isEqualToString:@"exceptionCode"] || [str isEqualToString:@"returnCode"] || [str isEqualToString:@"microName"]) {
            continue;
        }
        
        if ([str isEqualToString:@"startVirturlStockVo"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.receivedic objectForKey:str]];
            if([[self.rdoEnabledStock getStrVal] isEqualToString:@"0"]){
                [dic setValue:[NSString stringWithFormat:@"2"] forKey:@"value"];;
            }else{
                [dic setValue:[self.rdoEnabledStock getStrVal] forKey:@"value"];
            }
            [sendlist addObject:dic];
        } else if ([str isEqualToString:@"operatingFreeVo"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.receivedic objectForKey:str]];
            [dic setValue:[self.lsProcedureFee getStrVal] forKey:@"value"];
            [sendlist addObject:dic];
        } else if ([str isEqualToString:@"autoConfirmGoodVo"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.receivedic objectForKey:str]];
            [dic setValue:[self.lsAutoReceipt getStrVal] forKey:@"value"];
            [sendlist addObject:dic];
        } else if ([str isEqualToString:@"allowReturnGoodVo"]) {
          NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.receivedic objectForKey:str]];
            if ([[self.rdoAllowRefund getStrVal] isEqualToString:@"0"]) {
                [dic setValue:@"2" forKey:@"value"];
            } else {
                [dic setValue:[self.rdoAllowRefund getStrVal] forKey:@"value"];
            }
          
          [sendlist addObject:dic];
        } else if ([str isEqualToString:@"startMemberCardPayVo"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.receivedic objectForKey:str]];
            if ([[self.rdoEnabledCardPay getStrVal] isEqualToString:@"0"]) {
                [dic setValue:@"2" forKey:@"value"];
            } else {
                [dic setValue:[self.rdoEnabledCardPay getStrVal] forKey:@"value"];
            }
            [sendlist addObject:dic];
        } else if ([str isEqualToString:@"startIntegralConvertVo"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.receivedic objectForKey:str]];
            if ([[self.rdoEnabledCredits getStrVal] isEqualToString:@"0"]) {
                 [dic setValue:@"2" forKey:@"value"];
            } else {
                 [dic setValue:[self.rdoEnabledCredits getStrVal] forKey:@"value"];
            }
         
            [sendlist addObject:dic];
        } else if ([str isEqualToString:@"startThemePackageVo"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.receivedic objectForKey:str]];
            if([[self.rdoEnabledPackage getStrVal] isEqualToString:@"0"]){
                [dic setValue:[NSString stringWithFormat:@"2"] forKey:@"value"];;
            }else{
                [dic setValue:[self.rdoEnabledPackage getStrVal] forKey:@"value"];
            }
            [sendlist addObject:dic];
        } else if ([str isEqualToString:@"startCashOnThingVo"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.receivedic objectForKey:str]];
            if ([[self.rdoEnabledCOD getStrVal] isEqualToString:@"0"]) {
                [dic setValue:@"2" forKey:@"value"];
            } else {
                [dic setValue:[self.rdoEnabledCOD getStrVal] forKey:@"value"];
            }
            [sendlist addObject:dic];
        }
//        else if ([str isEqualToString:@"wareHouseName"]) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[self.lsExchangeWarehouse getDataLabel] forKey:str];
//            [sendlist addObject:dic];
//        }
//        else if ([str isEqualToString:@"exchangeWarehouseVo"]) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.receivedic objectForKey:str]];
//            if ([NSString isBlank:[self.lsExchangeWarehouse getStrVal]]&&[[self.rdoEnabledCredits getStrVal] intValue] == 1) {
//                [AlertBox show:@"请选择兑换仓库"];
//                return;
//            }else{
//                [dic setValue:[self.lsExchangeWarehouse getStrVal] forKey:@"value"];
//                [sendlist addObject:dic];
//            }
//        }
//        else if ([str isEqualToString:@"integralGoodsStockVo"]) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.receivedic objectForKey:str]];
//            if([[self.rdoWechatStock getStrVal] isEqualToString:@"0"]){
//                [dic setValue:[NSString stringWithFormat:@"2"] forKey:@"value"];;
//            }else{
//                [dic setValue:[self.rdoWechatStock getStrVal] forKey:@"value"];
//            }
//                [sendlist addObject:dic];
//        }
    }
    
    if ([NSString isBlank:[self.wechatName getStrVal]]) {
        [LSAlertHelper showAlert:@"请设置微店名称！"];
    }
    
//    if (self.lsExchangeWarehouse.hidden == NO && [NSString isBlank:[self.lsExchangeWarehouse getDataLabel]]) {
//        [AlertBox show:@"请选择兑换仓库"];
//        return;
//    }
    
    NSDictionary *param = @{@"microBasicSetVoList":sendlist,@"microName":[self.wechatName getStrVal]};
    
    __weak WechatSetView *weakSelf = self;
    [_wechatService SaveWechatBaseSet:param completionHandler:^(id json) {
        [weakSelf removeNotification];
      //  [parent showView:WECHAT_SECOND_VIEW];
      //  [XHAnimalUtil animalEdit:parent action:ACTION_CONSTANTS_EDIT];
//        if ([[self.rdoEnabledPlace getStrVal] intValue] == 1) {//启用微分销
//            [[Platform Instance] setMicroDistributionStatus:1];
//        } else {
//            [[Platform Instance] setMicroDistributionStatus:2];
//        }
        LSWechatModuleController *wechatView = nil;
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LSWechatModuleController class]]) {
                wechatView = (LSWechatModuleController *)vc;
            }
        }
        [wechatView loadData];
        
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
