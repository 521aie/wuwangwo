//
//  CalendarDayView.h
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    DSLCalendarDayViewNotSelected = 0,
    DSLCalendarDayViewSelected,
    DSLCalendarDayViewWholeSelection,
    DSLCalendarDayViewStartOfSelection,
    DSLCalendarDayViewWithinSelection,
    DSLCalendarDayViewEndOfSelection,
} typedef DSLCalendarDayViewSelectionState;

enum {
    DSLCalendarDayViewStartOfWeek = 0,
    DSLCalendarDayViewMidWeek,
    DSLCalendarDayViewEndOfWeek,
} typedef DSLCalendarDayViewPositionInWeek;



@interface CalendarDayView : UIView
@property (nonatomic, strong) NSDateComponents *day;
@property (nonatomic, assign) BOOL isSelect;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblGoal;
@property (strong, nonatomic) IBOutlet UIButton *clickDay;
@property (nonatomic, strong) NSString *oldGoal;
@property (nonatomic, strong) NSString *currentGoal;
@property (nonatomic, assign) NSInteger performanceId;
@property (nonatomic, assign) NSInteger lastVer;
- (IBAction)clickBtn:(id)sender;

+ (id)getInstanceWithFrame:(CGRect)frame;
- (void)loadDayView:(id)obj;
- (BOOL)isBeforeToday;
- (BOOL)goalIschange;

- (void)initGoal:(NSString *)goal;
- (void)changeGoal:(NSString *)goal;
- (void)clearGoal;
@end
