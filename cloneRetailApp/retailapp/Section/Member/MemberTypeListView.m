//
//  MemberTypeListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberTypeListView.h"
#import "MemberModule.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "GridColHead.h"
#import "MemberTypeCell.h"
#import "MemberTypeEditView.h"
#import "XHAnimalUtil.h"
#import "ObjectUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "KindCardVo.h"
#import "ViewFactory.h"
#import "ColorHelper.h"
#import "FooterListView.h"

@interface MemberTypeListView ()

@property (nonatomic, strong) MemberService* memberService;
@property (nonatomic, strong) KindCardVo* kindCardVo;
@property (nonatomic,strong) NSMutableArray *memberTypeList;    //原始数据集
@end

@implementation MemberTypeListView

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
    [self initGrid];
    
    NSArray *arr=[[NSArray alloc] initWithObjects:@"add",nil];
    [self.footView initDelegate:self btnArrs:arr];
    [self initDelegate:self event:@"memberType" title:@"会员卡类型" foots:arr];
    
    __weak MemberTypeListView* weakSelf = self;
    [self.mainGrid addHeaderWithCallback:^{
        [weakSelf selectKindCardList];
    }];
    [self loadDatas];
}

- (void)loadDatas
{
    [self.mainGrid headerBeginRefreshing];
}

#pragma 从编辑页面返回
- (void)loadDatasFromEdit:(KindCardVo *)kindCardVo action:(int)action
{
    self.mainGrid.loading = YES;
    
    if (action == ACTION_CONSTANTS_DEL) {
        [self.datas removeObject:_kindCardVo];
    }else{
        _kindCardVo.kindCardName = kindCardVo.kindCardName;
        _kindCardVo.ratio = kindCardVo.ratio;
        _kindCardVo.mode = kindCardVo.mode;
    }
    
    [self.mainGrid reloadData];
    self .mainGrid.loading = NO;
}

#pragma 查询会员类型list
- (void)selectKindCardList
{
    self.mainGrid.loading = YES;
    __weak MemberTypeListView* weakSelf = self;
    [_memberService selectKindCardList:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
        [weakSelf.mainGrid headerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    self.datas = [JsonHelper transList:[json objectForKey:@"kindCardList"] objName:@"KindCardVo"];
    if (self.datas != nil && self.datas.count > 0) {
        [[Platform Instance] setKindCardList:self.datas];
    }
    [self.mainGrid reloadData];
    self.mainGrid.loading = NO;
}

#pragma 跳转到添加页面
- (void)showAddEvent:(NSString *)event
{
    MemberTypeEditView* memberTypeEditView = [[MemberTypeEditView alloc] initWithNibName:[SystemUtil getXibName:@"MemberTypeEditView"] bundle:nil kindCardId:nil action:ACTION_CONSTANTS_ADD];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:memberTypeEditView animated:NO];
}

- (void)showHelpEvent
{
    
}

#pragma 导航栏事件
- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)remoteLoadData:(NSString *)responseStr
{
    MemberTypeVo *memberTypeVo = [[MemberTypeVo alloc] init];
    memberTypeVo.cardTypeName = @"金卡";
    memberTypeVo.cardTypeDiscount = @"会员价";
    [self.memberTypeList addObject:memberTypeVo];
    self.datas = [NSMutableArray array];
    if (self.memberTypeList != nil && self.memberTypeList.count > 0) {
        for (MemberTypeVo *vo in self.memberTypeList) {
            [self.datas addObject:vo];
        }
    }
    
    [self.mainGrid reloadData];
}

//- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
//{
//   
//}

#pragma mark UITableView无section列表
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberTypeCell *detailItem = (MemberTypeCell *)[self.mainGrid dequeueReusableCellWithIdentifier:MemberTypeCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"MemberTypeCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        KindCardVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblMemberTypeName.text = item.kindCardName;
        [detailItem.lblMemberTypeName setTextColor:[ColorHelper getTipColor3]];
        if (item.mode == 1) {
            detailItem.lblMemberTypeDiscount.text = @"会员价";
        }else if (item.mode == 8){
            detailItem.lblMemberTypeDiscount.text = @"批发价";
        }else if (item.mode == 3){
            detailItem.lblMemberTypeDiscount.text = [NSString stringWithFormat:@"%.2f", item.ratio];
        }
        [detailItem.lblMemberTypeDiscount setTextColor:[ColorHelper getBlueColor]];
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
       
    }
    return detailItem;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:@"卡名称" col2:@"折扣率%"];
    [headItem initColLeft:10 col2:140];
    return headItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        _kindCardVo = (KindCardVo *)[self.datas objectAtIndex:indexPath.row];
        MemberTypeEditView *memberTypeEditView = [[MemberTypeEditView alloc] initWithNibName:[SystemUtil getXibName:@"MemberTypeEditView"] bundle:nil kindCardId:_kindCardVo.kindCardId action:ACTION_CONSTANTS_EDIT];
        [self pushController:memberTypeEditView from:kCATransitionFromRight];
    }
}

- (void)initGrid
{
    self.mainGrid.sectionHeaderHeight = 40.0f;
    self.mainGrid.rowHeight = 88.0f;
    UIView *view = [ViewFactory generateFooter:88];
    view.backgroundColor = [UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
