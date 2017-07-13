//
//  CalendarMonthView.h
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CalendarDayView;
@class CalendarRange;

@interface CalendarMonthView : UIView

@property (nonatomic, copy, readonly) NSDateComponents *month;
@property (nonatomic, strong, readonly) NSSet *dayViews;

// Designated initialiser
- (void)initWithMonth:(NSDateComponents*)month frame:(CGRect)frame dayViewHeight:(CGFloat)dayViewHeight;

- (void)setSaleGoal:(NSString *)goal;
- (void)updateGoalbyList:(NSArray *)goalList;
- (BOOL)isGoalChange;
- (NSArray *)getGoal;
- (NSDictionary *)getEveryDaySameGoal;
- (BOOL)isEveryDaySameGoal;//是否每天的目标都一样。若都一样,外部按照按月处理

- (CalendarDayView*)dayViewForDay:(NSDateComponents*)day;

- (void)changeMonth:(NSDateComponents*)month;
@end
