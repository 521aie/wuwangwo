//
//  DatePickerBox2.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PopupBoxViewController.h"
//#import "AppController.h"
#import "DatePickerBox.h"
#import "PopupBoxViewController.h"

@protocol DatePickerClient2;
@class CDatePickerViewEx;
@interface DatePickerBox2 : PopupBoxViewController
{
    id<DatePickerClient2> datePickerClient;
    
    NSInteger event;
}

@property (nonatomic, retain) IBOutlet CDatePickerViewEx *datePicker;
@property (nonatomic, retain) IBOutlet UIView *pickerBackground;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UIImageView *img;
@property (nonatomic, retain) IBOutlet UILabel *lblDateClear;
@property (nonatomic, retain) IBOutlet UIButton *btnClear;


+ (void)initDatePickerBox;

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient2>) client event:(NSInteger)eventType;

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient2>)client event:(NSInteger)eventType isLimit:(BOOL)limit;

//显示带清空按钮的页.
//+ (void)showClear:(NSString *)title clearName:(NSString*)clearName date:(NSDate *)date client:(id<DatePickerClient2>) client event:(NSInteger)event;


+ (void)hide;

- (IBAction)confirmBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;

- (IBAction)clearBtnClick:(id)sender;
@end

@protocol DatePickerClient2 <NSObject>

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event;

@optional
//新增清空日期
- (void)clearDate:(NSInteger)eventType;
@end
