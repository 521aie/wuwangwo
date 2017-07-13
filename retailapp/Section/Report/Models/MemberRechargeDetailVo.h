//
//  MemberRechargeDetailVo.h
//  retailapp
//
//  Created by guozhi on 15/10/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberRechargeDetailVo : NSObject
@property (nonatomic, copy) NSString *customerName; //会员名
@property (nonatomic, copy) NSString *mobile; //会员手机
@property (nonatomic, copy) NSString *cardCode; //会员卡号
@property (nonatomic ,strong) NSString *kindCardName;/*<会员卡类型名>*/
@property (nonatomic, copy) NSString *staffId; //收银员编号
@property (nonatomic, copy) NSString *staffName; //收银员姓名
@property (nonatomic, copy) NSNumber *payMode; //支付方式
@property (nonatomic ,strong) NSString *payModeName;/*<支付方式 eg:现金>*/
@property (nonatomic, copy) NSString *action; //操作类型
@property (nonatomic, copy) NSString *shopName; //充值门店
@property (nonatomic, strong) NSNumber *payMoney; //充值金额 BigDecimal
@property (nonatomic, strong) NSNumber *giftMoney; //赠送金额 BigDecimal
@property (nonatomic, strong) NSNumber *balance; //充值后余额 BigDecimal
@property (nonatomic, strong) NSNumber *moneyFlowCreatetime; //充值时间 long
@property (nonatomic, strong) NSNumber *giftIntegral; //赠送积分 BigDecimal
@property (nonatomic, strong) NSString *payType; //充值方式 eg:实体充值
@property (nonatomic, strong) NSNumber *status;



- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
