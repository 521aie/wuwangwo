//
//  OrderListCell.m
//  retailapp
//
//  Created by yumingdong on 15/10/18.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderListCell.h"
#import "ColorHelper.h"
#import "DateUtils.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"

@implementation OrderListCell


- (void)initDate:(OrderInfoVo *)orderInfo {
    
    
    NSString *name = orderInfo.customerName;
    NSString *mobile = orderInfo.customerMobile;
    name = [NSString text:name subToIndex:8];
    
    NSString *nameStr = [NSString stringWithFormat:@"%@  %@", name, mobile];
    
    NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithString:nameStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(name.length, mobile.length+2)];
    self.lblName.attributedText = attr;
    CGSize nameSize = [NSString sizeWithText:name maxSize:CGSizeMake(MAXFLOAT, 100) font:[UIFont systemFontOfSize:15]];
    CGSize mobileSize = [NSString sizeWithText:mobile maxSize:CGSizeMake(MAXFLOAT, 100) font:[UIFont systemFontOfSize:13]];
    CGFloat w = nameSize.width + mobileSize.width+11;
    self.lblName.ls_width = w;
    
    
    if ([orderInfo.outType isEqualToString:@"weixin"]) {//微信订单
        //        self.imgState.image = [UIImage imageNamed:@"weixin"];
        self.imgState.hidden = YES;
    } else if ([orderInfo.outType isEqualToString:@"weiPlatform"]) {//微平台订单
        self.imgState.image = [UIImage imageNamed:@"weiplatform"];
        self.imgState.hidden = NO;
    } else {//实体订单
        self.imgState.hidden = YES;
    }
    self.imgState.ls_left = self.lblName.ls_right;
    
    
    
    //订单状态 status
    self.lblStatus.text = [self getStatusString:orderInfo.status];
    if (orderInfo.status == 16) {
        self.lblStatus.textColor = [ColorHelper getRedColor];
    } else if (orderInfo.status == 22 || orderInfo.status == 23) {
        self.lblStatus.textColor = [ColorHelper getTipColor6];
    } else if ( orderInfo.status == 21 || orderInfo.status == 24) {
        self.lblStatus.textColor = [ColorHelper getGreenColor];
    } else {
        self.lblStatus.textColor = [ColorHelper getBlueColor];
    }
    
    // 订单编号
    
//    if([NSString isBlank:orderInfo.divideCode]){
//        self.lblOrderId.text = [orderInfo.code substringFromIndex:3];
//    }else{
//        if ([orderInfo.divideCode hasPrefix:@"ROW"]) {
//            self.lblOrderId.text = [orderInfo.divideCode substringFromIndex:3];
//        } else {
//            self.lblOrderId.text = orderInfo.divideCode;
//        }
//    }
    
    if ([orderInfo.code hasPrefix:@"ROW"]) {
        self.lblOrderId.text = [orderInfo.code substringFromIndex:3];
    } else {
        self.lblOrderId.text = orderInfo.code;
    }
    
    //下单时间
    self.lblTime.text = [DateUtils formateTime:orderInfo.createTime];
}

- (NSString *)getStatusString:(short)status {
    //销售订单  状态:11待付款、12付款中、13待分配、15待处理、20配送中、21配送完成、16拒绝配送、22交易取消、23交易关闭
    //供货订单:15待处理、20配送中、21配送完成、16拒绝配送
    NSDictionary *statusDic = @{ @"11":@"待付款", @"12":@"付款中", @"13":@"待分配", @"15":@"待处理", @"16":@"拒绝配送", @"20":@"配送中", @"21":@"交易成功", @"22":@"交易取消", @"23":@"交易关闭",@"24":@"配送完成"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

//截取前几个字节
- (NSString *)getString:(NSString *)str subToIndex:(NSInteger)index {
    if ([NSString isNotBlank:str]) {
        NSString *subStr = nil;
        NSUInteger length = str.length;
        for (int i = 1; i<= length; i ++) {
            subStr = [str substringToIndex:i];
            NSLog(@"--->%lu",sizeof(subStr));
            if (sizeof(subStr)>index) {
                NSLog(@"--->%lu",sizeof(subStr));
                return subStr;
            }
            
        }
        return str;
    }
    return @"";
}

@end
