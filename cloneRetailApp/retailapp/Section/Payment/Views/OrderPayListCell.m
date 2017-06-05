//
//  OrderPayListCell.m
//  RestApp
//
//  Created by 果汁 on 15/9/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#import "OrderPayListCell.h"
#import "NSString+Estimate.h"
#import "AlertImageView.h"
#import "ObjectUtil.h"

@interface OrderPayListCell ()
@end
@implementation OrderPayListCell

- (void)initWithData:(LSOnlineReceiptVo *)receiptVo payType:(NSString *)payType{
    
    self.orderId.delegate =  self;
    if ([ObjectUtil isNotNull:receiptVo.payName]) {
        self.payName.text=receiptVo.payName;
    } else {
        self.payName.text=@"无";
    }
   
    self.orderName.text = [NSString stringWithFormat:@"%@账单号:",payType];
    NSString *code = [NSString shortStringForOrderID:receiptVo.orderCode];
    if ([NSString isBlank:code]) {
        code = @"无";
    }
    NSString *innerCode = nil;
    
    NSString *mobile = [NSString stringWithFormat:@"手机号：%@",receiptVo.mobile];
    if ([receiptVo.payFor isEqualToString:@"pay_for_order"]) {//订单
        self.lblCharge.text = @"消费收入";
        innerCode = [NSString stringWithFormat:@"订单编号：%@",code];
        if ([NSString isBlank:receiptVo.mobile]) {
            self.mobile.text = @"手机号：无";
        } else {
            self.mobile.hidden = NO;
            self.mobile.text = mobile;
            
        }

    } else if ([receiptVo.payFor isEqualToString:@"pay_for_charge"]) {//充值
         self.lblCharge.text = @"充值收入";
        innerCode = [NSString stringWithFormat:@"充值流水号：%@",code];
        if ([ObjectUtil isNotNull:receiptVo.channelType]) {
            if (receiptVo.channelType.intValue == 2) {
                 self.mobile.text = @"充值方式：微店充值";
            } else {
                 self.mobile.text = @"充值方式：实体充值";
            }
        }
       
    } else {
        self.lblCharge.text = @"消费收入";
        innerCode = [NSString stringWithFormat:@"订单编号：%@",code];
        if ([NSString isBlank:receiptVo.mobile]) {
            self.mobile.text = @"手机号：无";
        } else {
            self.mobile.hidden = NO;
            self.mobile.text = mobile;
        }
        

    }
    
    self.innerCode.text =  innerCode;
    NSTimeInterval time =receiptVo.payTime/1000.0;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    currentDateStr = [NSString stringWithFormat:@"时间：%@",currentDateStr];
    self.payTime.text =currentDateStr;
    self.intoCountMoney.text= [NSString stringWithFormat:@"＋¥%.2f",receiptVo.payWx];
    self.intoCountMoney.textColor = [ColorHelper getRedColor];
    NSString *weixinPayNo = [NSString stringWithFormat:@"%@",receiptVo.weixinPayNo];
    self.orderId.text =weixinPayNo;
    self.orIntoMyCount.text= receiptVo.statusMsg;
    if ([receiptVo.statusMsg isEqualToString:@"未到账"]) {
        self.orIntoMyCount.textColor=[ColorHelper getRedColor];
    } else {//已到账 已划帐
        self.orIntoMyCount.textColor = [ColorHelper getGreenColor];
    }
    
    
}


-(void)copyEventFininshed{
 
    AlertTextView * alertView = [[AlertTextView alloc]initWithContent:[NSString stringWithFormat: @"%@已经复制，可以粘贴使用", [self.orderName.text substringToIndex:self.orderName.text.length-1]] location:[UIApplication sharedApplication].keyWindow.center];
    [alertView setBackColor:[UIColor blackColor] alpha:0.7  textColor:[UIColor whiteColor]];
    [alertView setViewSizeFont:nil label:220];
    [alertView showAlertView];
    [alertView dismissAfterTimeInterval:4.0f alertFinish:nil];

 }
@end
