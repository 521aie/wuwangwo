//
//  MemberTransactionListCell.m
//  retailapp
//
//  Created by 果汁 on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberListCell.h"
#import "MemberTransactionListVo.h"
#import "DateUtils.h"
#import "ColorHelper.h"
#import "MemberRechargeListVo.h"
#import "MemberIntegralListVo.h"
#import "UIView+Sizes.h"
#import "LSOrderReportVo.h"
#import "StockChangeLogVo.h"
#import "NSString+Estimate.h"
#import "ColorHelper.h"
#import "ObjectUtil.h"


@implementation MemberListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblName.text = @"";
    self.lblCost.text = @"";
    self.lblGood.text = @"";
    self.lblTime.text = @"";
}

- (void)prepareForReuse {
    self.lblName.text = @"";
    self.lblCost.text = @"";
    self.lblGood.text = @"";
    self.lblTime.text = @"";
}

#pragma mark - 会员消费信息cell
- (void)initDataWithMemberTransactionListVo:(MemberTransactionListVo *)memberTransactionListVo {
   
    // 会员名
    NSString *custerName = memberTransactionListVo.customerName?:@"无名氏";
    if (custerName.length > 4) {
        custerName = [custerName substringToIndex:4];
        custerName = [custerName stringByAppendingString:@"..."];
    }
    
    // 会员卡类型名称， 多余5个字符以省略号结尾
    NSString *cardTypeName = memberTransactionListVo.kindCardName ?:@"";
    if (cardTypeName.length > 5) {
        cardTypeName = [cardTypeName substringToIndex:5];
        cardTypeName = [cardTypeName stringByAppendingString:@"..."];
    }
    
    // 会员卡号, 多余10字符以省略号结尾
    NSString *cardNum = memberTransactionListVo.cardCode?:@"";
    if (cardNum.length > 10) {
        cardNum = [cardNum substringToIndex:10];
        cardNum = [cardNum stringByAppendingString:@"..."];
    }
    
    // 有全为空的情况，操蛋
    if ([NSString isNotBlank:cardTypeName] || [NSString isNotBlank:cardNum]) {
        self.lblName.text = [NSString stringWithFormat:@"%@(%@ %@)",custerName ,cardTypeName ,cardNum];
    } else {
        self.lblName.text = custerName;
    }
    [self.lblName sizeToFit];
    
    double cost = fabs([memberTransactionListVo.cost doubleValue]);
    if (memberTransactionListVo.orderKind.intValue == 1) {//销售单
        self.lblTitle.text = @"合计:";
        self.lblCost.text = [NSString stringWithFormat:@"￥%.2f",cost];
        self.lblCost.textColor = [ColorHelper getRedColor];
//<<<<<<< HEAD
    }
    else {
//=======
//    }else {//退货单
//>>>>>>> dev
        self.lblTitle.text = @"合计:";
        self.lblCost.text = [NSString stringWithFormat:@"-￥%.2f", cost];
        self.lblCost.textColor = [ColorHelper getGreenColor];
    }
    [self.lblTitle sizeToFit];
    self.lblCost.ls_left = self.lblTitle.ls_right + 2;
    self.lblTime.text = [DateUtils formateTime4:memberTransactionListVo.createTime.longLongValue];
    if ([memberTransactionListVo.outType isEqualToString:@"weixin"]) {//微信订单
        self.imgStatus.image = [UIImage imageNamed:@"weixin"];
        self.imgStatus.hidden = NO;
    } else if ([memberTransactionListVo.outType isEqualToString:@"weiPlatform"]) {//微平台订单
        self.imgStatus.image = [UIImage imageNamed:@"weiplatform"];
        self.imgStatus.hidden = NO;
    } else {//实体订单
         self.imgStatus.hidden = YES;
    }
}

#pragma mark - 会员充值记录cell
- (void)initDataWithMemberRechargeListVo:(MemberRechargeListVo *)memberRechargeListVo {
   
    NSString *custerName = memberRechargeListVo.customerName?:@"无名氏";
    if (custerName.length > 4) {
        custerName = [custerName substringToIndex:4];
        custerName = [custerName stringByAppendingString:@"..."];
    }
    
    // 会员卡类型名称， 多余5个字符以省略号结尾
    NSString *cardTypeName = memberRechargeListVo.kindCardName ?:@"";
    if (cardTypeName.length > 5) {
        cardTypeName = [cardTypeName substringToIndex:5];
        cardTypeName = [cardTypeName stringByAppendingString:@"..."];
    }
    
    // 会员卡号, 多余10字符以省略号结尾
    NSString *cardNum = memberRechargeListVo.cardCode;
    if (cardNum.length > 10) {
        cardNum = [cardNum substringToIndex:10];
        cardNum = [cardNum stringByAppendingString:@"..."];
    }
    
    if ([NSString isNotBlank:cardTypeName] || [NSString isNotBlank:cardNum]) {
        self.lblName.text = [NSString stringWithFormat:@"%@(%@ %@)",custerName,cardTypeName,cardNum];
    } else {
        self.lblName.text = custerName;
    }
    
    [self.lblName sizeToFit];
    self.lblTitle.text = @"合计:";
    [self.lblTitle sizeToFit];
    self.lblCost.ls_left = self.lblTitle.ls_right + 2;
    if ([memberRechargeListVo.action isEqualToString:@"红冲"] || [memberRechargeListVo.action isEqualToString:@"退卡"]) {
        self.lblCost.text = [NSString stringWithFormat:@"￥-%.2f",fabs([memberRechargeListVo.payMoney doubleValue])];
        self.lblCost.textColor = [ColorHelper getGreenColor];
    }
    else if (memberRechargeListVo.status && [memberRechargeListVo.status intValue] == 0){
        self.lblCost.text = [NSString stringWithFormat:@"￥%.2f(已红冲)",[memberRechargeListVo.payMoney doubleValue]];
        self.lblCost.textColor = [ColorHelper getRedColor];
    }
    else {
        self.lblCost.text = [NSString stringWithFormat:@"￥%.2f",[memberRechargeListVo.payMoney doubleValue]];
        self.lblCost.textColor = [UIColor darkGrayColor];
    
    }
    
    [self.lblCost sizeToFit];
    self.lblTitle.ls_top = self.lblCost.ls_top;
    self.lblTime.text = [DateUtils getTimeStringFromCreaateTime:memberRechargeListVo.moneyFlowCreatetime.stringValue format:@"yyyy-MM-dd HH:mm:ss"];
    if ([memberRechargeListVo.payType isEqualToString:@"微店充值"]) {
        self.imgStatus.image = [UIImage imageNamed:@"weixin_charge"];
        self.imgStatus.hidden = NO;
    }
    else {
         self.imgStatus.hidden = YES;
    }
}

// 积分兑换商品
- (void)initDataWithMemberIntegralListVo:(MemberIntegralListVo *)memberIntegralListVo {
    NSString *custerName = memberIntegralListVo.customername;
    if (custerName.length > 4) {
        custerName = [custerName substringToIndex:4];
        custerName = [custerName stringByAppendingString:@"..."];
    }
    
    // 会员卡类型名称， 多余5个字以省略号结尾
    NSString *cardTypeName = memberIntegralListVo.kindCardName;
    if (cardTypeName.length > 5) {
        cardTypeName = [cardTypeName substringToIndex:5];
        cardTypeName = [cardTypeName stringByAppendingString:@"..."];
    }
    
    // 会员卡号, 多余5字符以省略号结尾
    NSString *cardNum = memberIntegralListVo.cardCode;
    if (cardNum.length > 10) {
        cardNum = [cardNum substringToIndex:10];
        cardNum = [cardNum stringByAppendingString:@"..."];
    }

    self.lblGood.hidden = NO;
    self.lblGood.text = [NSString stringWithFormat:@"兑换商品:%@",memberIntegralListVo.name];
    self.lblName.text = [NSString stringWithFormat:@"%@(%@ %@)",custerName,cardTypeName,cardNum];
    self.lblTime.text = [DateUtils getTimeStringFromCreaateTime:memberIntegralListVo.createtime.stringValue format:@"yyyy-MM-dd HH:mm:ss"];
    self.lblTitle.text = @"积分:";
    [self.lblTitle sizeToFit];
    self.lblCost.text = [NSString stringWithFormat:@"%d",[memberIntegralListVo.totalpoint  intValue]];
    [self.lblCost sizeToFit];
    self.lblCost.ls_left = self.lblTitle.ls_right + 2;
    
    if ([memberIntegralListVo.exchangetype isEqualToString:@"微店兑换"]) {
        self.imgStatus.image = [UIImage imageNamed:@"weixin_duihuan"];
        self.imgStatus.hidden = NO;
    }
    else {
        self.imgStatus.hidden = YES;
    }
}


//=====================================以下是报表部分================================================

//- (void)initDataWithOrderReportVo:(OrderReportVo *)orderReportVo{
//    NSString *waternumber = orderReportVo.waternumber;
//    if ([self isOrder:waternumber]) {
//        self.lblCost.textColor = [ColorHelper getRedColor];
//    } else {
//        self.lblCost.textColor = [ColorHelper getGreenColor];
//    }
//
//     self.lblName.text = [NSString shortStringForOrderID:waternumber];
//    self.lblTitle.text = @"合计:";
//    [self.lblTitle sizeToFit];
//    
//    self.lblCost.ls_left = self.lblTitle.ls_right + 2;
//    double cost = [orderReportVo.totalmoney doubleValue];
//    self.lblCost.text = [NSString stringWithFormat:@"￥%.2f" ,cost];
//    
//    BOOL isOrder = [self isOrder:orderReportVo.waternumber];
//    if (isOrder) {
//        self.lblCost.textColor = [ColorHelper getRedColor];
//    }else{
//        self.lblCost.textColor = [ColorHelper getGreenColor];
//        if (cost == 0) {
//            self.lblCost.text = @"￥-0.00";
//        }
//    }
//    
//    [self.lblCost sizeToFit];
//    
//    
//    
//    self.lblTime.text = orderReportVo.salesTime;
//    
//    if ([orderReportVo.outType isEqualToString:@"weixin"]) {//微信订单
//        self.imgStatus.image = [UIImage imageNamed:@"weixin"];
//        self.imgStatus.hidden = NO;
//    } else if ([orderReportVo.outType isEqualToString:@"weiPlatform"]) {//微平台订单
//        self.imgStatus.image = [UIImage imageNamed:@"weiplatform"];
//        self.imgStatus.hidden = NO;
//    } else {//实体订单
//        self.imgStatus.hidden = YES;
//    }
//}


//根据流水号判断是订货单还是退货单
- (BOOL)isOrder:(NSString *)waterNumber{
    NSString *begin = [waterNumber substringToIndex:1];
    NSString *beginThree = [waterNumber substringToIndex:3];
    if ([begin isEqualToString:@"2"] || [beginThree isEqualToString:@"RBW"]) {
        return NO;//退货单
    }else{
        return YES;//订货单
    }
}

/**商品供货明细表*/
- (void)initDataWithGoodsSupplyList:(NSDictionary *)obj {
    if ([ObjectUtil isNull:obj]) {
        return;
    }
     self.lblName.text = [obj objectForKey:@"supplyGoodsNo"];//供货单号
    self.lblTitle.text = @"合计:";
    [self.lblTitle sizeToFit];
    self.lblCost.ls_left = self.lblTitle.ls_right + 2;
    float totalPrice = [[obj objectForKey:@"totalPrice"] doubleValue];
    self.lblCost.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
    self.lblCost.textColor = [ColorHelper getRedColor];
    [self.lblCost sizeToFit];
//    long long time = [[obj objectForKey:@"opTime"] longLongValue];
//    self.lblTime.text = [DateUtils formateTime4:time];
    self.lblTime.text = [DateUtils getTimeStringFromCreaateTime:[obj objectForKey:@"opTime"]  format:@"yyyy-MM-dd HH:mm:ss"];
    self.imgStatus.hidden = YES;
}

@end
