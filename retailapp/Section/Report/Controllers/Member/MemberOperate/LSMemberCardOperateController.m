  //
//  LSMemberCardOperateController.m
//  retailapp
//
//  Created by wuwangwo on 17/1/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#define kTagLstTime 3
#define kTagLstStartDate 1
#define kTagLstEndDate 2
#define kTagLstType 4

#import "LSMemberCardOperateController.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "INameItem.h"
#import "DatePickerBox.h"
#import "XHAnimalUtil.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "DateUtils.h"
#import "UIHelper.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "SelectShopListView.h"
#import "DatePickerBox.h"
#import "AlertBox.h"
#import "MenuList.h"

#import "LSMemberCardOperateListController.h"
#import "LSAlertHelper.h"
#import "LSMemberConst.h"

@interface LSMemberCardOperateController ()<IEditItemListEvent, OptionPickerClient, DatePickerClient,EditItemTextDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) LSEditItemList *lstTime;//时间
@property (nonatomic, strong) LSEditItemList *lstStartDate;//开始日期
@property (nonatomic, strong) LSEditItemList *lstEndDate;//结束日期
@property (nonatomic, strong) LSEditItemList *action;//操作类型：挂失、退卡、换卡、解挂
@property (nonatomic, strong) LSEditItemText *keyWord;//查询条件:会员卡号/手机号
@property (nonatomic, strong) NSMutableDictionary *param;//请求参数
@end

@implementation LSMemberCardOperateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"会员卡操作记录" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    [self.scrollView addSubview:self.container];
    
    //选项修改：今天、昨天、本周、上周、本月、上月、自定义
    self.lstTime = [LSEditItemList editItemList];
    self.lstTime.tag = kTagLstTime;
    [self.lstTime initLabel:@"时间" withHit:nil delegate:self];
    [self.lstTime initData:@"今天" withVal:@"0"];
    [self.container addSubview:self.lstTime];
    
    //开始日期
    self.lstStartDate = [LSEditItemList editItemList];
    self.lstStartDate.tag = kTagLstStartDate;
    [self.container addSubview:self.lstStartDate];
    NSDate* date=[NSDate date];
    NSString* dateStr=[DateUtils formateDate2:date];
    [self.lstStartDate initLabel:@"▪︎ 开始日期" withHit:nil delegate:self];
    [self.lstStartDate initData:dateStr withVal:dateStr];
    [self.lstStartDate visibal:NO];
    
    //结束日期
    self.lstEndDate = [LSEditItemList editItemList];
    self.lstEndDate.tag = kTagLstEndDate;
    [self.container addSubview:self.lstEndDate];
    [self.lstEndDate initLabel:@"▪︎ 结束日期" withHit:nil delegate:self];
    [self.lstEndDate initData:dateStr withVal:dateStr];
    [self.lstEndDate visibal:NO];
    
    //操作类型
    self.action = [LSEditItemList editItemList];
    self.action.tag = kTagLstType;
    [self.action initLabel:@"操作类型" withHit:nil delegate:self];
    [self.action initData:@"全部" withVal:0];
    [self.container addSubview:self.action];
    
    //查询会员卡号/手机号
    self.keyWord = [LSEditItemText editItemText];
    [self.keyWord initLabel:@"查询条件" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    self.keyWord.txtVal.placeholder = @"会员卡号/手机号";
    self.keyWord.isShowStatus = NO;
    [self.keyWord initMaxNum:32];
    self.keyWord.delegate = self;
    [self.keyWord initData:@""];
    [self.container addSubview:self.keyWord];
    
    //添加查询按钮
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *text = @"提示：可以根据上面的条件查询会员卡操作记录。";
    [LSViewFactor addExplainText:self.container text:text y:0];
}



- (void)onItemListClick:(LSEditItemList *)obj {
     if (obj == self.lstTime) {//时间
        NSMutableArray *list = [NSMutableArray array];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:@"今天" andId:@"0"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"昨天" andId:@"1"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"本周" andId:@"2"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"上周" andId:@"3"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"本月" andId:@"4"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"上月" andId:@"5"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"自定义" andId:@"6"];
        [list addObject:item];
        [OptionPickerBox initData:list itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
     }else if (obj == self.action) {//操作类型
         NSArray *list;
         list = @[@"全部",@"挂失",@"解挂",@"换卡",@"退卡"];
         [OptionPickerBox initData:[MenuList list1FromArray:list] itemId:[obj getStrVal]];
         [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
     }else if (obj == self.lstStartDate || obj == self.lstEndDate) {
        NSDate *date = [NSDate date];
        if ([NSString isNotBlank:obj.lblVal.text]) {
            date = [DateUtils parseDateTime4:obj.lblVal.text];
        }
         [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
     }
}

#pragma mark - 选择下拉框的内容
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == kTagLstTime){//自定义时间
        [self.lstTime initData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemName] isEqualToString:@"自定义"]) {
            [self.lstStartDate visibal:YES];
            [self.lstEndDate visibal:YES];
        } else {
            [self.lstStartDate visibal:NO];
            [self.lstEndDate visibal:NO];
        }
    } else if (eventType == kTagLstType) {//操作类型
        [self.action initData:[item obtainItemName] withVal:[item obtainItemId]];
        /*
        if ([[item obtainItemName] isEqualToString:@"全部"]) {
            [self.action initData:@"全部" withVal:nil];
            [self.action visibal:YES];
        }else if ([[item obtainItemName] isEqualToString:@"挂失"]) {
            [self.action initData:@"挂失" withVal:nil];
            [self.action visibal:YES];
        }else if ([[item obtainItemName] isEqualToString:@"解挂"]){
            [self.action initData:@"解挂" withVal:nil];
            [self.action visibal:YES];
        }else if ([[item obtainItemName] isEqualToString:@"退卡"]){
            [self.action initData:@"退卡" withVal:nil];
            [self.action visibal:YES];
        }else if ([[item obtainItemName] isEqualToString:@"换卡"]){
            [self.action initData:@"换卡" withVal:nil];
            [self.action visibal:YES];
        }*/
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma mark - 选择日期
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    NSString *dateStr = [DateUtils formateDate2:date];
    if (event == kTagLstStartDate) {
        [self.lstStartDate initData:dateStr withVal:dateStr];
    } else if (event == kTagLstEndDate) {
        [self.lstEndDate initData:dateStr withVal:dateStr];
    }
    return YES;
}

#pragma mark - 验证是否满足查询条件
- (BOOL)isValid {
    NSDate *startDate = [DateUtils parseDateTime4:[self.lstStartDate getStrVal]];
    NSDate *endDate = [DateUtils parseDateTime4:[self.lstEndDate getStrVal]];
    if (self.lstStartDate.hidden == NO) {
//        时间选择“自定义”时，开始日期不能大于结束日期，并且只能选择最近3个月的日期，否则报错误消息“开始日期只能选择最近3个月的日期！
        if (![DateUtils daysToNow:startDate]) {
            return NO;
        }
        if ([startDate compare:endDate] == NSOrderedDescending) {
            [AlertBox show:@"开始日期不能大于结束日期!"];
            return NO;
        }
    }
    return YES;
}

#pragma - 点击查询按钮
- (void)btnClick:(UIButton *)sender {
    if ([self isValid]) {
        LSMemberCardOperateListController *vc = [[LSMemberCardOperateListController alloc] init];
        vc.param = self.param;
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param removeAllObjects];
   
    //开始时间 结束时间精确到毫秒
    if ([self.lstTime.lblVal.text isEqualToString:@"自定义"]) {
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.lstStartDate.lblVal.text]/1000] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.lstEndDate.lblVal.text]/1000] forKey:@"endTime"];
    } else {
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.lstTime.lblVal.text]/1000] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.lstTime.lblVal.text]/1000] forKey:@"endTime"];
    }
    
    //操作类型：2 挂失  3 解挂 8 换卡 12 退卡
//    if ([self.action.lblVal.text isEqualToString:@"全部"]) {
//        [_param setValue:@(0) forKey:@"action"];
//    }else
        if ([self.action.lblVal.text isEqualToString:@"挂失"]){
        [_param setValue:@(2) forKey:@"action"];
    }else if ([self.action.lblVal.text isEqualToString:@"解挂"]){
        [_param setValue:@(3) forKey:@"action"];
    }else if ([self.action.lblVal.text isEqualToString:@"退卡"]){
        [_param setValue:@(12) forKey:@"action"];
    }else if ([self.action.lblVal.text isEqualToString:@"换卡"]){
        [_param setValue:@(8) forKey:@"action"];
    }
    
    //查询条件
    if ([NSString isNotBlank:self.keyWord.txtVal.text]) {
        [_param setValue:self.keyWord.txtVal.text forKey:@"keyWord"];
    }
//    else{
//        [_param setValue:@"" forKey:@"keyWord"];
//    }
    
    return _param;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
