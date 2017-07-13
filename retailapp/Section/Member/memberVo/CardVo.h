//
//  CardVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface CardVo : Jastor

//会员卡Id
@property (nonatomic, strong) NSString *cardId;

//会员卡类型ID
@property (nonatomic, strong) NSString *kindCardId;

//会员卡号
@property (nonatomic, strong) NSString *code;

//会员卡类型名称
@property (nonatomic, strong) NSString *kindCardName;

//开卡门店ID
@property (nonatomic, strong) NSString *cardshopid;

//开卡门店
@property (nonatomic, strong) NSString *cardshopname;

//余额
@property (nonatomic) double balance;

//累计消费
@property (nonatomic)  double consumeAmount;

//积分
@property (nonatomic) NSInteger point;

//累积积分
@property (nonatomic) NSInteger degreeAmount;

//赠送积分
@property (nonatomic) double giftBalance;

//折扣率
@property (nonatomic) double ratio;

//办卡日期
@property (nonatomic) long long activeDate;

//卡状态
@property (nonatomic, strong) NSString *status;

//预充值额消费是否积分
@property (nonatomic) short isPrefeeDegree;

//刷卡打折消费是否积分
@property (nonatomic) short isRatiofeeDegree;

//预充值消费兑换1积分所需消费额
@property (nonatomic) double exchangeDegree;

//刷卡打折消费兑换1积分所需消费额
@property (nonatomic) double ratioExchangeDegree;

//版本号
@property (nonatomic) long lastVer;

+ (CardVo*)convertToCard:(NSDictionary*)dic;
+ (NSDictionary*)getDictionaryData:(CardVo*)cardVo;

@end
