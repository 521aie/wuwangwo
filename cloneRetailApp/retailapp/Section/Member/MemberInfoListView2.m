//
//  MemberInfoListView2.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberInfoListView2.h"
#import "MemberModule.h"
#import "EditItemList.h"
#import "SearchBar2.h"
#import "PaperFooterListView.h"
#import "GridColHead5.h"
#import "MemberInfoTypeViewCell2.h"
#import "CustomerCardVo.h"
#import "ObjectUtil.h"
#import "MemberInfoListView.h"
#import "CardSummarizingVo.h"
#import "CustomerVo.h"
#import "MemberInfoEditView.h"
#import "ISampleListEvent.h"
#import "MemberTopSelectView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "ViewFactory.h"
#import "MemberSearchCondition.h"
#import "UIImageView+WebCache.h"
#import "ExportView.h"
#import "XHAnimalUtil.h"
#import "SelectEmployeeListView.h"
#import "SelectShopListView.h"
#import "ColorHelper.h"
#import "DateUtils.h"

@interface MemberInfoListView2 ()

@property (nonatomic, strong) MemberService* memberService;

@property (nonatomic, strong) CustomerCardVo* tempVo;

@property (nonatomic, strong) NSDictionary* dispose;

@end

@implementation MemberInfoListView2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil memberSearchCondition:(MemberSearchCondition *)memberSearchCondition action:(int)action
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _memberSearchCondition = memberSearchCondition;
        _action = action;
        _memberService = [ServiceFactory shareInstance].memberService;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self initGrid];
    
    [self.memberSearchBarView initDelagate:self placeholder:@"会员名/手机号或后4位"];
    NSArray *arr= nil;
    if (![[Platform Instance] lockAct:ACTION_CARD_ADD]) {
        arr = [[NSArray alloc] initWithObjects:@"add", @"export", nil];
    } else {
        arr = [[NSArray alloc] initWithObjects:@"export", nil];
    }
    [self.footView initDelegate:self btnArrs:arr];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:60];
    if ([self.type isEqualToString:@"本月"]) {
        self.memberSearchCondition.startActiveTime = [NSString stringWithFormat:@"%lld",[DateUtils converStartTime:@"本月"]];
        self.memberSearchCondition.endActiveTime = [NSString stringWithFormat:@"%lld",[DateUtils converEndTime:@"本月"]];
    }
    
    __weak MemberInfoListView2* weakSelf = self;
    [self.mainGrid addHeaderWithCallback:^{
        
        weakSelf.lastDateTime = @"1";
        if (![NSString isBlank:weakSelf.memberSearchBarView.keyWordTxt.text]) {
            [weakSelf selectMemberInfoList:self.memberSearchCondition action:0];
        }else{
            [weakSelf selectMemberInfoList:self.memberSearchCondition action:1];
        }
        
    }];
    
    [self.mainGrid addFooterWithCallback:^{

        if (![NSString isBlank:weakSelf.memberSearchBarView.keyWordTxt.text]) {
            [weakSelf selectMemberInfoList:self.memberSearchCondition action:0];
        }else{
            [weakSelf selectMemberInfoList:self.memberSearchCondition action:1];
        }
    }];
    
    self.footView.btnHelp.enabled = NO;
    self.footView.btnHelp.hidden = YES;
    [self loaddatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loaddatas
{
    if (self.memberSearchCondition != nil) {
        self.memberSearchBarView.keyWordTxt.text = self.memberSearchCondition.keywords;
        self.searchCode = self.memberSearchCondition.keywords;
    }
    [self.mainGrid headerBeginRefreshing];
}

- (void)loaddatesFromEdit:(CustomerVo *)customerVo action:(int)action
{
    self.mainGrid.loading = YES;
    if (customerVo == nil) {
        [self.mainGrid setContentOffset:CGPointZero];
        _lastDateTime = @"1";
        [self selectMemberInfoList:self.memberSearchCondition action:self.action];
    }else {
        if (action == ACTION_CONSTANTS_EDIT) {
            _tempVo.customerName = customerVo.name;
            _tempVo.mobile = customerVo.mobile;
            _tempVo.kindCardName = customerVo.card.kindCardName;
            _tempVo.cardStatus = customerVo.card.status;
        }else if (action == ACTION_CONSTANTS_DEL) {
            [self.datas removeObject:_tempVo];
            self.customerSum = self.customerSum - 1;
        }
        [self.mainGrid reloadData];
        self.mainGrid.loading = NO;
    }
}

- (void)selectMemberInfoList:(MemberSearchCondition *)memberSearchCondition action:(int)action
{
    self.mainGrid.loading = YES;
    self.memberSearchCondition = memberSearchCondition;
    _searchCode = _memberSearchCondition.keywords;
    
    //放入platform中，导出用
    if (self.memberSearchCondition == nil) {
        [self initMemberSearchCondition];
        [[Platform Instance] setMemberSearchCondition:self.memberSearchCondition];
    }
    
    __weak MemberInfoListView2* weakSelf = self;
    //action为0时，表示从搜索框搜索；action为1时，表示从筛选框搜索，此时将搜索框清空
    if (action == 0) {
        [_memberService selectMemberInfoList:_searchCode
                                keywordsKind:@""
                                  kindCardId:@""
                             statusCondition:@""
                             startActiveTime:@""
                               endActiveTime:@""
                                lastDateTime:_lastDateTime disposeName:self.disposeName
                           completionHandler:^(id json) {
                               if (!(weakSelf)) {
                                   return ;
                               }
                               [weakSelf responseSuccess:json];
                               [weakSelf.mainGrid headerEndRefreshing];
                               [weakSelf.mainGrid footerEndRefreshing];
                           } errorHandler:^(id json) {
                               [AlertBox show:json];
                               [weakSelf.mainGrid headerEndRefreshing];
                               [weakSelf.mainGrid footerEndRefreshing];
                           }];

        
    }else{
        [_memberService selectMemberInfoList:_searchCode
                                keywordsKind:self.memberSearchCondition.keywordsKind
                                  kindCardId:self.memberSearchCondition.kindCardId
                             statusCondition:self.memberSearchCondition.statusCondition
                             startActiveTime:self.memberSearchCondition.startActiveTime
                               endActiveTime:self.memberSearchCondition.endActiveTime
                                 lastDateTime:_lastDateTime disposeName:self.disposeName
                           completionHandler:^(id json) {
                               if (!(weakSelf)) {
                                   return ;
                               }
                               [weakSelf responseSuccess:json];
                               [weakSelf.mainGrid headerEndRefreshing];
                               [weakSelf.mainGrid footerEndRefreshing];
                           } errorHandler:^(id json) {
                               [AlertBox show:json];
                               [weakSelf.mainGrid headerEndRefreshing];
                               [weakSelf.mainGrid footerEndRefreshing];
                           }];
    }
}

- (void)initMemberSearchCondition
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

- (void)responseSuccess:(id)json
{
    NSMutableArray* arrList = [JsonHelper transList:[json objectForKey:@"customerList"] objName:@"CustomerCardVo"];
    if ([_lastDateTime isEqualToString:@"1"]) {
        if (self.datas != nil) {
            [self.datas removeAllObjects];
            [self.datas addObjectsFromArray:arrList];
        }else{
            self.datas = arrList;
        }
    }else{
        [self.datas addObjectsFromArray:arrList];
    }
    
    if (arrList != nil && arrList.count > 0) {
        _lastDateTime = [[json objectForKey:@"lastDateTime"] stringValue];
    }
    
    [self.mainGrid reloadData];
    self.mainGrid.loading = NO;
}

- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event == DIRECT_LEFT) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[MemberInfoListView class]]) {
                MemberInfoListView *listView = (MemberInfoListView *)vc;
                [listView loaddatas:_memberSearchCondition];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else{
       
        if (!self.memberTopSelectView) {
            self.memberTopSelectView = [[MemberTopSelectView alloc] initWithNibName:[SystemUtil getXibName:@"MemberTopSelectView"] bundle:nil fromViewTag:MEMBER_INFO_LIST_VIEW2];
            [self.view addSubview:self.memberTopSelectView.view];
            [self.view bringSubviewToFront:self.memberTopSelectView.view];
        }
        self.memberTopSelectView.delegate = self;
        self.memberTopSelectView.conditionOfInit = _conditionOfInit;
        [self.memberTopSelectView loadMemberTopSelectView];
        [self.memberTopSelectView oper];
    }
}

- (void)memberSelectToListView:(MemberSearchCondition *)memberSearchCondition action:(int)action
{
    _lastDateTime = @"1";
    [self selectMemberInfoList:memberSearchCondition action:1];
}

- (void)showAddEvent
{
    __weak typeof(self) weakSelf = self;
    MemberInfoEditView* memberInfoEditView = [[MemberInfoEditView alloc] initWithNibName:[SystemUtil getXibName:@"MemberInfoEditView"] bundle:nil customerId:nil action:ACTION_CONSTANTS_ADD fromView:MEMBER_INFO_LIST_VIEW2];
    [memberInfoEditView setCallBackBlock:^(id retObj) {
        [weakSelf loaddatesFromEdit:nil action:ACTION_CONSTANTS_ADD];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:memberInfoEditView animated:NO];
}

- (void)showExportEvent
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.memberSearchCondition.keywords forKey:@"keywords"];
    [dic setObject:self.memberSearchCondition.kindCardId forKey:@"kindCardId"];
    if (![self.memberSearchCondition.statusCondition isEqualToString:@""]) {
        [dic setObject:self.memberSearchCondition.statusCondition forKey:@"statusCondition"];
    }
    if (![self.memberSearchCondition.startActiveTime isEqualToString:@""]) {
        [dic setObject:self.memberSearchCondition.startActiveTime forKey:@"startActiveTime"];
        [dic setObject:self.memberSearchCondition.endActiveTime forKey:@"endActiveTime"];
    }
    ExportView* exportView = [[ExportView alloc] initWithNibName:[SystemUtil getXibName:@"ExportView"] bundle:nil];
    [self.navigationController pushViewController:exportView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [exportView loadData:dic withPath:@"customer/exportExcel" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popToViewController:self animated:NO];
    }];
}

// 搜索框输入完成方法
- (void)imputFinish:(NSString *)keyWord
{
    if ([NSString isValidNumber:keyWord] && keyWord.length != 4 && keyWord.length != 11) {
        [AlertBox show:@"请输入11位手机号或后四位!"];
        return ;
    }
    self.searchCode = keyWord;
    _lastDateTime = @"1";
    [self initMemberSearchCondition];
    self.memberSearchCondition.keywords = keyWord;
    [self selectMemberInfoList:_memberSearchCondition action:0];
}

#pragma mark navigateTitle.
- (void)initHead
{
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"会员信息" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    [self.titleDiv addSubview:self.titleBox];
}

#pragma table部分
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberInfoTypeViewCell2 *detailItem = (MemberInfoTypeViewCell2 *)[self.mainGrid dequeueReusableCellWithIdentifier:MemberInfoTypeViewCell2Indentifier];
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"MemberInfoTypeViewCell2" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        CustomerCardVo *item = [self.datas objectAtIndex:indexPath.row];
        [detailItem fillMemberInfo:item];
        
    }
    return detailItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"memberInfo" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

-(void)initGrid
{
    self.mainGrid.rowHeight = 88.0f;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

// 跳转会员详情编辑页面
- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    _tempVo = (CustomerCardVo *)obj;
    __weak typeof(self) weakSelf = self;
    MemberInfoEditView* memberInfoEditView = [[MemberInfoEditView alloc] initWithNibName:[SystemUtil getXibName:@"MemberInfoEditView"] bundle:nil customerId:_tempVo.customerId action:ACTION_CONSTANTS_EDIT fromView:MEMBER_INFO_LIST_VIEW2];
    [memberInfoEditView setCallBackBlock:^(id retObj) {
        [weakSelf.mainGrid headerBeginRefreshing];
//        [weakSelf loaddatesFromEdit:retObj action:ACTION_CONSTANTS_EDIT];
        }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:memberInfoEditView animated:NO];
}


@end
