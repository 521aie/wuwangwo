//
//  SelectView.m
//  retailapp
//
//  Created by guozhi on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_START 1
#define TAG_LST_END 2
#import "ReturnGuideSelectView.h"
#import "EditItemList.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "OptionPickerBox.h"
#import "DatePickerBox2.h"
#import "MenuList.h"
#import "MenuListCell.h"
#import "AlertBox.h"
#import "Platform.h"
#import "NameItemVO.h"
#import "DateUtils.h"
@implementation ReturnGuideSelectView

- (void)initView {
  
    [self.lstStart initLabel:@"开始时间" withHit:nil delegate:self];
    [self.lstEnd initLabel:@"结束时间" withHit:nil delegate:self];
    self.lstStart.tag = TAG_LST_START;
    self.lstEnd.tag = TAG_LST_END;
    [self initData];

}

- (void)initData {
    [self.lstStart initData:@"请选择" withVal:@"请选择"];
    [self.lstEnd initData:@"请选择" withVal:@"请选择"];
    [UIHelper refreshUI:self.container];
}
- (void)onItemListClick:(EditItemList *)obj {
    NSDate *date = [NSDate date];
    if ([NSString isNotBlank:obj.lblVal.text]) {
        date = [DateUtils parseDateTime4:obj.lblVal.text];
    }
    [DatePickerBox2 show:obj.lblName.text date:date client:self event:obj.tag];
}

#pragma mark - 选择日期
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    NSString *dateStr = [DateUtils formateDate2:date];
    if (event == TAG_LST_START) {
        [self.lstStart initData:dateStr withVal:dateStr];
    } else if (event == TAG_LST_END) {
        [self.lstEnd initData:dateStr withVal:dateStr];
    }
    return YES;
}

- (IBAction)onResetClick:(UIButton *)sender {
    [self initData];
    [self.delegate selectViewWithResetButtonClickParam:nil];
}

- (IBAction)onCompleteClick:(UIButton *)sender {
    if ([[self.lstStart getDataLabel] isEqualToString:@"请选择"]) {
        [AlertBox show:@"请选择开始时间"];
        return;
    }
    if ([[self.lstEnd getDataLabel] isEqualToString:@"请选择"]) {
        [AlertBox show:@"请选择结束时间"];
        return;
    }
    NSDate *startDate = [DateUtils parseDateTime4:[self.lstStart getStrVal]];
    NSDate *newDate = [startDate dateByAddingTimeInterval:364*24*60*60];
    NSDate *endDate = [DateUtils parseDateTime4:[self.lstEnd getStrVal]];
        if ([endDate compare:newDate] == NSOrderedDescending) {
            [AlertBox show:@"查询日期不能超过一年"];
            return;
        }
        if ([startDate compare:endDate] == NSOrderedDescending) {
            [AlertBox show:@"开始日期不能大于结束日期!"];
            return;
        }
    [self.delegate selectViewWithCompleteButtonClickParam:nil];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.hidden = YES;
}

- (BOOL)isValid {
    NSDate *startDate = [DateUtils parseDateTime4:[self.lstStart getStrVal]];
    NSDate *endDate = [DateUtils parseDateTime4:[self.lstEnd getStrVal]];
    if ([startDate compare:endDate] == NSOrderedDescending) {
        [AlertBox show:@"开始日期不能大于结束日期!"];
        return NO;
    }
    return YES;
}

@end
