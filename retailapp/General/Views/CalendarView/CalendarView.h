//
//  CalendarView.h
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarRange.h"
#import "CalendarMonthView.h"
#import "CalendarMonthSelectorView.h"
#import "CalendarDayView.h"
#import "NSDate+CalendarView.h"
#import "UIView+Sizes.h"
@protocol CalendarViewDelegate;

@class CalendarMonthSelectorView,CalendarMonthView;

@interface CalendarView : BaseViewController
@property (nonatomic, weak) id<CalendarViewDelegate>delegate;
@property (nonatomic, copy) NSDateComponents *visibleMonth;
@property (nonatomic, strong) CalendarRange *selectedRange;

@property (nonatomic, strong) IBOutlet CalendarMonthSelectorView *monthSelectorView;
@property (strong, nonatomic) IBOutlet CalendarMonthView *monthView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<CalendarViewDelegate>)host;
- (void)setSaleGoal:(NSString *)goal;

- (void)updateGoalbyList:(NSArray *)goalList;
- (BOOL)isGoalChange;//当前月的业绩是否有变化
- (NSArray *)getGoal;
- (void)initMonth:(NSDate *)month;

@end


@protocol CalendarViewDelegate <NSObject>
- (void)clickPreMonth:(NSDate *)preMonth;
- (void)clickNextMonth:(NSDate *)nextMonth;
@end