//
//  WeChatOrderSelectView.m
//  retailapp
//
//  Created by guozhi on 16/3/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_ORDER_STATUS 1
#define TAG_LST_ORDER_DATE 2
#import "WeChatOrderSelectView.h"
#import "EditItemList.h"
#import "UIHelper.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "DateUtils.h"
#import "DatePickerBox.h"
#import "AlertBox.h"
@implementation WeChatOrderSelectView
- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"WeChatOrderSelectView" owner:self options:nil];
    [self addSubview:self.control];
    if (self.tag == 1) {//订单管理列表筛选
         [self initMainView1];
    } else if (self.tag == 2) {//积分兑换列表筛选
        [self initMainView2];
    }
   
}

- (void)initMainView1 {
    [self.lstOrderStatus initLabel:@"订单状态" withHit:nil delegate:self];
    [self.lstOrderDate initLabel:@"订单日期" withHit:nil delegate:self];
    
    self.lstOrderStatus.tag = TAG_LST_ORDER_STATUS;
    self.lstOrderDate.tag = TAG_LST_ORDER_DATE;
    
    //连锁模式总部用户登录时，默认“待分配”单店没有待分配
    if ([[Platform Instance] isTopOrg]) {
        [self.lstOrderStatus initData:@"待分配" withVal:@"13"];
    }
    //连锁模式非总部机构用户、门店用户登录时，默认“全部”
    if ([[Platform Instance] getShopMode] !=1 && ![[Platform Instance] isTopOrg]) {
       [self.lstOrderStatus initData:@"全部" withVal:nil];
    }
    // 单店模式默认“待处理”
    if ([[Platform Instance] getShopMode] == 1) {
        [self.lstOrderStatus initData:@"待处理" withVal:@"15"];
    }
    [self.lstOrderDate initData:@"请选择" withVal:nil];
    
    [UIHelper refreshUI:self.bgView];
}

- (void)initMainView2 {
    [self.lstOrderStatus initLabel:@"状态" withHit:nil delegate:self];
    [self.lstOrderDate initLabel:@"订单日期" withHit:nil delegate:self];
    self.lstOrderStatus.tag = TAG_LST_ORDER_STATUS;
    self.lstOrderDate.tag = TAG_LST_ORDER_DATE;
    [self.lstOrderStatus initData:@"待处理" withVal:@"15"];
    [self.lstOrderDate initData:@"请选择" withVal:nil];
    [UIHelper refreshUI:self.bgView];

}

- (void)onItemListClick:(EditItemList *)obj {
     if (obj == self.lstOrderStatus) {
        NSMutableArray *nameItems = [[NSMutableArray alloc] init];
        NameItemVO *nameItemVo = [[NameItemVO alloc] initWithVal:@"全部" andId:nil];
        [nameItems addObject:nameItemVo];
        if (self.tag == 1) {//订单管理筛选页面
            if ([[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"]) {//总部用户
                nameItemVo = [[NameItemVO alloc] initWithVal:@"待付款" andId:@"11"];
                [nameItems addObject:nameItemVo];
            }
            if ([[Platform Instance] isTopOrg]) {//连锁总部才有待分配
                nameItemVo = [[NameItemVO alloc] initWithVal:@"待分配" andId:@"13"];
                [nameItems addObject:nameItemVo];
            }
            nameItemVo = [[NameItemVO alloc] initWithVal:@"待处理" andId:@"15"];
            [nameItems addObject:nameItemVo];
            nameItemVo = [[NameItemVO alloc] initWithVal:@"配送中" andId:@"20"];
            [nameItems addObject:nameItemVo];
            nameItemVo = [[NameItemVO alloc] initWithVal:@"配送完成" andId:@"24"];
            [nameItems addObject:nameItemVo];
            nameItemVo = [[NameItemVO alloc] initWithVal:@"交易成功" andId:@"21"];
            [nameItems addObject:nameItemVo];
            nameItemVo = [[NameItemVO alloc] initWithVal:@"拒绝配送" andId:@"16"];
            [nameItems addObject:nameItemVo];
            if ([[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"]) {//总部用户
                nameItemVo = [[NameItemVO alloc] initWithVal:@"交易取消" andId:@"22"];
                [nameItems addObject:nameItemVo];
            }
            nameItemVo = [[NameItemVO alloc] initWithVal:@"交易关闭" andId:@"23"];
            [nameItems addObject:nameItemVo];

        } else if (self.tag == 2) {//积分兑换管理筛选页面
            nameItemVo = [[NameItemVO alloc] initWithVal:@"待处理" andId:@"15"];
            [nameItems addObject:nameItemVo];
            nameItemVo = [[NameItemVO alloc] initWithVal:@"配送中" andId:@"20"];
            [nameItems addObject:nameItemVo];
            nameItemVo = [[NameItemVO alloc] initWithVal:@"交易成功" andId:@"21"];
            [nameItems addObject:nameItemVo];

        }
       
        [OptionPickerBox initData:nameItems itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        
    } else if (obj == self.lstOrderDate) {
        NSDate *date = [DateUtils parseDateTime4:self.lstOrderDate.currentVal];
        [DatePickerBox showClear:obj.lblName.text clearName:@"清空日期" date:date client:self event:(int)obj.tag];
    }

}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_ORDER_STATUS){
        //状态
        [self.lstOrderStatus initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    
    if ([DateUtils daysToNow:date]) {
        NSString* dateStr=[DateUtils formateDate2:date];
        [self.lstOrderDate initData:dateStr withVal:dateStr];
    }
    return YES;
}

- (void)clearDate:(NSInteger)eventType {
    [self.lstOrderDate initData:@"请选择" withVal:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(showClearEvent)]) {
        [self.delegate showClearEvent];
    }
}

- (IBAction)controlClick:(id)sender {
    self.hidden = YES;
}

- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        //重置
        if (self.tag == 1) {
             [self initMainView1];
        } else if (self.tag == 2) {
            [self initMainView2];
        }
        if(self.delegate && [self.delegate respondsToSelector:@selector(showResetEvent)]) {
            [self.delegate showResetEvent];
        }
    } else {
        //完成
        self.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(showFinishEvent)]) {
            [self.delegate showFinishEvent];
        }
    }
}


@end
