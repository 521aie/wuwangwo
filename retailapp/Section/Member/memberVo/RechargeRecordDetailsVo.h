//
//  RechargeRecordDetailsVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface RechargeRecordDetailsVo : Jastor

//会员卡号
@property (nonatomic, strong) NSString *cardCode;

//会员名
@property (nonatomic, strong) NSString *customerName;

//手机号
@property (nonatomic, strong) NSString *mobile;

//充值金额
@property (nonatomic) double payMoney;

//赠送金额
@property (nonatomic) double giftMoney;

//充值后余额
@property (nonatomic) double balance;

//充值时间
@property (nonatomic) long long moneyFlowCreatetime;

//赠送积分
@property (nonatomic) NSInteger giftIntegral;

//收银员姓名
@property (nonatomic, strong) NSString *staffName;

//收银员编号
@property (nonatomic, strong) NSString *staffId;

//支付方式
@property (nonatomic) NSInteger payMode;

//支付方式名称
@property (nonatomic, strong) NSString *payModeName;

//操作类型
@property (nonatomic) NSInteger action;

//充值门店
@property (nonatomic, strong) NSString *shopName;

//充值方式
@property (nonatomic) NSInteger payType;

//会员卡版本号
@property (nonatomic) NSInteger lastVer;

+ (RechargeRecordDetailsVo*)convertToRechargeRecordDetailsVo:(NSDictionary*)dic;

@end
