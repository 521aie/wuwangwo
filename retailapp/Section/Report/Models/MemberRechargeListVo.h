//
//  MemberRechargeListVo.h
//  retailapp
//
//  Created by guozhi on 15/10/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberRechargeListVo : NSObject
@property (nonatomic, strong) NSString *orderId; //订单编号
@property (nonatomic, strong) NSString *customerName; //会员名
@property (nonatomic, strong) NSString *kindCardName;/*<会员卡类型名>*/
@property (nonatomic, strong) NSString *cardCode;/*<会员卡号>*/
@property (nonatomic, strong) NSString *mobile; //手机号码
@property (nonatomic, strong) NSString *action; //操作
@property (nonatomic, strong) NSString *payType; //充值类型
@property (nonatomic, strong) NSString *payMode; //支付方式
@property (nonatomic, strong) NSNumber *payMoney; //充值金额
@property (nonatomic, strong) NSNumber *moneyFlowCreatetime; //充值时间
@property (nonatomic, strong) NSNumber *status;
- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
