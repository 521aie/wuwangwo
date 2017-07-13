//
//  MemberRechargeEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberRechargeEditView.h"
#import "MemberModule.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "EditItemText.h"
#import "EditItemList.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "MemberModuleEvent.h"
#import "OptionPickerBox.h"
#import "MemberRender.h"
#import "SaleRechargeVo.h"
#import "CustomerCardVo.h"
#import "SymbolNumberInputBox.h"
#import "DateUtils.h"
#import "MemberSelectListView.h"
#import "PaymentVo.h"
#import "NameItemVO.h"
#import "ObjectUtil.h"
@interface MemberRechargeEditView ()

@property (nonatomic, strong) MemberService* memberService;

@property (nonatomic, strong) SettingService *settingservice;

@property (nonatomic) int action;

@property (nonatomic, strong) CustomerVo *customerVo;

@property (nonatomic, strong) NSString *customerId;

@property (nonatomic, strong) SaleRechargeVo *temp;

@property (nonatomic, strong) NSMutableArray *saleRechargeList;

@property (nonatomic, copy) NSString *token;

@end

@implementation MemberRechargeEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil customerId:(NSString *)customerId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _customerId = customerId;
        _memberService = [ServiceFactory shareInstance].memberService;
        _settingservice = [ServiceFactory shareInstance].settingService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHead];
    [self initMainView];
    [self loaddatas];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.scrollView];
    [UIHelper clearColor:self.container];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loaddatas
{
    __weak MemberRechargeEditView* weakSelf = self;
    [_memberService selectRechargeSalesList:@"1" completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        self.saleRechargeList = [JsonHelper transList:[json objectForKey:@"saleRechargeList"] objName:@"SaleRechargeVo"];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    [_memberService selectMemberInfoDetail:_customerId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    self.customerVo = [JsonHelper dicTransObj:[json objectForKey:@"customer"] obj:[CustomerVo new]];
    
    self.titleBox.lblTitle.text = self.customerVo.name;
    
    [self fillModel];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}



-(void) fillModel
{
    [self.txtCardCode initData:self.customerVo.card.code];
    
    [self.txtMemberName initData:self.customerVo.name];
    
    [self.txtMobile initData:self.customerVo.mobile];
    
    [self.txtKindCardName initData:self.customerVo.card.kindCardName];
    
    [self.txtBalance initData:[NSString stringWithFormat:@"%.2f", self.customerVo.card.balance]];
    if (self.customerVo.card.point == 0) {
        [self.txtDegree initData:@"0"];
    }else{
        [self.txtDegree initData:[NSString stringWithFormat:@"%.tu", self.customerVo.card.point]];
    }
    
    [self.lsRechargeKind initData:@"请选择" withVal:@""];
    
    [self.lsRechargeMoney initData:@"" withVal:@""];
    
    [self.txtPresentMoney initData:@"0.00"];
    
    [self.txtPresentPoint initData:@"0"];
    
//    [self.lsPayMode initData:@"现金" withVal:@"5"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    __weak MemberRechargeEditView* weakSelf = self;
    [_settingservice payMentList:arr completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        NSArray *list = json[@"payMentVoList"];
        NSMutableArray* payModeList = [JsonHelper transList:list objName:@"PaymentVo"];
        payModeList = [MemberRender listPayMode:payModeList];
        if ([ObjectUtil isNotEmpty:payModeList]) {
            NameItemVO *item = [payModeList objectAtIndex:0];
            [weakSelf.lsPayMode initData:[item obtainItemName] withVal:[item obtainItemId]];
        } else {
            [weakSelf.lsPayMode initData:@"请选择" withVal:nil];
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:self.customerVo.name backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void) initMainView
{
    [self.txtCardCode initLabel:@"会员卡号" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtCardCode editEnabled:NO];
    
    [self.txtMemberName initLabel:@"会员名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtMemberName editEnabled:NO];
    
    [self.txtMobile initLabel:@"手机号码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtMobile editEnabled:NO];
    
    [self.txtKindCardName initLabel:@"卡类型" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtKindCardName editEnabled:NO];
    
    [self.txtBalance initLabel:@"卡内余额(元)" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtBalance editEnabled:NO];
    
    [self.txtDegree initLabel:@"卡内积分" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtDegree editEnabled:NO];
    
    [self.lsRechargeKind initLabel:@"充值类型" withHit:nil delegate:self];
    
    [self.lsRechargeMoney initLabel:@"充值金额(元)" withHit:nil isrequest:YES delegate:self];
    
    [self.txtPresentMoney initLabel:@"赠送金额(元)" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtPresentMoney editEnabled:NO];
    
    [self.txtPresentPoint initLabel:@"赠送积分" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtPresentPoint editEnabled:NO];
    
    [self.lsPayMode initLabel:@"支付方式" withHit:nil delegate:self];
    
    self.lsRechargeKind.tag = MEMBER_RECHARGE_EDIT_RECHARGEKIND;
    self.lsPayMode.tag = MEMBER_RECHARGE_EDIT_PAYMODE;
    self.lsRechargeMoney.tag = MEMBER_RECHARGE_EDIT_RECHARGEMONEY;
}

-(void) onItemListClick:(EditItemList *)obj
{
    if (obj.tag == MEMBER_RECHARGE_EDIT_RECHARGEKIND) {
        [OptionPickerBox initData:[MemberRender listSaleRecharge:self.saleRechargeList] itemId:[obj getStrVal]];
        [OptionPickerBox showManager:obj.lblName.text managerName:@"清空类型" client:self event:obj.tag];
        [OptionPickerBox changeImgManager:@"setting_data_clear.png"];
    }else if (obj.tag == MEMBER_RECHARGE_EDIT_PAYMODE){
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        __weak MemberRechargeEditView* weakSelf = self;
        [_settingservice payMentList:arr completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSArray *list = json[@"payMentVoList"];
            NSMutableArray* payModeList = [JsonHelper transList:list objName:@"PaymentVo"];
            [OptionPickerBox initData:[MemberRender listPayMode:payModeList] itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else if (obj.tag == MEMBER_RECHARGE_EDIT_RECHARGEMONEY){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }
}

-(void) managerOption:(NSInteger)eventType
{
    if (eventType == MEMBER_RECHARGE_EDIT_RECHARGEKIND) {
        [self.lsRechargeKind changeData:@"请选择" withVal:@""];
        [self.txtPresentMoney initData:@"0.00"];
        [self.txtPresentPoint initData:@"0"];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>) selectObj;
    if (eventType == MEMBER_RECHARGE_EDIT_RECHARGEKIND) {
        [self.lsRechargeKind changeData:[item obtainItemName] withVal:[item obtainItemId]];
        for (SaleRechargeVo* vo in self.saleRechargeList) {
            if (vo.saleRechargeId == [item obtainItemId]) {
                self.temp = vo;
                break;
            }
        }
        if ([NSString isBlank:[self.lsRechargeMoney getStrVal]] || [self.lsRechargeMoney getStrVal].doubleValue >= self.temp.rechargeThreshold) {
            [self.lsRechargeMoney initData:[NSString stringWithFormat:@"%.2f", self.temp.rechargeThreshold] withVal:[NSString stringWithFormat:@"%.2f", self.temp.rechargeThreshold]];
            [self.txtPresentMoney initData:[NSString stringWithFormat:@"%.2f", self.temp.money]];
            if ([NSString isBlank:[NSString stringWithFormat:@"%tu", self.temp.point]]) {
                [self.txtPresentPoint initData:@"0"];
            }else{
                [self.txtPresentPoint initData:[NSString stringWithFormat:@"%tu", self.temp.point]];
            }
        }else{
            [self.lsRechargeMoney initData:nil withVal:nil];
            [self.txtPresentMoney initData:@"0.00"];
            [self.txtPresentPoint initData:@"0"];
        }
    }else if (eventType == MEMBER_RECHARGE_EDIT_PAYMODE) {
        [self.lsPayMode changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

-(void) numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if ([NSString isBlank:val]) {
        val = @"";
    }else{
        val = [NSString stringWithFormat:@"%.2f", val.doubleValue];
    }
    if (eventType == MEMBER_RECHARGE_EDIT_RECHARGEMONEY) {
        [self.lsRechargeMoney changeData:val withVal:val];
        if (![NSString isBlank:[self.lsRechargeKind getStrVal]]) {
            if (val.doubleValue >= self.temp.rechargeThreshold) {
                [self.txtPresentMoney initData:[NSString stringWithFormat:@"%.2f", self.temp.money]];
                if ([NSString isBlank:[NSString stringWithFormat:@"%.ld", self.temp.point]]) {
                    [self.txtPresentPoint initData:@"0"];
                }else{
                    [self.txtPresentPoint initData:[NSString stringWithFormat:@"%.ld", self.temp.point]];
                }
            }else{
                [self.txtPresentMoney initData:@"0.00"];
                [self.txtPresentPoint initData:@"0"];
            }
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark 充值按钮点击
-(IBAction)btnRecClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:@"确认要充值吗?"];
}

-(BOOL) isValid
{
    if ([NSString isBlank:[self.lsRechargeMoney getStrVal]]) {
        [AlertBox show:@"充值金额不能为空，请输入!"];
        return NO;
    }
    
    if ([self.lsRechargeMoney getStrVal].doubleValue == 0) {
        [AlertBox show:@"充值金额必须大于0，请重新输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsPayMode getStrVal]]) {
        [AlertBox show:@"支付方式不能为空，请选择!"];
        return NO;
    }
    return YES;
    
}

//充值确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        if (![self isValid]) {
            return;
        }
        
        if ([NSString isBlank:_token]) {
            _token = [[Platform Instance] getToken];
        }
        
        __weak MemberRechargeEditView* weakSelf = self;
        [_memberService doRecharge:weakSelf.customerVo.card.cardId lastVer:[NSString stringWithFormat:@"%.ld", weakSelf.customerVo.card.lastVer] amount:[weakSelf.lsRechargeMoney getStrVal] presentAmount:[weakSelf.txtPresentMoney getStrVal] presentPoint:[weakSelf.txtPresentPoint getStrVal] rechargeRuleId:[weakSelf.lsRechargeKind getStrVal] chargeTime:[NSString stringWithFormat:@"%.lld",[DateUtils formateDateTime2:[DateUtils formateDate3:[NSDate date]]]] payMode:[weakSelf.lsPayMode getStrVal] token:_token completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            weakSelf.token = nil;
            [weakSelf recFinish];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)recFinish
{
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
