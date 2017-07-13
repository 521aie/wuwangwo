//
//  TimePickerBox.m
//  RestApp
//
//  Created by zxh on 14-4-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TimePickerBox.h"
#import "DatePickerBox.h"
//#import "AppController.h"
#import "SystemUtil.h"
#import "DateUtils.h"
#import "ColorHelper.h"

@interface TimePickerBox ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *hoursArr;
@property (nonatomic, strong) NSArray *minutesArr;
@end
@implementation TimePickerBox
static TimePickerBox *timePickerBox;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pickerBackground.layer setCornerRadius:2.0];
    self.datePicker.hidden = YES;
    self.pickerView = [[UIPickerView alloc] initWithFrame:self.datePicker.frame];
    self.pickerView.backgroundColor = [UIColor clearColor];
    [self.mainContainer addSubview:self.pickerView];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.hoursArr = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    self.minutesArr = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];

    self.view.hidden = YES;
}

+ (void)initTimePickerBox
{
    timePickerBox = [[TimePickerBox alloc] init];
    timePickerBox.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:timePickerBox.view];
    timePickerBox.view.hidden = YES;
}

+ (void)show:(NSString *)title date:(NSDate *)date client:(id<TimePickerClient>) client event:(NSInteger)eventType
{
    [timePickerBox.pickerView selectRow:[timePickerBox.hoursArr count] inComponent:0 animated:YES];
    [timePickerBox.pickerView selectRow:[timePickerBox.minutesArr count] inComponent:1 animated:YES];
    if (date != nil) {
        NSString *dateStr =[DateUtils formateChineseTime:date];
        NSArray *arr = [dateStr componentsSeparatedByString:@":"];
        [timePickerBox.pickerView selectRow:[timePickerBox.hoursArr indexOfObject:arr[0]] inComponent:0 animated:NO];
        [timePickerBox.pickerView selectRow:[timePickerBox.minutesArr indexOfObject:arr[1]] inComponent:1 animated:NO];
    } else {
        [timePickerBox.pickerView selectRow:0 inComponent:0 animated:NO];
        [timePickerBox.pickerView selectRow:0 inComponent:1 animated:NO];
    }
    timePickerBox.lblTitle.text=title;
    timePickerBox->timePickerClient = client;
    timePickerBox->event=eventType;
    [timePickerBox showMoveIn];
}

#pragma mark pickview delegate
//组件数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

//每个组件的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return self.hoursArr.count*50;
    }else{
        return self.minutesArr.count*50;
    }
}

//初始化每个组件每一行数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.hoursArr objectAtIndex:(row%[self.hoursArr count])];
    }else{
        return [self.minutesArr objectAtIndex:(row%[self.minutesArr count])];
    }
}

//选中picker cell,save ArrayIndex
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUInteger max = 0;
    NSUInteger base10 = 0;
    if(component == 0) {
        max = [self.hoursArr count]*50;
        base10 = (max/2)-(max/2)%[self.hoursArr count];
        [pickerView selectRow:[pickerView selectedRowInComponent:component]%[self.hoursArr count]+base10 inComponent:component animated:NO];
    }else{
        max = [self.minutesArr count]*50;
        base10 = (max/2)-(max/2)%[self.minutesArr count];
        [pickerView selectRow:[pickerView selectedRowInComponent:component]%[self.minutesArr count]+base10 inComponent:component animated:NO];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = nil;
    if (component==0) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
        label.text = [self.hoursArr objectAtIndex:(row%[self.hoursArr count])];
        label.font = [UIFont systemFontOfSize:23];
        label.textAlignment = NSTextAlignmentRight;
        
    }else{
        label = [[UILabel alloc] initWithFrame:CGRectMake(220.0f, 0.0f, 100.0f, 30.0f)];
        label.text = [self.minutesArr objectAtIndex:(row%[self.minutesArr count])];
        label.font = [UIFont systemFontOfSize:23];
        label.textAlignment = NSTextAlignmentLeft;
    }
    label.textColor = [ColorHelper getBlackColor];
    return label;
}

+ (void)hide
{
    [timePickerBox hideMoveOut];
}

- (IBAction)confirmBtnClick:(id)sender
{
    NSUInteger max = 0;
    NSUInteger base10 = 0;
    max = [self.hoursArr count]*50;
    base10 = (max/2)-(max/2)%[self.hoursArr count];
    NSInteger indexHour =[self.pickerView selectedRowInComponent:0]%[self.hoursArr count]+base10;
    max = [self.minutesArr count]*50;
    base10 = (max/2)-(max/2)%[self.minutesArr count];
    NSInteger indexMinute = [self.pickerView selectedRowInComponent:1]%[self.minutesArr count]+base10;
    NSString *dateStr = [NSString stringWithFormat:@"%@:%@",self.hoursArr[indexHour%[self.hoursArr count]],self.minutesArr[indexMinute%[self.minutesArr count]]];
    NSDate *date = [DateUtils parseDateTime6:dateStr];
//    NSDate *date = [self.datePicker date];
    if ([timePickerClient pickTime:date event:event]) {
        [self hideMoveOut];
    }
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self hideMoveOut];
}


@end
