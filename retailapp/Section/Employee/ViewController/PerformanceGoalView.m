//
//  PerformanceGoalView.m
//  retailapp
//
//  Created by qingmei on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PerformanceGoalView.h"
#import "NSDate+CalendarView.h"
#import "SelectShopListView.h"
#import "LSFooterView.h"
#import "EmployeeService.h"
#import "ISearchBarEvent.h"
#import "SearchBar2.h"
#import "ServiceFactory.h"
#import "DateUtils.h"
#import "UserPerformanceTargetVo.h"
#import "PerformanceGoalDetailView.h"
#import "DateMonthPickerBox.h"
#import "ExportView.h"
#import "EmployeeCell.h"
#import "HeaderItem.h"
#import "TDFComplexConditionFilter.h"
#import "LSFooterView.h"

@interface PerformanceGoalView ()<ISearchBarEvent,LSFooterViewDelegate,UITableViewDataSource,UITableViewDelegate,TDFConditionFilterDelegate,DateMonthPickerClient>

@property (nonatomic, strong) EmployeeService *service; //网络服务
@property (nonatomic, assign) NSInteger shopMode; //1 单店 2连锁门店 3连锁组织机构
@property (nonatomic, strong) NSString *shopId;  //保存筛选选中的shopId
@property (nonatomic, strong) NSNumber *lastDateTime; //最后更新事件
@property (nonatomic, strong) NSMutableDictionary *exportParam;   //导出参数
@property (nonatomic, strong) UITableView *mainGrid; //tableview
@property (nonatomic, strong) SearchBar2 *searchBar; //搜索栏
@property (nonatomic, strong) LSFooterView *footView; //页脚button
@property (nonatomic ,strong) TDFComplexConditionFilter *filterView;/**<右侧筛选页>*/
@property (nonatomic ,strong) NSArray *filterModels;/**<筛选需要的数据>*/

/**业绩目标员工列表*/
@property (nonatomic, strong) NSMutableArray *userPerformanceTargetVoList;
/**总业绩目标*/
@property (nonatomic, strong) NSString *totalSaleTarget;
@end

@implementation PerformanceGoalView

- (void)viewDidLoad {
    [super viewDidLoad];
    _service = [ServiceFactory shareInstance].employeeService;
    [self initMainView];
    [self configHelpButton:HELP_EMPLOYE_SHOPPING_GUIDE];
}

- (void)initMainView {

    //获得店铺类型
    self.shopMode = [[Platform Instance] getShopMode];
    if (self.shopMode != 3) {
        //单店可以直接加载 连锁需要选择门店
        self.shopId = [[Platform Instance] getkey:SHOP_ID];
        [self loadData];
    }
    
    //设置导航栏
    [self configTitle:@"导购员业绩目标" leftPath:Head_ICON_BACK rightPath:nil];
   
    
    //设置searchbar
    self.searchBar = [SearchBar2 searchBar2];
    self.searchBar.ls_top = kNavH;
    [self.searchBar initDelagate:self placeholder:@"姓名/工号/手机号"];
    [self.view addSubview:self.searchBar];
    
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.ls_bottom, SCREEN_W, SCREEN_H-self.searchBar.ls_bottom) style:UITableViewStylePlain];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.showsVerticalScrollIndicator = NO;
    self.mainGrid.rowHeight = 88.0f;
    self.mainGrid.sectionHeaderHeight = 40.0f;
    self.mainGrid.sectionFooterHeight = 88.0f;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];

    //添加下拉加载
    __weak PerformanceGoalView* weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        [weakSelf loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        [weakSelf loadData];
    }];
    
    //设置footView
    self.footView = [LSFooterView footerView];
    if (self.shopMode == 3) {//连锁机构不用添加 12.05确认需求
        [self.footView initDelegate:self btnsArray:@[kFootExport]];
    } else {
        [self.footView initDelegate:self btnsArray:@[kFootExport,kFootAdd]];
    }
    [self.view addSubview:self.footView];
    
    
    // 筛选
    self.filterView = [[TDFComplexConditionFilter alloc] initFilter:@"筛选条件" image:@"ico_filter_normal" highlightImage:@"ico_filter_highlighted"];
    self.filterView.delegate = self;
    [self.filterView addToView:self.view withDatas:self.filterModels];
}

- (NSArray *)filterModels {
    
    if (!_filterModels) {
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
        if (self.shopMode == 3) {
            //连锁机构
            TDFTwiceCellModel *shopModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellTwoLine optionName:@"门店" hideStatus:NO];
            shopModel.arrowImageName = @"ico_next";
            shopModel.restName = @"请选择";
            [array addObject:shopModel];
        }
        
        TDFTwiceCellModel *date = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellOneLine optionName:@"时间" hideStatus:NO];
        date.arrowImageName = @"ico_next_down";
        date.restValue = [NSDate date];
        date.restName = [DateUtils formateDate5:date.restValue];
        [array addObject:date];

        _filterModels = [array copy];
    }
    return _filterModels;
}


- (void)responseSuccess:(id)json{
    
    _userPerformanceTargetVoList = nil;
    _userPerformanceTargetVoList = [[NSMutableArray alloc]init];
    NSArray *arr = [json objectForKey:@"userPerformanceTargetVoList"];
    _totalSaleTarget = [json objectForKey:@"totalSaleTarget"];
    _lastDateTime = [json objectForKey:@"lastDateTime"];
    
    if ([ObjectUtil isNotNull:arr]) {
        for (NSDictionary *dic in arr) {
            UserPerformanceTargetVo *tempvo = [UserPerformanceTargetVo convertToUser:dic];
            [_userPerformanceTargetVoList addObject:tempvo];
        }
    }
    [self.mainGrid reloadData];
    self.mainGrid.ls_show = YES;
}

// 获取导出数据
- (NSMutableDictionary *)exportParam {
    
    _exportParam = [NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:_shopId]) {
        [_exportParam setValue:_shopId forKey:@"shopId"];
    }
    NSString *keyWord = self.searchBar.keyWordTxt.text;
    NSDate *month = [[self.filterModels lastObject] currentValue];
    NSInteger beginTime = 0;
    NSInteger endTime = 0;
    if (month) {
        ////计算开始时间和结束时间
        NSDate *beginDate = nil;
        NSDate *endDate = nil;
        beginDate = [[month GetFirstDayInThisMonth] GetlocaleDate];
        endDate = [[month GetLastDayInThisMonth] GetlocaleDate];
        beginTime = [NSNumber numberWithLongLong:([DateUtils getStartTimeOfDate:beginDate]/1000)].integerValue;
        endTime = [NSNumber numberWithLongLong:([DateUtils getEndTimeOfDate:endDate]/1000)].integerValue;
    }
    [_exportParam setValue:[NSNumber numberWithInteger:beginTime] forKey:@"startDate"];
    [_exportParam setValue:[NSNumber numberWithInteger:endTime] forKey:@"endDate"];
    
    if ([ObjectUtil isNull:keyWord]) {
        [_exportParam setValue:@"" forKey:@"keyWord"];
    } else {
        [_exportParam setValue:keyWord forKey:@"keyWord"];
    }
    
    if ([ObjectUtil isNull:_lastDateTime]) {
        [_exportParam setValue:@"" forKey:@"lastDateTime"];
    } else {
        [_exportParam setValue:_lastDateTime forKey:@"lastDateTime"];
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:_userPerformanceTargetVoList.count];
    for (UserPerformanceTargetVo *tempVo in _userPerformanceTargetVoList) {
        [arr addObject:tempVo.userId];
    }
    [_exportParam setValue:arr forKey:@"userIdList"];

    return _exportParam;
}

// 进入门店选择页面
- (void)selectShop {
    __weak typeof(self) weakSelf = self;
    SelectShopListView *vc = [[SelectShopListView alloc] init];
    [vc loadShopList:_shopId withType:2 withViewType:NOT_CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
        if (shop) {
            weakSelf.shopId = [shop obtainItemId];
            TDFTwiceCellModel *model = weakSelf.filterModels.firstObject;
            model.currentName = [shop obtainItemName];
            model.currentValue = [shop obtainItemId];
        }
        [weakSelf popToLatestViewController:kCATransitionFromLeft];
    }];
    [self pushController:vc from:kCATransitionFromRight];
}

#pragma mark - 相关协议方法 -

// LSFooterViewDelegate
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    
    if ([footerType isEqualToString:kFootExport]) {
        // 导出
        if ([ObjectUtil isNull:_shopId]) {
            [LSAlertHelper showAlert:@"请先选择门店，再进行导出！"]; return;
        }
        __weak typeof(self) weakSelf = self;
        ExportView *vc = [[ExportView alloc]init];
        [self pushController:vc from:kCATransitionFromTop];
        [vc loadData:weakSelf.exportParam withPath:@"performanceTarget/export" withIsPush:YES callBack:^{
            [weakSelf popToLatestViewController:kCATransitionFromBottom];
        }];
    } else if ([footerType isEqualToString:kFootAdd]) {
        
        PerformanceGoalDetailView *vc = [[PerformanceGoalDetailView alloc]initWithParent:self];
        [vc initDataInAddType:_userPerformanceTargetVoList shopId:_shopId month:[NSDate date]];
        [self pushController:vc from:kCATransitionFromTop];
    }
}

// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord{
    [self loadData];
}

// TDFConditionFilterDelegate
- (BOOL)tdf_filterWillShow {
   return [self.searchBar endEditing:YES];
}

- (void)tdf_filter:(TDFComplexConditionFilter *)filter actionWithCellModel:(TDFFilterMoel *)model {
    if (model.type == TDF_TwiceFilterCellTwoLine) {
        [self selectShop];
    } else if (model.type == TDF_TwiceFilterCellOneLine) {
        TDFTwiceCellModel *dateModel = self.filterModels.lastObject;
        [DateMonthPickerBox show:@"时间" date:dateModel.currentValue client:self event:11];
    }
}

- (void)tdf_filterCompleted {
    [self loadData];
}

// DateMonthPickerClient
- (BOOL)pickMonthDate:(NSDate *)date event:(NSInteger)event {
    
    NSDate *newDate = [date dateByAddingTimeInterval:365*24*60*60];
    NSDate *todayDate = [NSDate date];
    if ([todayDate compare:newDate] == NSOrderedDescending) {
        [LSAlertHelper showAlert:@"查询日期不能超过一年!"]; return YES;
    }
    TDFTwiceCellModel *dateModel = self.filterModels.lastObject;
    dateModel.currentValue = date;
    dateModel.currentName = [DateUtils formateDate5:date];
    return YES;
}

- (void)clearDate:(NSInteger)eventType {
    TDFTwiceCellModel *dateModel = self.filterModels.lastObject;
    dateModel.currentValue = nil;
    dateModel.currentName = nil;
}

// UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _userPerformanceTargetVoList.count>0?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _userPerformanceTargetVoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"PerformanceGoalCell";
    EmployeeCell* cell = (EmployeeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [EmployeeCell getInstance];
    }
    UserPerformanceTargetVo *tempVo = [_userPerformanceTargetVoList objectAtIndex:indexPath.row];
    [cell loadCell:tempVo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_userPerformanceTargetVoList != nil && _userPerformanceTargetVoList.count > 0) {
        UserPerformanceTargetVo *tempVo = [_userPerformanceTargetVoList objectAtIndex:indexPath.row];
        PerformanceGoalDetailView *vc = [[PerformanceGoalDetailView alloc]initWithParent:self];
        [vc loadDataWithVo:tempVo shopId:self.shopId month:[self.filterModels.lastObject currentValue]];
        [self pushController:vc from:kCATransitionFromRight];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderItem *headItem = [[[NSBundle mainBundle]loadNibNamed:@"HeaderItem" owner:self options:nil]lastObject];
    headItem.lbtitle.textColor = [UIColor whiteColor];
    NSString *kindMember = [NSString stringWithFormat:@"目标合计%@元",_totalSaleTarget];
    [headItem initWithName:kindMember];
    return headItem;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,88);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

#pragma mark - 网络请求 -
- (void)loadData {
    
    if ([NSString isBlank:self.shopId]) {
        [LSAlertHelper showAlert:@"请先选择门店!"];
        return;
    }
    
    NSString *shopID = self.shopId;
    NSInteger beginTime = 0;
    NSInteger endTime = 0;
    NSDate *thismounth = [self.filterModels.lastObject currentValue];
    NSString *keyWord = self.searchBar.keyWordTxt.text;
    if (thismounth) {
        ////计算开始时间和结束时间
        NSDate *beginDate = nil;
        NSDate *endDate = nil;
        beginDate = [[thismounth GetFirstDayInThisMonth] GetlocaleDate];
        endDate = [[thismounth GetLastDayInThisMonth] GetlocaleDate];
        beginTime = [NSNumber numberWithLongLong:([DateUtils getStartTimeOfDate:beginDate]/1000)].integerValue;
        endTime = [NSNumber numberWithLongLong:([DateUtils getEndTimeOfDate:endDate]/1000)].integerValue;
    }
    
    __weak PerformanceGoalView* weakSelf = self;
    if ([ObjectUtil isNotNull:shopID]&& beginTime!=0 && endTime!=0) {
        [_service performanceTargetByShopId:shopID startDate:beginTime endDate:endTime keyword:keyWord lastDateTime:0 completionHandler:^(id json) {
            if (!weakSelf) return ;
            [self.mainGrid headerEndRefreshing];
            [self.mainGrid footerEndRefreshing];
            [weakSelf responseSuccess:json];
        } errorHandler:^(id json) {
            [self.mainGrid headerEndRefreshing];
            [self.mainGrid footerEndRefreshing];
            [LSAlertHelper showAlert:json];
        }];
    } else {
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
        [_userPerformanceTargetVoList removeAllObjects];
        [self.mainGrid reloadData];
    }
}

@end
