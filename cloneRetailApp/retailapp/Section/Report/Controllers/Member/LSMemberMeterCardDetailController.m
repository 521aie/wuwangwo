//
//  LSMemberMeterCardDetailController.m
//  retailapp
//
//  Created by wuwangwo on 2017/4/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberMeterCardDetailController.h"
#import "LSMemberMeterCardDetailVo.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "ColorHelper.h"
#import "XHAnimalUtil.h"
#import "NSString+Estimate.h"
#import "LSEditItemView.h"
#import "DateUtils.h"
#import "ObjectUtil.h"

@interface LSMemberMeterCardDetailController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
/**会员名*/
@property (nonatomic, strong) LSEditItemView* memberName;
/** 手机号码*/
@property (nonatomic,strong) LSEditItemView *phoneNum;
/** 会员卡类型*/
@property (nonatomic,strong) LSEditItemView *memberCardType;
/** 会员卡号*/
@property (nonatomic,strong) LSEditItemView *memberCardNum;
/** 计次服务*/
@property (nonatomic,strong) LSEditItemView *meterService;
/** 有效期*/
@property (nonatomic,strong) LSEditItemView *period;
/** 操作类型*/
@property (nonatomic,strong) LSEditItemView *action;
/** 销售金额（元）*/
@property (nonatomic,strong) LSEditItemView *salePrice;
/** 支付方式*/
@property (nonatomic,strong) LSEditItemView *payType;
/** 操作人*/
@property (nonatomic,strong) LSEditItemView *operate;
/** 时间*/
@property (nonatomic,strong) LSEditItemView *actionTime ;
@property (nonatomic,strong) LSMemberMeterCardDetailVo *detailVo;
@end

@implementation LSMemberMeterCardDetailController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self initMainView];
    [self loadData];
}

- (void)configViews {
    
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configTitle:@"计次充值记录" leftPath:Head_ICON_BACK rightPath:nil];
    
    //scollVIew
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
    
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
}

- (void)configContainerViews {
    
    self.memberName = [LSEditItemView editItemView];
    [self.container addSubview:self.memberName];
    
    self.phoneNum = [LSEditItemView editItemView];
    [self.container addSubview:self.phoneNum];
    
    self.memberCardType = [LSEditItemView editItemView];
    [self.container addSubview:self.memberCardType];
    
    self.memberCardNum = [LSEditItemView editItemView];
    [self.container addSubview:self.memberCardNum];
    
    self.meterService = [LSEditItemView editItemView];
    [self.container addSubview:self.meterService];
    
    self.period = [LSEditItemView editItemView];
    [self.container addSubview:self.period];
    
    self.action = [LSEditItemView editItemView];
    [self.container addSubview:self.action];
    
    self.salePrice = [LSEditItemView editItemView];
    [self.container addSubview:self.salePrice];
    
    self.payType = [LSEditItemView editItemView];
    [self.container addSubview:self.payType];
    
    self.operate = [LSEditItemView editItemView];
    [self.container addSubview:self.operate];
    
    self.actionTime = [LSEditItemView editItemView];
    [self.container addSubview:self.actionTime];
}

- (void)initMainView
{
    
    [self.memberName initLabel:@"会员名" withHit:nil];
    [self.phoneNum initLabel:@"手机号码" withHit:nil];
    [self.memberCardType initLabel:@"会员卡类型" withHit:nil];
    [self.memberCardNum initLabel:@"会员卡号" withHit:nil];
    [self.meterService initLabel:@"计次服务" withHit:nil];
    [self.period initLabel:@"有效期" withHit:nil];
    [self.action initLabel:@"操作类型" withHit:nil];
    [self.salePrice initLabel:@"销售金额（元）" withHit:nil];
    [self.payType initLabel:@"支付方式" withHit:nil];
    [self.operate initLabel:@"操作人" withHit:nil];
    [self.actionTime initLabel:@"时间" withHit:nil];
}

- (void)loadData {
    
    NSString *url = @"accountcard/detail";
    __weak typeof(self) wself = self;
    
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:@"" show:YES CompletionHandler:^(id json) {
        
        NSMutableArray *list = json[@"accountRechargeRecordVo"];
        
        if ([ObjectUtil isNotNull:json]) {
            
                wself.detailVo =  [LSMemberMeterCardDetailVo mj_objectWithKeyValues:list];
                [wself initData];
            
        }
        
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        
    } errorHandler:^(id json) {
        
        [LSAlertHelper showAlert:json];
    }];
}

- (void)initData{
    
    __weak typeof(self) wself = self;
    
    if ([NSString isNotBlank:self.detailVo.memberName]) {
        
        [wself.memberName initData:self.detailVo.memberName];
    }
    
    if ([NSString isNotBlank:self.detailVo.phoneNo]) {
        
        [wself.phoneNum initData:[NSString stringWithFormat:@"%@",self.detailVo.phoneNo]];
    }
    
    if ([NSString isNotBlank:self.detailVo.memberType]) {
        
        [wself.memberCardType initData:self.detailVo.memberType];
    }
    
    if ([NSString isNotBlank:self.detailVo.memberNo]) {
        
        [wself.memberCardNum initData:self.detailVo.memberNo];
    }
    
    if ([NSString isNotBlank:self.detailVo.accountCardName]) {
        
        [wself.meterService initData:self.detailVo.accountCardName];
    }
    
    NSString *dateFrom = [DateUtils formateTime5:self.detailVo.startDate.longLongValue];
    NSString *dateTo = [DateUtils formateTime5:self.detailVo.endDate.longLongValue];
    
    if ([NSString isNotBlank:dateFrom] && [NSString isNotBlank:dateTo] ) {
        
        [wself.period initData:[NSString stringWithFormat:@"%@  至 %@",dateFrom,dateTo]];
        
    }else{
        
        [wself.period initData:@"不限期"];
    }
    
    //操作类型(1充值,2支付,3退卡）
    if ([ObjectUtil isNotNull:self.detailVo.action]) {
        
        if ([self.detailVo.action  isEqual: @1]) {
            
            [wself.action initData:@"充值"];
            
        } else if ([self.detailVo.action  isEqual: @2]) {
            
            [wself.action initData:@"支付"];
            
        }else if ([self.detailVo.action  isEqual: @3]) {
            
            [wself.action initData:@"退卡"];
        }
    }
    
    //销售金额
    NSNumber *price = self.detailVo.pay;
    
    if (price.integerValue >= 0) {
        
        wself.salePrice.lblVal.textColor = [ColorHelper getRedColor];
        [wself.salePrice initData:[NSString stringWithFormat:@"%.2f",price.doubleValue]];
        
    } else {
        
        wself.salePrice.lblVal.textColor = [ColorHelper getGreenColor];
        NSMutableString *temp = [NSMutableString stringWithFormat:@"%.2f",price.doubleValue];
        [temp insertString:@"￥" atIndex:1];
        [wself.salePrice initData:temp];
    }
    
    if ([ObjectUtil isNotNull:self.detailVo.payMode]) {
        
        [wself.payType initData: [self getPayModeString:self.detailVo.payMode]];
    }
    
    if ([NSString isNotBlank:self.detailVo.opUserName]) {
        
        NSString *oper = [NSString stringWithFormat:@"%@(%@)",self.detailVo.opUserName,self.detailVo.opUserNo];
        [wself.operate initData:oper];
    }
    
    NSString *creatTime = [DateUtils formateTime:_detailVo.createTime.longLongValue];
    if ([NSString isNotBlank:creatTime]) {
        
        [wself.actionTime initData:creatTime];
    }
}

- (NSString *)getPayModeString:(NSNumber *)status {
    
    //1:会员卡;2:优惠券;3:支付宝;4:支付宝;5:现金;6:微支付;99:其他'
    NSDictionary *statusDic = @{@"1":@"会员卡", @"2":@"优惠券", @"3":@"支付宝", @"4":@"银行卡", @"5":@"现金", @"6":@"微支付", @"99":@"其他",@"8":@"[支付宝]",@"9":@"[微信]",@"50":@"货到付款",@"51":@"手动退款", @"52":@"[QQ钱包]"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%@", status]];
    
    if ([NSString isNotBlank:statusString]) {
        
        return statusString;
        
    } else {
        
        return @"";
    }
}

@end
