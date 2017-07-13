//
//  MemberTypeEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberTypeEditView.h"
#import "MemberModule.h"
#import "ServiceFactory.h"
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "EditItemText.h"
#import "UIHelper.h"
#import "MemberRender.h"
#import "NSString+Estimate.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "OptionPickerBox.h"
#import "IEditItemRadioEvent.h"
#import "MemberModuleEvent.h"
#import "KindCardVo.h"
#import "Platform.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "MemberTypeListView.h"
#import "SymbolNumberInputBox.h"

@interface MemberTypeEditView ()

@property (nonatomic, strong) MemberService* memberService;
@property (nonatomic) int action;
@property (nonatomic, strong) KindCardVo *kindCardVo;
@property (nonatomic, strong) NSString* kindCardId;
@end

@implementation MemberTypeEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil kindCardId:(NSString *)kindCardId action:(int)action {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _kindCardId = kindCardId;
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

#pragma 查询会员类型详情
- (void)loaddatas {
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)animated:YES];
    self.kindCardVo = [[KindCardVo alloc] init];
    [self.btnDel setHidden:_action == ACTION_CONSTANTS_ADD];
    if (_action == ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text = @"添加";
        [self clearDo];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }else{
        __weak MemberTypeEditView* weakSelf = self;
        [_memberService selectKindCardDetail:_kindCardId completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [self responseSuccess:json];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)responseSuccess:(id)json
{
    self.kindCardVo = [KindCardVo convertToKindCard:[json objectForKey:@"kindCardVo"]];
    self.titleBox.lblTitle.text = self.kindCardVo.kindCardName;
    [self fillModel];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 导航栏事件
- (void)initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

#pragma 添加页面初始化
- (void)clearDo
{
    //卡类名称
    [self.txtMemberTypeName initData:nil];
    //是否升级
    [self.rdoIsUpgrade initData:@"0"];
    //下一级卡类型
    [self.lsNextCardType visibal:NO];
    [self.lsNextCardType initData:@"请选择" withVal:@""];
    
    //升级所需积分
    [self.lsNeedIntegral visibal:NO];
    [self.lsNeedIntegral initData:@"" withVal:@""];
    
    //积分比例
    [self.lsIntegralRatio initData:@"" withVal:@""];
    //价格方案
    [self.lsPriceScheme initData:@"请选择" withVal:nil];
    //折扣比例
    [self.lsDiscountRatio visibal:NO];
    [self.lsDiscountRatio initData:@"" withVal:@""];
    
    //备注
    [self.txtMemo initData:nil];
}

#pragma 详情页面数据显示
- (void)fillModel
{
    //卡类名称
    [self.txtMemberTypeName initData:self.kindCardVo.kindCardName];
    
    //是否升级
    [self.rdoIsUpgrade initData:[NSString stringWithFormat:@"%d", self.kindCardVo.canUpgrade]];
    
    
    if ([[self.rdoIsUpgrade getStrVal] isEqualToString:@"0"]) {
        [self.lsNextCardType visibal:NO];
        [self.lsNeedIntegral visibal:NO];
        [self.lsNextCardType initData:@"请选择" withVal:@""];
    }else {
        [self.lsNextCardType visibal:YES];
        [self.lsNeedIntegral visibal:YES];
        [self.lsNextCardType initData:[MemberRender obtainKindCardName:self.kindCardVo.upKindCardId kindCardList:[[Platform Instance] getKindCardList]] withVal:self.kindCardVo.upKindCardId];
        //升级所需积分
        [self.lsNeedIntegral initData:[NSString stringWithFormat:@"%lu", self.kindCardVo.upPoint] withVal:[NSString stringWithFormat:@"%lu", self.kindCardVo.upPoint]];
    }
    
    [self.lsIntegralRatio initData:[NSString stringWithFormat:@"%.2f", self.kindCardVo.ratioExchangeDegree] withVal:[NSString stringWithFormat:@"%.2f", self.kindCardVo.ratioExchangeDegree]];
    
    //价格方案
    [self.lsPriceScheme initData:[MemberRender obtainPriceScheme:self.kindCardVo.mode] withVal:[NSString stringWithFormat:@"%d",self.kindCardVo.mode]];
    if (![[self.lsPriceScheme getStrVal] isEqualToString:@"3"]) {
        [self.lsDiscountRatio visibal:NO];
    }else{
        [self.lsDiscountRatio visibal:YES];
        //折扣比例
        [self.lsDiscountRatio initData:[NSString stringWithFormat:@"%.2f", self.kindCardVo.ratio] withVal:[NSString stringWithFormat:@"%.2f", self.kindCardVo.ratio]];
    }

    [self.txtMemo initData:self.kindCardVo.memo];
}

#pragma notification 处理.
- (void)initNotifaction
{
        [UIHelper initNotification:self.container event:Notification_UI_MemberTypeEditView_Change];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_MemberTypeEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification *)notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

#pragma 页面数据初始化
- (void)initMainView
{
    //卡类名称
    [self.txtMemberTypeName initLabel:@"名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtMemberTypeName initMaxNum:50];
    //是否升级
    [self.rdoIsUpgrade initLabel:@"此卡可升级" withHit:nil delegate:self];
    //下一级卡类型
    [self.lsNextCardType initLabel:@"▪︎ 下一级卡类型" withHit:nil delegate:self];
    //升级所需积分
    [self.lsNeedIntegral initLabel:@"▪︎ 升级所需积分" withHit:nil isrequest:YES delegate:self];
    //消费积分比例
    [self.lsIntegralRatio initLabel:@"消费积分比例" withHit:@"消费多少元兑换1积分" isrequest:YES delegate:self];
    //价格方案
    [self.lsPriceScheme initLabel:@"价格方案" withHit:nil delegate:self];
    
    //折扣比例(%)
    [self.lsDiscountRatio initLabel:@"▪︎ 折扣率(%)" withHit:nil isrequest:YES delegate:self];
    //备注
    [self.txtMemo initLabel:@"备注" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtMemo initMaxNum:50];
    self.rdoIsUpgrade.tag = MEMBER_TYPE_EDIT_ISUPGRADE;
    self.lsNextCardType.tag = MEMBER_TYPE_EDIT_NEXTCARDTYPE;
    self.lsPriceScheme.tag = MEMBER_TYPE_EDIT_PRICESCHEME;
    self.lsNeedIntegral.tag = MEMBER_TYPE_EDIT_NEEDINTEGRAL;
    self.lsIntegralRatio.tag = MEMBER_TYPE_EDIT_INTEGRALRATIO;
    self.lsDiscountRatio.tag = MEMBER_TYPE_EDIT_DISCOUNTRATIO;
}

#pragma mark 下拉框事件
- (void)onItemListClick:(EditItemList *)obj {
    
    if (obj.tag == MEMBER_TYPE_EDIT_NEXTCARDTYPE) {
        __weak MemberTypeEditView* weakSelf = self;
        [_memberService selectKindCardList:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list= [JsonHelper transList:[json objectForKey:@"kindCardList"] objName:@"KindCardVo"];
            [OptionPickerBox initData:[MemberRender listKindCardName2:list]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else if (obj.tag == MEMBER_TYPE_EDIT_PRICESCHEME) {
        [OptionPickerBox initData:[MemberRender listType]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag == MEMBER_TYPE_EDIT_NEEDINTEGRAL) {
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:8 digitLimit:0];
    }else if (obj.tag == MEMBER_TYPE_EDIT_INTEGRALRATIO) {
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }else if (obj.tag == MEMBER_TYPE_EDIT_DISCOUNTRATIO) {
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
    }
}

// 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == MEMBER_TYPE_EDIT_NEXTCARDTYPE) {
        [self.lsNextCardType changeData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == MEMBER_TYPE_EDIT_PRICESCHEME) {
        [self.lsPriceScheme changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[self.lsPriceScheme getStrVal] isEqualToString:@"3"]) {
            [self.lsDiscountRatio visibal:YES];
        }else{
            [self.lsDiscountRatio visibal:NO];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    
    if (eventType==MEMBER_TYPE_EDIT_NEEDINTEGRAL) {
        
        if ([NSString isBlank:val]) {
            val = @"";
        }else{
            val = [NSString stringWithFormat:@"%.d",val.intValue];
        }
        
        [self.lsNeedIntegral changeData:val withVal:val];
        
    }else {

        if ([NSString isBlank:val]) {
            val = @"";
            
        }else{
            
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
        
        if (eventType==MEMBER_TYPE_EDIT_INTEGRALRATIO) {
            [self.lsIntegralRatio changeData:val withVal:val];
        }else if (eventType==MEMBER_TYPE_EDIT_DISCOUNTRATIO){
            if (val.doubleValue > 100.00) {
                [AlertBox show:@"折扣率(%)不能超过100.00，请重新输入!"];
                return;
            }
            [self.lsDiscountRatio changeData:val withVal:val];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

// Radio控件变换.
- (void)onItemRadioClick:(EditItemRadio*)obj {
    
    BOOL result = [[obj getStrVal] isEqualToString:@"1"];
    
    if (obj.tag == MEMBER_TYPE_EDIT_ISUPGRADE) {
        if (result) {
            [self.lsNextCardType visibal:YES];
            [self.lsNeedIntegral visibal:YES];
        }else{
            [self.lsNextCardType visibal:NO];
            [self.lsNeedIntegral visibal:NO];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 导航栏事件
-(void) onNavigateEvent:(Direct_Flag)event {
    
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
- (void)save {
    
    if (![self isValid]){
        return;
    }
    
    __weak MemberTypeEditView* weakSelf = self;
    if (self.action == ACTION_CONSTANTS_ADD) {
        self.kindCardVo = [[KindCardVo alloc] init];
        self.kindCardVo.kindCardName = [self.txtMemberTypeName getStrVal];
        self.kindCardVo.canUpgrade = [self.rdoIsUpgrade getStrVal].integerValue;
        if ([[self.rdoIsUpgrade getStrVal] isEqualToString:@"1"]) {
            self.kindCardVo.upKindCardId = [self.lsNextCardType getStrVal];
            self.kindCardVo.upPoint = [self.lsNeedIntegral getStrVal].integerValue;
        }
        self.kindCardVo.ratioExchangeDegree = [self.lsIntegralRatio getStrVal].doubleValue;
        self.kindCardVo.mode = [self.lsPriceScheme getStrVal].integerValue;
        if ([[self.lsPriceScheme getStrVal] isEqualToString:@"3"]) {
            self.kindCardVo.ratio = [self.lsDiscountRatio getStrVal].doubleValue;
        }
        self.kindCardVo.memo = [self.txtMemo getStrVal];
        
        [_memberService saveKindCard:@"add" kindCard:self.kindCardVo completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MemberTypeListView class]]) {
                    MemberTypeListView *listView = (MemberTypeListView *)vc;
                    [listView loadDatas];
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else {
        self.kindCardVo.kindCardName = [self.txtMemberTypeName getStrVal];
        self.kindCardVo.canUpgrade = [self.rdoIsUpgrade getStrVal].integerValue;
        if ([[self.rdoIsUpgrade getStrVal] isEqualToString:@"1"]) {
            self.kindCardVo.upKindCardId = [self.lsNextCardType getStrVal];
            self.kindCardVo.upPoint = [self.lsNeedIntegral getStrVal].integerValue;
        }else{
            self.kindCardVo.upKindCardId = @"";
            self.kindCardVo.upPoint = 0;
        }
        self.kindCardVo.ratioExchangeDegree = [self.lsIntegralRatio getStrVal].doubleValue;
        self.kindCardVo.mode = [self.lsPriceScheme getStrVal].integerValue;
        if ([[self.lsPriceScheme getStrVal] isEqualToString:@"3"]) {
            self.kindCardVo.ratio = [self.lsDiscountRatio getStrVal].doubleValue;
        }else{
            self.kindCardVo.ratio = 0;
        }
        self.kindCardVo.memo = [self.txtMemo getStrVal];
        
        [_memberService saveKindCard:@"edit" kindCard:self.kindCardVo completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MemberTypeListView class]]) {
                    MemberTypeListView *listView = (MemberTypeListView *)vc;
                    [listView loadDatasFromEdit:self.kindCardVo action:ACTION_CONSTANTS_EDIT];
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
    
}

- (IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",self.kindCardVo.kindCardName]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        __weak MemberTypeEditView* weakSelf = self;
        [_memberService delKindCard:self.kindCardVo.kindCardId lastVer:[NSString stringWithFormat:@"%tu", self.kindCardVo.lastVer] completionHandler:^(id json) {
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
        if ([vc isKindOfClass:[MemberTypeListView class]]) {
            MemberTypeListView *listView = (MemberTypeListView *)vc;
            [listView loadDatasFromEdit:self.kindCardVo action:ACTION_CONSTANTS_DEL];
        }
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma save-data
- (BOOL)isValid {
    
    if ([NSString isBlank:[self.txtMemberTypeName getStrVal]]) {
        [AlertBox show:@"名称不能为空，请输入!"];
        return NO;
    }
    if ([[self.rdoIsUpgrade getStrVal] isEqualToString:@"1"] && [NSString isBlank:[self.lsNextCardType getStrVal]]) {
        [AlertBox show:@"请选择下一级卡类型!"];
        return NO;
    }else if ([[self.rdoIsUpgrade getStrVal] isEqualToString:@"1"] && [[self.lsNextCardType getStrVal] isEqualToString:self.kindCardVo.kindCardId]){
        [AlertBox show:@"下一级卡类型不能与此卡相同，请重新选择!"];
        return NO;
    }
    
    if ([[self.rdoIsUpgrade getStrVal] isEqualToString:@"1"] && [NSString isBlank:[self.lsNeedIntegral getStrVal]]) {
        [AlertBox show:@"升级所需积分不能为空，请输入!"];
        return NO;
    }
    
    if ([[self.rdoIsUpgrade getStrVal] isEqualToString:@"1"] && [self.lsNeedIntegral getStrVal].intValue == 0) {
        [AlertBox show:@"升级所需积分必须大于0，请重新输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsIntegralRatio getStrVal]]) {
        [AlertBox show:@"消费积分比例不能为空，请输入!"];
        return NO;
    }
    
    if ([[self.lsPriceScheme getStrVal] isEqualToString:@"3"] && [NSString isBlank:[self.lsDiscountRatio getStrVal]]) {
        [AlertBox show:@"折扣率不能为空，请输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsPriceScheme getStrVal]]) {
        [AlertBox show:@"请选择价格方案!"];
        return NO;
    }
    
    return YES;
}

@end