//
//  CustomerCardVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameValueItem.h"
#import "GoodsGiftVo.h"

@interface CustomerCardVo : Jastor

//会员ID
@property (nonatomic, strong) NSString *customerId;

//会员名
@property (nonatomic, strong) NSString *customerName;

//性别
@property (nonatomic, strong) NSString *sex;

//卡ID
@property (nonatomic, strong) NSString *cardId;

//卡号
@property (nonatomic, strong) NSString *cardCode;

//卡状态
@property (nonatomic, strong) NSString *cardStatus;

//卡类型名称
@property (nonatomic, strong) NSString *kindCardName;

//手机
@property (nonatomic, strong) NSString *mobile;

//积分
@property (nonatomic) int degree;

//余额
@property (nonatomic) double balance;

//版本号
@property (nonatomic) long lastVer;

//图片
@property (nonatomic, strong) NSString *picture;

//密码
@property (nonatomic, strong) NSString *pwd;

//密码
@property (nonatomic, strong) GoodsGiftVo *goodsGiftVo;

@end
