//
//  OrderInfoVo.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderInfoVo.h"

@implementation OrderInfoVo

+ (OrderInfoVo*)converToVo:(NSDictionary*)dic
{
    OrderInfoVo *orderInfoVo = [[OrderInfoVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        orderInfoVo.orderId = [ObjectUtil getStringValue:dic key:@"id"];
        orderInfoVo.orignId = [ObjectUtil getStringValue:dic key:@"orignId"];
        orderInfoVo.memo = [ObjectUtil getStringValue:dic key:@"memo"];
        orderInfoVo.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        orderInfoVo.globalCode = [ObjectUtil getStringValue:dic key:@"globalCode"];
        orderInfoVo.outType = [ObjectUtil getStringValue:dic key:@"outType"];
        orderInfoVo.orderKind = [ObjectUtil getIntegerValue:dic key:@"orderKind"];
        orderInfoVo.code = [ObjectUtil getStringValue:dic key:@"code"];
        orderInfoVo.isDivide = [ObjectUtil getIntegerValue:dic key:@"isDivide"];
        orderInfoVo.divideId = [ObjectUtil getStringValue:dic key:@"divideId"];
//        orderInfoVo.divideCode = [ObjectUtil getStringValue:dic key:@"divideCode"];
        orderInfoVo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
        orderInfoVo.openTime = [ObjectUtil getLonglongValue:dic key:@"openTime"];
        orderInfoVo.endTime = [ObjectUtil getIntegerValue:dic key:@"endTime"];
        orderInfoVo.applyPayTime = [ObjectUtil getLonglongValue:dic key:@"applyPayTime"];
        orderInfoVo.payTime = [ObjectUtil getIntegerValue:dic key:@"payTime"];
        orderInfoVo.payDate = [ObjectUtil getLonglongValue:dic key:@"payDate"];
        orderInfoVo.cardId = [ObjectUtil getStringValue:dic key:@"cardId"];
        orderInfoVo.receiverName = [ObjectUtil getStringValue:dic key:@"receiverName"];
        orderInfoVo.mobile = [ObjectUtil getStringValue:dic key:@"mobile"];
        orderInfoVo.address = [ObjectUtil getStringValue:dic key:@"address"];
        orderInfoVo.payMode = [ObjectUtil getIntegerValue:dic key:@"payMode"];
        orderInfoVo.outFee = [ObjectUtil getDoubleValue:dic key:@"outFee"];
        orderInfoVo.distributionMod = [ObjectUtil getIntegerValue:dic key:@"distributionMod"];
        orderInfoVo.sourceAmount = [ObjectUtil getDoubleValue:dic key:@"sourceAmount"];
        orderInfoVo.discountAmount = [ObjectUtil getDoubleValue:dic key:@"discountAmount"];
        orderInfoVo.resultAmount = [ObjectUtil getDoubleValue:dic key:@"resultAmount"];
        orderInfoVo.recieveAmount = [ObjectUtil getDoubleValue:dic key:@"recieveAmount"];
        orderInfoVo.status = [ObjectUtil getIntegerValue:dic key:@"status"];
        orderInfoVo.rejReason = [ObjectUtil getStringValue:dic key:@"rejReason"];
        orderInfoVo.expansion = [ObjectUtil getStringValue:dic key:@"expansion"];
        orderInfoVo.createTime = [ObjectUtil getLonglongValue:dic key:@"createTime"];
        orderInfoVo.sendTime = [ObjectUtil getIntegerValue:dic key:@"sendTime"];
        orderInfoVo.sendTimeRange = [ObjectUtil getStringValue:dic key:@"sendTimeRange"];
        orderInfoVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        orderInfoVo.employeeId = [ObjectUtil getStringValue:dic key:@"employeeId"];
        orderInfoVo.divideExpansion = [ObjectUtil getStringValue:dic key:@"divideExpansion"];
//        orderInfoVo.divideShopId = [ObjectUtil getStringValue:dic key:@"divideShopId"];
//        orderInfoVo.divideCount = [ObjectUtil getIntegerValue:dic key:@"divideCount"];
//        orderInfoVo.divideLastVer = [ObjectUtil getIntegerValue:dic key:@"divideLastVer"];
//        orderInfoVo.divideCode = [ObjectUtil getStringValue:dic key:@"divideCode"];
        orderInfoVo.shopName = [ObjectUtil getStringValue:dic key:@"shopName"];
        orderInfoVo.isPickUpShopName = [ObjectUtil getStringValue:dic key:@"isPickUpShopName"];
        orderInfoVo.dealShopName = [ObjectUtil getStringValue:dic key:@"dealShopName"];
        orderInfoVo.dealShopId = [ObjectUtil getStringValue:dic key:@"dealShopId"];
        orderInfoVo.customerName = [ObjectUtil getStringValue:dic key:@"customerName"];
        orderInfoVo.customerMobile = [ObjectUtil getStringValue:dic key:@"customerMobile"];

        NSDictionary *dict = dic[@"orderDivideExpansion"];
        if ([ObjectUtil isNotNull:dict]) {
            if ([ObjectUtil isNotNull:dict[@"logisticsName"]]) {
                //物流公司
                orderInfoVo.logisticsName = dict[@"logisticsName"];

            }
            if ([ObjectUtil isNotNull:dict[@"logisticsNo"]]) {
                //物流单号
                orderInfoVo.logisticsNo = dict[@"logisticsNo"];
            }
            if ([ObjectUtil isNotNull:dict[@"sendMan"]]) {
                //配送员
                orderInfoVo.sendMan = dict[@"sendMan"];
            }
            if ([ObjectUtil isNotNull:dict[@"shopFreight"]]) {
                orderInfoVo.shopFreight = [dict[@"shopFreight"] doubleValue];
            }
        }
        dict = dic[@"orderInfoExpansion"];
        if ([ObjectUtil isNotNull:dict]) {
            if ([ObjectUtil isNotNull:dict[@"logisticsName"]]) {
                //物流公司
                orderInfoVo.logisticsName = dict[@"logisticsName"];
                
            }
            if ([ObjectUtil isNotNull:dict[@"logisticsNo"]]) {
                //物流单号
                orderInfoVo.logisticsNo = dict[@"logisticsNo"];
            }
            if ([ObjectUtil isNotNull:dict[@"sendMan"]]) {
                //配送员
                orderInfoVo.sendMan = dict[@"sendMan"];
            }
            if ([ObjectUtil isNotNull:dict[@"shopFreight"]]) {
                orderInfoVo.shopFreight = [dict[@"shopFreight"] doubleValue];
            }
            if ([ObjectUtil isNotNull:dict[@"reducePrice"]]) {
                orderInfoVo.reducePrice = [dict[@"reducePrice"] doubleValue];
            }
        }

        NSString *expansion = [dic objectForKey:@"expansion"];
        if ([NSString isNotBlank:expansion]) {
            NSData *data = [expansion dataUsingEncoding:NSUTF8StringEncoding];
            orderInfoVo.expansionDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
           
            orderInfoVo.salesInfo = [ObjectUtil getStringValue:orderInfoVo.expansionDic key:@"salesInfo"];
//            orderInfoVo.reducePrice = [ObjectUtil getDoubleValue:orderInfoVo.expansionDic key:@"reducePrice"];
            if ([[Platform Instance] getShopMode] == 1) {//单店取这个配送费
                orderInfoVo.shopFreight = [ObjectUtil getDoubleValue:orderInfoVo.expansionDic key:@"shop_freight"];
            }
            
            //营业手续费
            orderInfoVo.service_charge = [ObjectUtil getStringValue:orderInfoVo.expansionDic key:@"service_charge"];
            
            //消费积分
            orderInfoVo.consume_points = [ObjectUtil getStringValue:orderInfoVo.expansionDic key:@"consume_points"];
            
            //整单折扣
            orderInfoVo.whole_discount_fee = [ObjectUtil getStringValue:orderInfoVo.expansionDic key:@"whole_discount_fee"];
            
            //确认收货时间
            orderInfoVo.receiving_time = [ObjectUtil getStringValue:orderInfoVo.expansionDic key:@"receiving_time"];
            
            //是否货到付款
            orderInfoVo.is_cash_on_delivery = [ObjectUtil getStringValue:orderInfoVo.expansionDic key:@"is_cash_on_delivery"];
            
            
           
        }
    }
    
    return orderInfoVo;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    if ([ObjectUtil isEmpty:sourceList]) {
        return nil;
    }
    
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            OrderInfoVo* orderInfoVo = [OrderInfoVo converToVo:dic];
            [dataList addObject:orderInfoVo];
        }
    }
    return dataList;
}


@end
