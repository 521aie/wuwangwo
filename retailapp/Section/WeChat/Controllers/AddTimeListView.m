//
//  AddTimeListView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AddTimeListView.h"
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "AlertBox.h"
#import "TimePickerBox.h"
#import "DateUtils.h"

@interface AddTimeListView () <INavigateEvent,IEditItemListEvent,TimePickerClient>

@property (nonatomic,copy) AddTimeCallBack addTimeCallBack;
@property (nonatomic,copy) CancelTimeCallBack cancelTimeCallBack;

@end

@implementation AddTimeListView

- (void)addTimeCallBack:(AddTimeCallBack)addTimeCallBack cancelTime:(CancelTimeCallBack)cancelTimeCallBack {
    self.addTimeCallBack = addTimeCallBack;
    self.cancelTimeCallBack = cancelTimeCallBack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"添加" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [self.titleDiv addSubview:self.titleBox];
    
    [self.lstStartTime initLabel:@"开始时间" withHit:@"" delegate:self];
    [self.lstStartTime initData:@"请选择" withVal:nil];
    self.lstStartTime.tag = 0;
    [self.lstEndTime initLabel:@"结束时间" withHit:@"" delegate:self];
    [self.lstEndTime initData:@"请选择" withVal:nil];
    self.lstEndTime.tag = 1;
}


- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        if (_cancelTimeCallBack) {
            _cancelTimeCallBack();
        }
    }else{
        [self save];
    }
}

- (void)changeNavigate
{
    BOOL isChange = NO;
    NSString *startTime = [self.lstStartTime currentVal];
    NSString *endTime = [self.lstEndTime currentVal];
    
    if ([NSString isNotBlank:startTime] && [NSString isNotBlank:endTime]) {
        isChange = YES;
    }
    
    [self.titleBox editTitle:isChange act:ACTION_CONSTANTS_ADD];
}

- (void)save
{
    NSString *startTime = [self.lstStartTime currentVal];
    NSString *endTime = [self.lstEndTime currentVal];
    
    if ([NSString isBlank:startTime] || [NSString isBlank:endTime]) {
        return;
    }
    if ([startTime compare:endTime] == NSOrderedAscending) {
        
    } else {
        [AlertBox show:@"配送开始时间要小于配送结束时间"];
        return;
    }
    for (NSDictionary*dic in self.arrSendTime) {
        NSString * oldEndtime=dic[@"endTime"];
        NSString *oldStartTime = dic[@"startTime"];
        if (([DateUtils formateDateTime5:startTime] < [DateUtils formateDateTime5:oldEndtime]) && ([DateUtils formateDateTime5:endTime] > [DateUtils formateDateTime5:oldStartTime])) {
            [AlertBox show:@"配送时间不能重叠"];
            return;

        }
    }
    
    if (self.addTimeCallBack) {
        self.addTimeCallBack(startTime, endTime);
    }
}

- (void)onItemListClick:(EditItemList *)obj {
     NSDate *date=[DateUtils parseDateTime6:[obj getStrVal]];
    [TimePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
}

- (BOOL)pickTime:(NSDate *)date event:(NSInteger)event {
    NSString* timeStr=[DateUtils formateChineseTime:date];
    if (event==0) {
        [self.lstStartTime changeData:timeStr withVal:timeStr];
    }else if (event==1) {
        [self.lstEndTime changeData:timeStr withVal:timeStr];
    }
    
    [self changeNavigate];
    return YES;
}

@end
