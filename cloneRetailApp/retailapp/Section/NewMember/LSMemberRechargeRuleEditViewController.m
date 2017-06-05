//
//  LSMemberRechargeRuleEditViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberRechargeRuleEditViewController.h"
#import "NavigateTitle2.h"
#import "EditItemText.h"
#import "EditItemList.h"
#import "SymbolNumberInputBox.h"
#import "LSMemberConst.h"
#import "LSMemberRechargeSetVo.h"
#import "LSAlertHelper.h"
#import "NSNumber+Extension.h"

#define kRechargeMoney 1
#define kPresentMoney 2
#define kPresentIntegral 3
@interface LSMemberRechargeRuleEditViewController ()<INavigateEvent ,IEditItemListEvent ,SymbolNumberInputClient>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) EditItemText *cardType;/*<卡状态>*/
@property (nonatomic ,strong) EditItemList *rechargeMoney;/*<充值金额>*/
@property (nonatomic ,strong) EditItemList *presentMoney;/*<赠送金额>*/
@property (nonatomic ,strong) EditItemList *presentIntegral;/*<赠送积分>*/
@property (nonatomic ,strong) UILabel *noticeLabel;/*<提示文案>*/
@property (nonatomic ,strong) UIButton *ensureButton;/*<确认button>*/
@property (nonatomic ,strong) UIScrollView *scrollView;/*<>*/

@property (nonatomic ,assign) NSInteger actionType;/*<编辑，添加状态>*/
@property (nonatomic ,strong) LSMemberRechargeRuleVo *ruleVo;/*<>*/
@property (nonatomic ,copy) RechargeRuleHandleBlock callBackBlock;/*<>*/
@end

@implementation LSMemberRechargeRuleEditViewController

- (instancetype)init:(NSInteger)type vo:(id)obj callBack:(RechargeRuleHandleBlock)block {
    
    self = [super init];
    if (self) {
        
        self.actionType = type;
        self.callBackBlock = block;
        self.ruleVo = (LSMemberRechargeRuleVo *)obj;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self initNavigate];
    [self confingSubView];
    [self fillData];
    [self configHelpButton:HELP_MEMBER_RECHARGE_PROMOTIONS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)confingSubView {
    
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0, self.titleBox.ls_bottom, SCREEN_W, SCREEN_H - self.titleBox.ls_bottom)];
        self.scrollView.backgroundColor  = [UIColor clearColor];
        [self.view addSubview:self.scrollView];
    }
    
    CGFloat topY = 0.0;
    if (!self.cardType) {
        
        self.cardType = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.cardType initLabel:@"卡类型" withHit:@"" isrequest:NO type:0];
        [self.cardType initData:self.ruleVo.kindCardName];
        [self.cardType editEnabled:NO];
        [self.scrollView addSubview:self.cardType];
    }
    self.cardType.ls_top = topY;
    topY += 48.0f;
    
    if (!self.rechargeMoney) {
        
        self.rechargeMoney = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.rechargeMoney initLabel:@"充值金额(元)" withHit:@"" isrequest:YES delegate:self];
        [self.rechargeMoney initData:@"" withVal:@""];
        [self.scrollView addSubview:self.rechargeMoney];
    }
    self.rechargeMoney.ls_top = topY;
    topY += 48.0;
    
    if (!self.presentMoney) {
        
        self.presentMoney = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.presentMoney initLabel:@"赠送金额(元)" withHit:@"" delegate:self];
        [self.presentMoney initData:@"0.00" withVal:@"0.00"];
        [self.scrollView addSubview:self.presentMoney];
    }
    self.presentMoney.ls_top = topY;
    topY += 48.0;

    
    if (!self.presentIntegral) {
        
        self.presentIntegral = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.presentIntegral initLabel:@"赠送积分" withHit:@"" delegate:self];
        [self.presentIntegral initData:@"0" withVal:@"0"];
        [self.scrollView addSubview:self.presentIntegral];
    }
    self.presentIntegral.ls_top = topY;
    topY += 48.0;
    
    if (!self.noticeLabel) {
       
        self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W-20.0, 116.0)];
        self.noticeLabel.textColor = [ColorHelper getTipColor6];
        self.noticeLabel.font = [UIFont systemFontOfSize:13.0];
        self.noticeLabel.numberOfLines = 0;
        self.noticeLabel.text = PrimeRechargeSetNoticeString;
        [self.scrollView addSubview:self.noticeLabel];
    }
    self.noticeLabel.ls_top = topY;
    topY = self.noticeLabel.ls_bottom + 20.0;
    
    
    if (!self.ensureButton && self.actionType == ACTION_CONSTANTS_EDIT) {
        
        self.ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ensureButton setTitle:@"删除" forState:0];
        [self.ensureButton setBackgroundColor:[ColorHelper getRedColor]];
        [self.ensureButton.titleLabel setTextColor:RGB(192, 0, 0)];
        [self.ensureButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        self.ensureButton.frame = CGRectMake(12, topY + 5.0, SCREEN_W - 24, 44);
        self.ensureButton.layer.cornerRadius = 4.0;
        [self.scrollView addSubview:self.ensureButton];
        topY = self.ensureButton.ls_bottom + 30.0f;
    }

    
    if (self.scrollView.ls_height < topY) {
        [self.scrollView setContentSize:CGSizeMake(SCREEN_W, topY + 30)];
    }
}

- (void)deleteAction:(UIButton *)sender {
    NSString *statusString = [NSString stringWithFormat:@"确认要删除[每充值%@元送%@元]吗?" ,self.ruleVo.condition,self.ruleVo.rule];
    [LSAlertHelper showAlert:@"提示" message:statusString cancle:@"取消" block:nil ensure:@"确定" block:^{
        [self deleteRechargeRule];
    }];
}

#pragma mark - NavigateTitle2 代理

- (void)initNavigate {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    if (self.actionType == ACTION_CONSTANTS_ADD) {
        [self.titleBox initWithName:@"添加优惠设置" backImg:Head_ICON_BACK moreImg:nil];
        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_ADD];
    }
    else {
        [self.titleBox initWithName:@"编辑优惠设置" backImg:Head_ICON_BACK moreImg:nil];
    }
    [self.view addSubview:self.titleBox];
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
        if (self.actionType == ACTION_CONSTANTS_ADD) {
            [self saveNewRechargeRule];
        }
        else if (self.actionType == ACTION_CONSTANTS_EDIT) {
            [self updateRechargeRule];
        }
    }
}

#pragma mark - 协议
// IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj {
    
    if ([obj isEqual:self.rechargeMoney]) {
        
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:YES event:kRechargeMoney];
    }
    else if ([obj isEqual:self.presentMoney]) {
        
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:YES event:kPresentMoney];
    }
    else if ([obj isEqual:self.presentIntegral]) {
        
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:8 digitLimit:0];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:YES event:kPresentIntegral];
    }
}

// SymbolNumberInputClient
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    
    
    if (eventType == kRechargeMoney) {
        
        NSString *result = [val formatWith2FractionDigits];
        [self.rechargeMoney changeData:result withVal:result];
//        self.ruleVo.condition = [val convertToNumber];
    }
    else if (eventType == kPresentMoney) {
        
        NSString *result = [val formatWith2FractionDigits];
        [self.presentMoney changeData:result withVal:result];
//        self.ruleVo.rule = [val convertToNumber];
    }
    else if (eventType == kPresentIntegral) {
        [self.presentIntegral changeData:val withVal:val];
//        self.ruleVo.giftDegree = [val convertToNumber];
    }
    
    if (self.actionType == ACTION_CONSTANTS_EDIT) {
        
        if (self.rechargeMoney.baseChangeStatus || self.presentMoney.baseChangeStatus || self.presentIntegral.baseChangeStatus) {
            
            [self.titleBox editTitle:YES act:ACTION_CONSTANTS_ADD];
        }
        else {
            [self.titleBox editTitle:NO act:0];
        }
    }
}

#pragma mark - 数据处理

- (void)fillData {
    
    if (self.actionType == ACTION_CONSTANTS_EDIT) {
        NSString *rechargeMoney = [self.ruleVo.condition convertToStringWithFormat:@"###,##0.00"];
        [self.rechargeMoney initData:rechargeMoney withVal:rechargeMoney];
        NSString *presentMoney = [self.ruleVo.rule convertToStringWithFormat:@"###,##0.00"];
        [self.presentMoney initData:presentMoney withVal:presentMoney];
        [self.presentIntegral initData:self.ruleVo.giftDegree.stringValue withVal:self.ruleVo.giftDegree.stringValue];
    }
}

// 
- (void)saveData {
    self.ruleVo.condition = [[self.rechargeMoney getStrVal] convertToNumber];
    self.ruleVo.rule = [[self.presentMoney getStrVal] convertToNumber];
    self.ruleVo.giftDegree = [[self.presentIntegral getStrVal] convertToNumber];
}

#pragma mark - 网络请求
// 新增充值优惠
- (void)saveNewRechargeRule {

    if ([self isVaild]) {
        [self saveData];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
        [param setValue:[self.ruleVo rechargeRuleVoJsonString] forKey:@"moneyRuleStr"];
        
        [BaseService getRemoteLSOutDataWithUrl:@"moneyRule/save" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
            if ([json[@"code"] boolValue]) {
                if (self.callBackBlock) {
                    self.callBackBlock(ACTION_CONSTANTS_ADD);
                    [self popToLatestViewController:kCATransitionFromLeft];
                }
            }

        } errorHandler:^(id json) {
            [LSAlertHelper showAlert:json block:nil];
        }];
    }
}

// 更新优惠设置
- (void)updateRechargeRule {
    
    if ([self isVaild]) {
        [self saveData];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
        [param setValue:[self.ruleVo rechargeRuleVoJsonString] forKey:@"moneyRuleStr"];
        [BaseService getRemoteLSOutDataWithUrl:@"moneyRule/update" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
            if ([json[@"code"] boolValue]) {
                if (self.callBackBlock) {
                    self.callBackBlock(ACTION_CONSTANTS_EDIT);
                    [self popToLatestViewController:kCATransitionFromLeft];
                }
            }

        } errorHandler:^(id json) {
            [LSAlertHelper showAlert:json block:nil];
        }];
    }
}

// 删除优惠设置
- (void)deleteRechargeRule {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:self.ruleVo.sId forKey:@"id"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"moneyRule/delete" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            
            if (self.callBackBlock) {
                self.callBackBlock(ACTION_CONSTANTS_DEL);
                [self popToLatestViewController:kCATransitionFromLeft];
            }
        }

    } errorHandler:^(id json) {
         [LSAlertHelper showAlert:json block:nil];
    }];
}

#pragma mark - 相关check

- (BOOL)isVaild {
    
    if ([NSString isBlank:self.rechargeMoney.currentVal]) {
        [LSAlertHelper showAlert:@"充值金额不能为空！" block:nil];
        return NO;
    }
    else if (self.rechargeMoney.currentVal.floatValue <= 0) {
        [LSAlertHelper showAlert:@"充值金额不能为0！" block:nil];
        return NO;
    }
    return YES;
}

- (BOOL)hasChanged {
    if (self.rechargeMoney.baseChangeStatus || self.presentMoney.baseChangeStatus || self.presentIntegral.baseChangeStatus) {
        return YES;
    }
    return NO;
}

@end
