//
//  SmsSetController.m
//  retailapp
//
//  Created by wuwangwo on 2017/1/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#define CONFIG_SEND_OPEN_CARD_SMS @"CONFIG_SEND_OPEN_CARD_SMS"
#define CONFIG_SEND_CHARGE_SMS @"CONFIG_SEND_CHARGE_SMS"
#define CONFIG_SEND_DEAL_SMS @"CONFIG_SEND_DEAL_SMS"
#define CONFIG_SEND_CANCEL_CARD_SMS @"CONFIG_SEND_CANCEL_CARD_SMS"
#define CONFIG_SEND_GIVE_DEGREE_SMS @"CONFIG_SEND_GIVE_DEGREE_SMS"
#define CONFIG_SEND_CANCEL_ACCOUNTCARD_SMS @"CONFIG_SEND_CANCEL_ACCOUNTCARD_SMS"

#import "SmsSetController.h"
#import "ItemTitle.h"
#import "LSEditItemRadio.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "LSAlertHelper.h"
#import "ConfigVo.h"
#import "LSEditItemView.h"
#import "SmsRemainNumItem.h"
#import "LSSmsRechargeViewController.h"


@interface SmsSetController ()<IEditItemRadioEvent, ISmsDelegate>
@property (nonatomic, strong)  UIScrollView* scrollView;
@property (nonatomic, strong)  UIView* container;
/**是否开启开卡短信提示*/
@property ( strong, nonatomic)  LSEditItemView *vewCardSms;
@property(nonatomic, strong)  LSEditItemRadio* rdoCardSms;
/**是否开启充值短信*/
@property ( strong, nonatomic)  LSEditItemView *vewPaySms;
@property(nonatomic, strong)  LSEditItemRadio* rdoPaySms;
/**是否开启交易短信*/
@property ( strong, nonatomic)  LSEditItemView *vewTradeSms;
@property(nonatomic, strong)  LSEditItemRadio* rdoTradeSms;
/**是否开启退卡短信*/
@property(nonatomic, strong)  LSEditItemRadio* rdoReturnSms;
@property ( strong, nonatomic)  LSEditItemView *vewReturnSms;
///**是否开启计次服务退款短信*/
@property(nonatomic, strong)  LSEditItemRadio* rdoMeterReturnSms;
@property ( strong, nonatomic)  LSEditItemView *vewMeterReturnSms;
@property ( strong, nonatomic)  LSEditItemRadio *rdoIntegral;
@property ( strong, nonatomic)  LSEditItemView *viewIntegral;

@property (nonatomic,strong) SettingService* service;
/**短信设置项列表*/
@property (nonatomic,strong) NSMutableArray* configVoList;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *telephone;
/**
 *  剩余短信条数
 */
@property (nonatomic, strong) SmsRemainNumItem *lblRemainNum;
@end

@implementation SmsSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.service = [[SettingService alloc] init];
    [self configViews];
    [self initMainView];
    [self loadData];
    [self configHelpButton:HELP_SETTING_SMS_SETTEING];
    [UIHelper clearColor:self.container];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"短信设置" leftPath:Head_ICON_BACK rightPath:nil];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
    
    //开卡短信
    self.rdoCardSms = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoCardSms];
    self.vewCardSms = [LSEditItemView editItemView];
    [self.container addSubview:self.vewCardSms];
    
    //充值短信
    self.rdoPaySms = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoPaySms];
    self.vewPaySms = [LSEditItemView editItemView];
    [self.container addSubview:self.vewPaySms];
    
    //赠分短信
    self.rdoIntegral = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoIntegral];
    self.viewIntegral = [LSEditItemView editItemView];
    [self.container addSubview:self.viewIntegral];
    
    //交易短信
    self.rdoTradeSms = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoTradeSms];
    self.vewTradeSms = [LSEditItemView editItemView];
    [self.container addSubview:self.vewTradeSms];
    
    //退卡短信
    self.rdoReturnSms = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoReturnSms];
    self.vewReturnSms = [LSEditItemView editItemView];
    [self.container addSubview:self.vewReturnSms];
    
    //计次服务退款短信
    self.rdoMeterReturnSms = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoMeterReturnSms];
    self.vewMeterReturnSms = [LSEditItemView editItemView];
    [self.container addSubview:self.vewMeterReturnSms];
}


#pragma mark - 初始化主视图
- (void)initMainView
{
    self.lblRemainNum = [SmsRemainNumItem smsRetainNumItem];
    [self.lblRemainNum initLabel:@"剩余短信条数" withHit:nil delegate:self];
    if ([[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"]) {//只有总部用户显示充值按钮
        [self.lblRemainNum showChargeBtn:YES];
    } else {
        [self.lblRemainNum showChargeBtn:NO];
    }
    [self.container insertSubview:self.lblRemainNum atIndex:0];
    [self.rdoCardSms initLabel:@"开卡短信" withHit:nil delegate:self];
    [self.rdoPaySms initLabel:@"充值短信" withHit:nil delegate:self];
    [self.rdoIntegral initLabel:@"赠分短信" withHit:nil delegate:self];
    [self.rdoTradeSms initLabel:@"交易短信" withHit:nil delegate:self];
    [self.rdoReturnSms initLabel:@"退卡短信" withHit:nil delegate:self];
    [self.rdoMeterReturnSms initLabel:@"计次服务退款短信" withHit:nil delegate:self];
    
    [self refreshUI];
}

- (void)refreshUI {
    [self.vewCardSms visibal:[self.rdoCardSms getVal]];
    if ([NSString isBlank:self.shopName]) {
        self.shopName = @"";
    }
    if ([NSString isBlank:self.telephone]) {
        self.telephone = @"";
    }
    
    NSString *strCardSms = [NSString stringWithFormat:@"【二维火】尊敬的{会员姓名}，您好！欢迎您成为我店会员。如有疑问请咨询%@<%@>",self.telephone, self.shopName];
    [self.vewCardSms initLabel:@"▪︎ 短信预览" withHit:strCardSms];
    
    NSString *strPaySms = nil;
    NSString *strTradeSms = nil;
    
    if ([[Platform Instance] getShopMode] != 1 && [[[Platform Instance] getkey:SHOP_MODE] intValue] == 102
) {
        
        strPaySms = [NSString stringWithFormat:@"储值充值短信：\n【二维火】您的会员卡充值成功，充值金额{充值金额}元，当前余额{卡内余额}元。如有疑问请咨询%@<%@>",self.telephone, self.shopName];
        
        strTradeSms = [NSString stringWithFormat:@"储值消费短信：\n【二维火】您的会员卡本次消费了{消费金额}元，当前余额{卡内余额}元。如有疑问请咨询%@<%@>\n\n储值退款短信：\n【二维火】您的会员卡本次退款{退款金额}元，当前余额{卡内余额}元。如有疑问请咨询%@<%@>",self.telephone, self.shopName, self.telephone, self.shopName];
        
        [self.vewMeterReturnSms visibal:NO];
        [self.rdoMeterReturnSms visibal:NO];
    } else {
        
        strPaySms = [NSString stringWithFormat:@"储值充值短信：\n【二维火】您的会员卡充值成功，充值金额{充值金额}元，当前余额{卡内余额}元。如有疑问请咨询%@<%@>\n\n计次充值短信：\n【二维火】您已成功充值计次服务：{计次服务名称}，有效期{开始日期}至{结束日期}。如有疑问请咨询%@<%@>",self.telephone, self.shopName,self.telephone, self.shopName];
        
        strTradeSms = [NSString stringWithFormat:@"储值消费短信：\n【二维火】您的会员卡本次消费了{消费金额}元，当前余额{卡内余额}元。如有疑问请咨询%@<%@>\n\n储值退款短信：\n【二维火】您的会员卡本次退款{退款金额}元，当前余额{卡内余额}元。如有疑问请咨询%@<%@>\n\n计次消费短信：\n【二维火】您的会员卡本次消费了计次服务：{计次商品名称}（等多项），共计消费{消费计次商品数量}次。如有疑问请咨询%@<%@>",self.telephone, self.shopName, self.telephone, self.shopName, self.telephone, self.shopName];
    }
    [self.vewPaySms initLabel:@"▪︎ 短信预览" withHit:strPaySms];
    [self.vewPaySms visibal:[self.rdoPaySms getVal]];
    
    NSString *strIntegral = [NSString stringWithFormat:@"【二维火】尊敬的{会员姓名} : 您已获赠卡积分**分，积分余额为**分。如有疑问请咨询%@<%@>" ,self.telephone,self.shopName];
    [self.viewIntegral initLabel:@"▪︎ 短信预览" withHit:strIntegral];
    [self.viewIntegral visibal:[self.rdoIntegral getVal]];
    
    [self.vewTradeSms initLabel:@"▪︎ 短信预览" withHit:strTradeSms];
    [self.vewTradeSms visibal:[self.rdoTradeSms getVal]];
    
    NSString *strReturnSms = [NSString stringWithFormat:@"【二维火】尊敬的{会员姓名}，您好！您已成功退卡！原卡内余额{卡内余额}元，实退{实退金额}元，会员卡内余额已清零。如有疑问请咨询%@<%@>",self.telephone, self.shopName];
    [self.vewReturnSms initLabel:@"▪︎ 短信预览" withHit:strReturnSms];
    [self.vewReturnSms visibal:[self.rdoReturnSms getVal]];
    
    NSString *strMeterReturnSms = [NSString stringWithFormat:@"【二维火】尊敬的{会员姓名}，您好！您的计次服务：{计次服务名称}已成功退款！实退{实退金额}元。如有疑问请咨询%@<%@>",self.telephone, self.shopName];
    [self.vewMeterReturnSms initLabel:@"▪︎ 短信预览" withHit:strMeterReturnSms];
    [self.vewMeterReturnSms visibal:[self.rdoMeterReturnSms getVal]];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - INavigateEvent协议
//页面返回及保存设置
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

#pragma mark - 注册UI变化通知
- (void)registerNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification*)notification
{
    [self editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 加载网络数据
- (void)loadData
{
    [self registerNotification];
    NSMutableArray* configCodeList = [NSMutableArray arrayWithObjects:CONFIG_SEND_OPEN_CARD_SMS,CONFIG_SEND_CANCEL_CARD_SMS,CONFIG_SEND_CHARGE_SMS,CONFIG_SEND_DEAL_SMS, CONFIG_SEND_GIVE_DEGREE_SMS,CONFIG_SEND_CANCEL_ACCOUNTCARD_SMS, nil];
    
    __weak typeof(self) weakSelf = self;
    [_service acquireSmsSettingDetail:configCodeList completionHandler:^(id json) {
        weakSelf.configVoList = [ConfigVo converToArr:[json objectForKey:@"configVoList"]];
        for (ConfigVo* configVo in weakSelf.configVoList) {
            //开卡短信开关 |1 开|2 关|
            if ([configVo.code isEqualToString:CONFIG_SEND_OPEN_CARD_SMS]) {
                [weakSelf.rdoCardSms initData:[@"2" isEqualToString:configVo.value]?@"0":configVo.value];
            }
            //充值短信开关 |1 开|2 关|
            if ([configVo.code isEqualToString:CONFIG_SEND_CHARGE_SMS]) {
                [weakSelf.rdoPaySms initData:[@"2" isEqualToString:configVo.value]?@"0":configVo.value];
            }
            //交易短信开关 |1 开|2 关|
            if ([configVo.code isEqualToString:CONFIG_SEND_DEAL_SMS]) {
                [weakSelf.rdoTradeSms initData:[@"2" isEqualToString:configVo.value]?@"0":configVo.value];
            }
            //退卡短信开关 |1 开|2 关|
            if ([configVo.code isEqualToString:CONFIG_SEND_CANCEL_CARD_SMS]) {
                [weakSelf.rdoReturnSms initData:[@"2" isEqualToString:configVo.value]?@"0":configVo.value];
            }
            //赠分短信开关 |1 开| 2关
            if ([configVo.code isEqualToString:CONFIG_SEND_GIVE_DEGREE_SMS]) {
                [weakSelf.rdoIntegral initData:[@"2" isEqualToString:configVo.value]?@"0":configVo.value];
            }
            //计次服务退款短信开关 |1 开| 2关
            if ([configVo.code isEqualToString:CONFIG_SEND_CANCEL_ACCOUNTCARD_SMS]) {
                [weakSelf.rdoMeterReturnSms initData:[@"2" isEqualToString:configVo.value]?@"0":configVo.value];
            }
        }
    
        [weakSelf refreshUI];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
    //加载剩余短信数量
    NSString *url = @"sms/smsNumber";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@1 forKey:@"needShopInfo"];
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        int number = [json[@"number"] intValue];
        weakSelf.telephone = json[@"telephone"];
        [wself.lblRemainNum initData:[NSString stringWithFormat:@"%d条", number] withVal:[NSString stringWithFormat:@"%d", number]];
        weakSelf.shopName = json[@"shopName"];
        [weakSelf refreshUI];
        //如果号码不存在或者该号码是固话则提示错误
        if ([NSString isBlank:weakSelf.telephone] || [weakSelf validateTelphone:weakSelf.telephone]) {
            // 打开短信提醒需先有店铺手机号
            [LSAlertHelper showAlert:@"提示" message:@"请先前往［营业］-［店家信息］完善手机号码，否则短信将无法正常发送！" cancle:@"我知道了" block:^{
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [weakSelf.navigationController popViewControllerAnimated:NO];
                //                    [weakSelf popToLatestViewController:kCATransitionFromLeft];
            }];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

//判断是否是固定电话
- (BOOL) validateTelphone:(NSString *)telphone
{
    NSString *phoneRegex = @"\\d{3}-\\d{8}|\\d{4}-\\d{7,8}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:telphone];
}

- (void)onItemRadioClick:(id)obj {
    [self refreshUI];
}

#pragma mark ISmsDelegate
//前往短信充值页面
- (void)startCharge:(int)remainNum {
    LSSmsRechargeViewController *vc = [[LSSmsRechargeViewController alloc] init];
    vc.smsCount = remainNum;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma mark - 保存短信设置
- (void)save
{
    for (ConfigVo* configVo in self.configVoList) {
        if ([configVo.code isEqualToString:CONFIG_SEND_OPEN_CARD_SMS]) {
            configVo.value = [self.rdoCardSms getVal]?@"1":@"2";
        }
        if ([configVo.code isEqualToString:CONFIG_SEND_CHARGE_SMS]) {
            configVo.value = [self.rdoPaySms getVal]?@"1":@"2";
        }
        if ([configVo.code isEqualToString:CONFIG_SEND_DEAL_SMS]) {
            configVo.value = [self.rdoTradeSms getVal]?@"1":@"2";
        }
        if ([configVo.code isEqualToString:CONFIG_SEND_CANCEL_CARD_SMS]) {
            configVo.value = [self.rdoReturnSms getVal]?@"1":@"2";
        }
        if ([configVo.code isEqualToString:CONFIG_SEND_GIVE_DEGREE_SMS]) {
            configVo.value = [self.rdoIntegral getVal]?@"1":@"2";
        }
        if ([configVo.code isEqualToString:CONFIG_SEND_CANCEL_ACCOUNTCARD_SMS]) {
            configVo.value = [self.rdoMeterReturnSms getVal]?@"1":@"2";
        }
    }
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:self.configVoList.count];
    for (ConfigVo* configVo in self.configVoList) {
        [arr addObject:[ConfigVo converToDic:configVo]];
    }
    
    __weak __typeof(self) weakSelf =self;
    [_service updateSmsSetting:arr completionHandler:^(id json) {
        [weakSelf removeNotification];
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

@end
