//
//  CardLossEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CardLossEditView.h"
#import "UIHelper.h"
#import "NavigateTitle2.h"
#import "CardVo.h"
#import "DateUtils.h"
#import "MemberModule.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "EditItemText.h"
#import "MemberModuleEvent.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "MemberRender.h"
#import "XHAnimalUtil.h"
#import "MemberSelectListView.h"

@interface CardLossEditView ()

@property (nonatomic, strong) MemberService* memberService;

@property (nonatomic, strong) CustomerVo *customerVo;

@property (nonatomic, strong) NSString* customerId;

@end

@implementation CardLossEditView

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
    
    __weak CardLossEditView* weakSelf = self;
    [_memberService selectMemberInfoDetail:_customerId completionHandler:^(id json) {
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
    self.customerVo = [JsonHelper dicTransObj:[json objectForKey:@"customer"] obj:[CustomerVo new]];
    
    self.titleBox.lblTitle.text = self.customerVo.name;
    if (![self.customerVo.card.status isEqualToString:@"1"]) {
        [self.btnDel setTitle:@"激活" forState:UIControlStateNormal];
        self.btnDel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_g.png"] forState:UIControlStateNormal];
    }else{
        [self.btnDel setTitle:@"挂失" forState:UIControlStateNormal];
        self.btnDel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];

    }
    
    [self fillModel];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) fillModel
{
    [self.txtCardCode initData:self.customerVo.card.code];
    
    [self.txtMemberName initData:self.customerVo.name];
    
    [self.txtmobile initData:self.customerVo.mobile];
    
    [self.txtKindCardName initData:self.customerVo.card.kindCardName];
    
    [self.txtStatus initData:[MemberRender obtainCardStatus:self.customerVo.card.status]];
    
    [self.txtBalance initData:[NSString stringWithFormat:@"%.2f", self.customerVo.card.balance]];
    
    [self.txtPoint initData:[NSString stringWithFormat:@"%ld", (long)self.customerVo.card.point]];
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
    
    [self.txtStatus initLabel:@"卡状态" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtStatus editEnabled:NO];
    
    [self.txtBalance initLabel:@"卡内余额(元)" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtBalance editEnabled:NO];
    
    [self.txtPoint initLabel:@"卡内积分" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtPoint editEnabled:NO];
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

-(IBAction)cardLoss:(id)sender
{
    if (![self.customerVo.card.status isEqualToString:@"1"]) {
        [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要激活[%@]吗？",self.customerVo.name]];
    } else {
        [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要挂失[%@]吗？",self.customerVo.name]];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        __weak CardLossEditView* weakSelf = self;
        if ([self.customerVo.card.status isEqualToString:@"1"]) {
            [_memberService doCardLoss:self.customerVo.card.cardId lastVer:[NSString stringWithFormat:@"%.ld", self.customerVo.card.lastVer] operate:@"loss" code:self.customerVo.card.code mobile:self.customerVo.mobile completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[MemberSelectListView class]]) {
                        MemberSelectListView *listView = (MemberSelectListView *)vc;
                        [listView loaddatasFromCardLossEditView:@"loss"];
                    }
                }
                [self.navigationController popViewControllerAnimated:NO];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else{
            [_memberService doCardLoss:self.customerVo.card.cardId lastVer:[NSString stringWithFormat:@"%.ld", self.customerVo.card.lastVer] operate:@"activation" code:self.customerVo.card.code mobile:self.customerVo.mobile completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[MemberSelectListView class]]) {
                        MemberSelectListView *listView = (MemberSelectListView *)vc;
                        [listView loaddatasFromCardLossEditView:@"activation"];
                    }
                }
                [self.navigationController popViewControllerAnimated:NO];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }
}

@end
