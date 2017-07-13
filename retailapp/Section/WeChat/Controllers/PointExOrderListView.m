//
//  PointExOrderListView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PointExOrderListView.h"
#import "WechatService.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "NameItemVO.h"
#import "OrderListCell.h"
#import "MicroOrderDealVo.h"
#import "EditItemList.h"
#import "ScanViewController.h"
#import "DatePickerBox.h"
#import "DateUtils.h"
#import "PointExOrderDetailView.h"
#import "SearchBar3.h"
#import "KxMenu.h"
#import "OptionPickerBox.h"
#import "OrderInfoVo.h"
#import "TDFComplexConditionFilter.h"
#import "LSWeChatFilterModelFactory.h"
#import "DatePickerBox.h"

@interface PointExOrderListView () <INavigateEvent, ISearchBarEvent,UITableViewDataSource,UITableViewDelegate, LSScanViewDelegate,TDFConditionFilterDelegate,DatePickerClient>

@property (nonatomic, strong) WechatService *wechatService;
@property (nonatomic) NavigateTitle2 *titleBox;
@property (strong, nonatomic) UIView *titleDiv;
@property (strong, nonatomic) SearchBar3 *searchBar3;
@property (nonatomic ,strong) TDFComplexConditionFilter *filterView;/**<筛选界面>*/
@property (nonatomic ,strong) NSArray *filterModels;/**<右侧筛选数组>*/
//查询值
@property (nonatomic, strong) NSString *keyWord;
//时间区间-开始
@property (nonatomic) long long lessDateTime;
//最后一条数据的创建时间
@property (nonatomic) long long lastDateTime;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSMutableArray *orderInfoList;
@property (nonatomic) long long reFreshlastDateTime;
@end

@implementation PointExOrderListView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wechatService = [ServiceFactory shareInstance].wechatService;
    [self configSubview];
    [self initTime];
    [self selectOrderList];
    [self configHelpButton:HELP_WECHAT_INTERGAL_EXCHANGE_ORDER_LIST];
}

- (void)configSubview {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"积分兑换订单" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
    self.searchBar3 = [SearchBar3 searchBar3];;
    self.searchBar3.ls_top = CGRectGetMaxY(self.titleBox.frame);
    [self.searchBar3 initDeleagte:self withName:@"单号" placeholder:@"请输入订单编号"];
    [self.searchBar3 showCondition:YES];
    [self.view addSubview:self.searchBar3];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar3.ls_bottom, SCREEN_W, SCREEN_H-self.searchBar3.ls_bottom) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView ls_addHeaderWithCallback:^{
        weakSelf.lastDateTime = weakSelf.reFreshlastDateTime;
        [weakSelf selectOrderList];
    }];
    
    [self.tableView ls_addFooterWithCallback:^{
        [weakSelf selectOrderList];
    }];
    
    self.filterView = [[TDFComplexConditionFilter alloc] initFilter:@"筛选条件" image:@"ico_filter_normal" highlightImage:@"ico_filter_highlighted"];
    self.filterView.delegate = self;
    self.filterModels = [LSWeChatFilterModelFactory wechatIntegralExchangeOrderListViewFilterModels];
    [self.filterView addToView:self.view withDatas:self.filterModels];
}

#pragma mark - 代理方法
// INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event==1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

// TDFConditionFilterDelegate
- (void)tdf_filter:(TDFComplexConditionFilter *)filter actionWithCellModel:(TDFFilterMoel *)model {
    if (model.type == TDF_TwiceFilterCellOneLine) {
        TDFTwiceCellModel *sModel = (TDFTwiceCellModel *)model;
        NSDate *date = sModel.currentValue ?:[NSDate date];
        [DatePickerBox setMaximumDate:[NSDate date]];
        [DatePickerBox showClear:model.optionName clearName:@"清空日期" date:date client:self event:11];
    }
}

- (void)tdf_filterReset {
    [self initTime];
}

- (void)tdf_filterCompleted {
    self.searchBar3.txtKeyWord.text = @"";
    TDFTwiceCellModel *model = self.filterModels.lastObject;
    if (model.currentName) {
        self.lessDateTime = [DateUtils converStartTime:model.currentName];
        self.lastDateTime = [DateUtils converEndTime:model.currentName];
        self.reFreshlastDateTime = self.lastDateTime;
        
    }
    self.lastDateTime = self.reFreshlastDateTime;
    [self.tableView headerBeginRefreshing];
}

// DatePickerClient
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    
    if ([DateUtils daysToNow:date]) {
        NSString *dateStr = [DateUtils formateDate2:date];
        TDFTwiceCellModel *model = [self.filterModels lastObject];
        model.currentValue = date;
        model.currentName = dateStr;
    }
    return YES;
}

- (void)clearDate:(NSInteger)eventType {
    TDFTwiceCellModel *model = self.filterModels.lastObject;
    model.currentName = nil;
    model.currentValue = nil;
    [self initTime];
}

#pragma mark - 条形码扫描

// 开始扫描
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.keyWord = scanString;
    [self.searchBar3 initDeleagte:self withName:@"单号" placeholder:@"请输入订单编号"];
    self.searchBar3.txtKeyWord.text = scanString;
    [self imputFinish:scanString];
    [self.tableView headerBeginRefreshing];
    
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord {
    if (![self vaildateMobile]) {//判断如果是手机号查询 手机号不正确不可进行查询
        return;
    }
    if ([self.searchBar3.lblName.text isEqualToString:@"单号"]) {
        keyWord = [@"ROW" stringByAppendingString:keyWord];
    }
    self.keyWord = keyWord;
    [self initTime];
    [self.tableView headerBeginRefreshing];
}

// UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderInfoList.count;
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSString *cellIdentifier = @"cell";
    OrderListCell *orderListCell = (OrderListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!orderListCell) {
        [tableView registerNib:[UINib nibWithNibName:@"OrderListCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        orderListCell = (OrderListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    OrderInfoVo *orderInfo = [self.orderInfoList objectAtIndex:indexPath.row];
    [orderListCell initDate:orderInfo];
    return orderListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PointExOrderDetailView *detailView = [[PointExOrderDetailView alloc] initWithNibName:[SystemUtil getXibName:@"PointExOrderDetailView"] bundle:nil];
    
    OrderInfoVo *orderInfo = [self.orderInfoList objectAtIndex:indexPath.row];
    detailView.orderId = orderInfo.orderId;
    detailView.shopId = orderInfo.shopId;
    detailView.receiverName = orderInfo.customerName;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:detailView animated:NO];
}


- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param removeAllObjects];
    NSString *shopId = [[Platform Instance] getkey:SHOP_ID];
    
    [_param setValue:shopId forKey:@"shopId"];
    [_param setValue:@(self.lessDateTime) forKey:@"lessDateTime"];
    [_param setValue:@(self.lastDateTime) forKey:@"lastDateTime"];
    
    // 指定查询订单的状态
    TDFRegularCellModel *model = self.filterModels.firstObject;
    [_param setValue:model.currentValue forKey:@"status"];

    if ([NSString isNotBlank:self.keyWord]) {
         [_param setValue:self.keyWord forKey:@"searchKey"];
        if ([self.searchBar3.lblName.text isEqualToString:@"单号"]) {
            [_param setValue:@"code" forKey:@"searchType"];
        } else {
            [_param setValue:@"phone" forKey:@"searchType"];
        }
    }
    
    return _param;
}

- (void)selectOrderList {
    __weak typeof(self) weakSelf = self;
    //店铺类型
    if (![self vaildateMobile]) {//判断如果是手机号查询 手机号不正确不可进行查询
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        return;
    }
    
    [_wechatService selectIntegralOrderList:self.param
                          completionHandler:^(id json) {
                      
                      [weakSelf.tableView headerEndRefreshing];
                      [weakSelf.tableView footerEndRefreshing];
                      
                      if (!_orderInfoList) {
                          _orderInfoList = [NSMutableArray array];
                      }
                          
                      if (weakSelf.reFreshlastDateTime == weakSelf.lastDateTime) {
                          [weakSelf.orderInfoList removeAllObjects];
                      }
                      if ([ObjectUtil isNotNull:json[@"lastDateTime"]]) {
                          weakSelf.lastDateTime = [json[@"lastDateTime"] longLongValue];
                      }
                      NSArray *list = [OrderInfoVo converToArr:json[@"orderInfoList"]];
                      [weakSelf.orderInfoList addObjectsFromArray:list];
                      [weakSelf.tableView reloadData];
                      
                  } errorHandler:^(id json) {
                      [weakSelf.tableView headerEndRefreshing];
                      [weakSelf.tableView footerEndRefreshing];
                      [AlertBox show:json];
                  }];
}



#pragma mark - 选择检索条件
- (void)selectCondition {
    
    NSArray *menuItems = @[
                           [KxMenuItem menuItem:@"单号"
                                          image:nil
                                         target:self
                                         action:@selector(pushMenuItem:)],
                           
                           [KxMenuItem menuItem:@"手机号"
                                          image:nil
                                         target:self
                                         action:@selector(pushMenuItem:)]
                           ];
    
    CGRect rect = CGRectMake(47, self.searchBar3.frame.origin.y, 80, 32);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
}

- (void)pushMenuItem:(id)sender {
    KxMenuItem* item = (KxMenuItem*)sender;
    [self.searchBar3 changeLimitCondition:item.title];
    if ([self.searchBar3.lblName.text isEqualToString:@"单号"]) {
        [self.searchBar3 changePlaceholder:@"请输入订单编号"];
    } else {
        [self.searchBar3 changePlaceholder:@"请输入会员手机号"];
    }
}



#pragma mark - 判断手机号是否正确
- (BOOL)vaildateMobile {
    if ([self.searchBar3.lblName.text isEqualToString:@"手机号"]) {
        NSString *keyWord = self.searchBar3.txtKeyWord.text;
        if ([NSString isNotBlank:keyWord]) {
            if (![NSString validateMobile:keyWord]) {
                [AlertBox show:@"请输入11位手机号码！"];
                return NO;
            }
        }
    }
    return YES;
}


- (void)initTime {
    self.lessDateTime = [[DateUtils getYearAgoDate:[NSDate date]] timeIntervalSince1970] * 1000;
    self.lastDateTime = [[NSDate date] timeIntervalSince1970] * 1000;
    self.reFreshlastDateTime = self.lastDateTime;
}

@end
