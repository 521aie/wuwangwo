//
//  SelectView.m
//  retailapp
//
//  Created by guozhi on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_STATE 1
#define TAG_LST_DATE 2
#import "EditItemList.h"
#import "UIHelper.h"
#import "OptionPickerBox.h"
#import "MenuList.h"
#import "MenuListCell.h"
#import "AlertBox.h"
#import "Platform.h"
#import "NameItemVO.h"
#import "DateUtils.h"
#import "CashRecordSelectView.h"
#import "DatePickerBox.h"
#import "NameItemVO.h"
@implementation CashRecordSelectView

- (void)initView {
    [self.lstState initLabel:@"审核状态" withHit:nil delegate:self];
    self.backgroundView.frame = self.container.frame;
    [self.lstDate initLabel:@"申请日期" withHit:nil delegate:self];
    [UIHelper refreshUI:self.container];
    self.lstDate.tag = TAG_LST_DATE;
    self.lstState.tag = TAG_LST_STATE;
    [self initData];

}

- (void)initData {
    [self.lstState initData:@"全部" withVal:@""];
    [self.lstDate initData:@"请选择" withVal:@""];

}

- (void)onItemListClick:(EditItemList *)obj {
    if (obj.tag == TAG_LST_STATE) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NameItemVO *itemVo = [[NameItemVO alloc] initWithVal:@"全部" andId:@""];
        [arr addObject:itemVo];
        itemVo = [[NameItemVO alloc] initWithVal:@"未审核" andId:@"1"];
        [arr addObject:itemVo];
        itemVo = [[NameItemVO alloc] initWithVal:@"审核不通过" andId:@"2"];
        [arr addObject:itemVo];
        itemVo = [[NameItemVO alloc] initWithVal:@"审核通过" andId:@"3"];
        [arr addObject:itemVo];
        itemVo = [[NameItemVO alloc] initWithVal:@"取消申请" andId:@"4"];
        [arr addObject:itemVo];
        [OptionPickerBox initData:arr itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
    if (obj.tag == TAG_LST_DATE) {
        NSDate* date = [DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox showClear:obj.lblName.text clearName:@"清空日期" date:date client:self event:obj.tag];
    }
    
    
    
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_STATE){
        [self.lstState initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    [self.lstDate initData:[DateUtils formateDate2:date] withVal:[DateUtils formateDate2:date]];
    return YES;
}

- (void)clearDate:(NSInteger)eventType {
    [self.lstDate initData:@"请选择" withVal:@""];
}


- (IBAction)onResetClick:(UIButton *)sender {
    [self initData];
    [self.delegate selectViewWithResetButtonClick];
}

- (IBAction)onCompleteClick:(UIButton *)sender {
    if ([self isValid]) {
         [self.delegate selectViewWithCompleteButtonClick];
    }

}
- (BOOL)isValid {
    if ([NSString isBlank:[self.lstDate getStrVal]]) {
        [AlertBox show:@"请选择申请日期"];
        return NO;
    }
    NSDate *startDate = [DateUtils parseDateTime4:[self.lstDate getStrVal]];
    NSDate *newDate = [startDate dateByAddingTimeInterval:365*24*60*60];
    NSDate *currentDate = [NSDate date];
        if ([currentDate compare:newDate] == NSOrderedDescending) {
            [AlertBox show:@"申请日期不能超过一年"];
            return NO;
    }
    return YES;
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.hidden = YES;
}

@end
