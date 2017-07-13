//
//  MemberChargeRecordView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberChargeRecordView.h"
#import "NavigateTitle2.h"
#import "ObjectUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "ViewFactory.h"
#import "MemberModule.h"
#import "MemberChargeRecordCell.h"
#import "ChargeRecordListVo.h"
#import "DateUtils.h"
#import "ChargeRecordSelectTopView.h"
#import "MemberRedRechargeEditView.h"
#import "XHAnimalUtil.h"
#import "ColorHelper.h"

@interface MemberChargeRecordView ()

@property (nonatomic, strong) MemberService* memberService;

@property (nonatomic, strong) ChargeRecordListVo* chargeRecordListVo;

@property (nonatomic, retain) NSString *customerId;

@property (nonatomic, retain) NSString *lastDateTime;

@property (nonatomic, retain) NSString *startTime;

@property (nonatomic, retain) NSString *endTime;

@property (nonatomic, retain) NSMutableArray *datas;

@end

@implementation MemberChargeRecordView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil customerId:(NSString *) customerId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _customerId = customerId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self initGrid];
    _memberService = [ServiceFactory shareInstance].memberService;
    __weak MemberChargeRecordView* weakSelf = self;
    [self.mainGrid addHeaderWithCallback:^{
        self.lastDateTime = @"";
        [weakSelf selectChargeRecordList:self.startTime endTime:self.endTime lastDateTime:self.lastDateTime];
        
    }];
    
    [self.mainGrid addFooterWithCallback:^{
        [weakSelf selectChargeRecordList:self.startTime endTime:self.endTime lastDateTime:self.lastDateTime];
    }];
    
    [self loaddatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loaddatas
{
    self.lastDateTime = @"";
    self.startTime = @"";
    self.endTime = @"";
    [self.mainGrid headerBeginRefreshing];
}

-(void) loaddatasFromEdit
{
    _chargeRecordListVo.status = 0;
    [self.mainGrid reloadData];
}

-(void) selectChargeRecordList:(NSString*) startTime endTime:(NSString*) endtime lastDateTime:(NSString*) lastDateTime
{
    self.mainGrid.loading = YES;
    
    self.lastDateTime = lastDateTime;
    self.startTime = startTime;
    self.endTime = endtime;
    
    __weak MemberChargeRecordView* wealSelf = self;
    [_memberService selectMemberChargeRecord:self.customerId chargeStartDate:startTime chargeEndDate:endtime lastDateTime:self.lastDateTime completionHandler:^(id json) {
        if (!(wealSelf)) {
            return ;
        }
        [wealSelf responseSuccess:json];
        [wealSelf.mainGrid headerEndRefreshing];
        [wealSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [wealSelf.mainGrid headerEndRefreshing];
        [wealSelf.mainGrid footerEndRefreshing];
    }];
}

- (void)responseSuccess:(id)json
{
    
    NSMutableArray* arrList = [JsonHelper transList:[json objectForKey:@"chargeRecordList"] objName:@"ChargeRecordListVo"];
    
    if ([NSString isBlank:self.lastDateTime]) {
        if (self.datas != nil) {
            [self.datas removeAllObjects];
            [self.datas addObjectsFromArray:arrList];
        }else{
            self.datas = arrList;
        }
    }else{
        [self.datas addObjectsFromArray:arrList];
    }
    
    if ([ObjectUtil isEmpty:[json objectForKey:@"lastDateTime"]]) {
        self.lastDateTime = @"";
    }else{
        self.lastDateTime = [NSString stringWithFormat:@"%@", [json objectForKey:@"lastDateTime"]];
    }
    
    [self.mainGrid reloadData];
    
    self.mainGrid.loading = NO;
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        if (!self.chargeRecordSelectTopView) {
            self.chargeRecordSelectTopView = [[ChargeRecordSelectTopView alloc] initWithNibName:[SystemUtil getXibName:@"ChargeRecordSelectTopView"] bundle:nil];
            [self.view addSubview:self.chargeRecordSelectTopView.view];
            [self.view bringSubviewToFront:self.chargeRecordSelectTopView.view];
        }
        self.chargeRecordSelectTopView.delegate = self;
        [self.chargeRecordSelectTopView oper];
    }
}

-(void) selectChangeRecord:(NSString *)startTime endTime:(NSString *)endtime lastDateTime:(NSString *)lastDateTime
{
    [self selectChargeRecordList:startTime endTime:endtime lastDateTime:lastDateTime];
}

#pragma navigateTitle.
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"会员充值记录" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    self.titleBox.lblRight.text = @"筛选";
    self.titleBox.lblRight.hidden = NO;
    [self.titleDiv addSubview:self.titleBox];
}

-(void)initGrid
{
    self.mainGrid.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"memberChargeRecord" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

-(void) showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    _chargeRecordListVo = (ChargeRecordListVo*) obj;
    MemberRedRechargeEditView* memberRedRechargeEditView = [[MemberRedRechargeEditView alloc] initWithNibName:[SystemUtil getXibName:@"MemberRedRechargeEditView"] bundle:nil moneyFlowId:_chargeRecordListVo.moneyFlowId customerId:_customerId status:_chargeRecordListVo.status action:ACTION_CONSTANTS_EDIT];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:memberRedRechargeEditView animated:NO];
    
}

//#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberChargeRecordCell *detailItem = (MemberChargeRecordCell *)[self.mainGrid dequeueReusableCellWithIdentifier:MemberSelectCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"MemberChargeRecordCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        ChargeRecordListVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblCustomerName.text = item.customerName;
        detailItem.lblMobile.text = [NSString stringWithFormat:@"%@", item.mobile != nil? item.mobile:@""];
        if (item.status == 0) {
            detailItem.lblMoney.text = [NSString stringWithFormat:@"￥%.2f(已红冲)", item.payMoney];
            [detailItem.lblMoney setTextColor:[ColorHelper getRedColor]];
        }else{
            detailItem.lblMoney.text = [NSString stringWithFormat:@"￥%.2f", item.payMoney];
            [detailItem.lblMoney setTextColor:[ColorHelper getTipColor6]];
        }
        
        detailItem.lblTime.text = [DateUtils formateTime4:item.moneyFlowCreatetime];
        
        if (item.payType == 1) {
            detailItem.btnType.hidden = YES;
        }
        
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return detailItem;
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

@end
