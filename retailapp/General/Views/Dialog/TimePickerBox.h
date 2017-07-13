//
//  TimePickerBox.h
//  RestApp
//
//  Created by zxh on 14-4-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "PopupBoxViewController.h"
#import "PopupBoxViewController.h"

@protocol TimePickerClient;
@interface TimePickerBox : PopupBoxViewController
{
    id<TimePickerClient> timePickerClient;
    NSInteger event;
}

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIView *pickerBackground;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;

+ (void)initTimePickerBox;

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<TimePickerClient>) client event:(NSInteger)eventType;

+ (void)hide;

- (IBAction)confirmBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;


@end


@protocol TimePickerClient <NSObject>

- (BOOL)pickTime:(NSDate *)date event:(NSInteger)event;

@end