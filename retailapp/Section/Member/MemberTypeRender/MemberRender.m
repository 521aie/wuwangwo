//
//  MemberTypeRender.m
//  RestApp
//
//  Created by zhangzhiliang on 15/6/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberRender.h"
#import "NameItemVO.h"
//#import "MemberTypeVo.h"
//#import "CardSummarizingVo.h"
//#import "KindCardVo.h"
#import "SaleRechargeVo.h"
#import "PaymentVo.h"

@implementation MemberRender

+(NSMutableArray*) listType
{
    NSMutableArray *vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"使用折扣率" andId:@"3"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"使用会员价" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"使用批发价" andId:@"8"];
    [vos addObject:item];
    
    return vos;
    
}


//+(NSMutableArray*) listKindCardName:(NSMutableArray*) kindCardNameList
//{
//    NSMutableArray* vos=[NSMutableArray array];
//    NameItemVO *item= [[NameItemVO alloc] initWithVal:@"全部" andId:@""];
//    [vos addObject:item];
//    if (kindCardNameList.count > 0) {
//        for (KindCardVo* vo in kindCardNameList) {
//            item=[[NameItemVO alloc] initWithVal:vo.kindCardName andId:vo.kindCardId];
//            [vos addObject:item];
//        }
//    }
//    
//    return vos;
//}

//+(NSMutableArray*) listKindCardName2:(NSMutableArray*) kindCardNameList
//{
//    NSMutableArray* vos=[NSMutableArray array];
//    NameItemVO *item= nil;
//    if (kindCardNameList.count > 0) {
//        for (KindCardVo* vo in kindCardNameList) {
//            item=[[NameItemVO alloc] initWithVal:vo.kindCardName andId:vo.kindCardId];
//            [vos addObject:item];
//        }
//    }
//    
//    return vos;
//}

//+(NSMutableArray*) listKindCard:(NSMutableArray*) kindCardList
//{
//    NSMutableArray* vos=[NSMutableArray array];
//    NameItemVO *item= nil;
//    if (kindCardList.count > 0) {
//        for (KindCardVo* vo in kindCardList) {
//            item=[[NameItemVO alloc] initWithVal:vo.kindCardName andId:vo.kindCardId];
//            [vos addObject:item];
//        }
//    }
//    
//    return vos;
//}

+(NSMutableArray*) listActiveTime
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item= [[NameItemVO alloc] initWithVal:@"全部" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"今天" andId:@"2"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"昨天" andId:@"3"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"最近三天" andId:@"4"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"本周" andId:@"5"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"本月" andId:@"6"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"自定义" andId:@"7"];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listActiveWay
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item= [[NameItemVO alloc] initWithVal:@"全部" andId:@""];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"微店开卡" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"实体开卡" andId:@"2"];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listCardStatus
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item= [[NameItemVO alloc] initWithVal:@"全部" andId:@""];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"正常" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"挂失" andId:@"2"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"注销" andId:@"3"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"异常" andId:@"4"];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listCardStatus2
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"正常" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"挂失" andId:@"2"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"注销" andId:@"3"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"异常" andId:@"4"];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listSex
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"男" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"女" andId:@"2"];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listBirthdayTime{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item= [[NameItemVO alloc] initWithVal:@"全部" andId:@""];
    [vos addObject:item];
    for (int count = 0; count < 31; count ++) {
        item=[[NameItemVO alloc] initWithVal:[NSString stringWithFormat:@"%d", count] andId:[NSString stringWithFormat:@"%d", count]];
        [vos addObject:item];
    }
    return vos;
}

+(NSMutableArray*) listSaleRecharge:(NSMutableArray*) saleRechargeList
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item= nil;
    if (saleRechargeList.count > 0) {
        for (SaleRechargeVo* vo in saleRechargeList) {
            item=[[NameItemVO alloc] initWithVal:vo.name andId:vo.saleRechargeId];
            [vos addObject:item];
        }
    }
    
    return vos;
}

+(NSMutableArray*) listPayMode
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"会员卡" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"优惠券" andId:@"2"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"支付宝" andId:@"3"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"银行卡" andId:@"4"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"现金" andId:@"5"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"微支付" andId:@"6"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"其他" andId:@"99"];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listPayMode:(NSMutableArray*) salePayModeList
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item= nil;
    if (salePayModeList.count > 0) {
        for (PaymentVo* vo in salePayModeList) {
            if (![vo.payTyleName isEqualToString:@"会员卡"] && ![vo.payTyleName isEqualToString:@"优惠券"] && ![vo.payTyleName isEqualToString:@"商圈卡"] && ![vo.payTyleVal isEqualToString:Alipay] && ![vo.payTyleVal isEqualToString:Wxpay]) {
                item=[[NameItemVO alloc] initWithVal:vo.payMentName andId:vo.payTyleVal];
                [vos addObject:item];
            }
        }
    }
    
    return vos;
}

+(NSMutableArray*) listRechargeType
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"实体充值" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"微信充值" andId:@"2"];
    [vos addObject:item];
    
    return vos;
}

+(NSString*) obtainRechargeType:(NSString*)rechargeType
{
    NSMutableArray *list = [self listRechargeType];
    for (NameItemVO *vo in list) {
        if ([[vo obtainItemId] isEqualToString:rechargeType]) {
            return [vo obtainItemName];
        }
    }
    return nil;
}

+(NSString*) obtainPayMode:(NSString*)payMode salePayModeList:(NSMutableArray*) salePayModeList
{
    NSMutableArray *list = [self listPayMode:salePayModeList];
    for (NameItemVO *vo in list) {
        if ([[vo obtainItemId] isEqualToString:payMode]) {
            return [vo obtainItemName];
        }
    }
    return nil;
}

//+(NSString*) obtainKindCard:(NSString*)kindCardName kindCardList:(NSMutableArray*) kindCardList
//{
//    NSMutableArray *list = [self listKindCardName:kindCardList];
//    for (NameItemVO *vo in list) {
//        if ([[vo obtainItemName] isEqualToString:kindCardName]) {
//            return [vo obtainItemId];
//        }
//    }
//    return nil;
//}

//+(NSString*) obtainKindCardName:(NSString*)kindCardId kindCardList:(NSMutableArray*) kindCardList
//{
//    NSMutableArray *list = [self listKindCardName:kindCardList];
//    for (NameItemVO *vo in list) {
//        if ([[vo obtainItemId] isEqualToString:kindCardId]) {
//            return [vo obtainItemName];
//        }
//    }
//    return nil;
//}

+(NSString*) obtainCardStatus:(NSString*)kindCardStatus
{
    NSMutableArray *list = [self listCardStatus];
    for (NameItemVO *vo in list) {
        if ([[vo obtainItemId] isEqualToString:kindCardStatus]) {
            return [vo obtainItemName];
        }
    }
    return nil;
}

+(NSString*) obtainActiveTime:(NSString*)activeTime
{
    NSMutableArray *list = [self listActiveTime];
    for (NameItemVO *vo in list) {
        if ([[vo obtainItemId] isEqualToString:activeTime]) {
            return [vo obtainItemName];
        }
    }
    return nil;
}

+(NSString*) obtainActiveWay:(NSString*)activeWay
{
    NSMutableArray *list = [self listActiveWay];
    for (NameItemVO *vo in list) {
        if ([[vo obtainItemId] isEqualToString:activeWay]) {
            return [vo obtainItemName];
        }
    }
    return nil;
}

+(NSString*) obtainSex:(int)sex
{
    NSMutableArray *list = [self listSex];
    for (NameItemVO *vo in list) {
        if ([[vo obtainItemId] isEqualToString:[NSString stringWithFormat:@"%d", sex]]) {
            return [vo obtainItemName];
        }
    }
    return nil;
}

+(NSString*) obtainPriceScheme:(NSInteger)priceSchemeId
{
    NSMutableArray *list = [self listType];
    for (NameItemVO *vo in list) {
        if ([vo obtainItemId].intValue == priceSchemeId) {
            return [vo obtainItemName];
        }
    }
    return nil;
}

@end
