//
//  MemberInfoListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberInfoListView.h"
#import "MemberModule.h"
#import "SearchBar2.h"
#import "CardSummarizingVo.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "MemberInfoTypeViewCell.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "ObjectUtil.h"
#import "UIHelper.h"
#import "MemberInfoListView2.h"
#import "CustomerCardVo.h"
#import "MemberTopSelectView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "ColorHelper.h"
#import "MemberModuleEvent.h"
#import "MemberSearchCondition.h"
#import "DateUtils.h"
#import "Platform.h"
#import "MemberRender.h"
#import "MemberInfoEditView.h"
#import "XHAnimalUtil.h"
#import "SelectEmployeeListView.h"
#import "SelectShopListView.h"
#import "MemberRender.h"

@interface MemberInfoListView ()

@property (nonatomic, strong) MemberService* memberService;
@property (nonatomic, strong) CardSummarizingVo *cardSummarizingVo;
@property (nonatomic, strong) MemberSearchCondition *memberSearchCondition;
@property (nonatomic, retain) NSMutableArray *datas;
@property (nonatomic, retain) NSString *searchCode;
@property (nonatomic, retain) NSString *kindCardId;
@property (nonatomic, retain) MemberSearchCondition* conditionOfInit;
@end

@implementation MemberInfoListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _memberService = [ServiceFactory shareInstance].memberService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self initMainView];
    [UIHelper clearColor:self.infoView];
    self.tableView.tableHeaderView = self.infoView;
    [self.memberSearchBarView initDelagate:self placeholder:@"会员名/手机号或后4位"];
    NSArray* arr= nil;
    if (![[Platform Instance] lockAct:ACTION_CARD_ADD]) {
        arr=[[NSArray alloc] initWithObjects:@"add", nil];
    } else {
        arr=[[NSArray alloc] init];
    }
    [self.footView initDelegate:self btnArrs:arr];
    [self loaddatas:nil];
    self.footView.btnHelp.enabled = NO;
    self.footView.imgHelp.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loaddatas:(MemberSearchCondition *) memberSearchCondition
{
    __weak MemberInfoListView* weakSelf = self;
    [_memberService selectMemberInfo:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    if (_memberSearchCondition != nil) {
        self.memberSearchBarView.keyWordTxt.text = _memberSearchCondition.keywords;
    }
    
}

- (void)responseSuccess:(id)json
{
    self.cardSummarizingVo = [JsonHelper dicTransObj:[json objectForKey:@"cardSummarizing"] obj:[CardSummarizingVo new]];
    
    [self fillModel];
    
    [self showInfoView];
    
    self.datas = [[NSMutableArray alloc] init];
    
    if (self.cardSummarizingVo.cardTypeSumMap != nil && self.cardSummarizingVo.cardTypeSumMap.count > 0) {
        
        for (NSString *key in self.cardSummarizingVo.cardTypeSumMap) {
            CardSummarizingVo *vo = [[CardSummarizingVo alloc] init];
            vo.cardTypeName = key;
            vo.everyCardTypeMemberNum = [self.cardSummarizingVo.cardTypeSumMap[key] intValue];
            [self.datas addObject:vo];
        }
        
        [self.tableView reloadData];
    }
    
    [self.lsMyMember.lblName setTextColor:[ColorHelper getRedColor]];
    [self.lsMemberSum.lblName setTextColor:[ColorHelper getBlackColor]];
    [self.lsCurrentMonthMemberNum.lblName setTextColor:[ColorHelper getBlackColor]];
}

- (void)showInfoView
{
    if (self.cardSummarizingVo != nil) {
        if (self.cardSummarizingVo.myMemberNum > 0) {
            [self.lsMyMember visibal:YES];
        }else{
            [self.lsMyMember visibal:NO];
        }
    }else{
        [self.lsMyMember visibal:NO];
    }
    
    
    [UIHelper refreshUI:self.infoView];
    self.tableView.tableHeaderView = self.infoView;
}

- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        
        if (!self.memberTopSelectView) {
            self.memberTopSelectView = [[MemberTopSelectView alloc] initWithNibName:[SystemUtil getXibName:@"MemberTopSelectView"] bundle:nil fromViewTag:MEMBER_INFO_LIST_VIEW];
            [self.view addSubview:self.memberTopSelectView.view];
            [self.view bringSubviewToFront:self.memberTopSelectView.view];
        }
        self.memberTopSelectView.delegate = self;
        _conditionOfInit = [[MemberSearchCondition alloc] init];
        self.conditionOfInit.activeTimeType = @"1";
        self.memberTopSelectView.conditionOfInit = _conditionOfInit;
        [self.memberTopSelectView loadMemberTopSelectView];
        [self.memberTopSelectView oper];
    }
}

- (void)memberSelectToSelectView:(MemberSearchCondition *)memberSearchCondition action:(int)action
{
    MemberInfoListView2* memberInfoListView2 = [[MemberInfoListView2 alloc] initWithNibName:[SystemUtil getXibName:@"MemberInfoListView2"] bundle:nil memberSearchCondition:memberSearchCondition action:1];
    memberInfoListView2.conditionOfInit = memberSearchCondition;
    [self.navigationController pushViewController:memberInfoListView2 animated:NO];
}

- (void)fillModel
{
    [self.lsMyMember initData:[NSString stringWithFormat:@"%d", self.cardSummarizingVo.myMemberNum] withVal:[NSString stringWithFormat:@"%d", self.cardSummarizingVo.myMemberNum]];
    self.lsMyMember.lblVal.enabled = NO;
    [self.lsMemberSum initData:[NSString stringWithFormat:@"%d", self.cardSummarizingVo.memberSum] withVal:[NSString stringWithFormat:@"%d", self.cardSummarizingVo.memberSum]];
    self.lsMemberSum.lblVal.enabled = NO;
    [self.lsCurrentMonthMemberNum initData:[NSString stringWithFormat:@"%d", self.cardSummarizingVo.sumPerMonth] withVal:[NSString stringWithFormat:@"%d", self.cardSummarizingVo.sumPerMonth]];
    self.lsMemberSum.lblVal.enabled = NO;
}

- (void)initMainView
{
    [self.lsMyMember initLabel:@"我的会员" withHit:nil delegate:self];
    [self.lsMyMember.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.lsMemberSum initLabel:@"会员总数" withHit:nil delegate:self];
    [self.lsMemberSum.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.lsCurrentMonthMemberNum initLabel:@"本月开卡会员总数" withHit:nil delegate:self];
    [self.lsCurrentMonthMemberNum.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    self.lsMyMember.tag = MEMBER_INFO_LIST_MYMEMBER;
    self.lsMemberSum.tag = MEMBER_INFO_LIST_MEMBERSUM;
    self.lsCurrentMonthMemberNum.tag = MEMBER_INFO_LIST_CURRENTMONTHMEMBERSUM;
}

#pragma mark navigateTitle.
- (void)initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"会员信息" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    self.titleBox.lblRight.text = @"筛选";
    self.titleBox.lblRight.hidden = NO;
    [self.titleDiv addSubview:self.titleBox];
}

- (void)showAddEvent
{
    __weak typeof(self) weakSelf = self;
    MemberInfoEditView* memberInfoEditView = [[MemberInfoEditView alloc] initWithNibName:[SystemUtil getXibName:@"MemberInfoEditView"] bundle:nil customerId:nil action:ACTION_CONSTANTS_ADD fromView:MEMBER_INFO_LIST_VIEW];
    [memberInfoEditView setCallBackBlock:^(id retObj) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*1);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [weakSelf loaddatas:nil];
        });
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:memberInfoEditView animated:NO];
}

- (void)onItemListClick:(EditItemList *)obj
{
    MemberInfoListView2* memberInfoListView2 = [[MemberInfoListView2 alloc] initWithNibName:[SystemUtil getXibName:@"MemberInfoListView2"] bundle:nil memberSearchCondition:_memberSearchCondition action:1];
    _conditionOfInit = [[MemberSearchCondition alloc] init];
    self.conditionOfInit.activeTimeType = @"1";
    if (obj.tag == MEMBER_INFO_LIST_MYMEMBER) {
        memberInfoListView2.type = nil;
        self.conditionOfInit.activeTimeType = nil;
        memberInfoListView2.memberSearchCondition.kindCardId = @"";
        memberInfoListView2.disposeName = [[Platform Instance] getkey:USER_ID];
        [self fillSearchCondition:MEMBER_INFO_LIST_MYMEMBER];
        memberInfoListView2.disposeName = nil;
        
    }else if (obj.tag == MEMBER_INFO_LIST_MEMBERSUM) {
        memberInfoListView2.type = @"全部";
        memberInfoListView2.lastDateTime = @"";
        memberInfoListView2.memberSearchCondition.startActiveTime = @"";
        memberInfoListView2.memberSearchCondition.kindCardId = @"";
        [self fillSearchCondition:MEMBER_INFO_LIST_MEMBERSUM];
    }else if (obj.tag == MEMBER_INFO_LIST_CURRENTMONTHMEMBERSUM) {
        memberInfoListView2.type = @"本月";
        self.conditionOfInit.activeTimeType = @"6";
        [self fillSearchCondition:MEMBER_INFO_LIST_CURRENTMONTHMEMBERSUM];
        memberInfoListView2.memberSearchCondition = self.memberSearchCondition;
        memberInfoListView2.memberSearchCondition.kindCardId = @"";
    }
    
    
    memberInfoListView2.conditionOfInit = _conditionOfInit;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:memberInfoListView2 animated:NO];
}

- (void)fillSearchCondition:(int)event
{
    self.memberSearchCondition = [[MemberSearchCondition alloc] init];
    self.memberSearchCondition.keywords = @"";
    self.memberSearchCondition.keywordsKind = @"";
    self.memberSearchCondition.kindCardId = @"";
    self.memberSearchCondition.statusCondition = @"";
    self.memberSearchCondition.startActiveTime = @"";
    self.memberSearchCondition.endActiveTime = @"";

    self.memberSearchCondition.lastDateTime = @"1";
    if (event == MEMBER_INFO_LIST_MEMBERSUM) {
         self.memberSearchCondition.startActiveTime = @"";
        self.memberSearchCondition.endActiveTime = @"";
    }else if (event == MEMBER_INFO_LIST_CURRENTMONTHMEMBERSUM) {
        NSArray * dates = [[NSArray alloc] initWithArray:[DateUtils getFirstAndLastDayOfThisMonth]];
        self.memberSearchCondition.startActiveTime = [NSString stringWithFormat:@"%lld", [DateUtils formateDateTime2:[DateUtils formateDate3:[dates objectAtIndex:0]]]];
        self.memberSearchCondition.endActiveTime = [NSString stringWithFormat:@"%lld", [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59", [DateUtils formateDate2:[dates objectAtIndex:1]]]]];
    }else if (event == MEMBER_INFO_LIST_MYMEMBER) {
        self.memberSearchCondition.startActiveTime = @"";
        self.memberSearchCondition.endActiveTime = @"";
    }else{
        self.memberSearchCondition.startActiveTime = @"";
        self.memberSearchCondition.endActiveTime = @"";
        self.memberSearchCondition.kindCardId = self.kindCardId;
    }
}

// 搜索框输入完成方法
- (void)imputFinish:(NSString *)keyWord
{
    if ([NSString isValidNumber:keyWord] && keyWord.length != 4 && keyWord.length != 11) {
        [AlertBox show:@"请输入11位手机号或后四位!"];
        return ;
    }
    [self fillSearchCondition:MEMBER_INFO_LIST_MEMBERSUM];
    _searchCode = keyWord;
    self.memberSearchCondition.keywords = _searchCode;
    MemberInfoListView2* memberInfoListView2 = [[MemberInfoListView2 alloc] initWithNibName:[SystemUtil getXibName:@"MemberInfoListView2"] bundle:nil memberSearchCondition:_memberSearchCondition action:0];
    _conditionOfInit = [[MemberSearchCondition alloc] init];
    self.conditionOfInit.activeTimeType = @"1";
    memberInfoListView2.conditionOfInit = _conditionOfInit;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:memberInfoListView2 animated:NO];
}

//#pragma table部分
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberInfoTypeViewCell *detailItem = (MemberInfoTypeViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MemberInfoTypeViewCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"MemberInfoTypeViewCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        CardSummarizingVo *item = [self.datas objectAtIndex:indexPath.row];
        [detailItem.lblMemberType setTextColor:[ColorHelper getTipColor3]];
        detailItem.lblMemberType.text = [NSString stringWithFormat:@"%@总数", item.cardTypeName];
        detailItem.lblNum.text = [NSString stringWithFormat:@"%d", item.everyCardTypeMemberNum ];
        [detailItem.lblNum setTextColor:[ColorHelper getBlueColor]];
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return detailItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"memberInfo" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
     CardSummarizingVo *editObj = (CardSummarizingVo *) obj;
    __weak MemberInfoListView* weakSelf = self;
    [_memberService selectKindCardList:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        NSMutableArray* list= [JsonHelper transList:[json objectForKey:@"kindCardList"] objName:@"KindCardVo"];
        NSString *kindType = [MemberRender obtainKindCard:editObj.cardTypeName kindCardList:list];
        self.kindCardId = [MemberRender obtainKindCard:[editObj obtainItemName] kindCardList:[[Platform Instance] getKindCardList]];
        [self fillSearchCondition:100];
        MemberInfoListView2* memberInfoListView2 = [[MemberInfoListView2 alloc] initWithNibName:[SystemUtil getXibName:@"MemberInfoListView2"] bundle:nil memberSearchCondition:_memberSearchCondition action:1];
        memberInfoListView2.type = kindType;
        _conditionOfInit = [[MemberSearchCondition alloc] init];
        self.conditionOfInit.activeTimeType = @"1";
        self.conditionOfInit.kindCardId = kindType;
        memberInfoListView2.conditionOfInit = _conditionOfInit;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:memberInfoListView2 animated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

@end
