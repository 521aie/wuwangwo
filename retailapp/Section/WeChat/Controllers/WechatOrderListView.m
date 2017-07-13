 //
//  WechatOrderListView.m
//  retailapp
//
//  Created by yumingdong on 15/10/18.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatOrderListView.h"
#import "WechatService.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "NavigateTitle2.h"
#import "LSAlertHelper.h"
#import "NameItemVO.h"
#import "OrderListCell.h"
#import "MicroOrderDealVo.h"
#import "EditItemList.h"
#import "ScanViewController.h"
#import "DatePickerBox.h"
#import "DateUtils.h"
#import "WechatOrderDetailView.h"
#import "SearchBar3.h"
#import "KxMenu.h"
#import "OptionPickerBox.h"
#import "OrderInfoVo.h"
#import "WeChatOrderSelectView.h"
#import "TDFComplexConditionFilter.h"
#import "LSWeChatFilterModelFactory.h"
#import "DatePickerBox.h"

@interface WechatOrderListView () <ISearchBarEvent,LSScanViewDelegate,INavigateEvent,TDFConditionFilterDelegate,DatePickerClient,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) SearchBar3 *searchBar3;
@property (nonatomic, strong) WechatService *wechatService;
@property (nonatomic, strong) NSMutableDictionary *param;

//查询值
@property (nonatomic, strong) NSString *keyWord;

//订单状态
//@property (nonatomic) int status;

//订单类型 1：销售订单，2：供货订单
@property (nonatomic) int orderType;

//时间区间-开始
@property (nonatomic) long long lessDateTime;

//最后一条数据的创建时间
@property (nonatomic) long long lastDateTime;
@property (nonatomic) long long reFreshlastDateTime;
@property (nonatomic, strong) NSString *searchType;
@property (nonatomic, strong) NSMutableArray *orderInfoList;
@property (nonatomic ,strong) TDFComplexConditionFilter *filterView;/**<筛选姐妹们>*/
@property (nonatomic ,strong) NSArray *filterModes;/**<保存右侧筛选界面需要的数据>*/
@end

@implementation WechatOrderListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.wechatService = [ServiceFactory shareInstance].wechatService;
        self.orderInfoList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    [self configHelpButton:HELP_WECHAT_SALE_ORDER_LIST];
    [self loadData];
}

- (void)configSubviews {
    
    self.searchType = @"单号";
     [self initTime];
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"销售订单" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
    self.searchBar3 = [SearchBar3 searchBar3];;
    self.searchBar3.ls_top = CGRectGetMaxY(self.titleBox.frame);
    [self.searchBar3 initDeleagte:self withName:@"单号" placeholder:@"请输入销售订单编号"];
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
    __weak WechatOrderListView* weakSelf = self;
    [self.tableView ls_addHeaderWithCallback:^{
        weakSelf.lastDateTime = weakSelf.reFreshlastDateTime;
        [weakSelf loadData];
    }];
    
    [self.tableView ls_addFooterWithCallback:^{
        [weakSelf loadData];
    }];
    
    self.filterView = [[TDFComplexConditionFilter alloc] initFilter:@"筛选条件" image:@"ico_filter_normal" highlightImage:@"ico_filter_highlighted"];
    self.filterView.delegate = self;
    self.filterModes = [LSWeChatFilterModelFactory wechatSellOrderListViewFilterModels];
    [self.filterView addToView:self.view withDatas:self.filterModes];
}

#pragma mark - 代理方法

// INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
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
    self.keyWord = nil;
    TDFTwiceCellModel *model = self.filterModes.lastObject;
    if (model.currentValue) {
        self.lessDateTime = [DateUtils converStartTime:model.currentName];
        self.lastDateTime = [DateUtils converEndTime:model.currentName];
        self.reFreshlastDateTime = self.lastDateTime;
    }
    self.lastDateTime = self.reFreshlastDateTime;
    [self initTime];
    [self.searchBar3 changePlaceholder:@"请输入销售订单编号"];
    [self loadData];
}

// DatePickerClient
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    
    if ([DateUtils daysToNow:date]) {
        NSString *dateStr = [DateUtils formateDate2:date];
        TDFTwiceCellModel *model = [self.filterModes lastObject];
        model.currentValue = date;
        model.currentName = dateStr;
    }
    return YES;
}

- (void)clearDate:(NSInteger)eventType {
    TDFTwiceCellModel *model = self.filterModes.lastObject;
    model.currentName = nil;
    model.currentValue = nil;
    [self initTime];
}


// ISearchBarEvent
- (void)selectCondition {
    
    NSArray *menuItems = @[[KxMenuItem menuItem:@"单号"
                                          image:nil
                                         target:self
                                         action:@selector(pushMenuItem:)],
                           [KxMenuItem menuItem:@"手机号"
                                          image:nil
                                         target:self
                                         action:@selector(pushMenuItem:)]];
    CGRect rect = CGRectMake(47, self.searchBar3.frame.origin.y, 80, 32);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
}

- (void)pushMenuItem:(id)sender {
    
    KxMenuItem* item = (KxMenuItem*)sender;
    [self.searchBar3 changeLimitCondition:item.title];
    self.searchType = item.title;
    if ([self.searchType isEqualToString:@"单号"]) {
        [self.searchBar3 changePlaceholder:@"请输入销售订单编号"];
    } else {
        [self.searchBar3 changePlaceholder:@"请输入会员手机号"];
    }
}

// UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderInfoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    WechatOrderDetailView *detailView = [[WechatOrderDetailView alloc] initWithNibName:[SystemUtil getXibName:@"WechatOrderDetailView"] bundle:nil];
    OrderInfoVo *orderInfo = [self.orderInfoList objectAtIndex:indexPath.row];
    detailView.orderId = orderInfo.orderId;
    detailView.orderType = self.orderType;
    detailView.shopId = orderInfo.shopId;
    detailView.receiverName = orderInfo.customerName;
    
    [self.navigationController pushViewController:detailView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma mark - 条形码扫描
// ISearchBarEvent
// 开始扫描
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.keyWord = scanString;
    self.searchBar3.txtKeyWord.text = scanString;
    self.searchBar3.lblName.text = @"单号";
    self.searchType = @"单号";
    [self initTime];
    [self loadData];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [LSAlertHelper showAlert:message];
}

// 输入完成
- (void)imputFinish:(NSString *)keyWord {
    if ([NSString isNotBlank:keyWord]){
        if (![self vaildateMobile]) {//判断如果是手机号查询 手机号不正确不可进行查询
            return;
        }
        if (self.orderType == 1) {
            if ([self.searchType isEqualToString:@"单号"]) {
                keyWord = [@"ROW" stringByAppendingString:keyWord];
            }
        }
    }
    
    [self initTime];
    self.keyWord = keyWord;
    [self.orderInfoList removeAllObjects];
    [self loadData];
}



- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param removeAllObjects];
    NSString *shopId = [[Platform Instance] getkey:SHOP_ID];
    int shopType = 0;
   if ([[Platform Instance] getShopMode] == 3) {
        shopType = 2;
    }else {
        shopType = 1;
    }
    [_param setValue:shopId forKey:@"shopId"];
    //门店类型 1 门店  2 机构
    [_param setValue:@(shopType) forKey:@"shopType"];
    //1 手机 2 订单单号
    //searchKey输入时，必须输入
    if ([NSString isNotBlank:self.keyWord]) {
        
        NSInteger searchType = [self.searchType isEqualToString:@"单号"]?2:1;
        [_param setValue:@(searchType) forKey:@"searchType"];
        
        // 单店或者连锁门店，销售订单按单号查询:销售订单号前+“ROW”
        if (searchType == 2 && [[Platform Instance] getShopMode] != 3 && ![_keyWord hasPrefix:@"ROW"]) {

            NSString *orderNo = [NSString stringWithFormat:@"ROW%@" ,_keyWord];
            [_param setValue:orderNo forKey:@"searchKey"];
            
        } else {
            [_param setValue:self.keyWord forKey:@"searchKey"];
        }
    }
    
    // 查指定状态的：销售订单
    TDFRegularCellModel *statusModel = self.filterModes.firstObject;
    [_param setValue:statusModel.currentValue forKey:@"status"];

    //订单类型 门店传2 其他传 1
    if ([[Platform Instance] getShopMode] == 2) {
        self.orderType = 2;
    } else {
        self.orderType = 1;
    }
    [_param setValue:[NSNumber numberWithInt:self.orderType] forKey:@"orderType"];
    [_param setValue:[NSNumber numberWithLongLong:self.lessDateTime] forKey:@"lessDateTime"];
    [_param setValue:[NSNumber numberWithLongLong:self.lastDateTime] forKey:@"lastDateTime"];
    return _param;
}

- (void)loadData {
    if (![self vaildateMobile]) {//判断如果是手机号查询 手机号不正确不可进行查询
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        return;
    }
    __weak WechatOrderListView* weakSelf = self;
    NSString *url = @"orderManagement/getOrderList";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (weakSelf.reFreshlastDateTime == self.lastDateTime) {
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
        [LSAlertHelper showAlert:json];
    }];
}



#pragma mark - 判断手机号是否正确
- (BOOL)vaildateMobile {
    if ([self.searchBar3.lblName.text isEqualToString:@"手机号"]) {
        NSString *keyWord = self.searchBar3.txtKeyWord.text;
        if ([NSString isNotBlank:keyWord]) {
            if (![NSString validateMobile:keyWord]) {
                [LSAlertHelper showAlert:@"请输入11位手机号码！"];
                return NO;
            }
        }
    }
    return YES;
}


- (void)initTime {
    
    TDFTwiceCellModel *model = self.filterModes.lastObject;
    if (model.currentValue) {
        self.lessDateTime = [DateUtils converStartTime:model.currentName];
        self.lastDateTime = [DateUtils converEndTime:model.currentName];
        self.reFreshlastDateTime = self.lastDateTime;
        
    } else {
        self.lessDateTime = [[DateUtils getYearAgoDate:[NSDate date]] timeIntervalSince1970] * 1000;
        self.lastDateTime = 1;
        self.reFreshlastDateTime = self.lastDateTime;
    }
}

@end
