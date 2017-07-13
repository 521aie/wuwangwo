//
//  DateMonthPickerBox.m
//  retailapp
//
//  Created by qingmei on 15/10/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SystemUtil.h"
#import "UIView+Sizes.h"
#import "DateMonthPickerBox.h"

static DateMonthPickerBox *datePickerBox;

@interface DateMonthPickerBox ()

@end

@implementation DateMonthPickerBox


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pickerBackground.layer setCornerRadius:2.0];
    self.view.hidden = YES;
}

+ (void)initDatePickerBox
{
    datePickerBox = [[DateMonthPickerBox alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:datePickerBox.view];
}

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DateMonthPickerClient>) client event:(NSInteger)eventType
{
    if (date != nil) {
        [datePickerBox.datePicker setDate:date];
    } else {
        [datePickerBox.datePicker setDate:[NSDate date]];
    }
    datePickerBox.datePicker.yearFirst = YES;
    datePickerBox.lblTitle.text=title;
    datePickerBox.datePickerClient = client;
    datePickerBox.event=eventType;
    [datePickerBox.lblDateClear setHidden:YES];
    [datePickerBox.img setHidden:YES];
    [datePickerBox.btnClear setHidden:YES];
    [datePickerBox showMoveIn];
    
}

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DateMonthPickerClient>)client event:(NSInteger)eventType isLimit:(BOOL)limit
{
//    if (limit) {
//        NSDateFormatter *fro = [[NSDateFormatter alloc] init];
//        [fro setDateFormat:@"yyyy"];
//        datePickerBox.datePicker.maximumYear = @([[fro stringFromDate:date] integerValue]);
//    }
    [DateMonthPickerBox show:title date:date client:client event:eventType];
}

+ (void)setMinYear:(NSString *)minYear maxYear:(NSString *)maxYear {
    if (minYear.length) {
        datePickerBox.datePicker.minimumYear = @(minYear.integerValue);
    }
    if (maxYear.length) {
        datePickerBox.datePicker.maximumYear = @(maxYear.integerValue);
    }
}

//显示带清空按钮的页.
+ (void)showClear:(NSString *)title clearName:(NSString*)clearName date:(NSDate *)date client:(id<DateMonthPickerClient>) client event:(NSInteger)event
{
    if (date != nil) {
        [datePickerBox.datePicker setDate:date];
    } else {
        [datePickerBox.datePicker setDate:[NSDate date]];
    }
    datePickerBox.lblTitle.text=title;
    datePickerBox.datePickerClient = client;
    datePickerBox.event=event;
    [datePickerBox.lblDateClear setLs_left:(310-datePickerBox.lblDateClear.ls_width)];
    [datePickerBox.img setLs_left:(datePickerBox.lblDateClear.ls_left-28)];
    [datePickerBox.btnClear setLs_width:datePickerBox.lblDateClear.ls_width+28];
    [datePickerBox.btnClear setLs_left:datePickerBox.img.ls_left];
    [datePickerBox.lblDateClear setHidden:NO];
    [datePickerBox.img setHidden:NO];
    [datePickerBox.btnClear setHidden:NO];
    [datePickerBox showMoveIn];
    
}

+ (void)hide
{
    [datePickerBox hideMoveOut];
}

- (IBAction)confirmBtnClick:(id)sender
{
    NSDate *date = [self.datePicker date];
    if ([_datePickerClient pickMonthDate:date event:_event]) {
        [self hideMoveOut];
    }
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self hideMoveOut];
}

- (IBAction)clearBtnClick:(id)sender
{
    [_datePickerClient clearDate:_event];
    [self hideMoveOut];
}

@end
