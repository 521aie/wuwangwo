//
//  MemberDegreeExchangeEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberDegreeChangeEditView.h"
#import "MemberModule.h"
#import "DegreeExchangeCell.h"
#import "ObjectUtil.h"
#import "CustomerCardVo.h"
#import "GoodsGiftVo.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "GridColHead.h"
#import "TextStepperField.h"
#import "DegreeExchangeFootView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "Platform.h"
#import "MemberSelectListView.h"
#import "JsonHelper.h"
#import "CustomerVo.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"

@interface MemberDegreeChangeEditView ()

@property (nonatomic,strong) DegreeExchangeFootView* footItem;

@property (nonatomic,strong) MemberService* memberService;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, retain) NSMutableArray *goodsGiftList;

@property (nonatomic) int point;

@property (nonatomic) int goodsNum;

@property (nonatomic, strong) CustomerVo *customerVo;

@property (nonatomic, strong) NSString *customerId;

@property (nonatomic, copy) NSString *token;

@end

@implementation MemberDegreeChangeEditView

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
    self.footItem = [[NSBundle mainBundle] loadNibNamed:@"DegreeExchangeFootView" owner:self options:nil].lastObject;
    self.footItem.delegate = self;
    [self loaddatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loaddatas
{
    __weak MemberDegreeChangeEditView* weakSelf = self;
    [_memberService selectMemberInfoDetail:_customerId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        self.customerVo = [JsonHelper dicTransObj:[json objectForKey:@"customer"] obj:[CustomerVo new]];
        self.titleBox.lblTitle.text = self.customerVo.name;
        [self selectGiftGoodsList];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

-(void) selectGiftGoodsList
{
    __weak MemberDegreeChangeEditView* weakSelf = self;
    [_memberService selectGiftGoodsList:self.customerVo.card.point == 0 ? @"0":[NSString stringWithFormat:@"%ld", self.customerVo.card.point] completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    NSMutableArray *array = [json objectForKey:@"goodsGiftList"];
    self.datas = [[NSMutableArray alloc] init];
    for (NSDictionary* dic in array) {
        [self.datas addObject:[GoodsGiftVo convertToGoodsGiftVo:dic]];
    }
    
    self.footItem.lblGoodsNum.text = [NSString stringWithFormat:@"%d", 0];
    self.footItem.lblpoint.text = [NSString stringWithFormat:@"%d", 0];
    self.goodsGiftList = [[NSMutableArray alloc] init];
    
    self.point = 0;
    
    self.goodsNum = 0;
    
    [self fillModel];
    
    if (self.datas.count > 0) {
        self.mainGrid.tableFooterView = self.footItem;
        
    } else {
        self.backView.alpha = 1.0;
        [self.backView setBackgroundColor:[UIColor clearColor]];
    }
    
    [self.mainGrid reloadData];
}

-(void) fillModel
{
    self.lblMobile.text = self.customerVo.mobile;
    if (self.customerVo.card.point == 0) {
        self.lblPoint.text = @"0";
    }else{
        self.lblPoint.text = [NSString stringWithFormat:@"%ld", self.customerVo.card.point];
    }
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma navigateTitle.
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"积分兑换" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

#pragma mark table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DegreeExchangeCell *detailItem = (DegreeExchangeCell *)[self.mainGrid dequeueReusableCellWithIdentifier:MemberDegreeExchangeCellIndentifier];
    
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"DegreeExchangeCell" owner:self options:nil].lastObject;
    }
    
    detailItem.textStepperField.delegate=self;
    detailItem.delegate=self;
    
    [detailItem.checkImg setHidden:YES];

    if ([ObjectUtil isNotEmpty:self.datas]) {
        GoodsGiftVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.textStepperField.vo = item;
        if ([NSString isBlank:[NSString stringWithFormat:@"%ld", item.number]] || item.number == 0) {
            detailItem.textStepperField.lbVal.text = @"1";
        }else{
            detailItem.textStepperField.lbVal.text = [NSString stringWithFormat:@"%ld", item.number];
        }
        
        detailItem.vo = item;
        
        if (![NSString isBlank:item.isCheck] && [item.isCheck isEqualToString:@"1"]) {
            [detailItem.uncheckImg setHidden:YES];
            [detailItem.checkImg setHidden:NO];
            [detailItem.textStepperField setHidden:NO];
        }else{
            [detailItem.uncheckImg setHidden:NO];
            [detailItem.checkImg setHidden:YES];
            [detailItem.textStepperField setHidden:YES];
        }

        if ([[Platform Instance] getkey:SHOP_MODE].intValue == 101) {
            detailItem.lblCode.text = item.innerCode;
        }else{
            detailItem.lblCode.text = item.barCode;
        }
        detailItem.lblGoodsName.text = item.name;
        if ([NSString isBlank:[NSString stringWithFormat:@"%ld积分", item.point]]) {
            detailItem.lblNeedPoint.text = @"0积分";
        }else{
            detailItem.lblNeedPoint.text = [NSString stringWithFormat:@"%ld积分", item.point];
        }
        
        if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) {
            [detailItem setPointLocation:102];
        }
        
        if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
            detailItem.lblAttribute.text = [NSString stringWithFormat:@"%@ %@", item.goodsColor, item.goodsSize];
        }
        
        [detailItem.lblNeedPoint setTextColor:[ColorHelper getRedColor]];
        
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    _item = [self.datas objectAtIndex:indexPath.row];
}


#pragma delegate
-(void) initGoodsNum:(int)num item:(GoodsGiftVo *)vo
{
    self.point = (int)self.point + (int)vo.point * num;
    vo.number = num;
    self.goodsNum = self.goodsNum + num;
    self.footItem.lblGoodsNum.text = [NSString stringWithFormat:@"%d", self.goodsNum];
    self.footItem.lblpoint.text = [NSString stringWithFormat:@"%d", self.point];
    
    if ([vo.isCheck isEqualToString:@"1"]) {
        if (self.goodsGiftList != nil) {
            BOOL flg = false;
            for (GoodsGiftVo* temp in self.goodsGiftList) {
                if ([temp.name isEqualToString:vo.name]) {
                    temp.number = temp.number + num;
                    flg = true;
                    break;
                }
            }
            if (!flg) {
                [self.goodsGiftList addObject:vo];
            }
        }else{
            self.goodsGiftList = [[NSMutableArray alloc] init];
            [self.goodsGiftList addObject:vo];
        }
    }else{
        [self.goodsGiftList removeObject:vo];
    }
}

- (void)showGoodsNum:(int)num item:(GoodsGiftVo *)vo
{
    vo.number =vo.number + num;
    self.point = (int)self.point  + (int)vo.point * num;
    self.goodsNum = self.goodsNum + num;
    
    self.footItem.lblGoodsNum.text = [NSString stringWithFormat:@"%d", self.goodsNum];
    self.footItem.lblpoint.text = [NSString stringWithFormat:@"%d", self.point];
}

-(BOOL) isValid
{
    if (self.goodsGiftList == nil || self.goodsGiftList.count == 0) {
        [AlertBox show:@"请选择所需兑换的商品！"];
        return NO;
    }
    
    if (self.point > self.customerVo.card.point) {
        [AlertBox show:@"兑换商品所需积分大于卡内积分，请重新选择商品!"];
        return NO;
    }
    
    if ([[Platform Instance] getShopMode] == 3) {
        [AlertBox show:@"非门店用户不允许进行积分兑换操作!"];
        return NO;
    }
    
    return YES;
}

#pragma mark 兑换按钮
-(void) ExchangeButton
{
    if (![self isValid]) {
        return ;
    }
    
    [UIHelper alert:self.view andDelegate:self andTitle:@"确认要兑换吗？"];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        
        NSString* shopId = [[Platform Instance] getkey:SHOP_ID];
        
        NSMutableArray* goodsGiftList = [[NSMutableArray alloc] init];
        for (GoodsGiftVo* vo in self.goodsGiftList) {
            [goodsGiftList addObject:[GoodsGiftVo getDictionaryData:vo]];
        }
        
        if ([NSString isBlank:_token]) {
            _token = [[Platform Instance] getToken];
        }
        
        __weak MemberDegreeChangeEditView* weakSelf = self;
        [_memberService doExchangeGiftGoods:weakSelf.customerVo.card.cardId shopId:shopId lastVer:[NSString stringWithFormat:@"%ld", weakSelf.customerVo.card.lastVer] goodsGiftList:goodsGiftList token:weakSelf.token completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            weakSelf.token = nil;
            [weakSelf excFinish];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    }
}

-(void) excFinish
{
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
