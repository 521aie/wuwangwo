//
//  CardCancelEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CardCancelEditView.h"
#import "UIHelper.h"
#import "NavigateTitle2.h"
#import "MemberModule.h"
#import "EditItemText.h"
#import "MemberModuleEvent.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "MemberRender.h"
#import "CardCancelVo.h"
#import "EditItemList.h"
#import "XHAnimalUtil.h"
#import "SymbolNumberInputBox.h"
#import "MemberSelectListView.h"

@interface CardCancelEditView ()

@property (nonatomic, strong) MemberService* memberService;

@property (nonatomic, strong) CardCancelVo *cardCancelVo;

@property (nonatomic, strong) NSString *customerId;

@property (nonatomic, copy) NSString *token;

@end

@implementation CardCancelEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil customerId:(NSString *)customerId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _customerId = customerId;
        _memberService = [ServiceFactory shareInstance].memberService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self initMainView];
    [self loaddatas];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loaddatas
{
    [self.scrollView setContentOffset:CGPointMake(0, 0)animated:YES];
    __weak CardCancelEditView* weakSelf = self;
    [_memberService selectCardCancelDetail:_customerId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


- (void)responseSuccess:(id)json
{
    self.cardCancelVo = [JsonHelper dicTransObj:[json objectForKey:@"cardCancelVo"] obj:[CardCancelVo new]];
    
    self.titleBox.lblTitle.text = self.cardCancelVo.customerName;
    [self fillModel];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) fillModel
{
    [self.txtCardCode initData:self.cardCancelVo.code];
    
    [self.txtMemberName initData:self.cardCancelVo.customerName];
    
    [self.txtmobile initData:self.cardCancelVo.mobile];
    
    [self.txtKindCardName initData:self.cardCancelVo.kindCardName];
    
    [self.txtRealBalance initData:[NSString stringWithFormat:@"%.2f", self.cardCancelVo.realBalance]];
    
    [self.txtGiftBalance initData:[NSString stringWithFormat:@"%.2f", self.cardCancelVo.giftBalance]];
    
    [self.txtConsumeAmount initData:[NSString stringWithFormat:@"%.2f", self.cardCancelVo.consumeAmount]];
    
    [self.txtBalance initData:[NSString stringWithFormat:@"%.2f", self.cardCancelVo.balance]];
    
    if ([NSString stringWithFormat:@"%.ld", self.cardCancelVo.degreeAmount] == nil || [[NSString stringWithFormat:@"%.ld", self.cardCancelVo.degreeAmount] isEqualToString:@""]) {
        [self.txtDegreeAmount initData:@"0"];
    }else{
        [self.txtDegreeAmount initData:[NSString stringWithFormat:@"%.ld", self.cardCancelVo.degreeAmount]];
    }
    
    
    [self.txtMemo initData:@""];
}

-(void) initMainView
{
    [self.txtCardCode initLabel:@"会员卡号" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtCardCode editEnabled:NO];
    
    [self.txtMemberName initLabel:@"会员名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtMemberName editEnabled:NO];
    
    [self.txtmobile initLabel:@"手机号码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtmobile editEnabled:NO];
    
    [self.txtKindCardName initLabel:@"卡类型" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtKindCardName editEnabled:NO];
    
    [self.txtRealBalance initLabel:@"累计充值(元)" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtRealBalance editEnabled:NO];
    
    [self.txtGiftBalance initLabel:@"累计赠送(元)" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtGiftBalance editEnabled:NO];
    
    [self.txtConsumeAmount initLabel:@"累计消费(元)" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtConsumeAmount editEnabled:NO];
    
    [self.txtBalance initLabel:@"卡内余额(元)" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtBalance editEnabled:NO];
    
    [self.txtDegreeAmount initLabel:@"卡内积分" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtDegreeAmount editEnabled:NO];
    
    [self.lsAmount initLabel:@"实退金额(元)" withHit:nil isrequest:YES delegate:self];
    
    [self.txtMemo initLabel:@"备注" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtMemo initMaxNum:100];
    
    self.lsAmount.tag = CARD_CANCEL_EDIT_AMOUNT;
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void) onItemListClick:(EditItemList *)obj
{
    if (obj.tag == CARD_CANCEL_EDIT_AMOUNT) {
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
    }
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (val.intValue > 999999) {
        [AlertBox show:@"输入的实退金额(元)整数位不能超过6位!"];
        return;
    }
    
    if (eventType==CARD_CANCEL_EDIT_AMOUNT) {
        
        if (val.doubleValue>=999999.99) {
            
            val = @"999999.99";
            
        }else{
            
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
        
        [self.lsAmount changeData:val withVal:val];
        
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(IBAction)btnCancelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要退卡[%@]吗？",self.cardCancelVo.customerName]];
}

//退卡确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        if (![self isValid]){
            return;
        }
        
        if ([NSString isBlank:_token]) {
            _token = [[Platform Instance] getToken];
        }
        
        __weak CardCancelEditView* weakSelf = self;
        [_memberService doCardCancel:weakSelf.cardCancelVo.cardId lastVer:[NSString stringWithFormat:@"%ld", weakSelf.cardCancelVo.lastVer] amount:[weakSelf.lsAmount getStrVal] mobile:weakSelf.cardCancelVo.mobile customerName:weakSelf.cardCancelVo.customerName comments:[weakSelf.txtMemo getStrVal] token:weakSelf.token completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            weakSelf.token = nil;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MemberSelectListView class]]) {
                    MemberSelectListView *listView = (MemberSelectListView *)vc;
                    [listView loaddatasFromEdit];
                }
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

#pragma save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.lsAmount getStrVal]]) {
        [AlertBox show:@"实退金额不能为空，请输入!"];
        return NO;
    }
    
    if ([self.lsAmount getStrVal].doubleValue > [self.txtBalance getStrVal].doubleValue) {
        [AlertBox show:@"实退金额不能大于卡内余额，请重新输入!"];
        return NO;
    }
    return YES;
}

-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

@end
