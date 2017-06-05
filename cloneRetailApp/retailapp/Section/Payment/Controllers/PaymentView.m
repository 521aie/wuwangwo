//
//  PaymentView.m
//  retailapp
//
//  Created by guozhi on 16/5/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "PaymentView.h"
#import "AlertBox.h"
#import "Platform.h"
#import "SignUtil.h"
#import "DateUtils.h"
#import "DatePickerBox.h"
#import "UIHelper.h"
//#import "AFHTTPRequestOperation.h"
#import "ShopInfoVO.h"
#import "UIView+Sizes.h"
#import "PayBillSummaryOfMonthVO.h"
#import "OrderListView.h"
#import "SystemUtil.h"
#import "XHAnimalUtil.h"
#import "PaymentEditView.h"
#import "PaymentTypeView.h"
#import "LSBarChartView.h"
#import "LSPaymentTypeVo.h"
#import "MJExtension.h"
#import "LSBarChartVo.h"
#import "DatePickerView.h"
#import "LSPaymentStatusController.h"
#import "LSPaymentAccountView.h"
@interface PaymentView () <LSBarChartViewEvent,DatePickerViewEvent>
@property (strong, nonatomic) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) UIView *container;
@property (strong, nonatomic) UILabel *lblTime;
@property (nonatomic, copy) NSString *lblTimeStr;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, assign) NSInteger currYear;    //当前年.
@property (nonatomic, assign) NSInteger currMonth;   //当年月份.
@property (nonatomic, assign) NSInteger currDay;     //当前日期.
@property (nonatomic, strong) NSMutableDictionary *dayDic;  //日数据字典表.
@property (nonatomic, strong) NSMutableArray *dayDatas;   //详细日数据.
@property (nonatomic, copy) NSString *entiyId;
@property (nonatomic, strong) ShopInfoVO *shopInfoVO;
@property (nonatomic, assign) BOOL isSuper;
// 微信  支付宝  QQ
@property (nonatomic, copy) NSString *payment;
@property (nonatomic, assign) BOOL isShowAccount;
@property (nonatomic, strong) LSPaymentTypeVo *paymentTypeVo;
@property (nonatomic, strong) LSBarChartView *barChartView;
@property (nonatomic, strong)DatePickerView *datePickerView;

@property (strong, nonatomic)  UILabel *consumeTxt;
@property (strong, nonatomic)  UILabel *rechargeTxt;
/** <#注释#> */
@property (nonatomic, strong) LSPaymentAccountView *topView;
/** chartView */
@property (nonatomic, strong) UIView *chartView;
/** <#注释#> */
@property (nonatomic, strong) UIView *orderView;

@end
@implementation PaymentView

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self configTitle:[NSString stringWithFormat:@"%@收款明细", self.payment] leftPath:Head_ICON_BACK rightPath:nil];
    [self setupScrollView];
    [self setupTopView];
    [self setupChartView];
    [self setupOrderView];
    [self initMainView];
    [self loadData];
    [self configHelpButton:HELP_PAYMENT_ACCOUNT];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, self.view.ls_width, self.view.ls_height - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
}
- (void)setupTopView {
    self.topView = [LSPaymentAccountView paymentAccountView];
    self.topView.lblMonthReceivedName.text = @"本月累计已到账金额(元)";
    [self.topView.btnBind addTarget:self action:@selector(bindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:self.topView];
}

- (void)setupChartView {
    self.chartView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.container.ls_width - 10, 270)];
    [self.container addSubview:self.chartView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.chartView.ls_width, 40)];
    [self.chartView addSubview:topView];
    UILabel *lblTime = [[UILabel alloc] init];
    self.lblTime = lblTime;
    lblTime.font = [UIFont systemFontOfSize:17];
    lblTime.textColor = [UIColor whiteColor];
    [topView addSubview:lblTime];
    [lblTime makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.centerX.equalTo(topView.centerX).offset(-10);
    }];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"ico_next_down_w"];
    [topView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(lblTime.right).offset(5);
        make.size.equalTo(22);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [topView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(5);
        make.right.equalTo(topView).offset(-5);
        make.bottom.equalTo(topView);
        make.height.equalTo(1);
    }];
    [topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDate)]];
    
    self.barChartView = [[LSBarChartView alloc] initWithFrame:CGRectMake(0, 50, self.chartView.bounds.size.width, 200) itemSize:CGSizeMake(10,200*5/6 ) itemSpace:10 delegate:self];
    self.barChartView.dateFomatter = MonthToDaySample;
    [self.chartView addSubview:self.barChartView];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 240, self.chartView.ls_width, 20)];
    [self.chartView addSubview:bottomView];
    
    self.consumeTxt = [[UILabel alloc] init];
    self.consumeTxt.text = @"消费收入0.00元";
    self.consumeTxt.textColor = [UIColor whiteColor];
    self.consumeTxt.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:self.consumeTxt];
    [self.consumeTxt makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.centerX).offset(-20);
        make.centerY.equalTo(bottomView);
    }];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:leftView];
    [leftView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(self.consumeTxt.left).offset(-5);
        make.size.equalTo(12);
    }];

    self.rechargeTxt = [[UILabel alloc] init];
    self.rechargeTxt.text = @"充值收入0.00元";
    self.rechargeTxt.textColor = [UIColor whiteColor];
    self.rechargeTxt.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:self.rechargeTxt];
    
    
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = [UIColor redColor];
    [bottomView addSubview:rightView];
    [rightView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.centerX).offset(20);
        make.centerY.equalTo(bottomView);
        make.size.equalTo(12);
    }];
    
    [self.rechargeTxt makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.left.equalTo(rightView.right).offset(5);
        
    }];
    
}

- (void)setupOrderView {
    self.orderView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.container.ls_width - 10, 40)];
    self.orderView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    self.orderView.layer.cornerRadius = 4;
    [self.container addSubview:self.orderView];
    
    UILabel *lblName = [[UILabel alloc] init];
    lblName.textColor = [UIColor whiteColor];
    lblName.text = @"当日账户明细";
    lblName.font = [UIFont boldSystemFontOfSize:14];
    [self.orderView addSubview:lblName];
    [lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderView).offset(5);
        make.centerY.equalTo(self.orderView);
    }];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"ico_next_down_w"];
    [self.orderView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderView).offset(-5);
        make.centerY.equalTo(self.orderView);
        make.size.equalTo(22);
    }];
    UILabel *lblVal = [[UILabel alloc] init];
    lblVal.textColor = [UIColor whiteColor];
    lblVal.text = @"展开";
    lblVal.font = [UIFont boldSystemFontOfSize:14];
    [self.orderView addSubview:lblVal];
    [lblVal makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgView.left).offset(-5);
        make.centerY.equalTo(self.orderView);
    }];
    [self.orderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOpen)]];
}

- (void)selectDate {//点击选择日期
    [self.datePickerView initDate:self.currYear  month:self.currMonth];
}

- (void)clickOpen {//点击展开时间
    NSString* date = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)self.currYear, (long)self.currMonth, (long)self.currDay];
    OrderListView *vc = [[OrderListView alloc] initWithDate:date entityId:self.entiyId payment:self.payment];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)direct {
    if (direct == LSNavigationBarButtonDirectLeft) {
        [self popViewController];
    } else {
        [self bindBtnClick:nil];
    }
}

- (void)initMainView {
    
    self.topView.lblTip.text =  [NSString stringWithFormat:@"未绑定%@支付",self.payment];
    self.dayDic = [NSMutableDictionary dictionary];
    self.datePickerView = [[DatePickerView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height) title:@"请选择日期" client:self];
   
    self.scrollView.hidden = YES;

    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
- (void)loadData {
    self.scrollView.hidden = YES;
    self.entiyId = [[Platform Instance] getkey:PAY_ENTITY_ID];
    [self initDataView];
}

-(void)initDataView{
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    [self loadData:year month:month day:day];
}
- (void)initDataView:(NSString *)payment isShowAccount:(BOOL)isShowAccount {
    self.payment = payment;
    self.isShowAccount = isShowAccount;
}

- (void)loadData:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    self.currYear = year;
    self.currMonth = month;
    self.currDay = day;
    NSDate *dateNow = [NSDate date];
    self.lblTimeStr = [DateUtils formateDate2:dateNow];
    self.lblTime.text = [NSString stringWithFormat:@"%ld年%02ld月",year,(long)month];
     NSString *date = [NSString stringWithFormat:@"%ld-%02ld", (long)year, (long)month];
    
    __weak typeof(self) wself  = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //查询店家信息
    [param setValue:self.entiyId forKey:@"entity_id"];
    ///查询店铺电子支付信息
    NSString *url = @"pay/online/v1/get_online_pay_info" ;
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.shopInfoVO = [ShopInfoVO mj_objectWithKeyValues:json[@"data"]];
        if (wself.shopInfoVO.settleAccountInfo.authStatus.intValue == 1 && self.isShowAccount) {
            [wself configNavigationBar:LSNavigationBarButtonDirectRight title:@"收款账户" filePath:@"nav_account"];
        } else {
            [wself configNavigationBar:LSNavigationBarButtonDirectRight title:nil filePath:nil];
        }
        
        NSInteger realDay = wself.shopInfoVO.fundBillHoldDay + 1;
        int authStatus = self.shopInfoVO.settleAccountInfo.authStatus.intValue;
        if (authStatus == 1) {//己进件
            wself.topView.lblRate.text = [NSString stringWithFormat: @"(%@官方已收取%@的服务费)",self.payment,@"0.6%"];
            wself.topView.lblBind.text = [NSString stringWithFormat:@"顾客使用%@支付付款成功后，此笔钱款会在支付成功后的第%ld天中午12：00以后自动转账到您绑定的收款账户，%@官方以0.6%%的费率收取服务费(“未到账总额”、“%@收款收入”皆为扣除服务费之前的金额)。若遇系统故障，延迟一天转账，敬请谅解。",self.payment, (long)realDay ,self.payment,self.payment];
            wself.topView.isBindCard = year;
        } else {//进件失败 未进件
            if (authStatus == 0) {//未进件
                [self.topView.btnBind setTitle:@"立即绑定收款账户" forState:UIControlStateNormal];
                self.topView.lblTip.text = @"未绑定收款账户！";
            } else if (authStatus == 2) {//进件失败
                self.topView.lblTip.text = @"收款账户有误，请修改！";
                [self.topView.btnBind setTitle:@"立即修改收款账户" forState:UIControlStateNormal];
                
            }
            wself.topView.isBindCard = NO;
            wself.topView.lblRate.text = @"";
            wself.topView.lblUnBind.text = [NSString stringWithFormat:@"绑定收款账户后，将为您开通电子支付，顾客购物结账时可以使用%@支付进行付款。在顾客支付成功的第%ld日中午12：00后此笔钱款将自动打入您绑定的账户，%@官方以0.6%%的费率收取服务费（“未到账总额”、“微信收款收入”皆为扣除服务费之前的金额）。请尽快绑定您的收款账户！", self.payment, realDay, self.payment];
            
        }
        self.topView.hidden = [[Platform Instance] lockAct:ACTION_WEI_PAY_SUMMARIZE_SEARCH];
        self.orderView.hidden = [[Platform Instance] lockAct:ACTION_WEI_PAY_SEARCH];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        wself.scrollView.hidden = NO;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];   
    
    //查询指定月微信账单合计
    [param removeAllObjects];
    [param setValue:wself.entiyId forKey:@"entity_id"];
    [param setValue:date forKey:@"year_month"];
    NSString *payType = nil;
    if ([self.payment isEqualToString:@"微信"]) {
        payType = @"1";
    } else if ([self.payment isEqualToString:@"支付宝"]) {
        payType = @"2";
    } else if ([self.payment isEqualToString:@"QQ钱包"]) {
        payType = @"5";
    }
    
    [param setValue:payType forKey:@"pay_type"];
    url = @"bill/v1/total_by_month";
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        [wself parseBillByMonthResult:json[@"data"]];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)parseBillByMonthResult:(NSDictionary *)dict {
    
    self.topView.lblUnReceivedTotalVal.text = [NSString numberFormatterWithDouble:[dict objectForKey:@"noShareTotalFee"]];
    self.topView.lblMonthIncomeVal.text = [NSString numberFormatterWithDouble:[dict objectForKey:@"monthTotalFee"]];
    self.topView.lblMonthReceivedVal.text = [NSString numberFormatterWithDouble:[dict objectForKey:@"monthShareIncome"]];
    NSMutableArray *arr = [dict objectForKey:@"everyDays"];
    NSArray *dayDatas = [PayBillSummaryOfMonthVO mj_objectArrayWithKeyValuesArray:arr];
    NSMutableDictionary *chartDict = [NSMutableDictionary dictionaryWithCapacity:31];
     [self.dayDic removeAllObjects];
    for (PayBillSummaryOfMonthVO *vo in dayDatas) {
        LSBarChartVo *chartVo = [[LSBarChartVo alloc] init];
        chartVo.value = vo.totalFee;
        chartVo.value2 = vo.payTagTotalFee;
        chartVo.isSelected = NO;
        chartVo.key = vo.date;
        [chartDict setValue:chartVo forKey:vo.date];
        [self.dayDic setValue:vo forKey:vo.date];
    }
    [self.barChartView loadData:chartDict];
    [self.barChartView initChartView:self.currYear month:self.currMonth day:self.currDay];
    
}
- (void)barChartViewdidScroll:(LSBarChartView *)barChartView chartVo:(LSBarChartVo *)chartVo {
    barChartView.tip.text = [NSString stringWithFormat:@"%02ld月%02ld日 %@",barChartView.currentMonth,barChartView.currentDay,barChartView.week];
     self.currDay = barChartView.currentDay;
     NSString *selectDate = [NSString stringWithFormat:@"%02ld月%02ld日", (long)self.currMonth, (long)self.currDay];
    self.consumeTxt.text = [NSString stringWithFormat:@"消费收入%.2f元",chartVo.value-chartVo.value2];
    self.rechargeTxt.text = [NSString stringWithFormat:@"充值收入%.2f元",chartVo.value2];
     self.topView.lblDayIncomeName.text = [NSString stringWithFormat:@"%@%@收款收入(元)",selectDate,self.payment];
     self.topView.lblUnReceivedTotalName.text = [NSString stringWithFormat:@"%@收款未到账总额(元)",self.payment];
     self.topView.lblDayReceivedName.text = [selectDate stringByAppendingString:@"已到账金额(元)"];
     self.topView.lblMonthIncomeName.text = [NSString stringWithFormat:@"本月累计%@收款收入(元)",self.payment];
    self.topView.lblDayIncomeVal.text = [NSString numberFormatterWithDouble:[NSNumber numberWithDouble:chartVo.value]];
    PayBillSummaryOfMonthVO *vo = [self.dayDic objectForKey:chartVo.key];
    if (!vo) {
        vo = [PayBillSummaryOfMonthVO  new];
    }
      self.topView.lblDayReceivedVal.text = [NSString numberFormatterWithDouble:[NSNumber numberWithDouble:vo.shareIncome]];

}


- (void)bindBtnClick:(UIButton *)btn {//绑卡事件
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
- (void)gotoPaymentEditView {
    PaymentEditView *vc = [[PaymentEditView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}
-(void)pickerOption:(DatePickerView *)obj eventType:(NSInteger)evenType{
    if (obj.month != self.currMonth || obj.year != self.currYear) {
        self.currDay = 1;
    }
    self.currYear = obj.year;
    self.currMonth = obj.month;
    
    self.lblTime.text = [NSString stringWithFormat:@"%ld年%02ld月",self.currYear,self.currMonth];
    [self.barChartView loadData:[NSMutableDictionary new]];
    [self.barChartView initChartView:self.currYear month:self.currMonth day:self.currDay];
    NSString *selectMonth = [NSString stringWithFormat:@"%ld年%02ld月",(long)self.currYear,(long)self.currMonth];
    self.lblTime.text = selectMonth;
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%02ld",(long) self.currYear,(long)self.currMonth];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.entiyId forKey:@"entity_id"];
    [param setValue:dateStr forKey:@"year_month"];
    NSString *payType = nil;
    if ([self.payment isEqualToString:@"微信"]) {
        payType = @"1";
    } else if ([self.payment isEqualToString:@"支付宝"]) {
        payType = @"2";
    } else if ([self.payment isEqualToString:@"QQ钱包"]) {
        payType = @"5";
    }
    [param setValue:payType forKey:@"pay_type"];
    NSString *url = @"bill/v1/total_by_month";
    __weak PaymentView *weakSelf = self;
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [weakSelf parseBillByMonthResult:json[@"data"]];
    } errorHandler:^(id json) {
        
    }];

}

@end


