//
//  MemberRechargeListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberSelectListView.h"
#import "MemberModule.h"
#import "UIHelper.h"
#import "SearchBar2.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "MemberSelectCell.h"
#import "ObjectUtil.h"
#import "UIImageView+WebCache.h"
#import "NSString+Estimate.h"
#import "MemberRechargeEditView.h"
#import "MemberDegreeChangeEditView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "ViewFactory.h"
#import "CardLossEditView.h"
#import "CardCancelEditView.h"
#import "MemberChargeRecordView.h"
#import "XHAnimalUtil.h"
#import "MemberService.h"

@interface MemberSelectListView ()

@property (nonatomic, strong) MemberService* memberService;

@property (nonatomic, strong) CustomerCardVo* tempVo;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, retain) NSString *searchCode;

@property (nonatomic, strong) CustomerCardVo * customerCardVo;

@property (nonatomic) int action;

@property (nonatomic, strong) NSString *lastDateTime;

/**
 1表示为从搜索框搜索，当查询出来为一条信息时，跳转到下一个页面
 */
@property (nonatomic) short isJump;

@end

@implementation MemberSelectListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil action:(int)action
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _lastDateTime = @"1";
        _action = action;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self initGrid];
    [self.memberSearchBarView initDelagate:self placeholder:@"会员名/手机号或后4位"];
    
    NSArray* arr=[[NSArray alloc] init];
    [self.footView initDelegate:self btnArrs:arr];
    _memberService = [ServiceFactory shareInstance].memberService;
    
    __weak MemberSelectListView* weakSelf = self;
    
    [self.mainGrid addHeaderWithCallback:^{
        weakSelf.lastDateTime = @"1";
        [weakSelf selectMemberInfoList];
    }];
    
    [self.mainGrid addFooterWithCallback:^{
        [weakSelf selectMemberInfoList];
    }];
    
    self.footView.btnHelp.enabled = NO;
    self.footView.imgHelp.hidden = YES;
    
    [self loaddatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loaddatas
{
    [self.mainGrid headerBeginRefreshing];
}

-(void) loaddatasFromEdit
{
    self .mainGrid.loading = YES;
    
    [self.datas removeObject:_tempVo];
    [self.mainGrid reloadData];
    
    self .mainGrid.loading = NO;
}


-(void) loaddatasFromCardLossEditView:(NSString*) status
{
    self .mainGrid.loading = YES;
    
    if ([status isEqualToString:@"loss"]) {
        _tempVo.cardStatus = @"2";
    } else {
        _tempVo.cardStatus = @"1";
    }
    
    [self.mainGrid reloadData];
    
    self .mainGrid.loading = NO;
}

-(void) selectMemberInfoList
{
    self.mainGrid.loading = YES;
    
    NSString *searchCode = @"";
    if (self.memberSearchBarView.keyWordTxt.text != nil && ![self.memberSearchBarView.keyWordTxt.text isEqualToString:@""]) {
        searchCode = self.searchCode;
    }
    
    NSString *status = @"";
    if (!(self.action == CARD_LOSS_EDIT_VIEW)) {
        status = @"1";
    }
    __weak MemberSelectListView* weakSelf = self;
    [_memberService selectMemberInfoList:searchCode
                            keywordsKind:@""
                              kindCardId:@""
                         statusCondition:status
                         startActiveTime:@""
                           endActiveTime:@""
                            lastDateTime:_lastDateTime disposeName:nil
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
    
    if (self.datas.count == 1 && _isJump == 1) {
        _tempVo = [self.datas objectAtIndex:0];
        if (self.action == MEMBER_RECHARGE_EDIT_VIEW) {
            MemberRechargeEditView* memberRechargeEditView = [[MemberRechargeEditView alloc] initWithNibName:[SystemUtil getXibName:@"MemberRechargeEditView"] bundle:nil customerId:_tempVo.customerId];
            [self.navigationController pushViewController:memberRechargeEditView animated:NO];
        }else if (self.action == MEMBER_PONIT_EXCHANGE_EDIT_VIEW) {
            MemberDegreeChangeEditView* memberDegreeChangeEditView = [[MemberDegreeChangeEditView alloc] initWithNibName:[SystemUtil getXibName:@"MemberDegreeChangeEditView"] bundle:nil customerId:_tempVo.customerId];
            [self.navigationController pushViewController:memberDegreeChangeEditView animated:NO];
        }else if (self.action == CARD_LOSS_EDIT_VIEW) {
            CardLossEditView* cardLossEditView = [[CardLossEditView alloc] initWithNibName:[SystemUtil getXibName:@"CardLossEditView"] bundle:nil customerId:_tempVo.customerId];
            [self.navigationController pushViewController:cardLossEditView animated:NO];
        }else if (self.action == CARD_CANCEL_EDIT_VIEW) {
            CardCancelEditView* cardCancelEditView = [[CardCancelEditView alloc] initWithNibName:[SystemUtil getXibName:@"CardCancelEditView"] bundle:nil customerId:_tempVo.customerId];
            [self.navigationController pushViewController:cardCancelEditView animated:NO];
        }else if (self.action == MEMBER_CHARGE_RECORD_VIEW) {
            MemberChargeRecordView* memberChargeRecordView = [[MemberChargeRecordView alloc] initWithNibName:[SystemUtil getXibName:@"MemberChargeRecordView"] bundle:nil customerId:_tempVo.customerId];
            [self.navigationController pushViewController:memberChargeRecordView animated:NO];
        }
        
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
    
    _isJump = 0;
    [self.mainGrid reloadData];
    
    self.mainGrid.loading = NO;
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        //退出会员选择页面时，清空页面数据
        [self.datas removeAllObjects];
        [self.mainGrid reloadData];
    }
}

#pragma navigateTitle.
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择会员" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

// 搜索框输入完成方法
- (void)imputFinish:(NSString *)keyWord
{
    if ([NSString isValidNumber:keyWord] && keyWord.length != 4 && keyWord.length != 11) {
        [AlertBox show:@"请输入11位手机号或后四位!"];
        return ;
    }
    _lastDateTime = @"1";
    self.searchCode = keyWord;
    _isJump = 1;
    [self selectMemberInfoList];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"memberRecharge" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

-(void) showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    _tempVo = (CustomerCardVo *) obj;
    if (self.action == MEMBER_RECHARGE_EDIT_VIEW) {
        
        MemberRechargeEditView* memberRechargeEditView = [[MemberRechargeEditView alloc] initWithNibName:[SystemUtil getXibName:@"MemberRechargeEditView"] bundle:nil customerId:_tempVo.customerId];
        [self.navigationController pushViewController:memberRechargeEditView animated:NO];
    }else if (self.action == MEMBER_PONIT_EXCHANGE_EDIT_VIEW) {
        MemberDegreeChangeEditView* memberDegreeChangeEditView = [[MemberDegreeChangeEditView alloc] initWithNibName:[SystemUtil getXibName:@"MemberDegreeChangeEditView"] bundle:nil customerId:_tempVo.customerId];
        [self.navigationController pushViewController:memberDegreeChangeEditView animated:NO];
    }else if (self.action == CARD_LOSS_EDIT_VIEW) {
        CardLossEditView* cardLossEditView = [[CardLossEditView alloc] initWithNibName:[SystemUtil getXibName:@"CardLossEditView"] bundle:nil customerId:_tempVo.customerId];
        [self.navigationController pushViewController:cardLossEditView animated:NO];
    }else if (self.action == CARD_CANCEL_EDIT_VIEW) {
        CardCancelEditView* cardCancelEditView = [[CardCancelEditView alloc] initWithNibName:[SystemUtil getXibName:@"CardCancelEditView"] bundle:nil customerId:_tempVo.customerId];
        [self.navigationController pushViewController:cardCancelEditView animated:NO];
    }else if (self.action == MEMBER_CHARGE_RECORD_VIEW) {
        MemberChargeRecordView* memberChargeRecordView = [[MemberChargeRecordView alloc] initWithNibName:[SystemUtil getXibName:@"MemberChargeRecordView"] bundle:nil customerId:_tempVo.customerId];
        [self.navigationController pushViewController:memberChargeRecordView animated:NO];
    }
    
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}

//#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberSelectCell *detailItem = (MemberSelectCell *)[self.mainGrid dequeueReusableCellWithIdentifier:MemberSelectCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"MemberSelectCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        CustomerCardVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.customerName;
        detailItem.lblMobile.text = [NSString stringWithFormat:@"手机:%@", item.mobile != nil? item.mobile:@""];
        if ([item.cardStatus isEqualToString:@"2"]) {
            [detailItem.btnStatus setTitle:@"挂失" forState:UIControlStateNormal];
        }else if ([item.cardStatus isEqualToString:@"3"]) {
            [detailItem.btnStatus setTitle:@"注销" forState:UIControlStateNormal];
        }else if ([item.cardStatus isEqualToString:@"4"]) {
            [detailItem.btnStatus setTitle:@"异常" forState:UIControlStateNormal];
        }else{
            detailItem.btnStatus.hidden = YES;
        }
        
        //暂无图片
//        UIImage* placeholder = [UIImage imageNamed:@"img_default.png"];
        UIImage *placeholder = nil;
        if (item.sex.integerValue == 2) {
            [detailItem.img setImage:[UIImage imageNamed:@"img_employee_cellbg_female.png"]];
            placeholder = [UIImage imageNamed:@"img_employee_cellbg_female.png"];
        } else {
            [detailItem.img setImage:[UIImage imageNamed:@"img_employee_cellbg_male.png"]];
            placeholder = [UIImage imageNamed:@"img_employee_cellbg_male.png"];
        }
        
        if (item.picture != nil && ![item.picture isEqualToString:@""]) {
            [detailItem.img.layer setMasksToBounds:YES];
            
            [detailItem.img.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
            
            NSURL* url = [NSURL URLWithString:[NSString urlFilterRan:item.picture]];
            
            [detailItem.img sd_setImageWithURL:url placeholderImage:placeholder];

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

-(void)initGrid
{
    self.mainGrid.opaque=YES;
    UIView* view=[ViewFactory generateFooter:60];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

@end
