//
//  MemberRedRechargeEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberRedRechargeEditView.h"
#import "UIHelper.h"
#import "NavigateTitle2.h"
#import "MemberModule.h"
#import "EditItemText.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "XHAnimalUtil.h"
#import "RechargeRecordDetailsVo.h"
#import "MemberRender.h"
#import "DateUtils.h"
#import "MemberChargeRecordView.h"

@interface MemberRedRechargeEditView ()

@property (nonatomic, strong) MemberService* memberService;

@property (nonatomic, strong) SettingService *settingservice;

@property (nonatomic) short status;

@property (nonatomic) int action;

@property (nonatomic, strong) RechargeRecordDetailsVo *rechargeRecordDetailsVo;

@property (nonatomic, strong) IBOutlet UIButton *btnRed;

@property (nonatomic, strong) NSString *moneyFlowId;

@property (nonatomic, strong) NSString *customerId;

@end

@implementation MemberRedRechargeEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil moneyFlowId:(NSString *)moneyFlowId customerId:(NSString *)customerId status:(short)status action:(int)action
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _moneyFlowId = moneyFlowId;
        _customerId = customerId;
        _status = status;
        _action = action;
        _memberService = [ServiceFactory shareInstance].memberService;
        _settingservice = [ServiceFactory shareInstance].settingService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self initMainView];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    [self loaddatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loaddatas
{
    [self.scrollView setContentOffset:CGPointMake(0, 0)animated:YES];
    __weak MemberRedRechargeEditView* weakSelf = self;
    [_memberService selectMemberRedRecharge:self.moneyFlowId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    self.rechargeRecordDetailsVo = [RechargeRecordDetailsVo convertToRechargeRecordDetailsVo:[json objectForKey:@"chargeRecordDetail"]];
    self.titleBox.lblTitle.text = self.rechargeRecordDetailsVo.customerName;
    [self fillModel];
    [self.btnRed setHidden:_status == 0];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) fillModel
{
    [self.txtCardCode initData:self.rechargeRecordDetailsVo.cardCode];
    
    [self.txtMemberName initData:self.rechargeRecordDetailsVo.customerName];
    
    [self.txtmobile initData:self.rechargeRecordDetailsVo.mobile];
    
    [self.txtPayMoney initData:[NSString stringWithFormat:@"%.2f", self.rechargeRecordDetailsVo.payMoney]];
    
    [self.txtGiftMoney initData:[NSString stringWithFormat:@"%.2f", self.rechargeRecordDetailsVo.giftMoney]];
    
    [self.txtBalance initData:[NSString stringWithFormat:@"%.2f", self.rechargeRecordDetailsVo.balance]];
    
    if (self.rechargeRecordDetailsVo.giftIntegral == 0) {
        [self.txtGiftIntegral initData:@"0"];
        
    }else{
        [self.txtGiftIntegral initData:[NSString stringWithFormat:@"%.ld", self.rechargeRecordDetailsVo.giftIntegral]];
    }
    
    [self.txtPayType initData:[MemberRender obtainRechargeType:[NSString stringWithFormat:@"%ld", self.rechargeRecordDetailsVo.payType]]];
    
    [self.txtShopName initData:self.rechargeRecordDetailsVo.shopName];
    
    [self.txtPayMode initData:self.rechargeRecordDetailsVo.payModeName];
    
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    __weak MemberRedRechargeEditView* weakSelf = self;
//    [_settingservice payMentList:arr completionHandler:^(id json) {
//        if (!(weakSelf)) {
//            return ;
//        }
//        NSArray *list = json[@"payMentVoList"];
//        NSMutableArray* payModeList = [JsonHelper transList:list objName:@"PaymentVo"];
//        [self.txtPayMode initData:[MemberRender obtainPayMode:[NSString stringWithFormat:@"%ld", self.rechargeRecordDetailsVo.payMode] salePayModeList:payModeList]];
//        
//    } errorHandler:^(id json) {
//        [AlertBox show:json];
//    }];
    
    [self.txtOperatePerson initData:[NSString stringWithFormat:@"%@(工号:%@)", self.rechargeRecordDetailsVo.staffName,self.rechargeRecordDetailsVo.staffId]];
    
    [self.txtTime initData: [DateUtils formateTime4:self.rechargeRecordDetailsVo.moneyFlowCreatetime]];
    
}

-(void) initMainView
{
    [self.txtCardCode initLabel:@"会员卡号" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtCardCode editEnabled:NO];
    
    [self.txtMemberName initLabel:@"会员名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtMemberName editEnabled:NO];
    
    [self.txtmobile initLabel:@"手机号码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtmobile editEnabled:NO];
    
    [self.txtPayMoney initLabel:@"充值金额(元)" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtPayMoney editEnabled:NO];
    
    [self.txtGiftMoney initLabel:@"赠送金额(元)" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtGiftMoney editEnabled:NO];
    
    [self.txtBalance initLabel:@"充值后余额(元)" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtBalance editEnabled:NO];
    
    [self.txtGiftIntegral initLabel:@"赠送积分" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtGiftIntegral editEnabled:NO];
    
    [self.txtPayType initLabel:@"充值方式" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtPayType editEnabled:NO];
    
    [self.txtShopName initLabel:@"充值门店" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtShopName editEnabled:NO];
    
    [self.txtPayMode initLabel:@"支付方式" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtPayMode editEnabled:NO];
    
    [self.txtOperatePerson initLabel:@"操作人" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtOperatePerson editEnabled:NO];
    
    [self.txtTime initLabel:@"时间" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtTime editEnabled:NO];
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(IBAction)btnCancelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:@"确认要红冲吗？"];
}

//红冲确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        __weak MemberRedRechargeEditView* weakSelf = self;
        [_memberService doMemberRedRecharge:self.moneyFlowId lastVer:[NSString stringWithFormat:@"%.ld", self.rechargeRecordDetailsVo.lastVer] completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MemberChargeRecordView class]]) {
                    MemberChargeRecordView *listView = (MemberChargeRecordView *)vc;
                    [listView loaddatasFromEdit];
                }
            }
            
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

@end
