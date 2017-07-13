//
//  LSMemberRechargeDetailReportController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberRechargeDetailReportController.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "ViewFactory.h"
#import "Platform.h"
#import "NSString+Estimate.h"
#import "LSEditItemView.h"
#import "MemberRechargeDetailVo.h"
#import "ColorHelper.h"
#import "DateUtils.h"
#import "Platform.h"
@interface LSMemberRechargeDetailReportController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
/**会员卡号*/
@property (strong, nonatomic) LSEditItemView *txtCardCode;

@property (strong, nonatomic) LSEditItemView *memberCardType;/**会员卡类型*/

/**会员名*/
@property (strong, nonatomic) LSEditItemView *txtCustomerName;
/**手机号码*/
@property (strong, nonatomic) LSEditItemView *txtMobile;
/**操作类型*/
@property (strong, nonatomic) LSEditItemView *txtAction;
/**充值金额*/
@property (strong, nonatomic) LSEditItemView *txtPayMoney;
/**赠送金额*/
@property (strong, nonatomic) LSEditItemView *txtGiftMoney;
/**充值后金额*/
@property (strong, nonatomic) LSEditItemView *txtBalance;
/**赠送积分*/
@property (strong, nonatomic) LSEditItemView *txtGiftIntegral;
/**充值方式*/
@property (strong, nonatomic) LSEditItemView *txtPayType;
/**充值门店*/
@property (strong, nonatomic) LSEditItemView *txtShopName;
/**支付方式*/
@property (strong, nonatomic) LSEditItemView *txtPayMode;
/**操作人*/
@property (strong, nonatomic) LSEditItemView *txtStaffName;
/**充值时间*/
@property (strong, nonatomic) LSEditItemView *txtTime;

@end

@implementation LSMemberRechargeDetailReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self loadData];
    
}

#pragma mark - 初始化导航栏

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:nil];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
}


- (void)configContainerViews {
    self.txtCardCode = [LSEditItemView   editItemView];
    [self.txtCardCode initLabel:@"会员卡号" withHit:nil];
    [self.container addSubview:self.txtCardCode];
    
    self.memberCardType = [LSEditItemView   editItemView];
    [self.memberCardType initLabel:@"会员卡类型" withHit:@""];
    [self.container addSubview:self.memberCardType];
    
    self.txtCustomerName = [LSEditItemView   editItemView];
    [self.txtCustomerName initLabel:@"会员名" withHit:nil];
    [self.container addSubview:self.txtCustomerName];
    
    self.txtMobile = [LSEditItemView   editItemView];
    [self.txtMobile initLabel:@"手机号码" withHit:nil];
    [self.container addSubview:self.txtMobile];
    
    self.txtAction = [LSEditItemView   editItemView];
    [self.txtAction initLabel:@"操作类型" withHit:nil];
    [self.container addSubview:self.txtAction];
    
    self.txtPayMoney = [LSEditItemView   editItemView];
    [self.txtPayMoney initLabel:@"充值金额(元)" withHit:nil];
    [self.container addSubview:self.txtPayMoney];
    
    self.txtGiftMoney = [LSEditItemView   editItemView];
    [self.txtGiftMoney initLabel:@"赠送金额(元)" withHit:nil];
    [self.container addSubview:self.txtGiftMoney];
    
    self.txtBalance = [LSEditItemView   editItemView];
    [self.txtBalance initLabel:@"充值后余额(元)" withHit:nil];
    [self.container addSubview:self.txtBalance];
    
    self.txtGiftIntegral = [LSEditItemView   editItemView];
    [self.txtGiftIntegral initLabel:@"赠送积分" withHit:nil];
    [self.container addSubview:self.txtGiftIntegral];
    
    self.txtPayType = [LSEditItemView   editItemView];
    [self.txtPayType initLabel:@"充值方式" withHit:nil];
    [self.container addSubview:self.txtPayType];
    
    self.txtShopName = [LSEditItemView   editItemView];
    [self.txtShopName initLabel:@"充值门店" withHit:nil];
    [self.container addSubview:self.txtShopName];
    
    self.txtPayMode = [LSEditItemView   editItemView];
    [self.txtPayMode initLabel:@"支付方式" withHit:nil];
    [self.container addSubview:self.txtPayMode];
    
    self.txtStaffName = [LSEditItemView   editItemView];
    [self.txtStaffName initLabel:@"操作人" withHit:nil];
    [self.container addSubview:self.txtStaffName];
    
    self.txtTime = [LSEditItemView   editItemView];
    [self.txtTime initLabel:@"时间" withHit:nil];
    [self.container addSubview:self.txtTime];
    if ([[Platform Instance] getShopMode] == 1) {
        [self.txtShopName visibal:NO];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 页面显示数据
- (void)initDataWithMemberRechargeDetailVo:(MemberRechargeDetailVo *)memberRechargeDetailVo {
    [self configTitle:memberRechargeDetailVo.customerName];
    [self.txtCardCode initData:memberRechargeDetailVo.cardCode];
    [self.memberCardType initData:memberRechargeDetailVo.kindCardName];
    [self.txtCustomerName initData:memberRechargeDetailVo.customerName];
    [self.txtMobile initData:memberRechargeDetailVo.mobile];
    [self.txtAction initData:memberRechargeDetailVo.action];
    if ([memberRechargeDetailVo.action isEqualToString:@"红冲"] || [memberRechargeDetailVo.action isEqualToString:@"退卡"]) {
        [self.txtPayMoney initData:[NSString stringWithFormat:@"-%.2f",fabs([memberRechargeDetailVo.payMoney doubleValue])]];
        self.txtPayMoney.lblVal.textColor = [ColorHelper getGreenColor];
        if ([memberRechargeDetailVo.giftMoney doubleValue] == 0.0) {
            [self.txtGiftMoney initData:[NSString stringWithFormat:@"%.2f",[memberRechargeDetailVo.giftMoney doubleValue]]];
        } else {
            double giftMoney = fabs(memberRechargeDetailVo.giftMoney.doubleValue);
            [self.txtGiftMoney initData:[NSString stringWithFormat:@"-%.2f",giftMoney] ];
        }
        if ([memberRechargeDetailVo.giftIntegral doubleValue] == 0.0) {
            [self.txtGiftIntegral initData:[NSString stringWithFormat:@"%@",memberRechargeDetailVo.giftIntegral]];
        } else {
            NSInteger giftIntegral = labs(memberRechargeDetailVo.giftIntegral.integerValue);
            [self.txtGiftIntegral initData:[NSString stringWithFormat:@"-%ld",(long)giftIntegral]];
        }
        self.txtGiftMoney.lblVal.textColor = [ColorHelper getGreenColor];
        self.txtGiftIntegral.lblVal.textColor = [ColorHelper getGreenColor];
        
    } else {
        [self.txtGiftMoney initData:[NSString stringWithFormat:@"%.2f",[memberRechargeDetailVo.giftMoney doubleValue]]];
        [self.txtGiftIntegral initData:[NSString stringWithFormat:@"%@",memberRechargeDetailVo.giftIntegral] ];
        if ([memberRechargeDetailVo.status intValue] == 0) {
            [self.txtPayMoney initData:[NSString stringWithFormat:@"%.2f(已红冲)",[memberRechargeDetailVo.payMoney doubleValue]]];
            self.txtPayMoney.lblVal.textColor = [ColorHelper getRedColor];
            
        } else {
            [self.txtPayMoney initData:[NSString stringWithFormat:@"%.2f",[memberRechargeDetailVo.payMoney doubleValue]]];
             [UIHelper refreshUI:self.container scrollview:self.scrollView];
        }
    }
    
    [self.txtBalance initData:[NSString stringWithFormat:@"%.2f",[memberRechargeDetailVo.balance doubleValue]]];
    [self.txtPayType initData:memberRechargeDetailVo.payType];
    [self.txtShopName initData:memberRechargeDetailVo.shopName];
    [self.txtPayMode initData:memberRechargeDetailVo.payModeName];
    
    if ([ObjectUtil isNotNull:memberRechargeDetailVo.moneyFlowCreatetime]) {
        NSString *time = [DateUtils getTimeStringFromCreaateTime:memberRechargeDetailVo.moneyFlowCreatetime.stringValue format:@"yyyy-MM-dd HH:mm:ss"];
        [self.txtTime initData:time];
    }
    if (![self.txtPayType.lblVal.text isEqualToString:@"微店充值"]) {
        //实体充值沿用原来的逻辑
        if ([NSString isNotBlank:memberRechargeDetailVo.staffName]) {
            // ADMIN 没有工号
            NSString *string = nil;
            if ([memberRechargeDetailVo.staffName isEqualToString:@"ADMIN"]) {
                string = [NSString stringWithFormat:@"%@",memberRechargeDetailVo.staffName];
            }
            else {
                string = [NSString stringWithFormat:@"%@(工号:%@)",memberRechargeDetailVo.staffName,memberRechargeDetailVo.staffId];
            }
            [self.txtStaffName initData:string];
        }
        else {
            [self.txtStaffName initData:@"微店"];
        }
    }else{
        //微店充值
        if (![NSString isNotBlank:memberRechargeDetailVo.staffName]) {
            //无法获取操作人时隐藏操作人
            [self.txtStaffName visibal:NO];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
        }else{
            // ADMIN 没有工号
            NSString *string = nil;
            if ([memberRechargeDetailVo.staffName isEqualToString:@"ADMIN"]) {
                string = [NSString stringWithFormat:@"%@",memberRechargeDetailVo.staffName];
            }
            else {
                string = [NSString stringWithFormat:@"%@(工号:%@)",memberRechargeDetailVo.staffName,memberRechargeDetailVo.staffId];
            }
            [self.txtStaffName initData:string];
        }
    }
}

#pragma mark - 加载数据
- (void)loadData {
    NSString *url = @"RechargeRecord/selectRechargeRecordDetails";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        MemberRechargeDetailVo *memberRechargeDetailVo = [[MemberRechargeDetailVo alloc] initWithDictionary:json[@"rechargeRecordDetailsVo"]];
        [self initDataWithMemberRechargeDetailVo:memberRechargeDetailVo];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


@end
