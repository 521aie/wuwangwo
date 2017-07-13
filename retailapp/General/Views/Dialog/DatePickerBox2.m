//
//  DatePickerBox2.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DatePickerBox2.h"
//#import "AppController.h"
#import "SystemUtil.h"
#import "UIView+Sizes.h"
#import "CDatePickerViewEx.h"
#import "DateUtils.h"

static DatePickerBox2 *datePickerBox2;

@interface DatePickerBox2 ()

@end

@implementation DatePickerBox2

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pickerBackground.layer setCornerRadius:2.0];
}

+ (void)initDatePickerBox
{
    datePickerBox2 = [[DatePickerBox2 alloc]init];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:datePickerBox2.view];
    datePickerBox2.view.hidden = YES;
}

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient2>) client event:(NSInteger)eventType
{
    datePickerBox2.datePicker.year = [DateUtils formateDate4:date];
    [datePickerBox2.datePicker selectRow:([DateUtils formateDate4:date].intValue - 2008 +11500) inComponent:0 animated:NO];
    datePickerBox2.lblTitle.text=title;
    datePickerBox2->datePickerClient = client;
    datePickerBox2->event=eventType;
    [datePickerBox2.lblDateClear setHidden:YES];
    [datePickerBox2.img setHidden:YES];
    [datePickerBox2.btnClear setHidden:YES];
    [datePickerBox2 showMoveIn];
}

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<DatePickerClient>)client event:(NSInteger)eventType isLimit:(BOOL)limit
{
    
    [DatePickerBox show:title date:date client:client event:eventType];
//    [datePickerBox2.datePicker setMinimumDate:[NSDate date]];
}

////显示带清空按钮的页.
//+ (void)showClear:(NSString *)title clearName:(NSString*)clearName date:(NSDate *)date client:(id<DatePickerClient>) client event:(NSInteger)event
//{
////    if (date != nil) {
////        [datePickerBox.datePicker setDate:date animated:YES];
////    } else {
////        [datePickerBox.datePicker setDate:[NSDate date] animated:YES];
////    }
//    datePickerBox2.lblTitle.text=title;
//    datePickerBox2->datePickerClient = client;
//    datePickerBox2->event=event;
//    [datePickerBox.lblDateClear setLeft:(310-datePickerBox.lblDateClear.width)];
//    [datePickerBox.img setLeft:(datePickerBox.lblDateClear.left-28)];
//    [datePickerBox.btnClear setWidth:datePickerBox.lblDateClear.width+28];
//    [datePickerBox.btnClear setLeft:datePickerBox.img.left];
//    [datePickerBox.lblDateClear setHidden:NO];
//    [datePickerBox.img setHidden:NO];
//    [datePickerBox.btnClear setHidden:NO];
//    [datePickerBox showMoveIn];
//    
//}

+ (void)hide
{
    [datePickerBox2 hideMoveOut];
}

- (IBAction)confirmBtnClick:(id)sender
{
    NSDate *date = [DateUtils parseDateTime5:self.datePicker.year];
    if ([datePickerClient pickDate:date event:event]) {
        [self hideMoveOut];
    }
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self hideMoveOut];
}

- (IBAction)clearBtnClick:(id)sender
{
    [datePickerClient clearDate:event];
    [self hideMoveOut];
}




@end
