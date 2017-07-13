//
//  CalendarMonthSelectorView.m
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CalendarMonthSelectorView.h"
#import "ColorHelper.h"

@implementation CalendarMonthSelectorView
+ (id)view {
    static UINib *nib;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    });
    
    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
    for (id object in nibObjects) {
        if ([object isKindOfClass:[self class]]) {
            return object;
        }
    }
    
    return nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        // Initialise properties
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ls_width = SCREEN_W;
    
    // Get a dictionary of localised day names
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitCalendar | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    formatter.dateFormat = @"EE";
    NSMutableDictionary *dayNames = [[NSMutableDictionary alloc] init];
    
    for (NSInteger index = 0; index < 7; index++) {
        NSInteger weekday = dateComponents.weekday /*- [dateComponents.calendar firstWeekday]*/;
        if (weekday < 0) weekday += 7;
        [dayNames setValue:[formatter stringFromDate:dateComponents.date] forKey:@(weekday)];
        
        dateComponents.day = dateComponents.day + 1;
        dateComponents = [dateComponents.calendar components:NSCalendarUnitCalendar | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:dateComponents.date];
    }
    
    // Set the day name label texts to localised day names
    for (UILabel *label in self.dayLabels) {
        label.text = [[dayNames objectForKey:@(label.tag)] uppercaseString];
    }
    
    //Set the button tittle color
    [_backButton setTitleColor:[ColorHelper getBlueColor] forState:UIControlStateNormal];
    [_forwardButton setTitleColor:[ColorHelper getBlueColor] forState:UIControlStateNormal];
    
    [_backButton setTitleColor:[ColorHelper getTipColor9] forState:UIControlStateDisabled];
    [_forwardButton setTitleColor:[ColorHelper getTipColor9] forState:UIControlStateDisabled];

}

@end
