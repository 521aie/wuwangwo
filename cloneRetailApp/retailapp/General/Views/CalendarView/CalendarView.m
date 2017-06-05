//
//  CalendarView.m
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarMonthSelectorView.h"

#define DAYVIEW_HIGHT 32

@interface CalendarView ()
@property (nonatomic, copy  ) NSDate *dateTag;   //初始化时的月份标记
@property (nonatomic, assign) NSInteger alertType;   //1.上一月 2.下一月

@end

@implementation CalendarView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<CalendarViewDelegate>)host{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate=host;
    }
    return self;
}


- (void)commonInit {
    
    //当前月
    _visibleMonth = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitCalendar fromDate:[NSDate date]];
    _visibleMonth.day = 1;
    
   
    
    //选择月份view
    self.monthSelectorView = [[[self class] monthSelectorViewClass] view];
    [self.view addSubview:self.monthSelectorView];
  
    
    //月份view
    self.monthView.ls_width = SCREEN_W;
    [self.monthView initWithMonth:_visibleMonth frame:self.monthView.frame dayViewHeight:DAYVIEW_HIGHT];
//    [self.view addSubview:self.monthView];
    
    [self updateMonthLabelMonth:_visibleMonth];
    
    [self.monthSelectorView.backButton addTarget:self action:@selector(didTapMonthBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.monthSelectorView.forwardButton addTarget:self action:@selector(didTapMonthForward:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)initMonth:(NSDate *)month{
    _visibleMonth = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitCalendar fromDate:month];
    _visibleMonth.day = 1;
    
    _dateTag = month;
    
    [self.monthView changeMonth:_visibleMonth];
    [self updateMonthLabelMonth:_visibleMonth];

}

- (void)setVisibleMonth:(NSDateComponents *)visibleMonth animated:(BOOL)animated {
    
    _visibleMonth = [visibleMonth.date CalendarView_monthWithCalendar:self.visibleMonth.calendar];
    
    [self updateMonthLabelMonth:_visibleMonth];
    [self.monthView changeMonth:_visibleMonth];
}

#pragma mark - 上一月
- (void)didTapMonthBack:(id)sender {
    
    if (self.isGoalChange) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前月业绩未保存,继续将会丢失已设置的业绩。确定要继续吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
        self.alertType = 1;
        [alertView show];
    }else{
        [self showMonthBack];
    }
}
- (void) showMonthBack{
    
   
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *tagPre = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitCalendar fromDate:_dateTag];
    tagPre.day = 1;
    tagPre.month = tagPre.month - 1;//标记月的上个月
    
    NSDate *visibleDay = [calendar dateFromComponents:self.visibleMonth];
    NSDateComponents *visiblePre = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitCalendar fromDate:visibleDay];
    visiblePre.day = 1;
    visiblePre.month = visiblePre.month - 1;//当前显示月的上个月
    
    
    NSDate *visiblePreDay = [calendar dateFromComponents:visiblePre];
    NSDate *tagPreDay = [calendar dateFromComponents:tagPre];
    long long visiblePreTime = [visiblePreDay timeIntervalSince1970];
    long long tagPreTime = [tagPreDay timeIntervalSince1970];
    
    if (visiblePreTime > tagPreTime ) {//如果当前月上个月时间戳比标记月的上个月大 则可以减一个月
        _monthSelectorView.forwardButton.hidden = NO;
        _monthSelectorView.imgRight.hidden = NO;
    }else{
        _monthSelectorView.backButton.hidden = YES;
        _monthSelectorView.imgLeft.hidden = YES;
    }
    self.visibleMonth.month --;
    [self setVisibleMonth:self.visibleMonth animated:YES];
    NSDate *day = [calendar dateFromComponents: self.visibleMonth];
    if (self.delegate) {
        [self.delegate clickPreMonth:day];
    }

}

#pragma mark - 下一月
- (void)didTapMonthForward:(id)sender {
    
    if ([self isGoalChange]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前月业绩未保存,继续将会丢失已设置的业绩。确定要继续吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
        self.alertType = 2;
        [alertView show];
    }else{
        [self showMonthForward];
    }
    
    
    
}

- (void)showMonthForward{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *tagNext = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitCalendar fromDate:_dateTag];
    tagNext.day = 1;
    tagNext.month = tagNext.month + 1;//当前月的下个月
    
    
    NSDate *visibleDay = [calendar dateFromComponents:self.visibleMonth];
    NSDateComponents *visibleNext = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitCalendar fromDate:visibleDay];
    visibleNext.day = 1;
    visibleNext.month = visibleNext.month + 1;//当前显示月的上个月

    
    NSDate *visibleNextDay = [calendar dateFromComponents:visibleNext];//当前显示的
    NSDate *tagNextDay = [calendar dateFromComponents:tagNext];
    long long visibleNextTime = [visibleNextDay timeIntervalSince1970];
    long long tagNextTime = [tagNextDay timeIntervalSince1970];
    
    if (visibleNextTime < tagNextTime) {//如果当前月时间戳比标记月的下个月小 则可以加一个月
        _monthSelectorView.backButton.hidden = NO;
        _monthSelectorView.imgLeft.hidden = NO;
    }else{
        _monthSelectorView.forwardButton.hidden = YES;
        _monthSelectorView.imgRight.hidden = YES;
    }
    self.visibleMonth.month ++;
    [self setVisibleMonth:self.visibleMonth animated:YES];

    NSDate *day = [calendar dateFromComponents: self.visibleMonth];
    if (self.delegate) {
        [self.delegate clickNextMonth:day];
    }

}
#pragma mark - alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {//确定
        switch (_alertType) {
            case 1://上一月
            {
               [self showMonthBack];
            }
                break;
            case 2://下一月
            {
               [self showMonthForward];
            }
                break;
            default:
                break;
        }//switch
    }//if
}


#pragma mark - Data
- (void)setSaleGoal:(NSString *)goal{
    [self.monthView setSaleGoal:goal];
}

- (void)updateGoalbyList:(NSArray *)goalList{
    [self.monthView updateGoalbyList:goalList];
}
- (BOOL)isGoalChange{
    return [self.monthView isGoalChange];
}
- (NSArray *)getGoal{
    return [self.monthView getGoal];
}

+ (Class)monthSelectorViewClass {
    return [CalendarMonthSelectorView class];
}

+ (Class)monthViewClass {
    return [CalendarMonthView class];
}

+ (Class)dayViewClass {
    return [CalendarDayView class];
}


- (void)updateMonthLabelMonth:(NSDateComponents*)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy年MM月"];
    
    NSDate *date = [month.calendar dateFromComponents:month];
    self.monthSelectorView.titleLabel.text = [formatter stringFromDate:date];
}



@end
