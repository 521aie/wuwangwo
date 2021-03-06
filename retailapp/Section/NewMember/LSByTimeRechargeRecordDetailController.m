//
//  LSByTimeRechargeRecordDetailController.m
//  retailapp
//
//  Created by taihangju on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSByTimeRechargeRecordDetailController.h"
#import "NavigateTitle2.h"
#import "SRTitleView.h"
#import "DateUtils.h"
#import "LSByTimeRechargeRecordVo.h"
#import "LSMemberCardVo.h"
#import "LSMemberInfoVo.h"

@interface LSByTimeRechargeRecordDetailController ()<INavigateEvent>

@property (nonatomic, strong) UIScrollView *scrollView;/**<>*/
@property (nonatomic, strong) NavigateTitle2 *titleBox;/**<导航>*/
@property (nonatomic, strong) SRTitleView *memberName;/**<会员名>*/
@property (nonatomic, strong) SRTitleView *memberPhone;/**<会员手机号>*/
@property (nonatomic, strong) SRTitleView *memberCardType;/**<会员卡类型>*/
@property (nonatomic, strong) SRTitleView *memberCardNo;/**<会员卡号>*/
@property (nonatomic, strong) SRTitleView *byTimeCard;/**<计次服务>*/
@property (nonatomic, strong) SRTitleView *effectiveTime;/**<有效期>*/
@property (nonatomic, strong) SRTitleView *optType;/**<操作类型>*/
@property (nonatomic, strong) SRTitleView *salePrice;/**<销售金额>*/
@property (nonatomic, strong) SRTitleView *payType;/**<支付方式>*/
@property (nonatomic, strong) SRTitleView *optPeople;/**<操作人>*/
@property (nonatomic, strong) SRTitleView *time;/**<时间>*/
@property (nonatomic, strong) LSByTimeRechargeRecordVo *recordVo;/**<充值记录详情vo>*/
@property (nonatomic, strong) LSMemberCardVo *cardVo;/**<记次充值记录所在的会员卡vo>*/
@property (nonatomic, strong) LSMemberPackVo *packVo;/**<会员vo>*/
@end

@implementation LSByTimeRechargeRecordDetailController

- (instancetype)initWithRechargeRecordVo:(id)vo memberCardVo:(LSMemberCardVo *)cardVo packVo:(LSMemberPackVo *)packVo {
    
    self = [super init];
    if (self) {
        _recordVo = vo;
        _cardVo = cardVo;
        _packVo = packVo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configSubViews];
//    [self fillDetailData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configSubViews {
    
    _titleBox = [NavigateTitle2 navigateTitle:self];
    [_titleBox initWithName:@"计次充值记录" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:_titleBox];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:
                   CGRectMake(0, _titleBox.ls_bottom, SCREEN_W, SCREEN_H-_titleBox.ls_bottom)];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _memberName = [SRTitleView titleViewWith:@"会员名"];
    [_memberName setLblText:_packVo.customer.name?:@"" color:nil];
    [_scrollView addSubview:_memberName];
    
    _memberPhone = [SRTitleView titleViewWith:@"手机号码"];
    [_memberPhone setLblText:[_packVo getMemberPhoneNum] color:nil];
    [_scrollView addSubview:_memberPhone];
    
    _memberCardType = [SRTitleView titleViewWith:@"会员卡类型"];
    [_memberCardType setLblText:_cardVo.cardTypeVo.name?:@"" color:nil];
    [_scrollView addSubview:_memberCardType];
    
    _memberCardNo = [SRTitleView titleViewWith:@"会员卡号"];
    [_memberCardNo setLblText:_cardVo.code?:@"" color:nil];
    [_scrollView addSubview:_memberCardNo];
    
    _byTimeCard = [SRTitleView titleViewWith:@"计次服务"];
    [_byTimeCard setLblText:_recordVo.accountCardName color:nil];
    [_scrollView addSubview:_byTimeCard];
    
    _effectiveTime = [SRTitleView titleViewWith:@"有效期"];
    [_effectiveTime setLblText:[_recordVo vailidTimeString] color:nil];
    [_scrollView addSubview:_effectiveTime];
    
    _optType = [SRTitleView titleViewWith:@"操作类型"];
    [_optType setLblText:[_recordVo operationTypeString] color:[ColorHelper getTipColor6]];
    [_scrollView addSubview:_optType];
    
    // 销售金额或者退款金额
    if ([_recordVo byTimeRechargeRecordVoOperType] == LSByTimeRechargeRecordOperType_Recharge) {
        
        _salePrice = [SRTitleView titleViewWith:@"销售金额(元)"];
        NSString *price = [NSString stringWithFormat:@"%.2f",_recordVo.pay.floatValue];
        [_salePrice setLblText:price color:[ColorHelper getRedColor]];
        
    } else if ([_recordVo byTimeRechargeRecordVoOperType] == LSByTimeRechargeRecordOperType_Refund) {
        
        _salePrice = [SRTitleView titleViewWith:@"销售金额(元)"];
        NSString *symbol = _recordVo.pay.floatValue >= 0 ? @"" : @"-";
        NSString *price = [NSString stringWithFormat:@"%@%.2f" ,symbol ,fabs(_recordVo.pay.floatValue)];
        [_salePrice setLblText:price color:[ColorHelper getGreenColor]];
    }
    [_scrollView addSubview:_salePrice];
    
    _payType = [SRTitleView titleViewWith:@"支付方式"];
    [_payType setLblText:[_recordVo payModeString] color:nil];
    [_scrollView addSubview:_payType];
    
    _optPeople = [SRTitleView titleViewWith:@"操作人"];
    NSString *optPeopleString = @"";
    if (_recordVo.opUserName && _recordVo.opUserNo) {
        optPeopleString = [NSString stringWithFormat:@"%@ (%@)", _recordVo.opUserName, _recordVo.opUserNo];
    }
    [_optPeople setLblText:optPeopleString color:nil];
    [_scrollView addSubview:_optPeople];
    
    _time = [SRTitleView titleViewWith:@"时间"];
    NSString *time = [DateUtils formateLongChineseTime:_recordVo.createTime.longLongValue];;
    [_time setLblText:time color:nil];
    [_scrollView addSubview:_time];
    
    [UIHelper refreshUI:_scrollView];
}


#pragma mark - 相关协议方法 -
// INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

// IEditItemListEvent
//- (void)onItemListClick:(EditItemList *)obj {
//    
//}

//#pragma mark - 网络请求 -
//// 获取计次充值记录详情信息
//- (void)getByTimeNoteDetail {
//    
//    __weak typeof(self) wself = self;
//    NSDictionary *param = @{@"id":_byTimeCardId};
//    NSString *url = @"accountcard/detail";
//    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
//        
//        wself.recordVo = [LSByTimeRechargeRecordVo byTimeRechargeRecordVo:json[@"accountRechargeRecordVo"]];
//        if (wself.recordVo) {
//            [wself fillDetailData];
//        }
//        
//    } errorHandler:^(id json) {
//        [LSAlertHelper showAlert:json];
//    }];
//}

@end


@interface LSMemberCardInfoView : UIView

@property (nonatomic, strong) UIImageView *icon;/**<会员头像>*/
@property (nonatomic, strong) UILabel *name;/**<会员名>*/
@property (nonatomic, strong) UILabel *phone;/**<会员手机>*/
@property (nonatomic, strong) UILabel *cardInfo;/**<会员卡，卡号信息>*/
@end

@implementation LSMemberCardInfoView

+ (instancetype)LSMemberCardInfoView {
    
    LSMemberCardInfoView *infoView = [[LSMemberCardInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 60)];
    infoView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [infoView configSubViews];
    return infoView;
}

- (void)configSubViews {
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_icon];
    
    _name = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_name];
    
    _phone = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_phone];
    
    _cardInfo = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_cardInfo];
    
//    __weak typeof(self) wself = self;
//    
//    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
//    
//    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
//    
//    [_phone mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
//    
//    [_cardInfo mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
}

@end

