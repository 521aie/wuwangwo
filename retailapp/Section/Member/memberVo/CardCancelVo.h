//
//  CardCancelVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface CardCancelVo : Jastor

//会员卡ID
@property (nonatomic, strong) NSString *cardId;

//会员卡号
@property (nonatomic, strong) NSString *code;

//会员名
@property (nonatomic, strong) NSString *customerName;

//手机号
@property (nonatomic, strong) NSString *mobile;

//会员卡类型名称
@property (nonatomic, strong) NSString *kindCardName;

//累计充值
@property (nonatomic) double realBalance;

//累计赠送
@property (nonatomic) double giftBalance;

//累计消费
@property (nonatomic) double consumeAmount;

//余额
@property (nonatomic) double balance;

//积分
@property (nonatomic) NSInteger degreeAmount;

//版本号
@property (nonatomic) NSInteger lastVer;

@end
