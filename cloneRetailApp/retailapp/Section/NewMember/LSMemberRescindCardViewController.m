//
//  LSMemberRescindCardViewController.m
//  retailapp
//
//  Created by taihangju on 16/9/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberRescindCardViewController.h"
#import "LSMemberSaveDetailViewController.h"
#import "LSByTimeServiceListController.h"
#import "NavigateTitle2.h"
#import "LSMemberInfoView.h"
#import "LSMemberAccessView.h"
#import "EditItemText.h"
#import "EditItemList.h"
#import "SymbolNumberInputBox.h"
#import "OptionPickerBox.h"
#import "LSMemberInfoVo.h"
#import "LSAlertHelper.h"
#import "LSMemberConst.h"
#import "LSMemberTypeVo.h"
#import "LSMemberCardVo.h"
#import "LSMemberConst.h"
#import "ServiceFactory.h"
#import "JSONHelper.h"
#import "MemberRender.h"

#define kActualBackMoney 1  // 实退金额
@interface LSMemberRescindCardViewController ()<INavigateEvent ,MBAccessViewDelegate ,IEditItemListEvent ,SymbolNumberInputClient ,LSMemberInfoViewDelegate ,EditItemTextDelegate ,OptionPickerClient>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) LSMemberInfoView *infoView;/* <二维火会员信息*/
@property (nonatomic ,strong) LSMemberAccessView *cardsSummary;/* <会员卡栏*/
@property (nonatomic ,strong) EditItemText *allRecharge;/*<累计充值>*/
@property (nonatomic ,strong) EditItemText *allPresent;/*<累计赠送>*/
@property (nonatomic ,strong) EditItemText *allCost;/*<累计花费>*/
@property (nonatomic ,strong) EditItemList *savingDetail;/* <储值明细*/
@property (nonatomic, strong) EditItemList *byTimeItem;/**<计次服务项>*/
@property (nonatomic ,strong) EditItemText *cardBalance;/*<卡余额>*/
@property (nonatomic, strong) EditItemList *lsAmount;/* <实退金额*/
@property (nonatomic ,strong) EditItemList *refundType;/*<退款方式>*/
@property (nonatomic ,strong) EditItemText *userNeedKnow;/*<备注>*/


//@property (nonatomic ,strong) UILabel *noticeLabel;/*<>*/
@property (nonatomic ,strong) UIButton *ensureButton;/*<确认button>*/
@property (nonatomic ,strong) UIScrollView *scrollView;/*<>*/

@property (nonatomic ,strong) NSString *phoneNum;/*<查询手机号>*/
@property (nonatomic ,strong) LSMemberPackVo *memberPackVo;/*<会员相关信息vo>*/
@property (nonatomic ,strong) LSMemberCardVo *memberCardVo;/*<当前选择的 会员卡vo>*/
@property (nonatomic ,strong) NSArray *memberCardTypes;/*<卡类型>*/
@property (nonatomic ,strong) NSArray *memberCards;/*<已发了的会员卡>*/
@property (nonatomic ,strong) NSArray *refundTypeItems;/*<退款方式>*/
@property (nonatomic ,strong) NSString *selectCardId;/*<指定初始化要操作的卡id>*/
@property (nonatomic ,strong) LSMemberRechargeVo *rechargeVo;/*<充值vo>*/
@property (nonatomic, strong) SettingService *settingservice;
@end

@implementation LSMemberRescindCardViewController

- (instancetype)init:(id)obj cardId:(NSString *)sId {
    
    self = [super init];
    if (self) {
        self.memberPackVo = (LSMemberPackVo *)obj;
        self.selectCardId = sId;
        self.settingservice = [ServiceFactory shareInstance].settingService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self initNavigate];
    [self configSubviews];
    [self loadMemberCards];
    [self configHelpButton:HELP_MEMBER_RETUEN_CARD];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NavigateTitle2 代理
//初始化导航栏
- (void)initNavigate {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"会员退卡" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

- (void)configSubviews {
    
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0, self.titleBox.ls_bottom, SCREEN_W, SCREEN_H - self.titleBox.ls_bottom)];
        self.scrollView.backgroundColor  = [UIColor clearColor];
        [self.view addSubview:self.scrollView];
    }
    
    
    CGFloat topY = 0.0;
    // 会员信息
    if (!self.infoView) {
        self.infoView = [[LSMemberInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 86) delegate:self];
        [self.scrollView addSubview:self.infoView];
    }
    self.infoView.ls_top = topY;
    topY += self.infoView.ls_height;
    
    // 卡信息
    if (!self.cardsSummary) {
        self.cardsSummary = [LSMemberAccessView memberAccessView:MBAccessCardsInfo delegate:self];
        [self.scrollView addSubview:self.cardsSummary];
    }
    self.cardsSummary.ls_top = topY;
    topY += self.cardsSummary.ls_height;
    
    
    if (!self.allRecharge) {
        self.allRecharge = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.allRecharge initLabel:@"累计充值(元)" withHit:nil isrequest:NO type:0];
        [self.allRecharge initData:@"0.00"];
        [self.allRecharge editEnabled:NO];
        [self.scrollView addSubview:self.allRecharge];
    }


    if (!self.allPresent) {
    
        self.allPresent = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.allPresent initLabel:@"累计赠送(元)" withHit:nil isrequest:NO type:0];
        [self.allPresent initData:@"0.00"];
        [self.allPresent editEnabled:NO];
        [self.scrollView addSubview:self.allPresent];
    }


    if (!self.allCost) {
        
        self.allCost = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.allCost initLabel:@"累计消费(元)" withHit:nil isrequest:NO type:0];
        [self.allCost initData:@"0.00"];
        [self.allCost editEnabled:NO];
        [self.scrollView addSubview:self.allCost];
    }

    
    if (!self.savingDetail) {
        
        self.savingDetail = [[EditItemList alloc] initWithFrame:
                             CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.savingDetail initLabel:@"储值明细" withHit:@"" delegate:self];
        self.savingDetail.lblVal.hidden = YES;
        self.savingDetail.imgMore.image = [UIImage imageNamed:@"ico_next"];
        [self.scrollView addSubview:self.savingDetail];
    }

    // 记次服务
    if ([[Platform Instance] getShopMode] == 1 && [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) {
        
        if (!_byTimeItem) {
            _byTimeItem = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_byTimeItem initLabel:@"计次服务" withHit:nil delegate:self];
            _byTimeItem.imgMore.image = [UIImage imageNamed:@"ico_next"];
            [_scrollView addSubview:_byTimeItem];
        }
    }

    
    if (!self.cardBalance) {
        
        self.cardBalance = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.cardBalance initLabel:@"卡余额(元)" withHit:nil isrequest:NO type:0];
        [self.cardBalance initData:@"0.00"];
        [self.cardBalance editEnabled:NO];
        self.cardBalance.txtVal.textColor = [ColorHelper getRedColor];
        [self.scrollView addSubview:self.cardBalance];
    }

    
    if (!self.lsAmount) {
        
        self.lsAmount = [[EditItemList alloc] initWithFrame:
                             CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.lsAmount initLabel:@"实退金额(元)" withHit:nil isrequest:YES delegate:self];
        [self.lsAmount initData:@"" withVal:@""];
        [self.scrollView addSubview:self.lsAmount];
    }

    
    if (!self.refundType) {
        
        self.refundType = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        self.refundType.imgMore.hidden = YES;
        [self.refundType initLabel:@"退款方式" withHit:@"" isrequest:NO delegate:nil];
        [self.refundType initData:@"现金" withVal:@"现金"];
        self.refundType.lblVal.textColor = [ColorHelper getTipColor6];
        self.refundType.lblVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        self.refundType.lblVal.ls_left += 22.0;
        self.refundType.tag = 111;
        [self.scrollView addSubview:self.refundType];
    }

    
    if (!self.userNeedKnow) {
        
        self.userNeedKnow =  [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        self.userNeedKnow.delegate = self;
        [self.userNeedKnow initLabel:@"备注" withHit:@"" isrequest:NO type:0];
        [self.userNeedKnow initMaxNum:kCommentMaxNum];
        [self.scrollView addSubview:self.userNeedKnow];
    }

    // 提示文案
    /*
    if (!self.noticeLabel) {
        
        self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W-20.0, 30.0)];
        self.noticeLabel.textColor = [ColorHelper getTipColor6];
        self.noticeLabel.font = [UIFont systemFontOfSize:13.0];
        self.noticeLabel.numberOfLines = 0;
        self.noticeLabel.text = ReturnCardNoticeString;
        [self.scrollView addSubview:self.noticeLabel];
    }*/

    // button
    if (!self.ensureButton) {
        self.ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ensureButton setTitle:@"退卡" forState:0];
        [self.ensureButton setBackgroundColor:[ColorHelper getRedColor]];
        [self.ensureButton.titleLabel setTextColor:RGB(192, 0, 0)];
        [self.ensureButton addTarget:self action:@selector(buttonTapAction) forControlEvents:UIControlEventTouchUpInside];
        self.ensureButton.frame = CGRectMake(12, 0, SCREEN_W - 24, 44);
        self.ensureButton.layer.cornerRadius = 4.0;
        [self.scrollView addSubview:self.ensureButton];
    }
   
    self.allRecharge.ls_top = topY;
    topY += 48.0f;
    self.allPresent.ls_top = topY;
    topY += 48.0f;
    self.allCost.ls_top = topY;
    topY += 48.0f;
    self.savingDetail.ls_top = topY;
    topY += 48.0;
    if (_byTimeItem) {
        _byTimeItem.ls_top = topY;
        topY += _byTimeItem.ls_height;
    }
    self.cardBalance.ls_top = topY;
    topY += 48.0;
    self.lsAmount.ls_top = topY;
    topY += 48.0;
    self.refundType.ls_top = topY;
    topY += 48.0;
    self.userNeedKnow.ls_top = topY;
    topY += self.userNeedKnow.ls_height;
//    self.noticeLabel.ls_top = topY;
  //  topY += self.noticeLabel.ls_height;
    self.ensureButton.ls_top = topY + 10.0;
    topY = self.ensureButton.ls_bottom + 30.0;
    
    // 挂失卡, 隐藏相关项
    BOOL status = [self.memberCardVo isLost];
    self.allRecharge.hidden = status;
    self.allPresent.hidden = status;
    self.allCost.hidden = status;
    self.savingDetail.hidden = status;
    _byTimeItem.hidden = status;
    self.cardBalance.hidden = status;
    self.lsAmount.hidden = status;
    self.refundType.hidden = status;
    self.userNeedKnow.hidden = status;
    //self.noticeLabel.hidden = status;
    self.ensureButton.hidden = status;
    
    if (self.memberCardVo && status) {
        topY = self.cardsSummary.ls_bottom + 50;
        topY = topY > self.scrollView.ls_height ? topY : self.scrollView.ls_height;
    }
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_W, topY)];
}

- (void)buttonTapAction {
    
    if ([self isVaild]) {
        
      //  [LSAlertHelper showSheet:[NSString stringWithFormat:@"确定要删除[%@]吗?" ,self.memberCardVo.kindCardName] cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
                [self deleteCard];
        //}];
    }
}

#pragma mark - 相关协议

/**
 **  MBAccessViewDelegate
 **  滑动选择了要操作的会员卡
 **/
- (void)memberAccessView:(LSMemberAccessView *)view selectdPage:(id)obj {
   
    LSMemberCardVo *vo = (LSMemberCardVo *)obj;
    if ([self hasChanged] && ![vo isLost]) {
        [LSAlertHelper showAlert:@"换卡后将对另外一张卡进行操作！" block:nil];
    }
    if (![self.memberCardVo.status isEqualToNumber:vo.status]) {
        self.memberCardVo = vo;
        [self configSubviews];
    }
    else {
        self.memberCardVo = vo;
    }
    [self fillData];
}

// LSMemberInfoViewDelegate
- (void)memberInfoViewHeightChaged {
    [self configSubviews];
}

// IEditItemListEvent ，实退接
- (void)onItemListClick:(EditItemList *)obj {
    
    if ([obj isEqual:self.lsAmount]) {
      
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:YES event:kActualBackMoney];
   
    } else if ([obj isEqual:self.savingDetail]) {
    
        // 调转对应“储值明细”的页面
        LSMemberSaveDetailViewController *vc = [[LSMemberSaveDetailViewController alloc] init:MBDetailSavingType cards:@[self.memberCardVo] selectCard:self.memberCardVo];
        [self pushController:vc from:kCATransitionFromRight];
    
    } else if ([obj isEqual:_byTimeItem]) {
        
        LSByTimeServiceListController *vc = [[LSByTimeServiceListController alloc] initWithListType:LSByTimeServiceNotExpired cardId:_memberCardVo.sId];
        [self pushController:vc from:kCATransitionFromRight];
    }
//    else if ([obj isEqual:self.refundType]) {
    
//        if ([ObjectUtil isNotEmpty:self.refundTypeItems]) {
//            [OptionPickerBox initData:self.refundTypeItems itemId:obj.currentVal];
//            [OptionPickerBox show:obj.lblName.text client:self event:self.refundType.tag];
//        }
//        else {
//            [self loadPayType:obj];
//        }
//    }
}

/**
 *  OptionPickerClient
 */
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    if (eventType == self.refundType.tag) {
        NameItemVO *item = (NameItemVO *)selectObj;
        [self.refundType changeData:item.itemName withVal:item.itemId];
//        self.rechargeVo.payTyp = @(item.itemId.integerValue);
        [self hasChanged];
    }
    return YES;
}

// SymbolNumberInputClient
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    
    NSString *returnMoney = [val formatWith2FractionDigits];
    [self.lsAmount changeData:returnMoney withVal:returnMoney];
    [self hasChanged];
//    self.memberCardVo.retreatVo.realPay = val;
}

// EditItemTextDelegate
- (void)editItemTextEndEditing:(EditItemText *)editItem currentVal:(NSString *)val {
    if ([editItem isEqual:self.userNeedKnow]) {
//        self.memberCardVo.retreatVo.memo = val;
        [self.userNeedKnow initData:val];
        [self hasChanged];
    }
}

#pragma mark - 数据填充等处理

- (void)fillData {
    
    // 会员信息
    if ([NSString isBlank:self.infoView.statusLabel.attributedText.string]) {
        
        [self.infoView fillMemberInfo:self.memberPackVo cards:self.memberCards cardTypes:self.memberCardTypes phone:self.phoneNum];
        [self.cardsSummary setCardDatas:self.memberCards initPage:[self.memberCards indexOfObject:self.memberCardVo]];
    }
    
    // 计次充值记录
    if ([[Platform Instance]  getShopMode] == 1 && [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) {
        
        [_byTimeItem initData:@"" withVal:@""];
        _byTimeItem.lblVal.hidden = YES;
        if (_memberCardVo.byTimeServiceTimes.integerValue >= 0) {
            [_byTimeItem initData:[NSString stringWithFormat:@"%@项",_memberCardVo.byTimeServiceTimes] withVal:@"1"];
            _byTimeItem.lblVal.hidden = NO;
        }
    }

    [self.allRecharge initData:[NSString stringWithFormat:@"%.2f",self.memberCardVo.realBalance.floatValue]];
    [self.allPresent initData:[NSString stringWithFormat:@"%.2f",self.memberCardVo.giftBalance.floatValue]];
    [self.allCost initData:[NSString stringWithFormat:@"%.2f",self.memberCardVo.payAmount.floatValue]];
    [self.cardBalance initData:[NSString stringWithFormat:@"%.2f",self.memberCardVo.balance.floatValue]];
    [self.userNeedKnow initData:@""];
    
    [self configSubviews];
}


#pragma mark - 网络请求

//// 退款方式
//- (void)loadPayType:(EditItemList *)obj {
//    __weak typeof(self) weakSelf = self;
//    [_settingservice payMentList:[NSMutableArray new] completionHandler:^(id json) {
//        
//        NSArray *list = json[@"payMentVoList"];
//        NSMutableArray* payModeList = [JsonHelper transList:list objName:@"PaymentVo"];
//        weakSelf.refundTypeItems = [MemberRender listPayMode:payModeList];
//        if ([ObjectUtil isNotEmpty:obj]) {
//            [OptionPickerBox initData:weakSelf.refundTypeItems itemId:[obj getStrVal]];
//            [OptionPickerBox show:obj.lblName.text client:weakSelf event:obj.tag];
//        }
//        else {
//            NameItemVO *item = [self.refundTypeItems firstObject];
//            [weakSelf.refundType initData:item.itemName withVal:item.itemId];
//        }
//    } errorHandler:^(id json) {
//        [LSAlertHelper showAlert:json block:nil];
//    }];
//}


// 获取会员所有的会员卡信息
- (void)loadMemberCards {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_memberPackVo.customerRegisterThirdPartyPojo.customerRegisterId forKey:@"customerRegisterId"];
    [param setValue:_memberPackVo.customer.sId forKey:@"customerId"];
    [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
    
    [BaseService getRemoteLSDataWithUrl:@"customer/queryCustomerCard" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"returnCode"] isEqualToString:@"success"]) {
            
            NSMutableArray *types = [[NSMutableArray alloc] init];
            NSMutableArray *cards = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in json[@"data"]) {
                
                LSMemberTypeVo *type = [LSMemberTypeVo getMemberTypeVo:dic[@"kindCard"]];
                LSMemberCardVo *card = [LSMemberCardVo getMemberCardVo:dic[@"card"]];
                card.cardTypeVo = type;
                // 计次服务次数
                if ([ObjectUtil isNotNull:[dic valueForKey:@"accountcardnum"]]) {
                    card.byTimeServiceTimes = [dic valueForKey:@"accountcardnum"];
                } else {
                    card.byTimeServiceTimes = @0;
                }
                card.kindCardName = type.name;
                card.filePath = type.filePath;
                card.mode = @(type.mode);
                [types addObject:type];
                [cards addObject:card];
            }

            self.memberCardTypes = [types copy];
            self.memberCards = [cards copy];
            if ([NSString isNotBlank:self.selectCardId]) {
                [self.memberCards enumerateObjectsUsingBlock:^(LSMemberCardVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.sId isEqualToString:self.selectCardId]) {
                        self.memberCardVo = obj;
                        *stop = YES;
                    }
                }];
            }
            else {
                self.memberCardVo = self.memberCards.firstObject;
            }
            
            [self fillData];
            if ([self.memberCardVo isLost] || self.memberCards.count > 1) {
                [self configSubviews];
            }
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 会员退卡
- (void)deleteCard {
    
    if ([self isVaild]) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
        [param setValue:self.memberCardVo.sId forKey:@"cardId"];
        [param setValue:[[Platform Instance] getkey:USER_ID] forKey:@"userId"];
        [param setValue:[[self.lsAmount getStrVal] convertToNumber] forKey:@"realPay"];
        [param setValue:[self.userNeedKnow getStrVal] forKey:@"memo"];
        [param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
//        [param setValue:[[self.refundType getStrVal] convertToNumber] forKey:@"refundType"]; // 退款方式
       
        [BaseService getRemoteLSDataWithUrl:@"customer/delCard" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
            if ([json[@"returnCode"] isEqualToString:@"success"]) {
                [LSAlertHelper showStatus:@" 退卡成功！" afterDeny:2 block:^{
                    if (self.selectCardId) {
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
}

#pragma mark - 相关check 

// 点击退卡，进行必填项等校验
- (BOOL)isVaild {
    
    if ([NSString isBlank:[self.lsAmount getStrVal]]) {
        [LSAlertHelper showAlert:@"实退金额不能为空！" block:nil];
        return NO;
    }
    else if ([[self.lsAmount getStrVal] floatValue] > self.cardBalance.txtVal.text.floatValue) {
        [LSAlertHelper showAlert:@"实退金额不能大于卡内余额！" block:nil];
        return NO;
    }
    
    if ([NSString isBlank:self.refundType.currentVal]) {
        [LSAlertHelper showAlert:@"请选择退款方式！" block:nil];
        return NO;
    }
    
    return YES;
}


// 一些可更改项变化后调用，改变导航状态
- (BOOL)hasChanged {
    
    if (self.refundType.baseChangeStatus || self.lsAmount.baseChangeStatus || self.userNeedKnow.baseChangeStatus) {
//        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_ADD];
        return YES;
    }
    else {
//        [self.titleBox editTitle:NO act:0];
        return NO;
    }
}

@end
