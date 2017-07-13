//
//  WeChatReturnMoneyManager.m
//  retailapp
//
//  Created by diwangxie on 16/4/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WeChatReturnMoneyManager.h"
#import "ReturnMoneyCell.h"
#import "SellReturnService.h"
#import "ServiceFactory.h"
#import "LSAlertHelper.h"
#import "KxMenu.h"
#import "FooterListView7.h"
#import "DatePickerBox.h"
#import "DateUtils.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "MicroBasicSetVo.h"
#import "WeChatReturnMoneyDetail.h"
#import "WeChatBatchReturnMoney.h"
#import "ExportView.h"
#import "NavigateTitle2.h"
#import "SearchBar4.h"
#import "FooterListView7.h"
#import "DatePickerBox.h"
#import "OptionPickerBox.h"
#import "TDFComplexConditionFilter.h"
#import "LSWeChatFilterModelFactory.h"

@interface WeChatReturnMoneyManager ()<INavigateEvent,ISearchBarEvent,FooterListEvent, DatePickerClient, TDFConditionFilterDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (strong, nonatomic) SearchBar4 *searchView;
@property (strong, nonatomic) FooterListView7 *footView;
@property (nonatomic, strong) TDFComplexConditionFilter *filterView;/**<筛选页面>*/
@property (nonatomic, strong) NSArray *filterModels;/**<筛选页面需要数据>*/
@property (nonatomic, strong) SellReturnService *sellReturnService;
@property (nonatomic, strong) NSMutableArray *sellReturnList;
@property (nonatomic, strong) WechatService *wechatService;
@property (nonatomic, strong) NSString *serachCode;//code
//@property (nonatomic, strong) NSString *returnTime; //退货时间 String
@property (nonatomic) long long lastDateTime;       //最后记录时间	 Long
@property (nonatomic, strong) NSString *searchType;
@end

@implementation WeChatReturnMoneyManager

- (void)viewDidLoad {
    [super viewDidLoad];
    //总部用户
    [self initData];
    [self configSubviews];
    [self loadData];
    [self configHelpButton:HELP_WECHAT_REFUND_MANAGEMENT];
}

- (void)configSubviews {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"手动退款管理" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
    self.searchView = [[SearchBar4 alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleBox.frame), SCREEN_W, 44)];
    [self.searchView awakeFromNib];
    [self.searchView initDeleagte:self withName:@"单号" placeholder:@"请输入退货单号"];
    [self.searchView showCondition:YES];
    [self.view addSubview:self.searchView];
    
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchView.ls_bottom, SCREEN_W, SCREEN_H-self.searchView.ls_bottom) style:UITableViewStylePlain];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.tableFooterView = [UIView new];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
    __weak typeof(self) weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.lastDateTime = 1;
        [weakSelf loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        [weakSelf loadData];
    }];
    
    self.footView = [[FooterListView7 alloc] initWithFrame:CGRectMake(0, SCREEN_H-64.0, SCREEN_W, 64.0)];
    [self.footView awakeFromNib];
    [self.footView initDelegate:self btnArrs:@[@"BATCH",@"EXPORT"]];
    [self.view addSubview:self.footView];
    
    self.filterView = [[TDFComplexConditionFilter alloc] initFilter:@"筛选条件" image:@"ico_filter_normal" highlightImage:@"ico_filter_highlighted"];
    self.filterView.delegate = self;
    self.filterModels = [LSWeChatFilterModelFactory wechatReturnMoneyListViewFilterModels];
    [self.filterView addToView:self.view withDatas:self.filterModels];
}

#pragma mark - 初始化
- (void)initData {
    
    self.lastDateTime = 1;
    self.searchType = @"2";
    _sellReturnList = [[NSMutableArray alloc] init];
    _param = [[NSMutableDictionary alloc]init];
    
    self.sellReturnService = [ServiceFactory shareInstance].sellReturnService;
    self.wechatService = [ServiceFactory shareInstance].wechatService;
}

#pragma mark - 代理方法
// INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}


// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord {
    
    if([self.searchType isEqualToString:@"2"]) {
        self.lastDateTime=1;
        self.serachCode=keyWord;
        [self loadData];
    } else{
        if([NSString validateMobile:keyWord] || [NSString isBlank:keyWord]) {
            self.lastDateTime=1;
            self.serachCode=keyWord;
            [self loadData];
        }else{
            [LSAlertHelper showAlert:@"请输入11位手机号码！"];
        }
    }
//<<<<<<< HEAD
//=======
//    [cell initWithData:self.sellReturnList[indexPath.row]];
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
//    return 88;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    WeChatReturnMoneyDetail *vc = [[WeChatReturnMoneyDetail alloc] init];
//    vc.sellReturnVo = self.sellReturnList[indexPath.row];
//    [vc loadSellReturnMoney:YES callBack:^{
//        [self.mainGrid headerBeginRefreshing];
//    }];
//    [self pushController:vc from:kCATransitionFromRight];
//}
//
//#pragma mark - 选择检索条件
//- (IBAction)typeNoOrMobileClick:(UIButton *)sender {
//    NSArray *menuItems = @[
//                           [KxMenuItem menuItem:@"单号"
//                                          image:nil
//                                         target:self
//                                         action:@selector(pushMenuItem:)],
//                           
//                           [KxMenuItem menuItem:@"手机号"
//                                          image:nil
//                                         target:self
//                                         action:@selector(pushMenuItem:)]
//                           ];
//    
//    CGRect rect = CGRectMake(5, self.searchView.frame.origin.y, 80, 32);
//    [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
//>>>>>>> dev
}

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
    
    CGRect rect = CGRectMake(35, self.searchView.frame.origin.y, 80, 32);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
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
    self.lastDateTime = 1;
    self.searchView.txtKeyWord.text = @"";
    self.serachCode = @"";
    [self loadData];
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


// FooterListEvent
- (void)showBatchEvent {
    WeChatBatchReturnMoney *vc = [[WeChatBatchReturnMoney alloc] init];
    [vc loadSellReturnMoney:YES callBack:^{
        [self.mainGrid headerBeginRefreshing];
    }];
    [self pushController:vc from:kCATransitionFromTop];
}


/*
 
 if ([NSString isNotBlank:self.searchType]) {
 [self.param setValue:self.searchType forKey:@"searchType"];
 }
 if ([NSString isNotBlank:self.serachCode]) {
 [self.param setValue:self.serachCode forKey:@"keywords"];
 }
 [self.param setValue:[NSNumber numberWithShort:[self.lstStatus getStrVal].intValue] forKey:@"status"];
 
 if ([NSString isNotBlank:self.returnTime]) {
 [self.param setValue:self.returnTime forKey:@"returnTime"];
 }
 
 ExportView *vc = [[ExportView alloc] initWithNibName:[SystemUtil getXibName:@"ExportView"] bundle:nil];
 [self.navigationController pushViewController:vc animated:NO];
 [vc loadData:_param withPath:@"refundManagement/exportToExcel" withIsPush:YES callBack:^{
 [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
 [self.navigationController popViewControllerAnimated:NO];
 }];
 [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
 }

 
 */

- (void)showExportEvent {
    
    if ([NSString isNotBlank:self.searchType]) {
        [self.param setValue:self.searchType forKey:@"searchType"];
    }
   
    if ([NSString isNotBlank:self.serachCode]) {
        [self.param setValue:self.serachCode forKey:@"keywords"];
    } else {
        [self.param setValue:@"" forKey:@"keywords"];
    }
    
    TDFRegularCellModel *statusModel = self.filterModels.firstObject;
    [self.param setValue:statusModel.currentValue forKey:@"status"];
    
    TDFTwiceCellModel *dateModel = self.filterModels.lastObject;
    if (![dateModel.currentName isEqualToString:dateModel.restName]) {
        [self.param setValue:dateModel.currentName forKey:@"returnTime"];
    } else {
        [self.param setValue:@"" forKey:@"returnTime"];
    }
    
    ExportView *vc = [[ExportView alloc] init];
    [vc loadData:_param withPath:@"refundManagement/exportToExcel" withIsPush:YES callBack:^{
        [self popToLatestViewController:kCATransitionFromLeft];
    }];
    [self pushController:vc from:kCATransitionFromTop];
}



// UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sellReturnList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReturnMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ReturnMoneyCell" owner:nil options:nil].lastObject;
    }
    [cell initWithData:self.sellReturnList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WeChatReturnMoneyDetail *vc = [[WeChatReturnMoneyDetail alloc] init];
    vc.sellReturnVo = self.sellReturnList[indexPath.row];
    __weak  typeof(self) wself = self;
    [vc loadSellReturnMoney:YES callBack:^{
        [wself.mainGrid headerBeginRefreshing];
    }];
    [self pushController:vc from:kCATransitionFromRight];
}

- (void)pushMenuItem:(id)sender {
    KxMenuItem* item = (KxMenuItem*)sender;
    [self.searchView changeLimitCondition:item.title];
    self.searchType = item.title;
    
    if ([self.searchType isEqualToString:@"单号"]) {
        [self.searchView changePlaceholder:@"请输入退货单号"];
        self.searchType=@"2";
    } else {
        [self.searchView changePlaceholder:@"请输入会员手机号"];\
        self.searchType=@"1";
    }
}

- (void)loadData {
    if([self.searchView.lblName.text isEqualToString:@"手机号"]){
        NSString *keyWord = self.searchView.txtKeyWord.text;
        if([NSString isNotBlank:keyWord] && ![NSString validateMobile:keyWord]) {
            [LSAlertHelper showAlert:@"请输入11位手机号码！"];
            [self.mainGrid headerEndRefreshing];
            [self.mainGrid footerEndRefreshing];
            return;
        }
    }
    
    TDFTwiceCellModel *dateModel = self.filterModels.lastObject;
    NSString *returnTime = @"";
    if ([ObjectUtil isNotNull:dateModel.currentValue]) {
        returnTime = dateModel.currentName;
    }
    NSUInteger billStatus = [[self.filterModels.firstObject currentValue] unsignedIntegerValue];
    [self.sellReturnService sellReturnMoneyList:self.searchType
                                     serachCode:self.serachCode
                                         status:billStatus
                                     returnTime:returnTime
                                   lastDateTime:self.lastDateTime
                              completionHandler:^(id json) {
        if (self.lastDateTime == 1) {
            [self.sellReturnList removeAllObjects];
        }
                                  
        if(json[@"lastDateTime"] == nil || [json[@"lastDateTime"] isEqual:[NSNull null]]) {
            
        } else {
            self.lastDateTime = [json[@"lastDateTime"] longLongValue];
        }
        if([ObjectUtil isNotNull:json[@"sellReturnList"]]){
            for (NSDictionary *obj in json[@"sellReturnList"]) {
                RetailSellReturnVo *returnVo = [RetailSellReturnVo converToVo:obj];
                [self.sellReturnList addObject:returnVo];
            }
        }
        [self.mainGrid reloadData];
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
        self.mainGrid.ls_show = YES;
    } errorHandler:^(id json) {
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
