//
//  MemberRechargeSalesEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberRechargeSalesEditView.h"
#import "MemberModule.h"
#import "UIHelper.h"
#import "EditItemText.h"
#import "EditItemList.h"
#import "DateUtils.h"
#import "ObjectUtil.h"
#import "NSString+Estimate.h"
#import "XHAnimalUtil.h"
#import "MemberModuleEvent.h"
#import "DatePickerBox.h"
#import "INameItem.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "SaleRechargeVo.h"
#import "MemberRechargeSalesView.h"
#import "SymbolNumberInputBox.h"

@interface MemberRechargeSalesEditView ()

@property (nonatomic, strong) MemberService* memberService;

@property(nonatomic, strong) SaleRechargeVo *memberSalesRechargeVo;

@property (nonatomic, strong) NSString* saleRechargeId;

@property (nonatomic) int action;

@end

@implementation MemberRechargeSalesEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil saleRechargeId:(NSString *)saleRechargeId action:(int)action
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _saleRechargeId = saleRechargeId;
        _action = action;
        _memberService = [ServiceFactory shareInstance].memberService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotifaction];
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
    [self.btnDel setHidden:_action == ACTION_CONSTANTS_ADD];
    if (_action==ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text = @"添加";
        [self clearDo];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }else{
        __weak MemberRechargeSalesEditView* weakSelf = self;
        [_memberService selectRechargeSalesDetail:_saleRechargeId completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [weakSelf responseSuccess:json];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
    
    
}

#pragma 后台数据返回封装
- (void)responseSuccess:(id)json
{
    self.memberSalesRechargeVo = [SaleRechargeVo convertToSaleRecharge:[json objectForKey:@"saleRecharge"]];
    self.titleBox.lblTitle.text = self.memberSalesRechargeVo.name;
    [self fillModel];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 导航栏事件
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

#pragma 添加页面初始化
-(void)clearDo
{
    //活动名称
    [self.txtName initData:nil];
    
    NSString* dateStr = [DateUtils formateDate2:[NSDate date]];
    //开始时间
    [self.lsStartTime initData:dateStr withVal:dateStr];
    //结束时间
    [self.lsEndTime initData:dateStr withVal:dateStr];
    //充值金额
    [self.lsRechargeThreshold initData:@"" withVal:@""];
    //赠送金额
    [self.lsMoney initData:@"" withVal:@""];
    //赠送积分
    [self.lsPoint initData:@"" withVal:@""];
    
}

-(void)fillModel
{
    //活动名称
    [self.txtName initData:self.memberSalesRechargeVo.name];
    
    NSString* startDate=[DateUtils formateTime2:self.memberSalesRechargeVo.startTime];
    //开始时间
    [self.lsStartTime initData:startDate withVal:startDate];
    NSString* endDate=[DateUtils formateTime2:self.memberSalesRechargeVo.endTime];
    //结束时间
    [self.lsEndTime initData:endDate withVal:endDate];
    //充值金额
    [self.lsRechargeThreshold initData:[NSString stringWithFormat:@"%.2f", self.memberSalesRechargeVo.rechargeThreshold] withVal:[NSString stringWithFormat:@"%.2f", self.memberSalesRechargeVo.rechargeThreshold]];
    //赠送金额
    [self.lsMoney initData:[NSString stringWithFormat:@"%.2f", self.memberSalesRechargeVo.money] withVal:[NSString stringWithFormat:@"%.2f", self.memberSalesRechargeVo.money]];
    //赠送积分
    [self.lsPoint initData:[NSString stringWithFormat:@"%ld", self.memberSalesRechargeVo.point] withVal:[NSString stringWithFormat:@"%ld", self.memberSalesRechargeVo.point]];
}

#pragma 页面初始化
-(void) initMainView
{
    //活动名称
    [self.txtName initLabel:@"活动名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtName initMaxNum:50];
    //开始时间
    [self.lsStartTime initLabel:@"开始时间" withHit:nil delegate:self];
    //结束时间
    [self.lsEndTime initLabel:@"结束时间" withHit:nil delegate:self];
    //充值金额
    [self.lsRechargeThreshold initLabel:@"充值金额" withHit:nil isrequest:YES delegate:self];
    //赠送金额
    [self.lsMoney initLabel:@"赠送金额" withHit:nil isrequest:NO delegate:self];
    //赠送积分
    [self.lsPoint initLabel:@"赠送积分" withHit:nil isrequest:NO delegate:self];
    
    self.lsStartTime.tag = MEMBER_RECHARGE_SALES_EDIT_STARTTIME;
    self.lsEndTime.tag = MEMBER_RECHARGE_SALES_EDIT_ENDTIME;
    self.lsRechargeThreshold.tag = MEMBER_RECHARGE_SALES_EDIT_RECHARGETHRESHOLD;
    self.lsMoney.tag = MEMBER_RECHARGE_SALES_EDIT_MONEY;
    self.lsPoint.tag = MEMBER_RECHARGE_SALES_EDIT_POINT;
    
}

#pragma 下拉框事件
-(void) onItemListClick:(EditItemList *)obj
{
    if (obj.tag == MEMBER_RECHARGE_SALES_EDIT_STARTTIME || obj.tag == MEMBER_RECHARGE_SALES_EDIT_ENDTIME) {
        NSDate *date=[DateUtils parseDateTime4:obj.lblVal.text];
        
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }else if (obj.tag == MEMBER_RECHARGE_SALES_EDIT_RECHARGETHRESHOLD){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }else if (obj.tag == MEMBER_RECHARGE_SALES_EDIT_MONEY){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }else if (obj.tag == MEMBER_RECHARGE_SALES_EDIT_POINT){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:8 digitLimit:0];
    }
}

//选择日期
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    if (event == MEMBER_RECHARGE_SALES_EDIT_STARTTIME) {
        
        NSString *dateStr=[DateUtils formateDate2:date];
        [self.lsStartTime changeData:dateStr withVal:dateStr];
   
    }else if (event == MEMBER_RECHARGE_SALES_EDIT_ENDTIME){
        
        NSString* dateStr=[DateUtils formateDate2:date];
        [self.lsEndTime changeData:dateStr withVal:dateStr];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

-(void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    
    if (eventType==MEMBER_RECHARGE_SALES_EDIT_POINT) {
        
        if ([NSString isBlank:val]) {
            val = @"";
            
        }else {
            
            val = [NSString stringWithFormat:@"%d",val.intValue];
        }
        
        [self.lsPoint changeData:val withVal:val];
        
    }else {
        
        if (eventType==MEMBER_RECHARGE_SALES_EDIT_RECHARGETHRESHOLD) {

            if ([NSString isBlank:val]) {
                
                val = @"";
                
            }else{
                
                val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
            }
            
            [self.lsRechargeThreshold changeData:val withVal:val];
        }else if (eventType==MEMBER_RECHARGE_SALES_EDIT_MONEY){
            
            if ([NSString isBlank:val]) {
                
                val = @"";
                
            }else{
                
                val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
            }
            
            [self.lsMoney changeData:val withVal:val];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_MemberRechargeSalesEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_MemberRechargeSalesEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

#pragma 导航栏事件
-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        if (self.action == ACTION_CONSTANTS_ADD) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        } else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

#pragma 保存事件
-(void) save
{
    if (![self isValid]) {
        return ;
    }
    
    __weak MemberRechargeSalesEditView* weakSelf = self;
    if (self.action == ACTION_CONSTANTS_ADD) {
        self.memberSalesRechargeVo = [[SaleRechargeVo alloc] init];
        self.memberSalesRechargeVo.name = [self.txtName getStrVal];
        self.memberSalesRechargeVo.startTime = [DateUtils formateDateTime3:[self.lsStartTime getStrVal]];
        self.memberSalesRechargeVo.endTime = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59", [self.lsEndTime getStrVal]]] ;
        self.memberSalesRechargeVo.rechargeThreshold = [self.lsRechargeThreshold getStrVal].doubleValue;
        self.memberSalesRechargeVo.money = [self.lsMoney getStrVal].doubleValue;
        self.memberSalesRechargeVo.point = [self.lsPoint getStrVal].integerValue;
        [_memberService saveRechargeSales:@"add" saleRecharge:self.memberSalesRechargeVo completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MemberRechargeSalesView class]]) {
                    MemberRechargeSalesView *listView = (MemberRechargeSalesView *)vc;
                    [listView loadDatas];
                }
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popViewControllerAnimated:NO];
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else{
        self.memberSalesRechargeVo.name = [self.txtName getStrVal];
        self.memberSalesRechargeVo.startTime = [DateUtils formateDateTime3:[self.lsStartTime getStrVal]];
        self.memberSalesRechargeVo.endTime = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59", [self.lsEndTime getStrVal]]];
        self.memberSalesRechargeVo.rechargeThreshold = [self.lsRechargeThreshold getStrVal].doubleValue;
        self.memberSalesRechargeVo.money = [self.lsMoney getStrVal].doubleValue;
        self.memberSalesRechargeVo.point = [self.lsPoint getStrVal].integerValue;
        [_memberService saveRechargeSales:@"edit" saleRecharge:self.memberSalesRechargeVo completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MemberRechargeSalesView class]]) {
                    MemberRechargeSalesView *listView = (MemberRechargeSalesView *)vc;
                    [listView loadDatasFromEdit:_memberSalesRechargeVo action:ACTION_CONSTANTS_EDIT];
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
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:@"请输入会员充值促销活动名称!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsStartTime getStrVal]]) {
        [AlertBox show:@"选择开始日期!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsEndTime getStrVal]]) {
        [AlertBox show:@"选择结束日期!"];
        return NO;
    }
    
    if ([DateUtils formateDateTime3:[self.lsEndTime getStrVal]] < [DateUtils formateDateTime3:[DateUtils formateDate2:[NSDate date]]]) {
        [AlertBox show:@"结束日期不能小于当前日期，请重新选择!"];
        return NO;
    }
    
    if ([DateUtils formateDateTime3:[self.lsStartTime getStrVal]] > [DateUtils formateDateTime3:[self.lsEndTime getStrVal]]) {
        [AlertBox show:@"结束日期不能小于开始日期，请重新选择!"];
        return NO;
    }
    
    if ([self.lsRechargeThreshold getStrVal].doubleValue == 0) {
        [AlertBox show:@"充值金额必须大于0，请重新输入!"];
        return NO;
    }
    
    return YES;
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",self.memberSalesRechargeVo.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        __weak MemberRechargeSalesEditView* weakSelf = self;
        [_memberService delRechargeSales:self.memberSalesRechargeVo.saleRechargeId lastVer:[NSString stringWithFormat:@"%tu", self.memberSalesRechargeVo.lastVer] completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [self delFinish];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)delFinish
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MemberRechargeSalesView class]]) {
            MemberRechargeSalesView *listView = (MemberRechargeSalesView *)vc;
            [listView loadDatasFromEdit:self.memberSalesRechargeVo action:ACTION_CONSTANTS_DEL];
        }
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
