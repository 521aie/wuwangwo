//
//  OptionPickerBox.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-26.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import "SystemUtil.h"
#import "GlobalRender.h"
#import "UIView+Sizes.h"
#import "OptionPickerBox.h"
#import "INameItem.h"

static OptionPickerBox *optionPickerBox;

@implementation OptionPickerBox

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pickerBackground.layer setCornerRadius:2.0];
}

+ (void)initOptionPickerBox
{
    optionPickerBox = [[OptionPickerBox alloc] init];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    optionPickerBox.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [window addSubview:optionPickerBox.view];
    // 懒加载，这里加载picker等view
    optionPickerBox.view.hidden = YES;
}



+ (void)show:(NSString *)title client:(id<OptionPickerClient>) client event:(NSInteger)event
{
    optionPickerBox.lblTitle.text=title;
    optionPickerBox->event=event;
    optionPickerBox->optionPickerClient = client;
    [optionPickerBox.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [optionPickerBox.lblManager setHidden:YES];
    [optionPickerBox.imgManager setHidden:YES];
    [optionPickerBox.btnManager setHidden:YES];
    [optionPickerBox showMoveIn];
}

//显示带管理按钮的页.
+ (void)showManager:(NSString *)title managerName:(NSString*)managerName client:(id<OptionPickerClient>) client event:(NSInteger)event
{
    optionPickerBox.lblTitle.text=title;
    optionPickerBox->event=event;
    optionPickerBox->optionPickerClient = client;
    
    [optionPickerBox.lblTitle setTextAlignment:NSTextAlignmentLeft];
    optionPickerBox.lblManager.text=managerName;
    [optionPickerBox.lblManager setHidden:NO];
    [optionPickerBox.imgManager setHidden:NO];
    optionPickerBox.imgManager.image = [UIImage imageNamed:@"ico_manage"];
    [optionPickerBox.btnManager setHidden:NO];
    [optionPickerBox showMoveIn];
}

/**
 显示清空的按钮

 @param title     标题
 @param client    代理
 @param event     弹出带清空按钮的选择
 */
+ (void)showClearTitle:(NSString *)title client:(id<OptionPickerClient>) client event:(NSInteger)event
{
    optionPickerBox.lblTitle.text=title;
    optionPickerBox->event=event;
    optionPickerBox->optionPickerClient = client;
    
    [optionPickerBox.lblTitle setTextAlignment:NSTextAlignmentLeft];
    optionPickerBox.lblManager.text=@"清空类型";
    [optionPickerBox.lblManager sizeToFit];
    [optionPickerBox.lblManager setLs_left:(310-optionPickerBox.lblManager.ls_width)];
    [optionPickerBox.imgManager setLs_left:(optionPickerBox.lblManager.ls_left-28)];
    [optionPickerBox.btnManager setLs_width:optionPickerBox.lblManager.ls_width+28];
    [optionPickerBox.btnManager setLs_left:optionPickerBox.imgManager.ls_left];
    [optionPickerBox.lblManager setHidden:NO];
    [optionPickerBox.imgManager setHidden:NO];
    optionPickerBox.imgManager.image = [UIImage imageNamed:@"clean_date_bg.9"];
    [optionPickerBox.btnManager setHidden:NO];
    [optionPickerBox showMoveIn];
}
+ (void)hide
{
    [optionPickerBox hideMoveOut];
}

+ (void)changeImgManager:(NSString *)imgStr
{
    [optionPickerBox.imgManager setImage:[UIImage imageNamed:imgStr]];
}

+ (void)initData:(NSArray *)data itemId:(NSString *)itemId
{
    optionPickerBox->objData = data;
    optionPickerBox->strData = [GlobalRender convertStrs:data];
    optionPickerBox.picker.dataSource = optionPickerBox;
    optionPickerBox.picker.delegate = optionPickerBox;
    NSInteger selectRow=[GlobalRender getPos:data itemId:itemId];
    [optionPickerBox.picker selectRow:selectRow inComponent:0 animated:YES];
}

- (IBAction)confirmBtnClick:(id)sender
{
    if (objData==nil || objData.count==0) {
        [self hideMoveOut];
        return;
    }
    NSInteger selectRow = [self.picker selectedRowInComponent:0];
    id<INameItem> selectObject = [objData objectAtIndex:selectRow];
    [optionPickerClient pickOption:selectObject event:event];
    [self hideMoveOut];
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self hideMoveOut];
}

- (IBAction)managerBtnClick:(id)sender
{
    [optionPickerClient managerOption:event];
    [self hideMoveOut];
}

#pragma mark - UIPickerView dalegate、dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (strData != nil) {
        return [strData count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (strData != nil) {
        return [strData objectAtIndex:row];
    }
    return @"";
}

@end
