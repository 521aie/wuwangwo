//
//  BusinessDetailView.m
//  retailapp
//
//  Created by hm on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "BusinessDetailView.h"
//#import "MainModule.h"
#import "XHChartBox.h"
#import "BusinessSummaryBox.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "UIHelper.h"
#import "DateUtils.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "BusinessDayVO.h"


@interface BusinessDetailView ()<XHChartDelegate>

@property (nonatomic,strong) MainModule* mainModule;
@property (nonatomic, strong) NSArray* monthArr;

@property (nonatomic) NSInteger currYear;    //当前年.
@property (nonatomic) NSInteger currMonth;   //当年月份.
@property (nonatomic) NSInteger currDay;     //当前日期.
@property (nonatomic) NSInteger realYear;   //实际的年份.
@property (nonatomic) NSInteger realMonth;   //实际的月份.
@property (nonatomic) NSInteger realDay;     //实际的日期
@end

@implementation BusinessDetailView
@synthesize mainModule;

- (void)viewDidLoad {
    [super viewDidLoad];
     service = [ServiceFactory shareInstance].loginService;
    [self initMainView];
    [self initDayPanel];
    [self loadData];
}

- (void)loadData {
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    [self loadData:year month:month day:day shopFlag:self.shopFlag];
}


- (void)initMainView
{
    if (self.shopFlag == 1) {
         _lblTitle.text = @"门店营业汇总";
    } else if (self.shopFlag == 2) {
        _lblTitle.text = @"导购员个人营业汇总";
    }
   
    [_chartBox initDelegate:self];
    _monthArr=[[NSArray alloc] initWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",nil];
    
    _tabBox.layer.cornerRadius=5;
    _tabBox.layer.masksToBounds=YES;
    _tabBox.layer.borderWidth=1;
    _tabBox.layer.borderColor=[[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3] CGColor];

    _lblTabLeft.text=@"今天";
    _lblTabRight.text=@"本月";
    self.monthPanel.hidden = YES;
   
}

- (void)initDayPanel {
    [_monthPanel setHidden:YES];
    [UIHelper refreshUI:self.container scrollview:self.dayScroll];
}

- (void)loadData:(NSInteger)year month:(NSInteger)month day:(NSInteger)day shopFlag:(int)shopFlag
{// shopFlag 1：按门店，2：按个人
    self.currYear=year;
    self.currMonth=month;
    self.currDay=day;
    
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
    self.realYear=[comps year];
    self.realMonth=[comps month];
    self.realDay=[comps day];
    [self.imgNext setHidden:(self.currMonth==self.realMonth)];
    [self.btnNext setHidden:(self.currMonth==self.realMonth)];
    
    [self.imgNextPay setHidden:(self.currMonth==self.realMonth)];
    [self.btnNextPay setHidden:(self.currMonth==self.realMonth)];
    if (self.realMonth>2) {
        [self.imgPre setHidden:((self.currMonth+2)==self.realMonth)];
        [self.btnPre setHidden:((self.currMonth+2)==self.realMonth)];
        
        [self.imgPrePay setHidden:((self.currMonth+2)==self.realMonth)];
        [self.btnPrePay setHidden:((self.currMonth+2)==self.realMonth)];
    } else if (self.realMonth==1) {
        [self.imgPre setHidden:(self.currMonth==11)];
        [self.btnPre setHidden:(self.currMonth==11)];
        
        [self.imgPrePay setHidden:(self.currMonth==11)];
        [self.btnPrePay setHidden:(self.currMonth==11)];
    } else if (self.realMonth==2) {
        [self.imgPre setHidden:(self.currMonth==12)];
        [self.btnPre setHidden:(self.currMonth==12)];
        
        [self.imgPrePay setHidden:(self.currMonth==12)];
        [self.btnPrePay setHidden:(self.currMonth==12)];
    }
    self.lblTitleDay.text=[NSString stringWithFormat:@"%ld年%ld月", (long)year, (long)month];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue: [[Platform Instance] getkey:ROLE_ID] forKey:@"roleId"];
    [param setValue:[NSString stringWithFormat:@"%ld-%ld",self.currYear,self.currMonth] forKey:@"month"];
    [param setValue:[NSNumber numberWithInt:self.shopFlag] forKey:@"shopFlag"];
    if (self.dayDic == nil) {
        self.dayDic = [[NSMutableDictionary alloc] init];
    }
    [self.dayDic removeAllObjects];
    
    __weak BusinessDetailView *weakself = self;
    //按天查询
    [service businessSummaryWithParam:param completionBlock:^(id json) {
        BOOL isHasAction = shopFlag == 1 ? ![[Platform Instance] lockAct:ACTION_INCOME_SEARCH] : ![[Platform Instance] lockAct:ACTION_USER_INCOME_SEARCH];
        
        if (json[@"summerOfDateList"] != nil && json[@"summerOfDateList"]!=(id)[NSNull null]&& [json[@"summerOfDateList"] count] != 0) {
            self.dayList = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in json[@"summerOfDateList"]) {
                BusinessDayVO *businessDayVo = [[BusinessDayVO alloc] initWithDictionary:dict];
                if (self.shopFlag == 2) {//个人
                    if ([businessDayVo.showName isEqualToString:@"收益(元)"]||[businessDayVo.showName isEqualToString:@"坪效(元/m²)"]) {
                        continue;
                    }
                }
                
                [self.dayList addObject:businessDayVo];
            }
        }
        NSArray *dayList = json[@"summerOfMonthList"];
        if (!(dayList == nil || [dayList isEqual:[NSNull null]]|| dayList.count == 0)) {
            for (NSArray *obj in dayList) {
                NSString *date = nil  ;
                NSMutableArray *day = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in obj) {
                    BusinessDayVO *businessDayVo = [[BusinessDayVO alloc] initWithDictionary:dict];
                    if (self.shopFlag == 2) {//个人
                        if ([businessDayVo.showName isEqualToString:@"收益(元)"]||[businessDayVo.showName isEqualToString:@"坪效(元/m²)"]) {
                            continue;
                        }
                    }
                    date = businessDayVo.incomeDate;
                    [day addObject:businessDayVo];
                }
                if ([NSString isNotBlank:date]) {
                    [self.dayDic setValue:day forKey:date];
                }               
            }
        }
        if (isHasAction == 0) {
            self.dayDic = [[NSMutableDictionary alloc] init];
            [weakself.chartBox loadBusinessData:self.dayDic];
        } else {
             [weakself.chartBox loadBusinessData:self.dayDic];
        }
        
         [weakself.chartBox initChartView:weakself.currYear month:weakself.currMonth day:weakself.currDay];
        } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    //按月查询
    [service businessMonthWithParam:param completionBlock:^(id json) {
        NSString *title = [NSString stringWithFormat:@"%ld月", (long)self.currMonth];
        NSMutableArray *monthList = [[NSMutableArray alloc] init];
        if (!(json[@"summerInfoVoList"] == nil || [json[@"summerInfoVoList"] isEqual:[NSNull null]]|| [json[@"summerInfoVoList"] count] == 0)) {
            for (NSDictionary *dict in json[@"summerInfoVoList"]) {
                BusinessDayVO *businessDayVo = [[BusinessDayVO alloc] initWithDictionary:dict];
                if (self.shopFlag == 2) {//个人
                    if ([businessDayVo.showName isEqualToString:@"收益(元)"]||[businessDayVo.showName isEqualToString:@"坪效(元/m²)"]) {
                        continue;
                    }
                }
                [monthList addObject:businessDayVo];
            }
        }
        [weakself.monthDetailBox initDataWithList:monthList title:title shopFlag:self.shopFlag];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}





- (void)scrollviewDidChangeNumber
{
    NSInteger day=self.chartBox.currDay;
    self.currDay=day;
    
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
    self.realYear=[comps year];
    self.realMonth=[comps month];
    self.realDay=[comps day];
    
    NSString* title=[NSString stringWithFormat:@"%ld月%ld日", (long)self.currMonth, (long)day];
    NSString* dateKey=[NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)self.currYear, (long)self.currMonth, (long)day];
    
    [self.dayDetailBox initDataWithList1:[self.dayDic objectForKey:dateKey] title:title list2:self.dayList date:[NSString stringWithFormat:@"%ld",(long)day] shopFlag:self.shopFlag];
    if (self.currYear==self.realYear && self.currMonth==self.realMonth) {
        self.lblTabRight.text=@"本月";
    } else {
        self.lblTabRight.text=[NSString stringWithFormat:@"%@月",[self.monthArr objectAtIndex:self.currMonth-1]];
    }
    
    if (self.currYear==self.realYear && self.currMonth==self.realMonth && self.currDay==self.realDay) {
        self.lblTabLeft.text=@"今天";
    } else {
        self.lblTabLeft.text=[NSString stringWithFormat:@"%ld月%ld日", (long)self.currMonth, (long)self.currDay];
    }
    [UIHelper refreshUI:self.container scrollview:self.dayScroll];
}


//返回事件.
- (IBAction)btnBackEvent:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//tab月处理.
- (IBAction)btnTabMonthEvent:(id)sender
{
    [_dayPanel setHidden:YES];
    [_monthPanel setHidden:NO];
    
    [_tabBg setLs_left:152];
    _lblTabLeft.textColor=[UIColor whiteColor];
    _lblTabRight.textColor=[ColorHelper getRedColor];
}

//tab月处理.
- (IBAction)btnTabTodayEvent:(id)sender
{
    [_dayPanel setHidden:NO];
    [_monthPanel setHidden:YES];
    [_tabBg setLs_left:0];
    _lblTabLeft.textColor=[ColorHelper getRedColor];
    _lblTabRight.textColor=[UIColor whiteColor];
}
- (IBAction)btnPreMonthPayEvent:(id)sender {
    [self loadPrevMonthData];
}

- (IBAction)btnNextMonthPayEvent:(id)sender {
    [self loadNextMonthData];
}

- (void)loadPrevMonthData
{
    NSInteger month=self.currMonth-1;
    self.currMonth=month==0?12:month;
    self.currYear=month==0?self.currYear-1:self.currYear;
    [self loadData:self.currYear month:self.currMonth day:1 shopFlag:self.shopFlag];
}

- (void)loadNextMonthData
{
    NSInteger month=self.currMonth+1;
    self.currMonth=month==13?1:month;
    self.currYear=month==13?self.currYear+1:self.currYear;
    [self loadData:self.currYear month:self.currMonth day:1 shopFlag:self.shopFlag];
}




@end
