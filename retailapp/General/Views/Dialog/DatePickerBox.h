//
//  DatePickerBox.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-26.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "DatePickerBox.h"
#import "PopupBoxViewController.h"

@protocol DatePickerClient;
@interface DatePickerBox : PopupBoxViewController
{
    id<DatePickerClient> datePickerClient;
    
    NSInteger event;
}
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIView *pickerBackground;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UIImageView *img;
@property (nonatomic, retain) IBOutlet UILabel *lblDateClear;
@property (nonatomic, retain) IBOutlet UIButton *btnClear;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
/**右下方的字是不是确认生成 默认是 NO 确定  YES 是确认生成*/
@property (nonatomic, assign) BOOL isRight;

+ (void)initDatePickerBox;

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient>) client event:(NSInteger)eventType;

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient>)client event:(NSInteger)eventType isLimit:(BOOL)limit;
+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient>)client startDate:(NSDate *)startDate endDate:(NSDate *)endDate event:(NSInteger)eventType;

//显示带清空按钮的页.
+ (void)showClear:(NSString *)title clearName:(NSString *)clearName date:(NSDate *)date client:(id<DatePickerClient>) client event:(NSInteger)event;

//显示带清空按钮以及最小时间
+ (void)showToClear:(NSString *)title clearName:(NSString *)clearName date:(NSDate *)date client:(id<DatePickerClient>) client  startDate:(NSDate *)startDate endDate:(NSDate *)endDate event:(NSInteger)event;


/**设置有下方按钮的字为手动生成在show方法之前调用*/
+ (void)setRight;

+ (void)hide;

+ (void)setMinimumDate:(NSDate *)date;
+ (void)setMaximumDate:(NSDate *)date;

- (IBAction)confirmBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;

- (IBAction)clearBtnClick:(id)sender;
@end

@protocol DatePickerClient <NSObject>

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event;

@optional
//新增清空日期
- (void)clearDate:(NSInteger)eventType;

@end
