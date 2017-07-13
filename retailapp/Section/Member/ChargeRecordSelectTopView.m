//
//  ChargeRecordSelectTopView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ChargeRecordSelectTopView.h"
#import "UIView+Sizes.h"
#import "EditItemList.h"
#import "MemberModuleEvent.h"
#import "ColorHelper.h"
#import "DateUtils.h"
#import "UIHelper.h"
#import "DatePickerBox.h"
#import "MemberModule.h"
#import "MemberChargeRecordView.h"

@interface ChargeRecordSelectTopView ()

@end

@implementation ChargeRecordSelectTopView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MemberModule *)parentTemp {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    [self initButton];
    [self loadChargeRecordTopSelectView];
    [UIHelper refreshPos:self.mainContainer scrollview:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadChargeRecordTopSelectView
{
    if (self.status == 0) {
        [self resetLblVal];
        self.status = 1;
    }
    
}

//初始化条件项内容
- (void)initMainView
{
    [self.lsDate initLabel:@"充值日期" withHit:nil delegate:self];
    
    self.lsDate.tag =  CHARGE_RECORD_SELECT_TOP_DATE;
    
}

//计算mainContainer的高度
- (void)changeHeight:(UIView*)container  {
    float height=0;
    for (UIView*  view in container.subviews) {
        [view setLs_top:height];
        height+=view.ls_height;
    }
    [container setLs_height:(height)];
    [container setNeedsDisplay];
}

- (void)initButton
{
    [self.btnReset setTitleColor:[ColorHelper getBlueColor] forState:UIControlStateNormal];
    [self.btnConfirm setTitleColor:[ColorHelper getBlueColor] forState:UIControlStateNormal];
}

#pragma mark - 重置
//重置选项栏的值
- (void)resetLblVal
{
    [self.lsDate initData:@"请选择" withVal:@""];
}

-(void) onItemListClick:(EditItemList *)obj
{
    if (obj.tag == CHARGE_RECORD_SELECT_TOP_DATE) {
        NSDate *date=[DateUtils parseDateTime5:obj.lblVal.text];
        
        [DatePickerBox show:obj.lblName.text date:date client:self event:(int)obj.tag];
    }
}

//选择日期
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    
    if (event == CHARGE_RECORD_SELECT_TOP_DATE) {
        
        NSString* dateStr=[DateUtils formateDate2:date];
        [self.lsDate initData:dateStr withVal:dateStr];
    }
    [UIHelper refreshUI:self.mainContainer scrollview:nil];
    return YES;
}

//module中调用
- (void)oper{
    
    [self showMoveIn];
    
}

//视图动画效果
- (void)showMoveIn
{
    self.view.hidden = NO;
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.alpha = 0.5;
    self.view.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)hideMoveOut
{
    [UIView beginAnimations:@"viewOut" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterMoveOut:finished:context:)];
    [UIView setAnimationDuration:0.2];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.view.alpha = 1.0;
    self.view.alpha = 0.5;
    [UIView commitAnimations];
}

- (void)afterMoveOut:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished context:(void *)paramContext
{
    self.view.hidden = YES;
}

//重置按钮
- (IBAction)btnReset:(id)sender
{
    
    [self resetLblVal];
    
}

//空白按钮
- (IBAction)btnTopClick
{
    [self hideMoveOut];
    
}

//确认按钮
- (IBAction)btnConfirm:(id)sender
{
    [self hideMoveOut];    
    NSString* startTime = @"";
    NSString* endTime = @"";
    if (![NSString isBlank:[self.lsDate getStrVal]]) {
        startTime = [NSString stringWithFormat:@"%lld", [DateUtils formateDateTime3:[self.lsDate getStrVal]]];
        endTime = [NSString stringWithFormat:@"%lld", [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59",[self.lsDate getStrVal]]]];
    }
    [self.delegate selectChangeRecord:startTime endTime:endTime lastDateTime:@""];
}

@end
