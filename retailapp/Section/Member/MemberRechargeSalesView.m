//
//  MemberRechargeSalesView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberRechargeSalesView.h"
#import "ServiceFactory.h"
#import "SaleRechargeVo.h"
#import "DateUtils.h"
#import "MemberModule.h"
#import "GridColHead.h"
#import "MemberRechargeSalesCell.h"
#import "XHAnimalUtil.h"
#import "ObjectUtil.h"
#import "MemberRechargeSalesEditView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "ColorHelper.h"

@interface MemberRechargeSalesView ()

@property (nonatomic, strong) MemberService* memberService;

@property (nonatomic, strong) SaleRechargeVo* tempVo;

@end

@implementation MemberRechargeSalesView

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
    NSArray *arr = [[NSArray alloc] initWithObjects:@"add",nil];
    [self initDelegate:self event:@"memberRechargeSales" title:@"充值促销" foots:arr];
    __weak MemberRechargeSalesView* weakSelf = self;
    [self.mainGrid addHeaderWithCallback:^{
        [weakSelf selectRechargeSalesList];
    }];
    
    [self loadDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadDatas
{
    [self.mainGrid headerBeginRefreshing];
}

- (void)selectRechargeSalesList
{
    self .mainGrid.loading = YES;
    
    __weak MemberRechargeSalesView* weakSelf = self;
    [_memberService selectRechargeSalesList:@"0" completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
        [weakSelf.mainGrid headerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
    }];
}

- (void)responseSuccess:(id)json
{
    self.datas = [JsonHelper transList:[json objectForKey:@"saleRechargeList"] objName:@"SaleRechargeVo"];
    
    [self.mainGrid reloadData];
    
    self .mainGrid.loading = NO;
}

- (void)loadDatasFromEdit:(SaleRechargeVo*) saleRechargeVo action:(int) action
{
    if (action == ACTION_CONSTANTS_EDIT) {
        _tempVo.name = saleRechargeVo.name;
        _tempVo.rechargeThreshold = saleRechargeVo.rechargeThreshold;
        _tempVo.money = saleRechargeVo.money;
        _tempVo.startTime = saleRechargeVo.startTime;
        _tempVo.endTime = saleRechargeVo.endTime;
        _tempVo.point = saleRechargeVo.point;
    }else if (action == ACTION_CONSTANTS_DEL){
        self .mainGrid.loading = YES;
        
        [self.datas removeObject:_tempVo];
    }
    
    [self.mainGrid reloadData];
    
    self .mainGrid.loading = NO;
}

- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)showHelpEvent
{
    
}

- (void)showAddEvent:(NSString *)event
{
    MemberRechargeSalesEditView* memberRechargeSalesEditView = [[MemberRechargeSalesEditView alloc] initWithNibName:[SystemUtil getXibName:@"MemberRechargeSalesEditView"] bundle:nil saleRechargeId:nil action:ACTION_CONSTANTS_ADD];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:memberRechargeSalesEditView animated:NO];
}

-(void) showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    _tempVo = (SaleRechargeVo *) obj;
    MemberRechargeSalesEditView* memberRechargeSalesEditView = [[MemberRechargeSalesEditView alloc] initWithNibName:[SystemUtil getXibName:@"MemberRechargeSalesEditView"] bundle:nil saleRechargeId:_tempVo.saleRechargeId action:ACTION_CONSTANTS_EDIT];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:memberRechargeSalesEditView animated:NO];
    
}

#pragma table head
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *) [self.mainGrid dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:@"活动名称" col2:@"活动状态"];
    [headItem initColLeft:10 col2:140];
    return headItem;
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberRechargeSalesCell *detailItem = (MemberRechargeSalesCell *)[self.mainGrid dequeueReusableCellWithIdentifier:MemberRechargeSalesCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"MemberRechargeSalesCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        SaleRechargeVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblRechargeSalesName.text = item.name;
        
        if (item.startTime > [DateUtils formateDateTime3:[DateUtils formateDate2:[NSDate date]]]) {
            detailItem.lblStatus.text = @"未开始";
            [detailItem.lblStatus setTextColor:[ColorHelper getGreenColor]];
        }else if (item.startTime <= [DateUtils formateDateTime3:[DateUtils formateDate2:[NSDate date]]] && item.endTime >= [DateUtils formateDateTime3:[DateUtils formateDate2:[NSDate date]]]){
            detailItem.lblStatus.text = @"正在进行";
            [detailItem.lblStatus setTextColor:[ColorHelper getBlueColor]];
        }
        detailItem.lblRechargeThreshold.text = [NSString stringWithFormat:@"%.2f", item.rechargeThreshold];
        [detailItem.lblRechargeThreshold setTextColor:[ColorHelper getBlueColor]];
        detailItem.lblMoney.text = [NSString stringWithFormat:@"%.2f", item.money];
        [detailItem.lblMoney setTextColor:[ColorHelper getBlueColor]];
        
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"memberRechargeSales" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

@end
