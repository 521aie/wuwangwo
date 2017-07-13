//
//  SellRetrunListView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SellRetrunListView.h"
#import "ServiceFactory.h"
#import "SellReturnService.h"
#import "LSAlertHelper.h"
#import "WechatService.h"
#import "MicroBasicSetVo.h"
#import "SellReturnListCell.h"
#import "RetailSellReturnVo.h"
#import "XHAnimalUtil.h"
#import "OptionPickerBox.h"
#import "DatePickerBox.h"
#import "NameItemVO.h"
#import "DateUtils.h"
#import "SellReturnDetailView.h"
#import "KxMenu.h"
#import "ScanViewController.h"
#import "SearchBar3.h"
#import "TDFComplexConditionFilter.h"
#import "LSWeChatFilterModelFactory.h"

@interface SellRetrunListView () <INavigateEvent, DatePickerClient,ISearchBarEvent,LSScanViewDelegate, TDFConditionFilterDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NavigateTitle2* titleBox;
//查找
@property (strong, nonatomic) SearchBar3 *searchView;
@property (nonatomic, strong) SellReturnService *sellReturnService;
@property (nonatomic, strong) WechatService *wechatService;
@property (nonatomic ,strong) TDFComplexConditionFilter *filterView;/**<右侧筛选页>*/
@property (nonatomic ,strong) NSArray *filterModels;/**<筛选页需要的数据>*/
//检索条件
@property (nonatomic, strong) NSString *keywords;   //退货号	 String
@property (nonatomic, strong) NSString *mobile;     //手机号或后4位 String
@property (nonatomic, strong) NSString *returnTime; //退货时间 String
@property (nonatomic) long long lastDateTime;       //最后记录时间	 Long
@property (nonatomic, strong) NSString *searchType;
//数据
@property (nonatomic, strong) NSMutableArray *sellReturnList;
@property (strong, nonatomic) UITableView *mainGrid;
@end

@implementation SellRetrunListView

- (void)viewDidLoad {
   [super viewDidLoad];

   self.sellReturnService = [ServiceFactory shareInstance].sellReturnService;
   self.wechatService = [ServiceFactory shareInstance].wechatService;
   self.lastDateTime = 1;
   [self configSubviews];
   [self loadData];
    [self configHelpButton:HELP_WECHAT_RETURN_AUDIT_LIST];
}

- (void)configSubviews {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"退货审核" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
    self.searchType = @"单号";
    self.searchView = [SearchBar3 searchBar3];
    self.searchView.ls_top = CGRectGetMaxY(self.titleBox.frame);
    [self.searchView initDeleagte:self withName:@"单号" placeholder:@"请输入退货单号"];
    [self.searchView showCondition:YES];
    [self.view addSubview:self.searchView];
    
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchView.ls_bottom, SCREEN_W, SCREEN_H-self.searchView.ls_bottom) style:UITableViewStylePlain];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.tableFooterView = [UIView new];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.mainGrid registerNib:[UINib nibWithNibName:@"SellReturnListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.mainGrid];
    __weak typeof(self) weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.lastDateTime = 1;
        [weakSelf loadData];
    }];
    
    [self.mainGrid ls_addFooterWithCallback:^{
        [weakSelf loadData];
    }];
    
    self.filterView = [[TDFComplexConditionFilter alloc] initFilter:@"筛选条件" image:@"ico_filter_normal" highlightImage:@"ico_filter_highlighted"];
    self.filterView.delegate = self;
    self.filterModels = [LSWeChatFilterModelFactory wechatSellReturnListViewFilterModels];
    [self.filterView addToView:self.view withDatas:self.filterModels];
}

// INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
   if (event == DIRECT_LEFT) {
      [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
      [self.navigationController popViewControllerAnimated:YES];
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


- (void)tdf_filterCompleted {
    
    TDFTwiceCellModel *dateModel = self.filterModels.lastObject;
    self.returnTime = [dateModel.currentName isEqualToString:dateModel.restName] ? @"" : dateModel.currentName;
    self.keywords = @"";
    self.mobile = @"";
    self.searchView.txtKeyWord.text = @"";
    [self.mainGrid headerBeginRefreshing];
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
}

- (void)loadData {
    if([self.searchType isEqualToString:@"手机号"]) {
        NSString *keyWord = self.searchView.txtKeyWord.text?:@"";
        if([NSString isNotBlank:keyWord] && ![NSString validateMobile:keyWord]) {
            [LSAlertHelper showAlert:@"请输入11位手机号码！"];
            [self.mainGrid headerEndRefreshing];
            [self.mainGrid footerEndRefreshing];
            return;
        }
    }
   NSUInteger billStatus = [[(TDFRegularCellModel *)self.filterModels.firstObject currentValue] unsignedIntegerValue];
   [self.sellReturnService sellReturnList:_keywords mobile:_mobile status:billStatus
                               returnTime:_returnTime lastDateTime:self.lastDateTime completionHandler:^(id json) {
      
                                   [self.mainGrid headerEndRefreshing];
                                   [self.mainGrid footerEndRefreshing];
                                   
                                   if (!_sellReturnList) {
                                       _sellReturnList = [NSMutableArray array];
                                   }
                                   
                                   if (self.lastDateTime == 1) {
                                      [self.sellReturnList removeAllObjects];
                                   }
                                   
                                   if ([ObjectUtil isNotNull:json[@"lastDateTime"]]) {
                                       self.lastDateTime = [json[@"lastDateTime"] longLongValue];
                                   }
                                   
                                   if([ObjectUtil isNotNull:json[@"sellReturnList"]]){
                                      for (NSDictionary *obj in json[@"sellReturnList"]) {
                                         RetailSellReturnVo *returnVo = [RetailSellReturnVo converToVo:obj[@"sellReturn"]];
                                         [self.sellReturnList addObject:returnVo];
                                      }
                                   }
                                   
                                   [self.mainGrid reloadData];
                                   
                                } errorHandler:^(id json) {
                                   [self.mainGrid headerEndRefreshing];
                                   [self.mainGrid footerEndRefreshing];
                                   [LSAlertHelper showAlert:json];
                                }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.sellReturnList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   SellReturnListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   [cell initWithData:self.sellReturnList[indexPath.row]];
   return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
   return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    RetailSellReturnVo *returnVo = [self.sellReturnList objectAtIndex:indexPath.row];
    SellReturnDetailView *vc = [[SellReturnDetailView alloc] initWithNibName:
                                [SystemUtil getXibName:@"SellReturnDetailView"] bundle:nil];
    [self.navigationController pushViewController:vc animated:NO];
//    vc.shopId = returnVo.shopId;
//    vc.code = returnVo.code;
//    vc.titleVal = returnVo.customerName;
//    vc.shopSellReturnId = returnVo.organizationShopSellReturnId;
    vc.sellReturn = returnVo;
    [vc loadSellReturnDetail:0 withIsPush:YES callBack:^(id<ITreeItem> companion) {
       [self.mainGrid headerBeginRefreshing];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
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
   
   CGRect rect = CGRectMake(47, self.searchView.frame.origin.y, 80, 32);
   [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
}

- (void)pushMenuItem:(id)sender {
   KxMenuItem* item = (KxMenuItem*)sender;
   [self.searchView changeLimitCondition:item.title];
   self.searchType = item.title;
   
   if ([self.searchType isEqualToString:@"单号"]) {
      [self.searchView changePlaceholder:@"请输入退货单号"];
   } else {
      [self.searchView changePlaceholder:@"请输入会员手机号"];
   }
}


#pragma mark - 条形码扫描
// 开始扫描
- (void)scanStart {
   ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
   [self.navigationController pushViewController:vc animated:NO];
   [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.keywords = scanString;
    self.searchView.txtKeyWord.text = scanString;
    self.searchType = @"单号";
    [self.searchView initDeleagte:self withName:@"单号" placeholder:@"请输入退货单号"];
    [self imputFinish:scanString];
    [self.mainGrid headerBeginRefreshing];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [LSAlertHelper showAlert:message];
}


// 输入完成
- (void)imputFinish:(NSString *)keyWord {

   self.lastDateTime = 1;
   if([self.searchType isEqualToString:@"单号"]){
      self.keywords = keyWord;
      self.mobile = @"";
      [self.mainGrid headerBeginRefreshing];
   } else {
      self.mobile = keyWord;
      self.keywords = @"";
      if([NSString validateMobile:keyWord] && [self.searchType isEqualToString:@"手机号"]) {
         [self.mainGrid headerBeginRefreshing];
      } else if ([NSString isNotBlank:keyWord]){
         [LSAlertHelper showAlert:@"请输入11位手机号码！"];
      }
   }
}

@end
