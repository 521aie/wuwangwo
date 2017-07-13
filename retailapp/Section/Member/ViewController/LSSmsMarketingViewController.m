//
//  LSSmsMarketingViewController.m
//  retailapp
//
//  Created by guozhi on 16/9/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_CARD_TYPE 1
#define TAG_LST_BIRTHDAY_MEMBER 2
#define TAG_LST_SMS_DEMO 3
#import "LSSmsMarketingViewController.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "SmsRemainNumItem.h"
#import "LSSmsRechargeViewController.h"
#import "AlertBox.h"
#import "EditItemList.h"
#import "NameItemVO.h"
#import "ObjectUtil.h"
#import "OptionPickerBox.h"
#import "LSSmsTemplateViewController.h"
#import "DateUtils.h"
#import "Platform.h"

@interface LSSmsMarketingViewController ()<INavigateEvent, ISmsDelegate, IEditItemListEvent, OptionPickerClient>
/**
 *  标题栏
 */
@property (nonatomic, strong) NavigateTitle2 *navigateTitle;
/**
 *  剩余短信条数
 */
@property (nonatomic, strong) SmsRemainNumItem *lblRemainNum;
/**
 *  卡类型
 */
//@property (nonatomic, strong) EditItemList *lstCardType;
/**
 *  生日会员
 */
@property (nonatomic, strong) EditItemList *lstBirthdayMember;
/**
 *  短信模板
 */
@property (nonatomic, strong) EditItemList *lstSmsDemo;
/**
 *  短信预览标签
 */
@property (nonatomic, strong) UILabel *lblSms;
/**
 *  短信内容
 */
@property (nonatomic, strong) UITextView *textViewSms;
/**
 *  发送按钮
 */
@property (nonatomic, strong) UIButton *btnSend;
/**
 *  可滚动
 */
@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  记录会员卡类型列表
 */
@property (nonatomic, strong) NSMutableArray *memberCardList;
/**
 *  生日会员时间列表
 */
@property (nonatomic, strong) NSMutableArray *dateList;
/**
 *  短信发送参数
 */
@property (nonatomic, strong) NSMutableDictionary *param;
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

@end

@implementation LSSmsMarketingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self configHelpButton:HELP_MEMBER_SMS_MARKET];
//    [self loadMemberCardList];
    // Do any additional setup after loading the view.
}
#pragma mark - 网络请求
#pragma mark 获得剩余短信数量
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)loadData {
    NSString *url = @"sms/smsNumber";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:@{@"needShopInfo":@(1)} withMessage:nil show:YES CompletionHandler:^(id json) {
        int number = [json[@"number"] intValue];
        [wself.lblRemainNum initData:[NSString stringWithFormat:@"%d条", number] withVal:[NSString stringWithFormat:@"%d", number]];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

//#pragma mark 获得卡类型列表
//- (void)loadMemberCardList {
//    NSString *url = @"kindCard/v1/list";
//    __weak typeof(self) wself = self;
//    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:NO CompletionHandler:^(id json) {
//        wself.memberCardList = [NSMutableArray array];
//        NameItemVO *item =[[NameItemVO alloc] initWithVal:@"全部" andId:nil];
//        [wself.memberCardList addObject:item];
//        NSMutableArray *kindCardList = json[@"kindCardList"];
//        if ([ObjectUtil isNotNull:kindCardList]) {
//            for (NSDictionary *dict in kindCardList) {
//                item = [[NameItemVO alloc] initWithVal:dict[@"kindCardName"] andId:dict[@"kindCardId"]];
//                [wself.memberCardList addObject:item];
//            }
//        }
//    } errorHandler:^(id json) {
//        [AlertBox show:json];
//    }];
//}

#pragma mark - 短信发送点击事件
- (void)btnClick:(UIButton *)btn {
    if ([NSString isBlank:[self.lstSmsDemo getStrVal]]) {
        [AlertBox show:@"请选择短信模板！"];
        return;
    }
    //短信发送
    NSString *url = @"sms/v3/send";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [AlertBox show:@"短信发送成功！"];
        [wself loadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}
#pragma mark - delegate
#pragma mark INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }

}

#pragma mark IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj {
//    if (obj == self.lstCardType) {//卡类型
//        [OptionPickerBox initData:self.memberCardList itemId:[obj getStrVal]];
//        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
//    } else
    if (obj == self.lstBirthdayMember) {//生日会员
        [OptionPickerBox initData:self.dateList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.lstSmsDemo) {//短信模板
        LSSmsTemplateViewController *vc = [[LSSmsTemplateViewController alloc] init];
        vc.smsCode= self.smsTemplateVo.code;
        vc.strText = self.strText;
        vc.strMemo = self.strMemo;
        vc.type = 1;
        __weak typeof(self) wself = self;
        [vc getSelectInfo:^(NSString *smsContext, SmsTemplateVo *smsTemplateVo, NSString *strText, NSString *strMemo) {
            wself.textViewSms.text = smsContext;
            [wself.lstSmsDemo initData:smsTemplateVo.title withVal:smsTemplateVo.code];
            wself.textViewSms.textColor = [UIColor blackColor];
            wself.smsTemplateVo = smsTemplateVo;
            wself.strMemo = strMemo;
            wself.strText = strText;
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
//    if (eventType == TAG_LST_CARD_TYPE) {
//        [self.lstCardType initData:[item obtainItemName] withVal:[item obtainItemId]];
//    } else
    if (eventType == TAG_LST_BIRTHDAY_MEMBER) {
         [self.lstBirthdayMember initData:[item obtainItemName] withVal:[item obtainItemId]];
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
//布局方式
- (void)setup {
    CGFloat y = 0;
    //剩余短信条数
    self.lblRemainNum.ls_top = y;
    y = y + self.lblRemainNum.ls_height;
//    卡类型
//    self.lstCardType.ls_top = y;
//    y = y + self.lstCardType.ls_height;
    //生日会员
    self.lstBirthdayMember.ls_top = y;
    y = y + self.lstBirthdayMember.ls_height;
    //短信模板
    self.lstSmsDemo.ls_top = y;
    y = y + self.lstSmsDemo.ls_height;
    //短信预览标签
    self.lblSms.ls_top = y;
    y = y + self.lblSms.ls_height;
    //短信预览
    self.textViewSms.ls_top = y;
    y = y + self.textViewSms.ls_height;
    //发送按钮
    y = y + 10;
    self.btnSend.ls_top = y;
    y = y + self.btnSend.ls_height;
    CGFloat contentSizeH = (self.scrollView.ls_height > y ? self.scrollView.ls_height : y) + 44;
    self.scrollView.contentSize = CGSizeMake(0, contentSizeH);
    
}
#pragma mark - setters and getters
#pragma mark 标题栏
- (NavigateTitle2 *)navigateTitle {
    if (!_navigateTitle) {
        _navigateTitle = [NavigateTitle2 navigateTitle:self];
        [_navigateTitle initWithName:@"短信营销" backImg:Head_ICON_BACK moreImg:nil];
        [self.view addSubview:_navigateTitle];
    }
    return _navigateTitle;
}
#pragma mark 剩余短信条数
- (SmsRemainNumItem *)lblRemainNum {
    if (!_lblRemainNum) {
        _lblRemainNum = [SmsRemainNumItem smsRetainNumItem];
        [_lblRemainNum initLabel:@"剩余短信条数" withHit:nil delegate:self];
        [self.scrollView addSubview:_lblRemainNum];
        if ([[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"]) {//只有总部用户显示充值按钮
            [_lblRemainNum showChargeBtn:YES];
        } else {
            [_lblRemainNum showChargeBtn:NO];
        }
    }
    return _lblRemainNum;
}

#pragma mark 卡类型
//- (EditItemList *)lstCardType {
//    if (!_lstCardType) {
//        _lstCardType = [EditItemList editItemList];
//        [_lstCardType initLabel:@"卡类型" withHit:nil delegate:self];
//        [_lstCardType initData:@"全部" withVal:nil];
//        _lstCardType.tag = TAG_LST_CARD_TYPE;
//        [self.scrollView addSubview:_lstCardType];
//    }
//    return _lstCardType;
//}

#pragma mark 生日会员
- (EditItemList *)lstBirthdayMember {
    if (!_lstBirthdayMember) {
        _lstBirthdayMember = [EditItemList editItemList];
        [_lstBirthdayMember initLabel:@"生日会员" withHit:nil delegate:self];
        [_lstBirthdayMember initData:@"全部" withVal:nil];
        _lstBirthdayMember.tag = TAG_LST_BIRTHDAY_MEMBER;
        [self.scrollView addSubview:_lstBirthdayMember];
    }
    return _lstBirthdayMember;
}

#pragma mark 短信模板
- (EditItemList *)lstSmsDemo {
    if (!_lstSmsDemo) {
        _lstSmsDemo = [EditItemList editItemList];
        [_lstSmsDemo initLabel:@"短信模板" withHit:nil isrequest:YES delegate:self];
        _lstSmsDemo.tag = TAG_LST_SMS_DEMO;
        NSString *attr = @"必选";
        UIColor *color = [UIColor redColor];
        _lstSmsDemo.lblVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:attr attributes:@{NSForegroundColorAttributeName:color}];;
        _lstSmsDemo.imgMore.image = [UIImage imageNamed:@"ico_next"];
        [self.scrollView addSubview:_lstSmsDemo];
    }
    return _lstSmsDemo;
}
#pragma mark 短信预览标签
- (UILabel *)lblSms {
    if (!_lblSms) {
        CGFloat margin = 10;
        CGFloat lblSmsX = margin;
        CGFloat lblSmsY = 0;
        CGFloat lblSmsW = self.view.ls_width - 2*margin;
        CGFloat lblSmsH = 48;
        _lblSms = [[UILabel alloc] initWithFrame:CGRectMake(lblSmsX, lblSmsY, lblSmsW, lblSmsH)];
        _lblSms.textColor = [UIColor blackColor];
        _lblSms.font = [UIFont systemFontOfSize:15];
        _lblSms.text = @"短信预览";
        [self.scrollView addSubview:_lblSms];
        
    }
    return _lblSms;
}

#pragma mark 短信内容预览
- (UITextView *)textViewSms {
    if (!_textViewSms) {
        CGFloat margin = 10;
        CGFloat textViewSmsX = margin;
        CGFloat textViewSmsY = 0;
        CGFloat textViewSmsW = self.view.ls_width - 2*margin;
        CGFloat textViewSmsH = 150;
        _textViewSms = [[UITextView alloc] initWithFrame:CGRectMake(textViewSmsX, textViewSmsY, textViewSmsW, textViewSmsH)];
        _textViewSms.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        _textViewSms.editable = NO;
        _textViewSms.layer.cornerRadius = 5;
        [self.scrollView addSubview:_textViewSms];
        NSMutableParagraphStyle *linebreak = [[NSMutableParagraphStyle alloc]init];
        linebreak.lineBreakMode = NSLineBreakByCharWrapping;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"请选择短信模板！" attributes:@{NSParagraphStyleAttributeName:linebreak,}];
        _textViewSms.attributedText = attrStr;
        _textViewSms.textColor = [UIColor lightGrayColor];
        _textViewSms.font = [UIFont systemFontOfSize:15];
    }
    return _textViewSms;
}
#pragma mark 短信发送按钮
- (UIButton *)btnSend {
    if (!_btnSend) {
        CGFloat margin = 10;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        CGFloat btnX = margin;
        CGFloat btnY = 0;
        CGFloat btnW = self.view.ls_width - 2 * margin;
        CGFloat btnH = 44;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_full_g"] forState:UIControlStateNormal];
        [btn setTitle:@"发送" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnSend = btn;
        [self.scrollView addSubview:btn];
    }
    return _btnSend;
}

#pragma mark 滚动区域
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat scrollViewX = 0;
        CGFloat scrollViewY = self.navigateTitle.ls_height;
        CGFloat scrollViewW = self.view.ls_width;
        CGFloat scrollViewH = self.view.ls_height - self.navigateTitle.ls_height;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH)];
         _scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [self.view addSubview:_scrollView];
       
    }
    return _scrollView;
}

#pragma mark 生日会员时间列表
- (NSMutableArray *)dateList {
    if (!_dateList) {
        _dateList = [NSMutableArray array];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:@"全部" andId:nil];
        [_dateList addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"今天" andId:@"1"];
        [_dateList addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"明天" andId:@"2"];
        [_dateList addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"最近一周" andId:@"3"];
        [_dateList addObject:item];
    }
    return _dateList;
}

#pragma mark 短信发送参数
- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param removeAllObjects];
    //短信内容
    [_param setValue:self.smsTemplateVo.code forKey:@"code"];
    [_param setValue:self.smsTemplateVo.fields.mj_JSONString forKey:@"params"];
//    if ([NSString isNotBlank:[self.lstCardType getStrVal]]) {
//        //会员卡ID
//        [_param setValue:[self.lstCardType getStrVal] forKey:@"kindCardId"];
//    }
    if ([NSString isNotBlank:[self.lstBirthdayMember getStrVal]]) {
        //会员生日时间
        NSString *dateFrom = nil;
        NSString *dateTo = nil;
        if ([[self.lstBirthdayMember getDataLabel] isEqualToString:@"今天"]) {
            NSString *dateStr = [DateUtils formateDate2:[NSDate date]];
            dateFrom = [NSString stringWithFormat:@"%@ 00:00:00", dateStr];
            dateTo = [NSString stringWithFormat:@"%@ 23:59:59", dateStr];
        } else if ([[self.lstBirthdayMember getDataLabel] isEqualToString:@"明天"]) {
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
            NSString *dateStr = [DateUtils formateDate2:date];
            dateFrom = [NSString stringWithFormat:@"%@ 00:00:00", dateStr];
            dateTo = [NSString stringWithFormat:@"%@ 23:59:59", dateStr];
        } else if ([[self.lstBirthdayMember getDataLabel] isEqualToString:@"最近一周"]) {
            dateFrom = [NSString stringWithFormat:@"%@ 00:00:00", [DateUtils formateDate2:[NSDate date]]];
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:6*24*60*60];
            NSString *dateStr = [DateUtils formateDate2:date];
            dateTo = [NSString stringWithFormat:@"%@ 23:59:59", dateStr];
        }
        [_param setValue:dateFrom?:[NSNull null] forKey:@"dateFrom"];
        [_param setValue:dateTo?:[NSNull null] forKey:@"dateTo"];

        
    }
    return _param;
}
@end
