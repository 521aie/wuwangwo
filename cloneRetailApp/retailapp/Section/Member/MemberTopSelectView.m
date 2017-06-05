//
//  MemberTopSelectView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberTopSelectView.h"
//#import "MemberModule.h"
#import "EditItemList.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "MemberModuleEvent.h"
#import "OptionPickerBox.h"
#import "MemberRender.h"
#import "DateUtils.h"
#import "SymbolNumberInputBox.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "Platform.h"
#import "MemberSearchCondition.h"
#import "MemberInfoListView2.h"
#import "SelectShopListView.h"

@interface MemberTopSelectView ()

@property (nonatomic, strong) MemberService* memberService;

@property (nonatomic, strong) NSString* startTime;

@property (nonatomic, strong) NSString* endTime;

@property (nonatomic, strong) MemberSearchCondition* memberSearchCondition;

@property (nonatomic) short status;

@property (nonatomic) int fromViewTag;

@end

@implementation MemberTopSelectView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil fromViewTag:(int) fromViewTag{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _fromViewTag = fromViewTag;
        _memberService = [ServiceFactory shareInstance].memberService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    [self initButton];
    [UIHelper refreshPos:self.mainContainer scrollview:self.scrollView];
}


- (void)loadMemberTopSelectView
{
    if (self.status == 0) {
        [self resetLblVal];
        self.status= 1;
    }
}

//初始化条件项内容
- (void)initMainView
{
    [self.lsKindCardName initLabel:@"卡类型" withHit:nil delegate:self];
    
    [self.lsStatus initLabel:@"卡状态" withHit:nil delegate:self];
    
    [self.lsActiveTime initLabel:@"开卡时间" withHit:nil delegate:self];
    
    [self.lsStartTime initLabel:@"▪︎ 开始时间" withHit:nil delegate:self];
    
    [self.lsEndTime initLabel:@"▪︎ 结束时间" withHit:nil delegate:self];
    
//    [self.lsActiveWay initLabel:@"开卡方式" withHit:nil delegate:self];
//    
//    [self.lsActiveShop initLabel:@"开卡门店" withHit:nil delegate:self];
//    [self.lsActiveShop.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
//    if ([[Platform Instance] getShopMode] == 3) {
//        [self.lsActiveShop visibal:YES];
//    } else {
//        [self.lsActiveShop visibal:NO];
//    }
    
//    [self.lsDisposeName initLabel:@"会员负责人" withHit:nil delegate:self];
//    [self.lsDisposeName.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
//    
//    [self.lsMemberBir initLabel:@"会员生日" withHit:@"未来几天内过生日" delegate:self];
   
    self.lsKindCardName.tag =  MEMBER_TOP_SELECT_KIND_CARD_NAME;
    self.lsStatus.tag = MEMBER_TOP_SELECT_STATUS;
    self.lsActiveTime.tag = MEMBER_TOP_SELECT_ACTIVE_TIME;
    self.lsStartTime.tag = MEMBER_TOP_SELECT_START_TIME;
    self.lsEndTime.tag = MEMBER_TOP_SELECT_END_TIME;
//    self.lsActiveWay.tag = MEMBER_TOP_SELECT_ACTIVE_WAY;
//    self.lsActiveShop.tag = MEMBER_TOP_SELECT_ACTIVE_SHOP;
//    self.lsDisposeName.tag = MEMBER_TOP_SELECT_DISPOSE_NAME;
//    self.lsMemberBir.tag = MEMBER_TOP_SELECT_MEMBER_BIR;
   
}

-(void) onItemListClick:(EditItemList *)obj
{
    if (obj.tag == MEMBER_TOP_SELECT_KIND_CARD_NAME) {
        __weak MemberTopSelectView* weakSelf = self;
        [_memberService selectKindCardList:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list= [JsonHelper transList:[json objectForKey:@"kindCardList"] objName:@"KindCardVo"];
            [OptionPickerBox initData:[MemberRender listKindCardName:list]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else if (obj.tag == MEMBER_TOP_SELECT_STATUS){
        [OptionPickerBox initData:[MemberRender listCardStatus]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag == MEMBER_TOP_SELECT_ACTIVE_TIME){
        [OptionPickerBox initData:[MemberRender listActiveTime]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag == MEMBER_TOP_SELECT_START_TIME || obj.tag == MEMBER_TOP_SELECT_END_TIME){
        NSDate *date=[DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox show:obj.lblName.text date:date client:self event:(int)obj.tag];
    }
    
    [self refreshView:self.mainContainer scrollView:self.scrollView];
}

// 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == MEMBER_TOP_SELECT_KIND_CARD_NAME) {
        [self.lsKindCardName initData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == MEMBER_TOP_SELECT_STATUS) {
        [self.lsStatus initData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == MEMBER_TOP_SELECT_ACTIVE_TIME) {
        [self.lsActiveTime initData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[self.lsActiveTime getStrVal] isEqualToString:@"7"]) {
            [self.lsStartTime visibal:YES];
            [self.lsEndTime visibal:YES];
        }else{
            [self.lsStartTime visibal:NO];
            [self.lsEndTime visibal:NO];
        }
        
    }
    
    [self refreshView:self.mainContainer scrollView:self.scrollView];
    return YES;
}

//超出界面滚动，反之则不滚动.
- (void)refreshView:(UIView*)container scrollView:(UIScrollView*)scrollView
{
    float height=0;
    for (UIView*  view in container.subviews) {
        if (!view.hidden) {
            [view setLs_top:height];
            height+=view.ls_height;
        }
    }
//    float contentHeight = scrollView.height;
//    height = height>contentHeight?height+48:contentHeight;
    [container setLs_height:height];
    if (scrollView) {
        scrollView.contentSize=CGSizeMake(320, container.ls_height);
        [container setNeedsDisplay];
    }
}

//选择日期
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    if (event == MEMBER_TOP_SELECT_START_TIME) {
        NSString* dateStr=[DateUtils formateDate2:date];
        [self.lsStartTime initData:dateStr withVal:dateStr];
    }else if (event == MEMBER_TOP_SELECT_END_TIME){
        NSString* dateStr=[DateUtils formateDate2:date];
        [self.lsEndTime initData:dateStr withVal:dateStr];
    }
    
    return YES;
}

#pragma mark - 重置
//重置选项栏的值
- (void)resetLblVal
{
    if ([NSString isBlank:self.conditionOfInit.kindCardId]) {
        [self.lsKindCardName initData:@"全部" withVal:@""];
    } else {
        __weak MemberTopSelectView* weakSelf = self;
        [_memberService selectKindCardList:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list= [JsonHelper transList:[json objectForKey:@"kindCardList"] objName:@"KindCardVo"];
            [weakSelf.lsKindCardName initData:[MemberRender obtainKindCardName:weakSelf.conditionOfInit.kindCardId kindCardList:list] withVal:weakSelf.conditionOfInit.kindCardId];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
    
    if ([NSString isBlank:self.conditionOfInit.statusCondition]) {
        [self.lsStatus initData:@"全部" withVal:@""];
    } else {
        [self.lsStatus initData:[MemberRender obtainCardStatus:self.conditionOfInit.statusCondition] withVal:self.conditionOfInit.statusCondition];
    }
    
    [self.lsActiveTime initData:[MemberRender obtainActiveTime:self.conditionOfInit.activeTimeType] withVal:self.conditionOfInit.activeTimeType];
    
    if ([self.conditionOfInit.activeTimeType isEqualToString:@"7"]) {
        [self.lsStartTime visibal:YES];
        [self.lsEndTime visibal:YES];
    } else {
        [self.lsStartTime visibal:NO];
        [self.lsEndTime visibal:NO];
    }
    
    if ([NSString isBlank:self.conditionOfInit.startActiveTime]) {
        [self.lsStartTime initData:[DateUtils formateDate2:[NSDate date]] withVal:[DateUtils formateDate2:[NSDate date]]];
        
        
        [self.lsEndTime initData:[DateUtils formateDate2:[NSDate date]] withVal:[DateUtils formateDate2:[NSDate date]]];
    } else {
        [self.lsStartTime initData:[DateUtils formateTime2:self.conditionOfInit.startActiveTime.longLongValue] withVal:[DateUtils formateTime2:self.conditionOfInit.startActiveTime.longLongValue]];
        
        [self.lsEndTime initData:[DateUtils formateTime2:self.conditionOfInit.endActiveTime.longLongValue] withVal:[DateUtils formateTime2:self.conditionOfInit.endActiveTime.longLongValue]];
    }

    [self refreshView:self.mainContainer scrollView:self.scrollView];
}


- (void)initButton
{
    [self.btnReset setTitleColor:[ColorHelper getBlueColor] forState:UIControlStateNormal];
    [self.btnConfirm setTitleColor:[ColorHelper getBlueColor] forState:UIControlStateNormal];
}

//module中调用
- (void)oper
{
    [self showMoveIn];
}

//视图动画效果
- (void)showMoveIn
{
    self.view.hidden = NO;
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.alpha = 0.5;
    self.view.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)hideMoveOut
{
    [UIView beginAnimations:@"viewOut" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterMoveOut:finished:context:)];
    [UIView setAnimationDuration:0.2];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.view.alpha = 1.0;
    self.view.alpha = 0.5;
    [UIView commitAnimations];
}

- (void)afterMoveOut:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished context:(void *)paramContext
{
    self.view.hidden = YES;
}

//重置按钮
- (IBAction)btnReset:(id)sender
{
    [self resetLblVal];
}

//空白按钮
- (IBAction)btnTopClick
{
    [self hideMoveOut];
}

//确认按钮
- (IBAction)btnConfirm:(id)sender
{
    [self fillSearchCondition];
    if ([[self.lsActiveTime getStrVal] isEqualToString:@"1"]) {
        //全部
        self.startTime = @"";
        self.endTime = @"";
    }else if ([[self.lsActiveTime getStrVal] isEqualToString:@"2"]){
        //今天
        self.startTime = [NSString stringWithFormat:@"%lld",[DateUtils converStartTime:@"今天"]];
        self.endTime = [NSString stringWithFormat:@"%lld",[DateUtils converEndTime:@"今天"]];
    }else if ([[self.lsActiveTime getStrVal] isEqualToString:@"3"]){
        //昨天
        self.startTime = [NSString stringWithFormat:@"%lld",[DateUtils converStartTime:@"昨天"]];
        self.endTime = [NSString stringWithFormat:@"%lld",[DateUtils converEndTime:@"昨天"]];
    }else if ([[self.lsActiveTime getStrVal] isEqualToString:@"4"]){
        //最近三天(包括今天）
        self.startTime = [NSString stringWithFormat:@"%lld",[DateUtils converStartTime:@"最近三天"]];
        self.endTime = [NSString stringWithFormat:@"%lld",[DateUtils converEndTime:@"最近三天"]];
    }else if ([[self.lsActiveTime getStrVal] isEqualToString:@"5"]){
        //本周
        self.startTime = [NSString stringWithFormat:@"%lld",[DateUtils converStartTime:@"本周"]];
        self.endTime = [NSString stringWithFormat:@"%lld",[DateUtils converEndTime:@"本周"]];
    }else if ([[self.lsActiveTime getStrVal] isEqualToString:@"6"]){
        //本月
        self.startTime = [NSString stringWithFormat:@"%lld",[DateUtils converStartTime:@"本月"]];
        self.endTime = [NSString stringWithFormat:@"%lld",[DateUtils converEndTime:@"本月"]];
    }else if ([[self.lsActiveTime getStrVal] isEqualToString:@"7"]){
        //自定义
        self.startTime = [NSString stringWithFormat:@"%lld", [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 00:00:00", [self.lsStartTime getStrVal]]]];
        self.endTime = [NSString stringWithFormat:@"%lld", [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59", [self.lsEndTime getStrVal]]]];
    }
    
    NSString* kindCardId = @"";
    if (![[self.lsKindCardName getStrVal] isEqualToString:@""]) {
        kindCardId = [self.lsKindCardName getStrVal];
    }

    if (![[self.lsActiveTime getStrVal] isEqualToString:@"1"] && self.startTime.longLongValue > self.endTime.longLongValue) {
        [AlertBox show:@"开始日期不能大于结束日期，请重新选择!"];
        return ;
    }
    
    self.memberSearchCondition.kindCardId = kindCardId;
    self.memberSearchCondition.statusCondition = [self.lsStatus getStrVal];
    self.memberSearchCondition.activeTimeType = [self.lsActiveTime getStrVal];
    self.memberSearchCondition.startActiveTime = self.startTime;
    self.memberSearchCondition.endActiveTime = self.endTime;
    self.memberSearchCondition.lastDateTime = @"1";
    
    [self hideMoveOut];
    if (_fromViewTag == MEMBER_INFO_LIST_VIEW) {
        [self.delegate memberSelectToSelectView:_memberSearchCondition action:1];
    }else{
        [self.delegate memberSelectToListView:_memberSearchCondition action:1];
    }
}

-(void) fillSearchCondition
{
    self.memberSearchCondition = [[MemberSearchCondition alloc] init];
    self.memberSearchCondition.keywords = @"";
    self.memberSearchCondition.keywordsKind = @"";
    self.memberSearchCondition.kindCardId = @"";
    self.memberSearchCondition.statusCondition = @"";
    self.memberSearchCondition.startActiveTime = @"";
    self.memberSearchCondition.endActiveTime = @"";
    self.memberSearchCondition.lastDateTime = @"1";
}

@end
