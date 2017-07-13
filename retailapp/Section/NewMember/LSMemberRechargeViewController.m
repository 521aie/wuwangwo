//
//  LSMemberRechargeViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberRechargeViewController.h"
#import "LSMemberSaveDetailViewController.h"
#import "NavigateTitle2.h"
#import "LSMemberInfoView.h"
#import "LSMemberAccessView.h"
#import "EditItemText.h"
#import "EditItemList.h"
#import "EditItemView.h"
#import "OptionPickerBox.h"
#import "SymbolNumberInputBox.h"
#import "LSAlertHelper.h"
#import "LSMemberInfoVo.h"
#import "LSMemberCardVo.h"
#import "LSMemberTypeVo.h"
#import "NameItemVO.h"
#import "LSMemberRechargeSetVo.h"
#import "ServiceFactory.h"
#import "JSONHelper.h"
#import "MemberRender.h"
#import "NSNumber+Extension.h"
#import "PopoverView.h"

@interface LSMemberRechargeViewController ()<INavigateEvent ,MBAccessViewDelegate ,IEditItemListEvent ,SymbolNumberInputClient ,OptionPickerClient ,LSMemberInfoViewDelegate>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) LSMemberInfoView *infoView;/* <二维火会员信息*/
@property (nonatomic ,strong) LSMemberAccessView *cardsSummary;/* <会员卡栏*/
@property (nonatomic ,strong) EditItemList *payType;/*<支付方式>*/
@property (nonatomic ,strong) EditItemList *rechargeMoney;/*<充值金额>*/
@property (nonatomic ,strong) EditItemView *presentMoney;/*<赠送金额>*/
@property (nonatomic ,strong) EditItemView *presentIntegral;/*<赠送积分>*/
@property (nonatomic ,strong) UIButton *ensureButton;/*<确认button>*/
@property (nonatomic ,strong) UIScrollView *scrollView;/*<>*/
@property (nonatomic, strong) UIButton *popBtn;/**<显示popView的button>*/

@property (nonatomic ,strong) NSString *phoneNum;/*<查询的手机号>*/
@property (nonatomic ,strong) LSMemberPackVo *memberPackVo;/*<>*/
@property (nonatomic ,strong) LSMemberCardVo *memberCardVo;/*<>*/
@property (nonatomic ,assign) NSString *selectCardId;/*<指定初始操作的card所对应的id>*/
@property (nonatomic ,strong) NSArray *memberCardTypes;/*<卡类型>*/
@property (nonatomic ,strong) NSArray *memberCards;/*<已发了的会员卡>*/
@property (nonatomic ,strong) NSArray *payTypeItems;/*<付款方式items>*/
@property (nonatomic ,strong) LSMemberRechargeVo *rechargeVo;/*<充值vo>*/
@property (nonatomic, strong) SettingService *settingservice;
@property (nonatomic, strong) NSMutableArray *ruleList;/**<充值的优惠规则：送积分送金额>*/
@end

@implementation LSMemberRechargeViewController

- (instancetype)init:(LSMemberPackVo *)obj phone:(NSString *)mobile selectCard:(NSString *)cardId {
    
    self = [super init];
    if (self) {
        
        _memberPackVo = (LSMemberPackVo *)obj;
        _rechargeVo = [[LSMemberRechargeVo alloc] init];
        _phoneNum = mobile;
        _selectCardId = cardId;
        _settingservice = [ServiceFactory shareInstance].settingService;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self initNavigate];
    [self configSubView];
    [self configHelpButton:HELP_MEMBER_RECHARGE];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self queryMemberInfo];
    [self loadPayType:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 创建，计算子view的布局
- (void)configSubView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0, _titleBox.ls_bottom, SCREEN_W, SCREEN_H - _titleBox.ls_bottom)];
        _scrollView.backgroundColor  = [UIColor clearColor];
        [self.view addSubview:_scrollView];
    }
    
    CGFloat topY = 0.0;
    // 会员信息
    if (!_infoView) {
        _infoView = [[LSMemberInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 86) delegate:self];
        [_scrollView addSubview:_infoView];
    }
    _infoView.ls_top = topY;
    topY += _infoView.ls_height;
    
    // 卡信息
    if (!_cardsSummary) {
        _cardsSummary = [LSMemberAccessView memberAccessView:MBAccessCardsInfo delegate:self];
        [_scrollView addSubview:_cardsSummary];
    }
    _cardsSummary.ls_top = topY;
    topY += _cardsSummary.ls_height;
    
    if (!_payType) {
        
        _payType = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [_payType initLabel:@"支付方式" withHit:@"" delegate:self];
        _payType.tag = 11;
        [_scrollView addSubview:_payType];
    }
    
    if (_memberCardVo.status.intValue != 2) {
        _payType.ls_top = topY;
        topY += 48.0f;
        _payType.hidden = NO;
    }
    else {
        _payType.hidden = YES;
    }
    
    
    if (!_rechargeMoney) {
        
        _rechargeMoney = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [_rechargeMoney initLabel:@"充值金额(元)" withHit:@"充值优惠活动" isrequest:YES delegate:self];
        _rechargeMoney.tag = 12;
        [_scrollView addSubview:_rechargeMoney];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"ico_query"] forState:0];
        button.frame = CGRectMake(86, 32, 29, 29);
        button.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
        [button addTarget:self action:@selector(showRechargeRulePopview) forControlEvents:UIControlEventTouchUpInside];
        [_rechargeMoney addSubview:button];
        _popBtn = button;
    }
    
    if (_memberCardVo.status.intValue != 2) {
        _rechargeMoney.ls_top = topY;
        topY += _rechargeMoney.ls_height;
        _rechargeMoney.hidden = NO;
    }
    else {
        _rechargeMoney.hidden = YES;
    }
    
    if (!_presentMoney) {
        
        _presentMoney = [EditItemView editItemView];
        [_presentMoney initLabel:@"赠送金额(元)" withDataLabel:@"0" withVal:@"0"];
        [_presentMoney initHit:@""];
        _presentMoney.lblVal.textColor = [ColorHelper getTipColor9];
        _presentMoney.tag = 13;
        [_scrollView addSubview:_presentMoney];
    }
    
    if (_memberCardVo.status.intValue != 2) {
        _presentMoney.ls_top = topY;
        topY += _presentMoney.ls_height;
        _presentMoney.hidden = NO;
    }
    else {
        _presentMoney.hidden = YES;
    }
   
    if (!_presentIntegral) {
        
        _presentIntegral = [EditItemView editItemView];
        [_presentIntegral initLabel:@"赠送积分" withDataLabel:@"0" withVal:@"0"];
        [_presentIntegral initHit:@""];
        _presentIntegral.lblVal.textColor = [ColorHelper getTipColor9];
        _presentIntegral.tag = 14;
        [_scrollView addSubview:_presentIntegral];
    }
    if (_memberCardVo.status.intValue != 2) {
        _presentIntegral.ls_top = topY;
        topY += _presentIntegral.ls_height;
        _presentIntegral.hidden = NO;
    }
    else {
        _presentIntegral.hidden = YES;
    }
    
    // button
    if (!_ensureButton) {
        _ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ensureButton setTitle:@"确认" forState:0];
        [_ensureButton setBackgroundColor:RGB(0, 170, 34)]; // 屎绿色#00AA22
        [_ensureButton.titleLabel setTextColor:RGB(192, 0, 0)];
        [_ensureButton addTarget:self action:@selector(buttonTapAction) forControlEvents:UIControlEventTouchUpInside];
        _ensureButton.frame = CGRectMake(12, 0, SCREEN_W - 24, 44);
        _ensureButton.layer.cornerRadius = 4.0;
        [_scrollView addSubview:_ensureButton];
    }
    
    if (_memberCardVo.status.intValue != 2) {
        _ensureButton.ls_top = topY + 15.0;
        topY = _ensureButton.ls_bottom + 30;
        _ensureButton.hidden = NO;
    }
    else {
        _ensureButton.hidden = YES;
    }
    
    if (_scrollView.ls_height < topY) {
        [_scrollView setContentSize:CGSizeMake(SCREEN_W, topY)];
    }
}

// 显示充值优惠规则的popview
- (void)showRechargeRulePopview {
    if (_ruleList.count > 0) {
        
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:_ruleList.count];
        for (NSString *rule in _ruleList) {
            PopoverAction *action1 = [PopoverAction actionWithTitle:rule handler:nil];
            [list addObject:action1];
        }
        PopoverView *popView = [PopoverView popoverView];
        [popView showToView:_popBtn withActions:list];
    }
}

- (void)buttonTapAction {
    
    if ([self isVaild]) {
        [self memberRecharge];
    }
}

// 填充model数据到界面
- (void)fillData {
    
    // 会员信息
    [_infoView fillMemberInfo:_memberPackVo cards:_memberCards cardTypes:_memberCardTypes phone:_phoneNum];
    [_cardsSummary setCardDatas:_memberCards initPage:[_memberCards indexOfObject:_memberCardVo]];
}

#pragma mark - NavigateTitle2 代理

- (void)initNavigate {
    
    _titleBox = [NavigateTitle2 navigateTitle:self];
    _titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [_titleBox initWithName:@"储值充值" backImg:Head_ICON_BACK moreImg:nil];
    _titleBox.btnUser.hidden = NO;
    _titleBox.imgMore.hidden = NO;
    _titleBox.imgMore.image = [UIImage imageNamed:@"ico_saveDetail"];
    [self.view addSubview:_titleBox];
    
    NSMutableArray *removeLayouts = [[NSMutableArray alloc] init];
    [removeLayouts addObjectsFromArray:_titleBox.imgMore.constraints];
    [removeLayouts addObjectsFromArray:_titleBox.lblRight.constraints];
    
    for (NSLayoutConstraint *layout in _titleBox.constraints) {
        if ([layout.secondItem isEqual:_titleBox.imgMore]) {
            [removeLayouts addObject:layout];
        }
    }
    [NSLayoutConstraint deactivateConstraints:removeLayouts];
    UIImageView *_imgMore = _titleBox.imgMore;
    NSDictionary *views = NSDictionaryOfVariableBindings(_imgMore);
    NSArray *xLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imgMore(88)]-10-|" options:0 metrics:nil views:views];
    NSArray *yLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imgMore(16)]-16-|" options:0 metrics:nil views:views];
    [_titleBox addConstraints:xLayoutArray];
    [_titleBox addConstraints:yLayoutArray];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        
        if ([self hasChanged]) {
            [LSAlertHelper showAlert:@"提示" message:@"内容有变更尚未保存，确定要退出吗？" cancle:@"取消" block:nil ensure:@"确定" block:^{
                [self popToLatestViewController:kCATransitionFromLeft];
            }];
        }
        else {
            [self popToLatestViewController:kCATransitionFromLeft];
        }
    }
    else if (event == DIRECT_RIGHT) {
        
        LSMemberSaveDetailViewController *vc = [[LSMemberSaveDetailViewController alloc] init:MBDetailSavingType cards:_memberCards selectCard:_memberCardVo];
        [self pushController:vc from:kCATransitionFromRight];
    }
}


/* 
 * MBAccessViewDelegate ,滑动选择了要操作的会员卡
**/
- (void)memberAccessView:(LSMemberAccessView *)view selectdPage:(id)obj {
   
    LSMemberCardVo *vo = (LSMemberCardVo *)obj;
    // 如果当前卡的充值金额>0 切换时进行提示
    if ([self hasChanged] && ![vo isLost]) {
         [LSAlertHelper showAlert:@"换卡后将对另外一张卡进行操作！" block:nil];
    }
    _memberCardVo = vo;
    _selectCardId = _memberCardVo.sId;
    [self configSubView];
    // 请求充值送金额、送积分的规则
    [self getQueryMoneyRules];
    if (_rechargeVo.recharegeMoney.integerValue > 0) {
        [self getPresetnMoney];
    }
}

// LSMemberInfoViewDelegate
- (void)memberInfoViewHeightChaged {
    [self configSubView];
}


/**
 *  IEditItemListEvent
 */
- (void)onItemListClick:(EditItemList *)obj {
    if ([obj isEqual:_payType]) {
       
        if ([ObjectUtil isNotEmpty:_payTypeItems]) {
            [OptionPickerBox initData:_payTypeItems itemId:_payType.currentVal];
            [OptionPickerBox show:@"支付方式" client:self event:_payType.tag];
        }
        else {
            [self loadPayType:obj];
        }
    }
    else if ([obj isEqual:_rechargeMoney]) {
        [SymbolNumberInputBox initData:_rechargeMoney.currentVal];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        [SymbolNumberInputBox show:@"充值金额" client:self isFloat:YES isSymbol:YES event:_rechargeMoney.tag];
    }
}

/**
 *  OptionPickerClient
 */
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    if (eventType == _payType.tag) {
        NameItemVO *item = (NameItemVO *)selectObj;
        [_payType changeData:item.itemName withVal:item.itemId];
        _rechargeVo.payTyp = [item.itemId convertToNumber];
    }
    return YES;
}

/**
 *  SymbolNumberInputClient
 */
- (void)numberClientInput:(NSString*)val event:(NSInteger)eventType {
    
    if (eventType == _rechargeMoney.tag) {
        
        NSString *rechargeMoney = [val formatWith2FractionDigits];
        [_rechargeMoney changeData:rechargeMoney withVal:rechargeMoney];
        _rechargeVo.recharegeMoney = [val convertToNumber];
        // 输入充值金额大于0 ，进行请求获取赠送金额和积分
        if (val.floatValue > 0) {
            [self getPresetnMoney];
        }
    }
}

#pragma mark - 网络请求

- (void)loadPayType:(EditItemList *)obj {
    __weak typeof(self) weakSelf = self;
    [_settingservice payMentList:[NSMutableArray new] completionHandler:^(id json) {

        NSArray *list = json[@"payMentVoList"];
        NSMutableArray* payModeList = [JsonHelper transList:list objName:@"PaymentVo"];
        weakSelf.payTypeItems = [MemberRender listPayMode:payModeList];
        if ([ObjectUtil isNotEmpty:obj]) {
            [OptionPickerBox initData:weakSelf.payTypeItems itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:weakSelf event:obj.tag];
        }
        else {
            NameItemVO *item = [_payTypeItems firstObject];
            [_payType initData:item.itemName withVal:item.itemId];
            _rechargeVo.payTyp = [item.itemId convertToNumber];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 会员充值
- (void)memberRecharge {

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:_memberCardVo.sId forKey:@"cardId"];
    [param setValue:_rechargeVo.recharegeMoney forKey:@"pay"]; //充值的钱
    [param setValue:[[Platform Instance] getkey:USER_ID] forKey:@"operatorId"];
    [param setValue:_memberCardVo.sellerId forKey:@"sellerId"];
    [param setValue:_rechargeVo.presentIntegral forKey:@"num"]; // 送的积分
    [param setValue:_rechargeVo.payTyp forKey:@"payMode"];
    [param setValue:@(NO) forKey:@"sendSms"];
    [param setValue:@(1) forKey:@"channelType"];
    [param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
    [param setValue:[[Platform Instance] getkey:EMPLOYEE_NAME] forKey:@"operatorName"];
    
    [BaseService getRemoteLSDataWithUrl:@"customer/chargeCard" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"returnCode"] isEqualToString:@"success"]) {
            [LSAlertHelper showStatus:@" 充值成功！" afterDeny:2 block:^{
                if (_selectCardId) {
                    // 有selectCardId，成功后返回详情页。
                    [self popToLatestViewController:kCATransitionFromLeft];
                }
                else {
                    [self popToViewControllerNamed:@"LSMemberModule" popDirection:kCATransitionFromLeft];
                }
            }];
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 根据实收金额获得赠送金额和赠送积分
- (void)getPresetnMoney {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_memberCardVo.kindCardId forKey:@"kindCardId"];
    [param setValue:[[_rechargeMoney getStrVal] convertToNumber] forKey:@"chargeMoney"];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"moneyRule/v2/getGift" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            
            // 赠送金额
            NSNumber *money = json[@"data"][@"gift"];
            _rechargeVo.presentMoney = @(money.floatValue/100.0);
            NSString *moneyString = [_rechargeVo.presentMoney convertToStringWithFormat:@"###,##0.00"];
            [_presentMoney initData:moneyString withVal:moneyString];
            _rechargeVo.presentIntegral = json[@"data"][@"giftDegree"];
            NSString *degreeString = [NSString stringWithFormat:@"%@" ,_rechargeVo.presentIntegral];
            [_presentIntegral initData:degreeString withVal:degreeString];
        }
        else {
            _rechargeVo.presentMoney = @(0);
            _rechargeVo.presentIntegral = @(0);
            [_presentMoney initData:@"0.00" withVal:@"0.00"];
            [_presentIntegral initData:@"0" withVal:@"0"];
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}


// 查询会员基本信息
- (void)queryMemberInfo {

    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:3];
    [param setValue:entityId forKey:@"entityId"];
    [param setValue:_phoneNum forKey:@"keyword"];
    [param setValue:@(NO) forKey:@"isOnlySearchMobile"];
    [param setValue:_memberPackVo.customerRegisterId forKey:@"twodfireMemberId"];
    [param setValue:_memberPackVo.customer.sId forKey:@"customerId"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"card/v2/queryCustomerInfo" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            
            NSArray *customerList = json[@"data"][@"customerList"];
            if ([ObjectUtil isNotEmpty:customerList]) {
                
                if (customerList.count == 1) {
                    self.memberPackVo = [LSMemberPackVo getMemberPackVo:customerList[0]];
                    [self loadMemberCards];
                }
            }
        }
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 获取会员所有的会员卡信息
- (void)loadMemberCards {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_memberPackVo.customerRegisterThirdPartyPojo.customerRegisterId forKey:@"customerRegisterId"];
    [param setValue:_memberPackVo.customer.sId forKey:@"customerId"];
    [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
    
    [BaseService getRemoteLSDataWithUrl:@"customer/v1/queryCustomerCard" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        //        if ([json[@"code"] boolValue]) {
        
        NSMutableArray *types = [[NSMutableArray alloc] init];
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in json[@"data"]) {
            
            LSMemberTypeVo *type = [LSMemberTypeVo getMemberTypeVo:dic[@"kindCard"]];
            LSMemberCardVo *card = [LSMemberCardVo getMemberCardVo:dic[@"card"]];
            card.cardTypeVo = type;
            card.kindCardName = type.name;
            card.mode = @(type.mode);
            card.filePath = type.filePath;
            [types addObject:type];
            [cards addObject:card];
        }
        _memberCardTypes = [types copy];
        _memberCards = [cards copy];
        if ([NSString isNotBlank:_selectCardId]) {
            [_memberCards enumerateObjectsUsingBlock:^(LSMemberCardVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.sId isEqualToString:_selectCardId]) {
                    _memberCardVo = obj;
                    *stop = YES;
                }
            }];
        }
        else {
            _memberCardVo = _memberCards.firstObject;
        }
        [self fillData];
        [self getQueryMoneyRules];
        //        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 获取指定会员卡类型的充值优惠信息
- (void)getQueryMoneyRules {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
    [param setObject:_memberCardVo.kindCardId forKey:@"kindCardId"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"moneyRule/v2/queryMoneyRules" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            
            NSArray *array = [LSMemberRechargeRuleVo getRechargeRuleVoList:json[@"data"]];
            NSMutableArray *ruleList = [[NSMutableArray alloc] init];
            [array enumerateObjectsUsingBlock:^(LSMemberRechargeRuleVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (obj.giftDegree.integerValue > 0 || obj.rule.floatValue > 0) {
                    NSString *giftDegree = @"";
                    if (obj.giftDegree.integerValue > 0) {
                        giftDegree = [obj.giftDegree stringValue];
                    }
//                    if ([NSString isNotBlank:obj.extendFields]) {
//                        NSRange range = [obj.extendFields rangeOfString:@":"];
//                        range.length = obj.extendFields.length - range.location;
//                        giftDegree = [obj.extendFields substringWithRange:range];
//                        giftDegree = giftDegree.integerValue == 0?@"":giftDegree;
//                    }
                    NSString *moneyRule = [NSString stringWithFormat:@"每充值%@元送%@元" ,obj.condition ,obj.rule];
                    if ([NSString isNotBlank:giftDegree]) {
                        moneyRule = [NSString stringWithFormat:@"每充值%@元送%@元、%@积分" ,obj.condition ,obj.rule,giftDegree];
                    }
                    [ruleList addObject:moneyRule];
                }
            }];
            _ruleList = ruleList;
            if (_ruleList.count > 0) {
                [_rechargeMoney initHit:@"充值优惠活动"];
                _popBtn.hidden = NO;
            } else {
                [_rechargeMoney initHit:@"暂无充值优惠活动"];
                _popBtn.hidden = YES;
            }
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}


#pragma mark - 相关 check

- (BOOL)isVaild {
    if ([NSString isBlank:_rechargeMoney.currentVal]) {
        [LSAlertHelper showAlert:@"充值金额不能为空！" block:nil];
        return NO;
    }
    else {
        if (_rechargeMoney.currentVal.floatValue <= 0.0f) {
            [LSAlertHelper showAlert:@"充值金额不能为0！" block:nil];
            return NO;
        }
    }
    return YES;
}

- (BOOL)hasChanged {
    
    if (_rechargeMoney.baseChangeStatus || _payType.baseChangeStatus) {
        return YES;
    }
    return NO;
}

@end
