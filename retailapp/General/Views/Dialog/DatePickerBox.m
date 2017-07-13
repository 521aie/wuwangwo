//
//  DatePickerBox.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-26.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DatePickerBox.h"
#import "SystemUtil.h"
#import "UIView+Sizes.h"

static DatePickerBox *datePickerBox;
@interface DatePickerBox ()
@property (nonatomic, strong) NSDate *systemMaxDate;
@property (nonatomic, strong) NSDate *systemMinDate;
@end
@implementation DatePickerBox

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pickerBackground.layer setCornerRadius:2.0];
}

+ (void)initDatePickerBox
{
    datePickerBox = [[DatePickerBox alloc] init];
    datePickerBox.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:datePickerBox.view];
    datePickerBox.systemMaxDate = datePickerBox.datePicker.maximumDate;
    datePickerBox.systemMinDate = datePickerBox.datePicker.minimumDate;
    datePickerBox.view.hidden = YES;
}

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient>)client event:(NSInteger)eventType
{
    if (date != nil) {
        [datePickerBox.datePicker setDate:date animated:YES];
    } else {
        [datePickerBox.datePicker setDate:[NSDate date] animated:YES];
    }

    datePickerBox.lblTitle.text=title;
    datePickerBox->datePickerClient = client;
    datePickerBox->event=eventType;
    if (datePickerBox.isRight) {
        [datePickerBox.btnConfirm setTitle:@"确认生成" forState:UIControlStateNormal];
    } else {
         [datePickerBox.btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
    }
    datePickerBox.isRight = NO;
    [datePickerBox.lblDateClear setHidden:YES];
    [datePickerBox.img setHidden:YES];
    [datePickerBox.btnClear setHidden:YES];
    [datePickerBox showMoveIn];
}

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient>)client startDate:(NSDate *)startDate endDate:(NSDate *)endDate event:(NSInteger)eventType
{
    [DatePickerBox show:title date:date client:client event:eventType];
     [datePickerBox.btnClear setHidden:YES];
    if (startDate!=nil) {
        [datePickerBox.datePicker setMinimumDate:startDate];
    } else {
        [datePickerBox.datePicker setMinimumDate:nil];
    }
    
    if (endDate!=nil) {
        [datePickerBox.datePicker setMaximumDate:endDate];
    } else {
        [datePickerBox.datePicker setMaximumDate:nil];
    }
}

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient>)client event:(NSInteger)eventType isLimit:(BOOL)limit
{
    [DatePickerBox show:title date:date client:client event:eventType];
    [datePickerBox.datePicker setMinimumDate:[NSDate date]];
}

+ (void)setRight {
    datePickerBox.isRight = YES;
}

//显示带清空按钮的页.
+ (void)showClear:(NSString *)title clearName:(NSString *)clearName date:(NSDate *)date client:(id<DatePickerClient>) client event:(NSInteger)event
{
    if (date != nil) {
        [datePickerBox.datePicker setDate:date animated:YES];
    } else {
        [datePickerBox.datePicker setDate:[NSDate date] animated:YES];
    }
    datePickerBox.lblTitle.text=title;
    datePickerBox->datePickerClient = client;
    datePickerBox->event=event;
    [datePickerBox.lblDateClear setLs_left:(310-datePickerBox.lblDateClear.ls_width)];
    [datePickerBox.img setLs_left:(datePickerBox.lblDateClear.ls_left-28)];
    [datePickerBox.btnClear setLs_width:datePickerBox.lblDateClear.ls_width+28];
    [datePickerBox.btnClear setLs_left:datePickerBox.img.ls_left];
    [datePickerBox.lblDateClear setHidden:NO];
    [datePickerBox.img setHidden:NO];
    [datePickerBox.btnClear setHidden:NO];
    [datePickerBox showMoveIn];
}

+ (void)showToClear:(NSString *)title clearName:(NSString *)clearName date:(NSDate *)date client:(id<DatePickerClient>) client  startDate:(NSDate *)startDate endDate:(NSDate *)endDate event:(NSInteger)event {
    [DatePickerBox show:title date:date client:client event:event];
    if (startDate!=nil) {
        [datePickerBox.datePicker setMinimumDate:startDate];
    } else {
        [datePickerBox.datePicker setMinimumDate:nil];
    }
    
    if (endDate!=nil) {
        [datePickerBox.datePicker setMaximumDate:endDate];
    } else {
        [datePickerBox.datePicker setMaximumDate:nil];
    }
    
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
    if ([datePickerClient pickDate:date event:event]) {
        [self hideMoveOut];
    }
    [datePickerBox.datePicker setMaximumDate:datePickerBox.systemMaxDate];
    [datePickerBox.datePicker setMinimumDate:datePickerBox.systemMinDate];
    
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self hideMoveOut];
    [datePickerBox.datePicker setMaximumDate:datePickerBox.systemMaxDate];
    [datePickerBox.datePicker setMinimumDate:datePickerBox.systemMinDate];
}

- (IBAction)clearBtnClick:(id)sender
{
    [datePickerClient clearDate:event];
    [self hideMoveOut];
}

+(void) setMinimumDate:(NSDate *)date
{
    [datePickerBox.datePicker setMinimumDate:date];
}

+ (void)setMaximumDate:(NSDate *)date
{
    [datePickerBox.datePicker setMaximumDate:date];
}

@end
