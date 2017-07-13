//
//  LSMemberInfoSummaryViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberInfoSummaryViewController.h"
#import "LSMemberListViewController.h"
#import "NavigateTitle2.h"
#import "LSMemberDataPanel.h"
#import "LSSegmentedView.h"
#import "LSDateSelectItem.h"
#import "LSMemberInfoChartBox.h"
#import "DateMonthPickerBox.h"
#import "LSExpandItem.h"
#import "OptionPickerBox.h"
#import "LSMemberSummaryInfoVo.h"
#import "NameItemVO.h"
#import "DateUtils.h"
//#import "LSAlertHelper.h"

@interface LSMemberInfoSummaryViewController ()<INavigateEvent ,DateMonthPickerClient ,OptionPickerClient ,LSMemberInfoChartBoxDelegate>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) UIScrollView *scrollView;/*<>*/
@property (nonatomic ,strong) LSSegmentedView *segmentView;/*<按天，按月统计切换>*/
@property (nonatomic ,strong) LSMemberDataPanel *dayPanel;/*<日会员信息汇总>*/
@property (nonatomic ,strong) LSMemberDataPanel *monthPanel;/*<月会员信息汇总>*/
@property (nonatomic ,strong) UIView *wrapper1;/*<>*/
@property (nonatomic ,strong) LSDateSelectItem *dateSelect1;/*<年月 日期选择>*/
@property (nonatomic ,strong) LSMemberInfoChartBox *dayChartBox;/*<按天查看>*/
@property (nonatomic ,strong) LSExpandItem *expand;/*<展示当日新增会员页面>*/
@property (nonatomic ,strong) UIView *wrapper2;/*<>*/
@property (nonatomic ,strong) LSDateSelectItem *dateSelect2;/*<年 日期选择>*/
@property (nonatomic ,strong) LSMemberInfoChartBox *monthChartBox;/*<按天查看>*/
@property (nonatomic ,strong) NSArray *yearArray;/*<1990~当前年组成的数组>*/
@property (nonatomic ,strong) NSString *yesterdayTime;/*<昨天时间:yyyyMMdd>*/

@property (nonatomic ,strong) NSString *dayStartDate;/*<按天开始查询日期>*/
@property (nonatomic ,strong) NSString *dayEndDate;/*<按天结束查询日期>*/
@property (nonatomic ,strong) NSString *monthStartDate;/*<按月开始查询日期>*/
@property (nonatomic ,strong) NSString *monthEndDate;/*<按月结束查询日期>*/

@property (nonatomic ,strong) NSArray *byDayDataArray;/*<数据源>*/
@property (nonatomic ,strong) NSArray *byMonthArray;/*<数据源>*/
@end

@implementation LSMemberInfoSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    [self initDate];
    [self switchDate:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configSubviews {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"会员信息汇总" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_W, SCREEN_H-64.0)];
    [self.view addSubview:self.scrollView];
    
    __weak typeof(self) weakSelf = self;
    self.segmentView = [LSSegmentedView segmentedView:^(NSInteger index) {
        [weakSelf switchDate:index];
    }];
    [self.scrollView addSubview:self.segmentView];
    self.segmentView.ls_top = 5.0;
    
    
    // 按天汇总信息相关views
    {
        self.dayPanel = [LSMemberDataPanel memberDataPanel:DataPanelSummaryPage block:nil];
        self.dayPanel.ls_top = 0.0;
        
        self.dateSelect1 = [LSDateSelectItem dateSelectItem:self selecter:@selector(yearMonthSelect)];
        self.dateSelect1.ls_top = CGRectGetMaxY(self.dayPanel.frame) - 10.0;
        self.dateSelect1.label.text = [DateUtils currentDateWith:@"yyyy年MM月"];
        
        self.dayChartBox = [LSMemberInfoChartBox memberInfoChartBox:self];
        self.dayChartBox.ls_top = CGRectGetMaxY(self.dateSelect1.frame);
        
        self.expand = [LSExpandItem expandItem:self selector:@selector(showTodayNewIncreaseMembers)];
        self.expand.ls_top = CGRectGetMaxY(self.dayChartBox.frame);
        
        self.wrapper1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.expand.frame))];
        [self.scrollView addSubview:self.wrapper1];
        [self.wrapper1 addSubview:self.dayPanel];
        [self.wrapper1 addSubview:self.dateSelect1];
        [self.wrapper1 addSubview:self.dayChartBox];
        [self.wrapper1 addSubview:self.expand];
        
        CGFloat conentHeight = fmax(CGRectGetHeight(self.wrapper1.frame), SCREEN_H-64.0);
        self.scrollView.contentSize = CGSizeMake(SCREEN_W, conentHeight+40.0);
    }
    
    // 按月相关汇总信息相关views
    {
        self.monthPanel = [LSMemberDataPanel memberDataPanel:DataPanelSummaryPage block:nil];
        self.monthPanel.ls_top = 0.0;
        
        self.dateSelect2 = [LSDateSelectItem dateSelectItem:self selecter:@selector(yearSelect)];
        self.dateSelect2.ls_top = CGRectGetMaxY(self.dayPanel.frame) - 10.0;
        self.dateSelect2.label.text = [DateUtils currentDateWith:@"yyyy年"];
        
        self.monthChartBox = [LSMemberInfoChartBox memberInfoChartBox:self];
        self.monthChartBox.ls_top = CGRectGetMaxY(self.dateSelect2.frame);
        
        self.wrapper2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.monthChartBox.frame))];
        [self.scrollView addSubview:self.wrapper2];
        [self.wrapper2 addSubview:self.monthPanel];
        [self.wrapper2 addSubview:self.dateSelect2];
        [self.wrapper2 addSubview:self.monthChartBox];
        
        self.wrapper2.hidden = YES;
    }
}

// 数据展示
- (void)fillData:(LSMemberSummaryInfoVo *)vo {
    
    if (!self.wrapper1.hidden) {
        NSArray *panelData = @[vo.customerNum?:@(0),vo.cardNum?:@(0),vo.cardBalance?:@(0.00),vo.customerNumDay?:@(0),vo.freshCardNum?:@(0),vo.rechargeMoneyDay?:@(0.00)];
        [self.dayPanel fillData:panelData time:nil];
        self.dayPanel.time.text = [DateUtils getDateString:[DateUtils getDate:vo.date format:@"yyyyMMdd"] format:@"yyyy年MM月dd日"];
        if ([vo.date isEqualToString:self.yesterdayTime]) {
            [self.segmentView setLeftButtonTitle:@"昨日" rightButtonTitle:nil];
        }
        else {
            [self.segmentView setLeftButtonTitle:[self.dayPanel.time.text substringFromIndex:5] rightButtonTitle:nil];
        }
    }
    else {
        NSArray *panelData = @[vo.customerNum?:@(0),vo.cardNum?:@(0),vo.cardBalance?:@(0.00),vo.customerNumMonth?:@(0),vo.freshCardNum?:@(0),vo.rechargeMoneyMonth?:@(0.00)];
        [self.monthPanel fillData:panelData time:nil];
        self.monthPanel.time.text = [DateUtils getDateString:[DateUtils getDate:vo.month format:@"yyyyMM"] format:@"yyyy年MM月"];
        if ([vo.month isEqualToString:[self.yesterdayTime substringToIndex:6]]) {
            [self.segmentView setLeftButtonTitle:nil rightButtonTitle:@"本月"];
        }
        else {
            [self.segmentView setLeftButtonTitle:nil rightButtonTitle:[self.monthPanel.time.text substringFromIndex:5]];
        }
    }
}

- (NSArray *)yearArray {
    
    if (!_yearArray) {
        
        NSMutableArray *vos = [NSMutableArray array];
        NSInteger maxYear = [[DateUtils getCurrentDate] substringWithRange:NSMakeRange(0, 4)].integerValue;
        for (int i = 1990; i <= maxYear; i++) {
            NameItemVO *item=[[NameItemVO alloc] initWithVal:[NSString stringWithFormat:@"%d年",i] andId:@(i).stringValue];
            [vos addObject:item];
        }
        _yearArray = [vos copy];

    }
    return _yearArray;
}

// 切换 按天查询/按月查询
- (void)switchDate:(NSInteger)index {
    
    UIView *view = nil;
    if (index == 1) {
        self.wrapper1.hidden = NO;
        self.wrapper2.hidden = YES;
        view = self.wrapper1;
    }
    else if (index == 2) {
        self.wrapper1.hidden = YES;
        self.wrapper2.hidden = NO;
        view = self.wrapper2;
    }
    CGFloat conentHeight = fmax(CGRectGetHeight(view.frame), SCREEN_H-64.0);
    self.scrollView.contentSize = CGSizeMake(SCREEN_W, conentHeight+40.0);
   
    if (index == 1) {
        
        if ([ObjectUtil isEmpty:self.byDayDataArray]) {
            [self getMemberSummaryInfoByDay];
        }
    }
    else if (index == 2) {
        if ([ObjectUtil isEmpty:self.byMonthArray]) {
            [self getMemberSummaryInfoByMonth];
        }
    }
}


// 点击，查看选择具体某天的新增会员
- (void)showTodayNewIncreaseMembers {
    
    if ([self.dayChartBox.currentData isKindOfClass:[LSMemberSummaryInfoVo class]]) {
        LSMemberSummaryInfoVo *infoVo = (LSMemberSummaryInfoVo *)self.dayChartBox.currentData;
        if ([ObjectUtil isNotNull:infoVo.customerNumDay]) {
            LSMemberListViewController *listVc = [[LSMemberListViewController alloc] initWithCheckDate:infoVo.date];
            [self pushController:listVc from:kCATransitionFromTop];
        }
    }
}

#pragma mark - 日期处理 -
- (void)initDate {
    self.yesterdayTime = [DateUtils getDateString:[NSDate dateWithTimeIntervalSinceNow:(-24*60*60)] format:@"yyyyMMdd"];
    [self adjustByDayCheckDates:nil];
    [self adjustByMonthCheckDates:nil];
}

// 选则按天查询-> 选择年月
- (void)yearMonthSelect {
    NSDate *date = [DateUtils getDate:self.dayEndDate format:@"yyyyMMdd"];
    [DateMonthPickerBox setMinYear:nil maxYear:[DateUtils getDateString:[NSDate date] format:@"yyyy"]];
    [DateMonthPickerBox show:@"月份" date:date client:self event:0];
}

// 选择按月查询-> 选择年
- (void)yearSelect {
    
    [OptionPickerBox initData:self.yearArray itemId:[self.monthEndDate substringWithRange:NSMakeRange(0, 4)]];
    [OptionPickerBox show:@"年份" client:self event:0];
}

// 生成按天查询日期
- (void)adjustByDayCheckDates:(NSString *)selectDate {
    
    if ([NSString isBlank:self.dayEndDate] || [selectDate isEqualToString:[self.yesterdayTime substringToIndex:6]]) {
        // 昨天日期
        self.dayEndDate = [DateUtils getDateString:[NSDate dateWithTimeIntervalSinceNow:(-24*60*60)] format:@"yyyyMMdd"];
        self.dayStartDate = [NSString stringWithFormat:@"%@%@" ,[self.dayEndDate substringToIndex:6] ,@"01"];
    }
    else if ([NSString isNotBlank:selectDate]) {
    
        NSUInteger dayNumbersOfMonth = [DateUtils getNumberOfDaysInMonth:[DateUtils getDate:selectDate format:@"yyyyMM"]];
        self.dayEndDate = [NSString stringWithFormat:@"%@%lu" ,selectDate ,(NSUInteger)dayNumbersOfMonth];
        self.dayStartDate = [NSString stringWithFormat:@"%@%@" ,selectDate ,@"01"];
    }
}

// 生成按月查询日期
- (void)adjustByMonthCheckDates:(NSString *)selectDate {
   
    if ([NSString isBlank:self.monthEndDate] || [selectDate isEqualToString:[self.yesterdayTime substringToIndex:4]]) {
        // 当前月
        self.monthEndDate = [self.yesterdayTime substringToIndex:6];
        self.monthStartDate = [NSString stringWithFormat:@"%@%@" ,[self.monthEndDate substringToIndex:4] ,@"01"];
    }
    else if ([NSString isNotBlank:selectDate]) {
        
        self.monthEndDate = [NSString stringWithFormat:@"%@%@" ,selectDate , @"12"];
        self.monthStartDate = [NSString stringWithFormat:@"%@%@" ,selectDate ,@"01"];
    }
}

#pragma mark - delegate

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
    else if (event == DIRECT_RIGHT) {}
}

//DateMonthPickerClient ， 选择年月
- (BOOL)pickMonthDate:(NSDate *)date event:(NSInteger)event {
    
    self.dateSelect1.label.text = [DateUtils getDateString:date format:@"yyyy年MM月"];
    NSString *yearMonth = [[DateUtils getDateString:date format:@"yyyyMMdd"] substringToIndex:6];
    [self adjustByDayCheckDates:yearMonth];
    [self getMemberSummaryInfoByDay];
    return YES;
}

// OptionPickerClient , 选择年
- (BOOL)pickOption:(NameItemVO *)selectObj event:(NSInteger)eventType {
    
    NSString *year = [[selectObj itemName] substringToIndex:4];
    self.dateSelect2.label.text = [selectObj itemName];
    [self adjustByMonthCheckDates:year];
    [self getMemberSummaryInfoByMonth];
    return YES;
}


//LSMemberInfoChartBoxDelegate
- (void)memberInfoChartBox:(LSMemberInfoChartBox *)box select:(id)obj {
    [self fillData:obj];
}

- (NSString *)memberInfoChartBox:(LSMemberInfoChartBox *)box page:(NSInteger)index {
   
    if ([box isEqual:self.dayChartBox]) {
        LSMemberSummaryInfoVo *vo = [self.byDayDataArray objectAtIndex:index];
        NSString *dateString = [DateUtils getDateString:[DateUtils getDate:vo.date format:@"yyyyMMdd"] format:@"yyyy年MM月dd日"];
        NSString *week = [DateUtils getWeeKName:[self convertWeek:[DateUtils getDate:vo.date format:@"yyyyMMdd"]]];
        return [NSString stringWithFormat:@"%@ %@" ,dateString ,week];
    }
    else {
        LSMemberSummaryInfoVo *vo = [self.byMonthArray objectAtIndex:index];
        NSString *dateString = [DateUtils getDateString:[DateUtils getDate:vo.month format:@"yyyyMM"] format:@"yyyy年MM月"];
        return dateString;
    }
}

- (NSInteger)convertWeek:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:date];
    return [comps weekday];
}

#pragma mark - network

// 按天获取会员汇总信息
- (void)getMemberSummaryInfoByDay {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:2];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:self.dayStartDate forKey:@"startDate"];
    [param setValue:self.dayEndDate forKey:@"endDate"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"memberstat/getMemberStatisticsByDate" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotEmpty:json[@"data"]]) {
            self.byDayDataArray = [LSMemberSummaryInfoVo getMemberSummaryInfoVoList:json[@"data"]];
            LSMemberSummaryInfoVo *vo = [self.byDayDataArray lastObject];
            NSInteger page = 0;
            if (vo.date && [vo.date isEqualToString:self.yesterdayTime]) {
                page = [self.byDayDataArray indexOfObject:vo];
            }
            
            // 查找日最大老会员数和新会员数进行比较，大的那个作为最大日会员数
            NSNumber *newMaxNum = [self.byDayDataArray valueForKeyPath:@"@max.customerNumDay"];
            NSNumber *oldMaxNum = [self.byDayDataArray valueForKeyPath:@"@max.custormerOldNumDay"];
            if ([newMaxNum compare:oldMaxNum] == NSOrderedAscending) {
                [self.dayChartBox setData:self.byDayDataArray memberNum:oldMaxNum startPage:page];
            }
            else {
                [self.dayChartBox setData:self.byDayDataArray memberNum:newMaxNum startPage:page];
            }
            [self fillData:self.byDayDataArray.lastObject];
        }
    } errorHandler:^(id json) {
         [LSAlertHelper showAlert:json block:nil];
    }];
}

// 按月获取会员汇总信息
- (void)getMemberSummaryInfoByMonth {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:2];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:self.monthStartDate forKey:@"startMonth"];
    [param setValue:self.monthEndDate forKey:@"endMonth"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"memberstat/getMemberStatisticsMonth" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotEmpty:json[@"data"]]) {
            
            self.byMonthArray = [LSMemberSummaryInfoVo getMemberSummaryInfoVoList:json[@"data"]];
            LSMemberSummaryInfoVo *vo = [self.byMonthArray lastObject];
            NSInteger page = 0;
            if (vo.month && [self.yesterdayTime containsString:vo.month]) {
                page = [self.byMonthArray indexOfObject:vo];
            }
            
            // 查找月最大老会员数和新会员数进行比较，大的那个作为最大月会员数
            NSNumber *newMaxNum = [self.byMonthArray valueForKeyPath:@"@max.customerNumMonth"];
            NSNumber *oldMaxNum = [self.byMonthArray valueForKeyPath:@"@max.customerOldNumMonth"];
                        
            if ([newMaxNum compare:oldMaxNum] == NSOrderedAscending) {
                [self.monthChartBox setData:self.byMonthArray memberNum:oldMaxNum startPage:page];
            }
            else {
                [self.monthChartBox setData:self.byMonthArray memberNum:newMaxNum startPage:page];
            }
            
            [self fillData:self.byMonthArray.lastObject];
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

@end
