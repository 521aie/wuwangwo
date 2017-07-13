//
//  WeChatBatchReturnMoney.m
//  retailapp
//
//  Created by diwangxie on 16/4/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WeChatBatchReturnMoney.h"
#import "XHAnimalUtil.h"
#import "SellReturnService.h"
#import "ServiceFactory.h"
#import "RetailSellReturnVo.h"
#import "LSAlertHelper.h"
#import "ReturnMoneyBatchCell.h"
#import "KxMenu.h"
#import "NameItemVO.h"
#import "DateUtils.h"
#import "MicroBasicSetVo.h"
#import "JsonHelper.h"
#import "WeChatReturnMoneyManager.h"
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "SearchBar4.h"
#import "DatePickerBox.h"
#import "TDFComplexConditionFilter.h"
#import "LSWeChatFilterModelFactory.h"
#import "LSFooterView.h"

@interface WeChatBatchReturnMoney ()<INavigateEvent,ISearchBarEvent, IEditItemListEvent, DatePickerClient,TDFConditionFilterDelegate, LSFooterViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SellReturnService *sellReturnService;
@property (nonatomic, strong) WechatService *wechatService;
@property (nonatomic, strong) NSMutableArray *sellReturnList;
@property (nonatomic, strong) NSMutableArray *sellReturnCheckList;
@property (nonatomic, strong) NSMutableArray *sellReturnVoList;
@property (nonatomic) long long lastDateTime;       //最后记录时间	 Long
@property (nonatomic) bool showFlg;
@property (nonatomic) bool isPush;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (strong, nonatomic) UITableView *mainGrid;
@property (strong, nonatomic) SearchBar4 *searchView;
@property (nonatomic, strong) TDFComplexConditionFilter *filterView;/**<筛选view>*/
@property (nonatomic, strong) NSArray *filterModels;/**<筛选页需要的models>*/
@property (strong, nonatomic) LSFooterView *footerView;
@end

@implementation WeChatBatchReturnMoney

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self configSubviews];
    [self loadData];
    [self configHelpButton:HELP_WECHAT_REFUND_MANAGEMENT];
}


- (void)configSubviews {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"选择退款订单" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
    self.searchView = [[SearchBar4 alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleBox.frame), SCREEN_W, 44)];
    [self.searchView awakeFromNib];
    [self.searchView initDeleagte:self withName:@"单号" placeholder:@"请输入退货单号"];
    [self.searchView showCondition:YES];
    [self.view addSubview:self.searchView];
    
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchView.ls_bottom, SCREEN_W, SCREEN_H-self.searchView.ls_bottom) style:UITableViewStylePlain];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
//    self.mainGrid.tableFooterView = [UIView new];
    self.mainGrid.rowHeight = 88.0;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
   
    __weak typeof(self) wself = self;
    [wself.mainGrid ls_addHeaderWithCallback:^{
        wself.lastDateTime = 1;
        [wself loadData];
    }];
    
    [self.mainGrid ls_addFooterWithCallback:^{
        [wself loadData];
    }];
    
    _footerView = [LSFooterView footerView];
    [_footerView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
    [self.view addSubview:_footerView];
    
    self.filterView = [[TDFComplexConditionFilter alloc] initFilter:@"筛选条件" image:@"ico_filter_normal" highlightImage:@"ico_filter_highlighted"];
    self.filterView.delegate = self;
    self.filterModels = [LSWeChatFilterModelFactory wechatReturnMoneyListViewFilterModels];
    [self.filterView addToView:self.view withDatas:self.filterModels];
}



#pragma mark - 初始化
- (void)initData {
    
    self.lastDateTime = 1;
    self.searchType =@"2";
    _showFlg = NO;
    _sellReturnList = [[NSMutableArray alloc] init];
    _sellReturnCheckList = [[NSMutableArray alloc] init];
    
    self.sellReturnService = [ServiceFactory shareInstance].sellReturnService;
    self.wechatService = [ServiceFactory shareInstance].wechatService;
}

#pragma mark - 相关代理方法 -
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        self.sellReturnMoneyDetailBlock(nil);
    } else {
        if (_showFlg) {
            __weak typeof(self) wself = self;
            [LSAlertHelper showSheet:nil cancle:@"取消" cancleBlock:nil selectItems:@[@"手动退款成功"] selectdblock:^(NSInteger index) {
                [wself returnMoneyManual];
            }];
        }
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

// LSFooterViewDelegate
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectAll]) {
        [self checkAllEvent];
    } else if ([footerType isEqualToString:kFootSelectNo]) {
        [self notCheckAllEvent];
    }
}


#pragma  mark 全选和全不选
- (void)checkAllEvent {
    
    [_sellReturnCheckList removeAllObjects];
    if (self.sellReturnList.count > 0) {
        for (RetailSellReturnVo *vo in self.sellReturnList) {
            vo.isCheck = @"1";
            [_sellReturnCheckList addObject:vo];
        }
    }
    if (self.sellReturnList.count == 0) {
        return;
    }
    [self.titleBox initWithName:@"手动退款管理" backImg:Head_ICON_CANCEL moreImg:Head_ICON_CONFIRM];
    self.titleBox.lblRight.text = @"操作";
    _showFlg=YES;
    
    [self.mainGrid reloadData];
}

- (void)notCheckAllEvent {
    [_sellReturnCheckList removeAllObjects];
    if (self.sellReturnList.count > 0) {
        for (RetailSellReturnVo *vo in self.sellReturnList) {
            vo.isCheck = @"0";
            [_sellReturnCheckList removeObject:vo];
        }
    }
    if (self.sellReturnList.count == 0 ) {
        return;
    }
    [self.titleBox initWithName:@"选择退款订单" backImg:Head_ICON_BACK moreImg:nil];
    _showFlg = NO;
    [self.mainGrid reloadData];
}

#pragma mark - 表格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sellReturnList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    ReturnMoneyBatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ReturnMoneyBatchCell" owner:nil options:nil].lastObject;
    }
    [cell initWithData:self.sellReturnList[indexPath.row]];
    if ([ObjectUtil isNotEmpty:self.sellReturnList]) {
        RetailSellReturnVo *item=self.sellReturnList[indexPath.row];
        if ([item.isCheck isEqualToString:@"0"] || item.isCheck==nil) {
            cell.imgUnCheck.hidden = NO;
            cell.imgCheck.hidden = YES;
        } else {
            cell.imgUnCheck.hidden = YES;
            cell.imgCheck.hidden = NO;
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RetailSellReturnVo *vo = [self.sellReturnList objectAtIndex:indexPath.row];
    if ([vo.isCheck isEqualToString:@"1"]) {
        vo.isCheck = @"0";
        [_sellReturnCheckList removeObject:vo];
    }else{
        vo.isCheck = @"1";
        [_sellReturnCheckList addObject:vo];
    }
    if (_sellReturnCheckList.count > 0) {
        [self.titleBox initWithName:@"选择退款订单" backImg:Head_ICON_CANCEL moreImg:Head_ICON_CONFIRM];
        self.titleBox.lblRight.text=@"操作";
        _showFlg=YES;
    } else {
        [self.titleBox initWithName:@"选择退款订单" backImg:Head_ICON_BACK moreImg:nil];
        _showFlg=NO;
    }
    [self.mainGrid reloadData];
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
    
    CGRect rect = CGRectMake(35, self.searchView.frame.origin.y, 80, 32);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
}

- (void)pushMenuItem:(id)sender {
    
    KxMenuItem* item = (KxMenuItem*)sender;
    [self.searchView changeLimitCondition:item.title];
    self.searchType = item.title;
    
    if ([self.searchType isEqualToString:@"单号"]) {
        [self.searchView changePlaceholder:@"请输入退货单号"];
        self.searchType=@"2";
    } else {
        [self.searchView changePlaceholder:@"请输入会员手机号"];
        self.searchType=@"1";
    }
}

- (void)imputFinish:(NSString *)keyWord {
    
    if([self.searchType isEqualToString:@"2"]){
        self.lastDateTime=1;
        self.serachCode = keyWord;
        [self loadData];
    } else {
        
        if([NSString validateMobile:keyWord]) {
            self.lastDateTime=1;
            self.serachCode=keyWord;
            [self loadData];
        } else if ([NSString isNotBlank:keyWord]) {
            [LSAlertHelper showAlert:@"请输入11位手机号码！"];
        }
    }
}

- (void)loadSellReturnMoney:(BOOL)isPush callBack:(SellReturnMoneyDetail)callBack {
    self.sellReturnMoneyDetailBlock=callBack;
    self.isPush = isPush;
}

#pragma mark - 网络请求 -
//  //手动退款
- (void)returnMoneyManual {
    
    _sellReturnVoList=[[NSMutableArray alloc] init];
    for (RetailSellReturnVo *vo in self.sellReturnCheckList) {
        [_sellReturnVoList addObject:[vo convertToDic]];
    }
    [_sellReturnService sellReturnMoneyBatchOpera:_sellReturnVoList
                                             flag:0
                                completionHandler:^(id json) {
                                    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        if ([obj isKindOfClass:[WeChatReturnMoneyManager class]]) {
                                            WeChatReturnMoneyManager *vc = (WeChatReturnMoneyManager *)obj;
                                            [vc.mainGrid headerBeginRefreshing];
                                        }
                                    }];
                                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                                    [self.navigationController popViewControllerAnimated:NO];
                                } errorHandler:^(id json) {
                                    [LSAlertHelper showAlert:json];
                                }];
}

// 获取列表数据
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
    
    // 退款单子状态
    TDFRegularCellModel *statusModel = self.filterModels.firstObject;
    NSInteger status = [statusModel.currentValue integerValue];
    
    // 查询时间
    TDFTwiceCellModel *dateModel = self.filterModels.lastObject;
    NSString *returnTime = @"";
    if ([ObjectUtil isNotNull:dateModel.currentValue]) {
        returnTime = dateModel.currentName;
    }
    
    [self.sellReturnService sellReturnMoneyList:self.searchType
                                     serachCode:self.serachCode
                                         status:status
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
                                      if (self.sellReturnList.count==0) {
                                          [_sellReturnCheckList removeAllObjects];
                                          [self.titleBox initWithName:@"选择退款订单" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
                                          self.titleBox.lblRight.text=@"筛选";
                                          _showFlg=NO;
                                      }
                                  }
                                  
                                  [self.mainGrid reloadData];
                                  [self.mainGrid headerEndRefreshing];
                                  [self.mainGrid footerEndRefreshing];
                              } errorHandler:^(id json) {
                                  [self.mainGrid headerEndRefreshing];
                                  [self.mainGrid footerEndRefreshing];
                                  [LSAlertHelper showAlert:json];
                              }];
}

@end
