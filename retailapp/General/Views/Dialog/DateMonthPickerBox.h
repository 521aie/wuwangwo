//
//  DateMonthPickerBox.h
//  retailapp
//
//  Created by qingmei on 15/10/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "DatePickerBox.h"
#import "PopupBoxViewController.h"
#import "MonthPicker.h"
@protocol DateMonthPickerClient;
@interface DateMonthPickerBox : PopupBoxViewController

@property (nonatomic ,assign) NSInteger event;/*<<#说明#>>*/
@property (nonatomic, retain) IBOutlet MonthPicker *datePicker;
@property (nonatomic, retain) IBOutlet UIView *pickerBackground;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UIImageView *img;
@property (nonatomic, retain) IBOutlet UILabel *lblDateClear;
@property (nonatomic, retain) IBOutlet UIButton *btnClear;

@property (nonatomic, weak) id<DateMonthPickerClient> datePickerClient;

+ (void)initDatePickerBox;

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DateMonthPickerClient>) client event:(NSInteger)eventType;

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DateMonthPickerClient>)client event:(NSInteger)eventType isLimit:(BOOL)limit;

//显示带清空按钮的页.
+ (void)showClear:(NSString *)title clearName:(NSString*)clearName date:(NSDate *)date client:(id<DateMonthPickerClient>) client event:(NSInteger)event;

+ (void)setMinYear:(NSString *)minYear maxYear:(NSString *)maxYear;

+ (void)hide;

- (IBAction)confirmBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;

- (IBAction)clearBtnClick:(id)sender;
@end

@protocol DateMonthPickerClient <NSObject>

- (BOOL)pickMonthDate:(NSDate *)date event:(NSInteger)event;

@optional
//新增清空日期
- (void)clearDate:(NSInteger)eventType;
@end
