//
//  LSBrithdayReminderViewController.m
//  retailapp
//
//  Created by guozhi on 16/9/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#define TAG_LST_SEND_TIME 1
#define TAG_LST_AHEAD_OF_TIME 2
#define TAG_LST_SMS_DEMO 3
#import "LSBrithdayReminderViewController.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "SmsRemainNumItem.h"
#import "LSSmsRechargeViewController.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "EditItemList.h"
#import "ObjectUtil.h"
#import "OptionPickerBox.h"
#import "LSSmsTemplateViewController.h"
#import "EditItemRadio.h"
#import "NameItemVO.h"
#import "DateUtils.h"
#import "TimePickerBox.h"
@interface LSBrithdayReminderViewController ()<INavigateEvent, ISmsDelegate, IEditItemListEvent, OptionPickerClient, IEditItemRadioEvent, TimePickerClient>
/**
 *  标题栏
 */
@property (nonatomic, strong) NavigateTitle2 *navigateTitle;
/**
 *  剩余短信条数
 */
@property (nonatomic, strong) SmsRemainNumItem *lblRemainNum;
/**
 *  可滚动
 */
@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  容器
 */
@property (nonatomic, strong) UIView *container;
/**
 *  短信模板
 */
@property (nonatomic, strong) EditItemList *lstSmsDemo;
/**
 *  短信预览标签
 */
@property (nonatomic, strong) UILabel *lblSms;
/**
 *  开启生日祝福
 */
@property (nonatomic, strong) EditItemRadio *rdoBirthdayAlert;
/**
 *  会员生日提前几天发送短信
 */
@property (nonatomic, strong) EditItemList *lstAheadOfTime;
/**
 *  发送时间
 */
@property (nonatomic, strong) EditItemList *lstSendTime;
/**
 *  短信内容
 */
@property (nonatomic, strong) UITextView *textViewSms;

/**
 *  当前操作的模板对象
 */
@property (nonatomic, strong) SmsTemplateVo *smsTemplateVo;
/**
 *
 */
@property (nonatomic, copy) NSString *strText;
/**
 *
 */
@property (nonatomic, copy) NSString *strMemo;
/**
 *  1：开启 2：关闭
 */
@property (nonatomic, assign) short status;
/**
 *  开启才返回
 */
@property (nonatomic, assign) short aheadDays;
/**
 *  发送时间 开启才返回
 */
@property (nonatomic, copy) NSString *sendTime;
/**
 *  短信模板名code开启才返回  以前的数据可能为空
 */
@property (nonatomic, copy) NSString *code;
/**
 *  短信模板名字 开启才返回  以前的数据可能为空
 */
@property (nonatomic, copy) NSString *templateName;
/**
 *  内容  以前的数据可能为空
 */
@property (nonatomic, copy) NSString *content;
/**
 *  提前天数数据源
 */
@property (nonatomic, strong) NSMutableArray *itemDays;
/** <#注释#> */
@property (nonatomic, copy) NSString *params;

@end

@implementation LSBrithdayReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    [self initNotification];
     [self loadData];
    
    [self configHelpButton:HELP_MEMBER_BIRTHDAY_ALERTING];
}

#pragma mark 获得剩余短信数量 生日提醒查询
- (void)loadData {
    NSString *url = @"sms/smsNumber";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
        int number = [json[@"number"] intValue];
        [wself.lblRemainNum initData:[NSString stringWithFormat:@"%d条", number] withVal:[NSString stringWithFormat:@"%d", number]];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    url = @"sms/v2/birthdayNotify";
    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:NO CompletionHandler:^(id json) {
        wself.status = [json[@"status"] shortValue];//1：开启 2：只有开启时下面的才有可能有值
        if (wself.status == 1) {
            wself.aheadDays = [json[@"aheadDays"] shortValue];
            wself.sendTime = json[@"sendTime"];
            wself.templateName = json[@"templateName"];
            wself.code = json[@"code"];
            wself.params = json[@"params"];
            wself.content = json[@"showContent"];
            if ([NSString isNotBlank:wself.content]) {
                wself.content = [NSString stringWithFormat:@"【二维火】%@", wself.content];
            }
            [wself fillData];
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

#pragma mark 填充数据
- (void)fillData {
    [self.rdoBirthdayAlert initData:[NSString stringWithFormat:@"%d", self.status]];
    if (self.status == 1) {
        for (NameItemVO *itemVo in self.itemDays) {
            if ([[itemVo obtainItemId] isEqualToString:[NSString stringWithFormat:@"%d", self.aheadDays]]) {
                //会员提前天数
                [self.lstAheadOfTime initData:[itemVo obtainItemName] withVal:[itemVo obtainItemId]];
                break;
            }
        }
        //发送时间
        NSString *sendTime = [self.sendTime substringToIndex:5];
        [self.lstSendTime initData:sendTime withVal:sendTime];
        
        //短信模板
        [self.lstSmsDemo initData:self.templateName withVal:self.code];
        //短信内容
        if ([NSString isNotBlank:self.content]) {
            self.textViewSms.text = self.content;
            self.textViewSms.textColor = [UIColor blackColor];
        }
        
    }
    
    [self refreshUI];
    
}
#pragma mark - 初始化通知
- (void)initNotification {
    NSString *event = @"Notification_UI_BIRTHDAY_VIEW_Change";
    [UIHelper initNotification:self.container event:event];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:event object:nil];
}

#pragma mark - 页面里面的值改变时调用
- (void)dataChange:(NSNotification *)notification {
    [self.navigateTitle editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}
#pragma mark - delegate
#pragma mark INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self save];
    }
    
}

- (void)save {
    if ([NSString isBlank:[self.lstSmsDemo getStrVal]]) {
        [AlertBox show:@"请选择短信模板！"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([self.rdoBirthdayAlert getVal]) {
        [param setValue:@1 forKey:@"status"];
        int aheadDays = [[self.lstAheadOfTime getStrVal] intValue];
        [param setValue:@(aheadDays) forKey:@"aheadDays"];
        if ([NSString isNotBlank:self.smsTemplateVo.code]) {
            [param setValue:self.smsTemplateVo.code forKey:@"code"];
        } else {
            [param setValue:self.code forKey:@"code"];
        }
        if ([NSString isNotBlank:self.smsTemplateVo.fields.mj_JSONString]) {
            [param setValue:self.smsTemplateVo.fields.mj_JSONString forKey:@"params"];
        } else {
            [param setValue:self.params forKey:@"params"];
        }
        [param setValue:[self.lstSendTime getDataLabel] forKey:@"sendTime"];
    } else {
        [param setValue:@2 forKey:@"status"];
    }
    __weak typeof(self) wself = self;
    NSString *url = @"sms/v2/saveBirthdayNotify";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [wself.navigationController popViewControllerAnimated:NO];
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

#pragma mark IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj {
    if (obj == self.lstSmsDemo) {//短信模板
        LSSmsTemplateViewController *vc = [[LSSmsTemplateViewController alloc] init];
        vc.smsCode = [self.lstSmsDemo getStrVal];
        vc.strText = self.strText;
        vc.strMemo = self.strMemo;
        vc.type = 3;
        __weak typeof(self) wself = self;
        [vc getSelectInfo:^(NSString *smsContext, SmsTemplateVo *smsTemplateVo, NSString *strText, NSString *strMemo) {
            wself.textViewSms.text = smsContext;
            [wself.lstSmsDemo changeData:smsTemplateVo.title withVal:smsTemplateVo.code];
            wself.textViewSms.textColor = [UIColor blackColor];
            wself.smsTemplateVo = smsTemplateVo;
            if (![wself.content isEqualToString:smsContext]) {//改变内容时也要显示改变标签
                wself.lstSmsDemo.oldVal = @"0";
                [wself.lstSmsDemo isChange];
            }
            wself.strMemo = strMemo;
            wself.strText = strText;
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    } else if (obj == self.lstAheadOfTime) {
        [OptionPickerBox initData:self.itemDays itemId:[obj getStrVal]];
        [OptionPickerBox show:[obj.lblName.text substringFromIndex:3] client:self event:obj.tag];
    } else if (obj == self.lstSendTime) {
        NSDate *date=[DateUtils parseDateTime6:[obj getStrVal]];
        [TimePickerBox show:[obj.lblName.text substringFromIndex:3] date:date client:self event:obj.tag];
    }
}

#pragma mark IEditItemRadioEvent 
- (void)onItemRadioClick:(id)obj {
    if (obj == self.rdoBirthdayAlert) {
        [self refreshUI];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
     id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_AHEAD_OF_TIME) {
        [self.lstAheadOfTime changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

#pragma mark TimePickerClient
- (BOOL)pickTime:(NSDate *)date event:(NSInteger)event {
    NSString* timeStr=[DateUtils formateChineseTime:date];
    if (event == TAG_LST_SEND_TIME) {
        [self.lstSendTime changeData:timeStr withVal:timeStr];
    }
    return YES;
}

#pragma mark ISmsDelegate
//前往短信充值页面
- (void)startCharge:(int)remainNum {
    LSSmsRechargeViewController *vc = [[LSSmsRechargeViewController alloc] init];
    vc.smsCount = remainNum;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma mark - setup
#pragma mark - 初始化页面
- (void)initMainView {
    //标题栏
    self.navigateTitle = [NavigateTitle2 navigateTitle:self];
    [self.navigateTitle initWithName:@"生日提醒" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.navigateTitle];
    //滚动区域
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = self.navigateTitle.ls_height;
    CGFloat scrollViewW = self.view.ls_width;
    CGFloat scrollViewH = self.view.ls_height - self.navigateTitle.ls_height;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH)];
    self.scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.scrollView];
    
    //容器
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    //剩余短信条数
    self.lblRemainNum = [SmsRemainNumItem smsRetainNumItem];
    [self.lblRemainNum initLabel:@"剩余短信条数" withHit:nil delegate:self];
    [self.container addSubview:self.lblRemainNum];
    if ([[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"]) {//只有总部用户显示充值按钮
        [self.lblRemainNum showChargeBtn:YES];
    } else {
        [self.lblRemainNum showChargeBtn:NO];
    }
    
    //开启生日祝福
    self.rdoBirthdayAlert = [EditItemRadio itemRadio];
    [self.rdoBirthdayAlert initLabel:@"开启生日祝福" withHit:nil delegate:self];
     [self.rdoBirthdayAlert initData:@"0"];
    [self.container addSubview:self.rdoBirthdayAlert];
    
    //会员生日提前几天发送短信
    self.lstAheadOfTime = [EditItemList editItemList];
    [self.lstAheadOfTime initLabel:@"▪︎ 会员生日提前几天发送短信" withHit:nil delegate:self];
    [self.lstAheadOfTime initData:@"当天" withVal:@"0"];
    self.lstAheadOfTime.tag = TAG_LST_AHEAD_OF_TIME;
    [self.container addSubview:self.lstAheadOfTime];
    
    //发送时间
    self.lstSendTime = [EditItemList editItemList];
    [self.lstSendTime initLabel:@"▪︎ 发送时间" withHit:nil delegate:self];
    self.lstSendTime.tag = TAG_LST_SEND_TIME;
    [self.lstSendTime initData:@"09:00" withVal:@"09:00"];
    [self.container addSubview:self.lstSendTime];
    
    //短信模板
    self.lstSmsDemo = [EditItemList editItemList];
    [self.lstSmsDemo initLabel:@"▪︎ 短信模板" withHit:nil isrequest:YES delegate:self];
    self.lstSmsDemo.tag = TAG_LST_SMS_DEMO;
    NSString *attr = @"必选";
    UIColor *color = [UIColor redColor];
    self.lstSmsDemo.lblVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:attr attributes:@{NSForegroundColorAttributeName:color}];;
    self.lstSmsDemo.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [self.container addSubview:self.lstSmsDemo];
    
    //短信预览标签
    CGFloat margin = 10;
    CGFloat lblSmsX = margin;
    CGFloat lblSmsY = 0;
    CGFloat lblSmsW = self.view.ls_width - 2*margin;
    CGFloat lblSmsH = 48;
    self.lblSms = [[UILabel alloc] initWithFrame:CGRectMake(lblSmsX, lblSmsY, lblSmsW, lblSmsH)];
    self.lblSms.textColor = [UIColor blackColor];
    self.lblSms.font = [UIFont systemFontOfSize:15];
    _lblSms.text = @"▪︎ 短信预览";
    [self.container addSubview:self.lblSms];
    
    //短信内容预览
    CGFloat textViewSmsX = margin;
    CGFloat textViewSmsY = 0;
    CGFloat textViewSmsW = self.view.ls_width - 2*margin;
    CGFloat textViewSmsH = 150;
    self.textViewSms = [[UITextView alloc] initWithFrame:CGRectMake(textViewSmsX, textViewSmsY, textViewSmsW, textViewSmsH)];
    self.textViewSms.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    self.textViewSms.editable = NO;
    self.textViewSms.layer.cornerRadius = 5;
    [self.container addSubview:self.textViewSms];
    NSMutableParagraphStyle* linebreak = [[NSMutableParagraphStyle alloc]init];
    linebreak.lineBreakMode = NSLineBreakByCharWrapping;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"请选择短信模板！" attributes:@{NSParagraphStyleAttributeName:linebreak}];
    self.textViewSms.attributedText = attrStr;
    self.textViewSms.textColor = [UIColor lightGrayColor];
    self.textViewSms.font = [UIFont systemFontOfSize:15];
        
    [self refreshUI];
    
}

- (void)refreshUI {
    BOOL isShow = [self.rdoBirthdayAlert getVal];
    [self.lstAheadOfTime visibal:isShow];
    [self.lstSendTime visibal:isShow];
    [self.lstSmsDemo visibal:isShow];
    self.lblSms.hidden = !isShow;
    self.textViewSms.hidden = !isShow;
    //刷新页面
    [UIHelper refreshUI:self.container scrollview:self.scrollView];

    
    
}

- (NSMutableArray *)itemDays {
    if (!_itemDays) {
        _itemDays = [NSMutableArray array];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:@"当天" andId:@"0"];
        [_itemDays addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"1天" andId:@"1"];
        [_itemDays addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"7天" andId:@"7"];
        [_itemDays addObject:item];
    }
    return _itemDays;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
