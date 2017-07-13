 //
//  WeChatBalanceLogDetail.m
//  retailapp
//
//  Created by diwangxie on 16/5/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BalanceLogDetail.h"
#import "XHAnimalUtil.h"
#import "BaseService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "MoneyFlowVo.h"
#import "DateUtils.h"
#import "UIHelper.h"

@interface BalanceLogDetail ()
@property (nonatomic, strong) BaseService             *service;           //网络服务
@property (nonatomic,strong) MoneyFlowVo *moneyFlowVo;
@end

@implementation BalanceLogDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    _service = [ServiceFactory shareInstance].baseService;
    [self initHead];
    [self initView];
    [self loadDate];
    // Do any additional setup after loading the view.
}
-(void)initHead{
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"账单详情" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}
-(void)loadDate{
    NSString *url = nil;
    
    url = @"accountInfo/moneyflow/detail";
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [param setValue:[NSNumber numberWithLongLong:_moneyFlow] forKey:@"moneyFlowId"];

    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {

        _moneyFlowVo =[MoneyFlowVo convertToMoneyFlowVo:[json objectForKey:@"moneyFlowVo"]];
        
        [self initView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
-(void)initView{
    if(_moneyFlowVo.action==5){
        self.lblMoney.text=[NSString stringWithFormat:@"-%.2f",_moneyFlowVo.fee];
        self.lblMoney.textColor=[ColorHelper getGreenColor];
    }else{
        if (_moneyFlowVo.fee>0) {
            self.lblMoney.text=[NSString stringWithFormat:@"+%.2f",_moneyFlowVo.fee];
            self.lblMoney.textColor=[ColorHelper getRedColor];
        }else{
            self.lblMoney.text=[NSString stringWithFormat:@"%.2f",_moneyFlowVo.fee];
            self.lblMoney.textColor=[ColorHelper getGreenColor];
        }
    }
    
    if (self.actionType==5) {
        self.lblState.text=@"提现";
        //提现
        [self.lstOne initLabel:@"提现方式" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.lstOne initData:_moneyFlowVo.withDrawType];
        [self.lstOne editEnabled:NO];
        
        [self.lstTwo visibal:NO];
        [self.txtTwo visibal:YES];
        
        [self.txtTwo initLabel:@"开户行" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.txtTwo initData:_moneyFlowVo.bankName];
        [self.txtTwo editEnabled:NO];
        
        [self.lstTree initLabel:@"银行卡号" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.lstTree initData:[NSString stringWithFormat:@"尾号 %@",[_moneyFlowVo.accountNumber substringFromIndex:[_moneyFlowVo.accountNumber length]-4]]];
        ;
        
        [self.lstTree editEnabled:NO];
        
        [self.lstFour initLabel:@"申请人" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.lstFour initData:_moneyFlowVo.customerName];
        [self.lstFour editEnabled:NO];
        
        [self.lstFive initLabel:@"申请时间" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.lstFive initData:[DateUtils formateTime1:_moneyFlowVo.createTime]];
        [self.lstFive editEnabled:NO];
        
    }else if(self.actionType==6){
        self.lblState.text=@"退款成功";
        //退款
        [self.lstOne initLabel:@"退款申请人" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.lstOne initData:[NSString stringWithFormat:@"%@ %@",_moneyFlowVo.customerName,_moneyFlowVo.customerMobile]];
        [self.lstOne editEnabled:NO];
        
        [self.lstTwo initLabel:@"单号" withHit:nil delegate:self];
        [self.lstTwo initData:[_moneyFlowVo.orderCode substringFromIndex:3] withVal:nil];
        self.lstTwo.lblVal.textColor=[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
        [self.lstTwo.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];

        [self.lstTree initLabel:@"申请时间" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.lstTree initData:[DateUtils formateTime:_moneyFlowVo.createTime]];
        [self.lstTree editEnabled:NO];
        
        [self.lstFour initLabel:@"退款成功时间" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.lstFour initData:[DateUtils formateTime:_moneyFlowVo.opTime]];
        [self.lstFour editEnabled:NO];
        
        [self.lstFive visibal:NO];
        [self.txtTwo visibal:NO];
    }else{
        self.lblState.text=[self getStatusString:_moneyFlowVo.status];
        //订单类
        [self.lstOne initLabel:@"订单来源" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.lstOne editEnabled:NO];
        
        if ([_moneyFlowVo.outType isEqualToString:@"weixin"]) {
            [self.lstOne initData:@"微店订单"];
        } else if ([_moneyFlowVo.outType isEqualToString:@"weiPlatform"]) {//微平台订单
            [self.lstOne initData:@"微平台订单"];
        } else {
            [self.lstOne initData:@"实体订单"];
        }
        
        [self.lstTwo initLabel:@"单号" withHit:nil delegate:self];
        [self.lstTwo initData:[_moneyFlowVo.orderCode substringFromIndex:3] withVal:nil];
        self.lstTwo.lblVal.textColor=[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
        [self.lstTwo.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
        
        [self.lstTree initLabel:@"类型" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.lstTree initData:[self getActionString:_moneyFlowVo.action]];
        [self.lstTree editEnabled:NO];
        
        [self.lstFour initLabel:@"佣金比例(%)" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.lstFour initData:[NSString stringWithFormat:@"%.2f",_moneyFlowVo.rebateRate]];
        [self.lstFour editEnabled:NO];
        
        if(self.actionType==1){
            [self.lstFour visibal:YES];
        }else{
            [self.lstFour visibal:NO];
        }
        
        [self.lstFive initLabel:@"下单时间" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.lstFive initData:[DateUtils formateTime:_moneyFlowVo.createTime]];

        [self.lstFive editEnabled:NO];
        [self.lstTwo visibal:YES];
        [self.txtTwo visibal:NO];

    }
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}

-(void)onItemListClick:(EditItemList *)obj{
    OrderRebateDetail *vc = [[OrderRebateDetail alloc] initWithNibName:[SystemUtil getXibName:@"OrderRebateDetail"] bundle:nil];
    vc.accountInfoId=_moneyFlowVo.id;
    vc.orderId=_moneyFlowVo.orderid;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}
- (NSString *)getStatusString:(short)status {
    //销售订单  状态:11待付款、12付款中、13待分配、15待处理、20配送中、21配送完成、16拒绝配送、22交易取消、23交易关闭
    //供货订单:15待处理、20配送中、21配送完成、16拒绝配送
    NSDictionary *statusDic = @{ @"11":@"待付款", @"13":@"待分配", @"15":@"待处理", @"16":@"拒绝配送", @"20":@"配送中", @"21":@"交易成功", @"22":@"交易取消", @"23":@"交易关闭",@"24":@"配送完成"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}
- (NSString *)getActionString:(short)status {
    //销售订单  状态:11待付款、12付款中、13待分配、15待处理、20配送中、21配送完成、16拒绝配送、22交易取消、23交易关闭
    //供货订单:15待处理、20配送中、21配送完成、16拒绝配送
    NSDictionary *statusDic = @{ @"1":@"分销返利",@"2":@"微平台", @"3":@"余利",@"4":@"销售收入", @"5":@"提现", @"6":@"退款"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

- (NSString *)getReturnStatusString:(short)status {
    NSDictionary *statusDic = @{@"1":@"待审核", @"2":@"退款成功", @"3":@"同意退货", @"4":@"退货中", @"5":@"待退款", @"6":@"拒绝退货", @"7":@"拒绝退款", @"8":@"取消退货", @"9":@"退款失败"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
