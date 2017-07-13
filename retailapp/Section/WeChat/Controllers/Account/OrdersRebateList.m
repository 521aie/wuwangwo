//
//  WeChatRebateOrders.m
//  retailapp
//
//  Created by diwangxie on 16/4/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrdersRebateList.h"
#import "XHAnimalUtil.h"
#import "OrdersRebateListCell.h"
#import "BaseService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "OrderRebateDetail.h"
#import "ObjectUtil.h"
#import "RebateOrdersVo.h"
#import "AccountInfoVo.h"
#import "NameItemVO.h"
#import "ObjectUtil.h"
#import "UIHelper.h"

@interface OrdersRebateList ()
@property (nonatomic, strong) BaseService             *service;           //网络服务
@property (nonatomic, strong) NSString                *companionAccountId;//id
@property (nonatomic) long long                       createTime;           //翻页
@property (nonatomic,strong) NSMutableArray           *orderRebates;      //返利订单列表
@property (nonatomic,strong) AccountInfoVo            *accountInfoVo;
@end

@implementation OrdersRebateList

- (void)viewDidLoad {
    [super viewDidLoad];
    _service = [ServiceFactory shareInstance].baseService;
    self.createTime=1;
    [self initHead];
    [self initFilterView];
    [self initGrid];
    [self loadDate];
    
}
-(void)initHead{
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"总部微店订单" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    self.titleBox.lblRight.text=@"筛选";
    [self.titleDiv addSubview:self.titleBox];
}

- (void)initFilterView {
    [self.lstRebateState initLabel:@"返利状态" withHit:nil delegate:self];
    [self.lstRebateState initData:@"全部" withVal:@"0"];
    self.lstRebateState.tag = 1;
    
}
-(void)initGrid{
    [self.mainGrid ls_addHeaderWithCallback:^{
        self.createTime=1;
        [self loadDate];
    }];
    
    [self.mainGrid ls_addFooterWithCallback:^{
        [self loadDate];
    }];
}
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        //筛选
        [self.view addSubview:self.viewFilter];
    }
}
-(void)loadDate{
    NSString *url = nil;
    
    url = @"accountInfo/orderRebate/list";
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    [param setValue:[NSNumber numberWithInteger:0] forKey:@"rebateDiv"];
   self.companionAccountId=[[Platform Instance] getkey:SHOP_ID];
    [param setValue:self.companionAccountId forKey:@"companionAccountId"];
    [param setValue:[NSNumber numberWithLongLong:[[self.lstRebateState getStrVal] intValue]] forKey:@"rebateDiv"];
    [param setValue:[NSNumber numberWithLongLong:self.createTime] forKey:@"createTime"];
    
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if (self.createTime==1) {
            [self.orderRebates removeAllObjects];
        }
        id createTime = [json objectForKey:@"createTime"];
        if ([ObjectUtil isNotNull:createTime]) {
            self.createTime=[[json objectForKey:@"createTime"] longLongValue];
        }
        NSArray *arr = [json objectForKey:@"orderRebates"];
        if ([ObjectUtil isNotNull:arr]) {
            [self.orderRebates addObjectsFromArray:arr];
        }
        
        if(self.accumulatedAmount!=0){
            self.lblAllGains.text=[NSString stringWithFormat:@"%.2f",self.accumulatedAmount];
        }else{
            self.headView.hidden=YES;
            [UIHelper refreshPos:self.container scrollview:self.scrollView];
        }
        [self.mainGrid reloadData];
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
    }];
}

- (NSMutableArray *)orderRebates {
    if (_orderRebates == nil) {
        _orderRebates=[[NSMutableArray alloc] init];
    }
    return _orderRebates;
}


- (void)onItemListClick:(EditItemList*)obj {
    if(obj==self.lstRebateState){
        NSMutableArray *nameItems = [[NSMutableArray alloc] init];
        NameItemVO *nameItemVo = [[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"待结算" andId:@"1"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"可提现" andId:@"2"];
        [nameItems addObject:nameItemVo];
        
        [OptionPickerBox initData:nameItems itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    NSLog(@"%ld",(long)eventType);
    if (eventType==1){
        id<INameItem> item = (id<INameItem>)selectObj;
        [self.lstRebateState initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

- (IBAction)closeFilterView:(id)sender {
    [self.viewFilter removeFromSuperview];
}

- (IBAction)filterOkClick:(UIButton *)sender {
    self.createTime=1;
    [self loadDate];
    [self.viewFilter removeFromSuperview];
}
- (IBAction)filterCancelClick:(UIButton *)sender {
    [self.lstRebateState initData:@"全部" withVal:@"0"];
}

#pragma mark - 表格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderRebates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* ordersRebateListCell = @"OrdersRebateListCell";
    OrdersRebateListCell * cell = [tableView dequeueReusableCellWithIdentifier:ordersRebateListCell];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ordersRebateListCell owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[OrdersRebateListCell class]]) {
                cell = (OrdersRebateListCell *)o;
                break;
            }
        }
    }
    [cell initDate:[self.orderRebates objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RebateOrdersVo *vo=[RebateOrdersVo convertToRebateOrdersVo:[self.orderRebates objectAtIndex:indexPath.row]];
    
    OrderRebateDetail*vc = [[OrderRebateDetail alloc] initWithNibName:[SystemUtil getXibName:@"OrderRebateDetail"] bundle:nil];
    vc.orderRebateId=vo.id;
    vc.orderId = vo.orderId;
    vc.rebateState = vo.rebateState;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
