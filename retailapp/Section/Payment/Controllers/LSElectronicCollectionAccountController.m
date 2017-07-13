//
//  LSElectronicCollectionAccountController.m
//  retailapp
//
//  Created by guozhi on 2016/12/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSElectronicCollectionAccountController.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "LSElectronicCollectionAccountInfoView.h"
#import "LSElectronicCollectionButton.h"
#import "NavButton.h"
#import "ShopInfoVO.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "JSONHelper.h"
#import "PayBillSummaryOfMonthVO.h"
#import "PaymentView.h"
#import "PaymentEditView.h"
@interface LSElectronicCollectionAccountController ()<INavigateEvent>
/** 标题 */
@property (nonatomic, strong) NavigateTitle2 *titleBox;
/** 上面View */
@property (nonatomic, strong) LSElectronicCollectionAccountInfoView *viewTop;
/** 微信按钮 */
@property (nonatomic, strong) LSElectronicCollectionButton *btnWeiXin;
/** 支付宝按钮 */
@property (nonatomic, strong) LSElectronicCollectionButton *btnAlipay;
/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 右上角按钮 */
@property (nonatomic, strong) NavButton2 *btnRight;
/** 实体Id */
@property (nonatomic, copy) NSString *entiyId;
/** 店铺信息 */
@property (nonatomic, strong) ShopInfoVO *shopInfoVO;
/** 某天收益 */
@property (nonatomic, strong)NSString *date;

@end

@implementation LSElectronicCollectionAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self loadData];
    
}

- (void)configViews {
    //标题
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"电子收款账户" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    //右上角按钮
    self.btnRight = [NavButton2 buttonWithType:UIButtonTypeCustom];
    [self.btnRight setImage:[UIImage imageNamed:@"ico_bangWXcount"] forState:UIControlStateNormal];
    [self.btnRight addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRight setTitle:@"收款信息" forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.btnRight];
    //默认隐藏
    self.btnRight.hidden = YES;
    //scrollView
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    self.scrollView.hidden = YES;
    //电子收款信息
    self.viewTop = [LSElectronicCollectionAccountInfoView electronicCollectionAccountInfoView];
    [self.viewTop.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.viewTop];
    //微信按钮
    self.btnWeiXin = [[LSElectronicCollectionButton alloc] init];
    [self.btnWeiXin setImage:[UIImage imageNamed:@"ico_epay_weixin"] forState:UIControlStateNormal];
    [self.btnWeiXin setTitle:@"微信收款明细" forState:UIControlStateNormal];
    [self.btnWeiXin addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.btnWeiXin];
    //支付宝按钮
    self.btnAlipay = [[LSElectronicCollectionButton alloc] init];
    [self.btnAlipay setImage:[UIImage imageNamed:@"ico_epay_alipay"] forState:UIControlStateNormal];
    [self.btnAlipay setTitle:@"支付宝收款明细" forState:UIControlStateNormal];
    [self.btnAlipay addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.btnAlipay];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.titleBox makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(wself.view);
        make.height.equalTo(64);
    }];
    //右上角按钮
    [self.btnRight makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.view.right).offset(-10);
        make.top.equalTo(wself.view.top).offset(25);
        make.size.equalTo(CGSizeMake(80, 30));
    }];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.titleBox.bottom);
    }];
    [self.viewTop makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.scrollView.top).offset(10);
        make.left.equalTo(wself.scrollView.left).offset(10);
        make.width.equalTo(wself.scrollView.width).offset(-20);
        make.height.equalTo(wself.viewTop.ls_height);
    }];
    CGFloat btnW = 70;
    CGFloat btnH = 100;
    //微信按钮
    [self.btnWeiXin makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.viewTop.bottom).offset(20);
        make.centerX.equalTo(wself.scrollView.centerX).offset(-55);
        make.size.equalTo(CGSizeMake(btnW, btnH));
        make.bottom.equalTo(wself.scrollView.bottom).offset(-40);
    }];
    //支付宝按钮
    [self.btnAlipay makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.btnWeiXin.top);
        make.centerX.equalTo(wself.scrollView.centerX).offset(55);
        make.size.equalTo(CGSizeMake(btnW, btnH));
    }];
  
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)loadData{
    //获取分账实体ID
    __weak typeof(self) wself = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    self.entiyId = [[Platform Instance] getkey:PAY_ENTITY_ID];
    [param setObject:self.entiyId forKey:@"entity_id"];
    ///查询店铺电子支付信息
    NSString *url = @"pay/online/v1/get_online_pay_info";
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        ShopInfoVO *shopInfoVo = [ShopInfoVO mj_objectWithKeyValues:json[@"data"]];
        wself.shopInfoVO = shopInfoVo;
        [wself initData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
-(void)initData{
    BOOL isAccount = [NSString isNotBlank:self.shopInfoVO.bankAccount];
    self.btnRight.hidden = !isAccount;
    //计算当天日期
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    self.date = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)year,(long)month,(long)day];
    NSString *dateStr = [DateUtils formateDate5:[NSDate date]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:self.entiyId forKey:@"entity_id"];
    [param setObject:dateStr forKey:@"year_month"];
    [param setObject:@"-1" forKey:@"pay_type"];
    NSString *url = @"bill/v1/total_by_month";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        [wself loadFinished:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

-(void)loadFinished:(NSDictionary *)map{
    NSDictionary *dict = [map objectForKey:@"data"];
    NSArray *array = [dict objectForKey:@"everyDays"];
    NSArray *datas = [JsonHelper transList:array objName:@"PayBillSummaryOfMonthVO"];
    PayBillSummaryOfMonthVO *payVo = [PayBillSummaryOfMonthVO new];
    for (PayBillSummaryOfMonthVO *vo in datas) {
        if ([self.date isEqualToString:vo.date]) {
            payVo = vo;
        }
    }
    //电子未到账总额
    NSString *unAcount = [NSString numberFormatterWithDouble:[dict objectForKey:@"noShareTotalFee"]];
    //本月累计电子收款已到账
    NSString *monthAcount = [NSString numberFormatterWithDouble:[dict objectForKey:@"monthShareIncome"]];//monthShareIncome
    //本月累计电子收款收入
    NSString *monthIncome = [NSString numberFormatterWithDouble:[dict objectForKey:@"monthTotalFee"]];
    //某天累计电子收款收入
    NSString *dayIncome = [NSString numberFormatterWithDouble:[NSNumber numberWithDouble:payVo.totalFee]];
   //某天累计电子收款已到账
    NSString *dayAcount = [NSString numberFormatterWithDouble:[NSNumber numberWithDouble:payVo.shareIncome]];
    NSString *dayStr = [DateUtils formateChineseShortDate2:[NSDate date]];
    [self.viewTop setShopInfoVo:self.shopInfoVO name:@"" date:dayStr unAccount:unAcount monthAccount:monthAcount monthIncome:monthIncome dayAccount:dayAcount dayIncome:dayIncome];
    __weak typeof(self) wself = self;
    [self.viewTop updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(wself.viewTop.ls_height);
    }];
    self.scrollView.hidden = NO;
    
  
    
}

#pragma mark - 微信支付宝点击事件
- (void)btnClick:(UIButton *)btn {
    if (btn == self.btnWeiXin) {
         [self gotoNextView:@"微信"];
    } else if (btn == self.btnAlipay){
        [self gotoNextView:@"支付宝"];
    } else if (btn == self.btnRight || btn == self.viewTop.btn) {//右上角及绑卡按钮点击
        [self gotoPaymentEditView];
    }
}

- (void)gotoNextView:(NSString *)name {
    int authStatus = self.shopInfoVO.settleAccountInfo.authStatus.intValue;
    PaymentView *vc = [[PaymentView alloc] init];
    [vc initDataView:name isShowAccount:NO];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    return;
    if(authStatus == 1) {//进件成功
        PaymentView *vc = [[PaymentView alloc] init];
        [vc initDataView:name isShowAccount:NO];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    }else if(authStatus == 0) {//未进件
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"根据央行政策,本店电子支付已被关闭,顾客无法使用电子支付,请立即绑定收款账户以重新开通" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoPaymentEditView];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else if(authStatus == 2){//进件失败
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"根据央行政策,本店电子支付已被关闭,顾客无法使用电子支付,请立即绑定收款账户以重新开通" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoPaymentEditView];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    
}

- (void)gotoPaymentEditView {
    if ([[Platform Instance] lockAct:ACTION_BANK_BINDING]) {
        [AlertBox show:@"您没有收款信息绑卡的权限"];
        return;
    }
    PaymentEditView *vc = [[PaymentEditView alloc] initWithNibName:[SystemUtil getXibName:@"PaymentEditView"] bundle:nil shopInfoVO:self.shopInfoVO];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}






@end
