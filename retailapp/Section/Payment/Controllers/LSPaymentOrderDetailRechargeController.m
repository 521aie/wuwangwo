//
//  LSPaymentOrderDetailRechargeController.m
//  retailapp
//
//  Created by wuwangwo on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPaymentOrderDetailRechargeController.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "LSOrderDetailReportVo.h"
#import "LSOrderReportVo.h"
#import "LSPersonDetailVO.h"
#import "DateUtils.h"
#import "OrderInfoVo.h"
#import "OnlineChargeVo.h"
#import "LSViewFactor.h"
#import "UIHelper.h"
#import "LSPaymentOrderDetailRechargeTopView.h"
#import "LSPaymentOrderDetailRechargeBottomView.h"

@interface LSPaymentOrderDetailRechargeController ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView *container;
/** headerView */
@property (nonatomic, strong) UIView *viewMember;
@property (nonatomic, strong) LSPaymentOrderDetailRechargeTopView *topView;
@property (nonatomic, strong) LSPaymentOrderDetailRechargeBottomView *bottomView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSDictionary *settlements;
@property (nonatomic, strong) OnlineChargeVo *onlineChargeVo;
@property (nonatomic, strong) OrderInfoVo *orderInfoVo;
@property (nonatomic, strong) LSPersonDetailVO *personDetailVO;
@end

@implementation LSPaymentOrderDetailRechargeController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initMainView];
    [self loadData];
}

- (void)initMainView {
    
    self.view.backgroundColor = [UIColor clearColor];
    [self configTitle:@"明细详情" leftPath:Head_ICON_BACK rightPath:nil];
    
    //scollVIew
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(64);
    }];
    
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
    
    self.topView = [LSPaymentOrderDetailRechargeTopView paymentOrderDetailRechargeTopView];
    [self.container addSubview:self.topView];
    
    [LSViewFactor addClearView:self.container y:0 h:5];
    
    self.bottomView = [LSPaymentOrderDetailRechargeBottomView paymentOrderDetailRechargeBottomView];
    [self.container addSubview:self.bottomView];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)loadData {
    
    __weak typeof(self) wself = self;
    //获取会员卡信息
    NSString *url = @"onlineReceipt/payPersonDetail";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if ([ObjectUtil isNotNull:self.customerId]) {
        
        [param setValue:self.customerId forKey:@"customerId"];
    }
    
    if ([ObjectUtil isNotNull:self.customerRegisterId]) {
        
        [param setValue:self.customerRegisterId forKey:@"customerRegisterId"];
    }
    
    [param setValue:self.orderId forKey:@"orderId"];
    [param setValue:self.orderCode forKey:@"orderCode"];
    [param setValue:self.payMsgTag forKey:@"payMsgTag"];
    
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        
        wself.settlements = json[@"settlements"];
        NSDictionary *personDetail = json[@"personDetail"];
        
        //会员信息
        if ([ObjectUtil isNotNull:personDetail]) {
            
            wself.personDetailVO = [LSPersonDetailVO personDetailVOWithMap:personDetail];
        }
        
        //订单信息
        NSDictionary *orderInfoVo = json[@"orderInfoVo"];
        if ([ObjectUtil isNotNull:orderInfoVo]) {
            
            wself.orderInfoVo = [OrderInfoVo converToVo:orderInfoVo];
        }
        
        //充值信息
        NSDictionary *onlineChargeVo = json[@"onlineChargeVo"];
        if ([ObjectUtil isNotNull:onlineChargeVo]) {
            
            wself.onlineChargeVo = [OnlineChargeVo onlineChargeVoWithMap:onlineChargeVo];
        }
        
        //商品信息
        NSArray *instanceVoList = json[@"instanceVoList"];
        if ([ObjectUtil isNotNull:instanceVoList]) {
            
            wself.datas = [InstanceVo converToArr:instanceVoList];
        }
        
        [wself.topView setPersonDetailVO:wself.personDetailVO cardNo:wself.onlineChargeVo.cardNo];
        [wself.bottomView setRechargeOnlineChargeVo:wself.onlineChargeVo settlements:wself.settlements];
        
    } errorHandler:^(id json) {
            
        [AlertBox show:json];
    }];
    
     [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

@end
