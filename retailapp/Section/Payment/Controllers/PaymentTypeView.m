 //
//  PaymentTypeView.m
//  RestApp
//
//  Created by xueyu on 16/4/14.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "PaymentTypeView.h"
#import "ServiceFactory.h"
#import "DateUtils.h"
#import "Platform.h"
#import "UIView+Sizes.h"
#import "ActionConstants.h"
#import "PayBillSummaryOfMonthVO.h"
#import "NSString+Estimate.h"
#import "ShopInfoVO.h"
#import "AlertBox.h"
#import "SVProgressHUD.h"
#import "JsonHelper.h"
#import "PaymentEditView.h"
#import "XHAnimalUtil.h"
#import "PaymentView.h"
#import "UIHelper.h"
#import "LSPaymentStatusController.h"
#import "LSPaymentButton.h"
#import "LSPaymentAccountView.h"

#define kWeiXin @"微信收款明细"
#define kAlipay @"支付宝收款明细"
#define kQQ @"QQ钱包收款明细"
@interface PaymentTypeView()

@property (nonatomic, strong) NSString *date;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic, copy) NSString *entiyId;
@property (nonatomic, strong) ShopInfoVO *shopInfoVO;
/** 进件状态 0未进件  1进件成功  2进件失败 */
@property (nonatomic, assign) int authStatus;
/**  */
@property (nonatomic, strong) LSPaymentAccountView *topView;
/** <#注释#> */
@property (nonatomic, strong) UIView *bottomView;
@end


@implementation PaymentTypeView
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"电子收款账户" leftPath:Head_ICON_BACK rightPath:nil];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, self.view.ls_width, self.view.ls_height - kNavH)];
    [self.view addSubview:self.scrollView];
    
    
    self.topView = [LSPaymentAccountView paymentAccountView];
    self.topView.lblUnReceivedTotalName.text = @"电子收款未到账总额(元)";
    self.topView.lblMonthIncomeName.text = @"本月累计电子收款收入(元)";
    self.topView.lblMonthReceivedName.text = @"本月累计已到账金额(元)";
    self.topView.lblRate.text = @"(已扣除服务费)";
    self.topView.lblUnBind.text = @"本店电子支付已自动开通，顾客可以使用微信支付和支付宝支付付款啦！顾客支付成功的钱会自动转账到您指定的账户，两种收款方式使用同一个指定的收款账户。微信和支付宝官方会收取一定服务费（“未到账总额”、“电子收款收入”皆为扣除服务费之前的金额）。请尽快绑定您的收款账户，才能收到顾客支付的钱款！";
    self.topView.lblBind.text = @"电子收款包括微信收款和支付宝收款两种收款方式的账单汇总信息(“未到账总额”、“电子收款收入”皆为扣除服务费之前的金额)。";
    [self.topView.btnBind addTarget:self action:@selector(bindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.topView];
    
    
    [self loadData];
    [self configHelpButton:HELP_PAYMENT_ACCOUNT];
   
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        [self popViewController];
    } else {
        [self bindBtnClick:nil];
    }
}

- (void)bindBtnClick:(UIButton *)btn {
    if ([[Platform Instance] lockAct:ACTION_BANK_BINDING]) {
        [AlertBox show:@"您没有收款账户绑卡的权限"];
        return;
    }
    //未进件或进件失败
    int authStatus = self.shopInfoVO.settleAccountInfo.authStatus.intValue;
    int auditStatus = self.shopInfoVO.settleAccountInfo.auditStatus.intValue;
    if(authStatus == 0 || authStatus == 2){
        [self gotoPaymentEditView];
    } else {
        //已进件
        //已进件未审核
        if (auditStatus == 0) {
            [self gotoPaymentEditView];
        }else{
            //进件后跳转到变更状态页面
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString  *failStr   = [defaults objectForKey:[NSString stringWithFormat:@"%@-failure",self.shopInfoVO.settleAccountInfo.entityId]];
            NSString  *sucStr = [defaults objectForKey:[NSString stringWithFormat:@"%@-success",self.shopInfoVO.settleAccountInfo.entityId]];
            
            if ([sucStr isEqualToString:[NSString stringWithFormat:@"%lld",self.shopInfoVO.settleAccountInfo.auditTime.longLongValue]]  || [failStr isEqualToString:[NSString stringWithFormat:@"%lld",self.shopInfoVO.settleAccountInfo.auditTime.longLongValue]] ) {
                [self gotoPaymentEditView];
            }else{
                LSPaymentStatusController *vc = [[LSPaymentStatusController alloc] init];
                vc.status = auditStatus;
                [self.navigationController pushViewController:vc animated:NO];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            }
        }
        
    }

}

- (void)loadData{
    //获取分账实体ID
    self.scrollView.hidden = YES;
    __weak typeof(self) wself = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    self.entiyId = [[Platform Instance] getkey:PAY_ENTITY_ID];
    [param setValue:self.entiyId forKey:@"entity_id"];
    ///查询店铺电子支付信息
    NSString *url = @"pay/online/v1/get_online_pay_info";
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        ShopInfoVO *shopInfoVo = [ShopInfoVO mj_objectWithKeyValues:json[@"data"]];
        wself.shopInfoVO = shopInfoVo;
        [wself initData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    //查询电子支付状态 qq状态必须通过这个接口不能被替换
    url = @"pay/online/v1/get_shop_status";
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        ShopInfoVO *shopInfoVo = [ShopInfoVO mj_objectWithKeyValues:json[@"data"]];
        [wself configBottomView:shopInfoVo];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    

    
}

-(void)initData{
    self.authStatus = self.shopInfoVO.settleAccountInfo.authStatus.intValue;
    //如果是未绑定的
    if (self.authStatus == 0) {//未进件
        //未完善信息是提示文字
        self.topView.lblUnBind.text = @"绑定收款账户后，将为您开通电子支付，顾客可以使用以下方式进行付款，支付的款项将会打入您绑定的账户，微信和支付宝官方会收取一定的服务费（“未到账总额”、“电子收款收入”皆为扣除服务费之前的金额）。请尽快绑定您的收款账户！";
        [self.topView.btnBind setTitle:@"立即绑定收款账户" forState:UIControlStateNormal];
        self.topView.lblTip.text = @"未绑定收款账户！";
    } else if (self.authStatus == 2) {//进件失败
         self.topView.lblTip.text = @"收款账户有误，请修改！";
         self.topView.lblUnBind.text = @"您的收款账户有误，请尽快修改，否则将不能收到顾客电子支付的钱。另外，根据央行政策，如未绑定正确的收款账户，电子支付将不能使用。请尽快修改，以免影响使用！";
        [self.topView.btnBind setTitle:@"立即修改收款账户" forState:UIControlStateNormal];
        
    } else if (self.authStatus == 1) {//己进件
        //完善信息时提示文字
//        self.bindingView.text = @"电子收款包括微信收款、支付宝收款和QQ钱包收款三种收款方式的账单汇总信息（“未到账总额”、“电子收款收入”皆为扣除服务费之前的金额)。";
        self.topView.lblBind.text = @"电子收款包括微信收款和支付宝收款两种收款方式的账单汇总信息（“未到账总额”、“电子收款收入”皆为扣除服务费之前的金额)。";
    }
    [self updateViewSize:self.shopInfoVO];
    NSString *dayStr = [DateUtils formateChineseShortDate2:[NSDate date]];
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    self.date = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)year,(long)month,(long)day];
    self.topView.lblDayReceivedName.text = [NSString stringWithFormat:@"%@已到账金额(元)",dayStr];
    self.topView.lblDayIncomeName.text = [NSString stringWithFormat:@"%@电子收款收入(元)",dayStr];
    NSString *dateStr = [DateUtils formateDate5:[NSDate date]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:self.entiyId forKey:@"entity_id"];
    [param setValue:dateStr forKey:@"year_month"];
    [param setValue:@"-1" forKey:@"pay_type"];
    NSString *url = @"bill/v1/total_by_month";
    __weak PaymentTypeView *weakSelf = self;
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        [weakSelf loadFinished:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}

-(void)updateViewSize:(ShopInfoVO *)shopInfo{
    BOOL isAccount = self.authStatus == 1;
    self.topView.isBindCard = isAccount;
    if (isAccount) {
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"收款账户" filePath:@"nav_account"];
    } else {
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:nil filePath:nil];
    }
    if ([[Platform Instance] lockAct:ACTION_WEI_PAY_SUMMARIZE_SEARCH]) {
        self.topView.hidden = YES;
    }
    [UIHelper refreshUI:self.scrollView];

}
-(void)loadFinished:(NSDictionary *)map{
    self.scrollView.hidden = NO;
    NSDictionary *dict = [map objectForKey:@"data"];
    self.topView.lblUnReceivedTotalVal.text = [NSString numberFormatterWithDouble:[dict objectForKey:@"noShareTotalFee"]];
    self.topView.lblMonthReceivedVal.text = [NSString numberFormatterWithDouble:[dict objectForKey:@"monthShareIncome"]];//monthShareIncome
    self.topView.lblMonthIncomeVal.text = [NSString numberFormatterWithDouble:[dict objectForKey:@"monthTotalFee"]];
    NSArray *array = [dict objectForKey:@"everyDays"];
    NSArray *datas = [JsonHelper transList:array objName:@"PayBillSummaryOfMonthVO"];
    PayBillSummaryOfMonthVO *payVo = [PayBillSummaryOfMonthVO new];
    for (PayBillSummaryOfMonthVO *vo in datas) {

        if ([self.date isEqualToString:vo.date]) {
            payVo = vo;
        }
    }

    self.topView.lblDayIncomeVal.text = [NSString numberFormatterWithDouble:[NSNumber numberWithDouble:payVo.totalFee]];
    self.topView.lblDayReceivedVal.text = [NSString numberFormatterWithDouble:[NSNumber numberWithDouble:payVo.shareIncome]];
    [UIHelper refreshUI:self.scrollView];
    
}
- (void)gotoNextView:(NSString *)name {
    int authStatus = self.shopInfoVO.settleAccountInfo.authStatus.intValue;
    if(authStatus == 1) {//进件成功
        PaymentView *vc = [[PaymentView alloc] init];
        [vc initDataView:name isShowAccount:NO];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    }else if(authStatus == 0) {//未进件
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"本店未绑定收款账户，不能查看此收款明细，请立即绑定收款账户！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self onNavigateEvent:LSNavigationBarButtonDirectRight];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else if(authStatus == 2){//进件失败
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"本店未绑定正确的收款账户，不能查看此收款明细，请立即修改收款账户！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self onNavigateEvent:LSNavigationBarButtonDirectRight];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }

    
}



- (void)gotoPaymentEditView {
        PaymentEditView *vc = [[PaymentEditView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}

#pragma mark - 底部view
- (void)configBottomView:(ShopInfoVO *)obj {
    obj.displayQQ = 0;//隐藏QQ支付
    NSMutableArray *list = [NSMutableArray array];
    if (obj.displayWxPay) {//显示微信
        NSDictionary *dict = @{@"title" : kWeiXin,
                               @"filePath" : @"payment_weixin"};
        [list addObject:dict];
    }
    if (obj.displayAlipay) {//显示支付宝
        NSDictionary *dict = @{@"title" : kAlipay,
                               @"filePath" : @"payment_alipay"};
        [list addObject:dict];
    }
    if (obj.displayQQ) {//显示qq
        NSDictionary *dict = @{@"title" : kQQ,
                               @"filePath" : @"paymet_qq"};
        [list addObject:dict];
        
    }
    [self.bottomView removeFromSuperview];
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.scrollView.ls_width, 120)];
    //2个按钮直接的距离
    __block CGFloat margin = 20;
    //每个按钮的宽度
    __block CGFloat w = 80;
    //每个按钮的高度度
    __block CGFloat h = 100;
    //按钮的个数
    NSInteger count = list.count;
    //左边按钮距离左边的间距
    CGFloat leftMargin = (self.bottomView.ls_width - count * w - (count - 1) * margin)/2;
    //设置约束
    __weak typeof(self) wself = self;
    [list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSPaymentButton *btn = [LSPaymentButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:obj[@"filePath"]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [wself.bottomView addSubview:btn];
        __block CGFloat x = leftMargin + (margin + w) * idx;
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.bottomView).offset(x);
            make.centerY.equalTo(wself.bottomView.centerY);
            make.size.equalTo(CGSizeMake(w, h));
        }];
    }];
    
    [self.scrollView addSubview:wself.bottomView];
    [UIHelper refreshUI:self.scrollView];
}

- (void)btnClick:(LSPaymentButton *)btn {
    NSString *title = btn.titleLabel.text;
    if ([title hasPrefix:kWeiXin]) {
        [self gotoNextView:@"微信"];
    } else if ([title hasPrefix:kAlipay]) {
        [self gotoNextView:@"支付宝"];
    } else if ([title hasPrefix:kQQ]) {
        [self gotoNextView:@"QQ钱包"];
    }

}

@end
