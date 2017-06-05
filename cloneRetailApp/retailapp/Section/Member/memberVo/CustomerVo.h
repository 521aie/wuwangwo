//
//  CustomerVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameValueItem.h"
#import "CardVo.h"

@interface CustomerVo : Jastor

//会员ID
@property (nonatomic, strong) NSString *customerId;

//会员名
@property (nonatomic, strong) NSString *name;

//性别
@property (nonatomic) NSInteger sex;

//手机号
@property (nonatomic, strong) NSString *mobile;

//身份证号
@property (nonatomic, strong) NSString *certificate;

//生日
@property (nonatomic, strong) NSNumber *birthday;

//微信
@property (nonatomic, strong) NSString *weixin;

//地址
@property (nonatomic, strong) NSString *address;

//邮箱
@property (nonatomic, strong) NSString *email;

//邮编
@property (nonatomic, strong) NSString *zipcode;

//职业
@property (nonatomic, strong) NSString *job;

//备注
@property (nonatomic, strong) NSString *memo;

//版本号
@property (nonatomic) long lastVer;

// 文件名
@property (nonatomic,retain) NSString *fileName;

// 文件操作类型
@property (nonatomic) short fileOperate;

// 文件二维数组
@property (nonatomic,retain) NSString *file;

//备注
@property (nonatomic, strong) CardVo *card;

//累计赠送
@property (nonatomic) double giftbalance;

//公司
@property (nonatomic, strong) NSString *company;

//职务
@property (nonatomic, strong) NSString *pos;

//车牌号
@property (nonatomic, strong) NSString *licenseplateno;

//卡号
@property (nonatomic, strong) NSString *cardCode;

//密码
@property (nonatomic, strong) NSString *pwd;

+(id) card_class;

+ (CustomerVo*)convertToCustomer:(NSDictionary*)dic;
+ (NSDictionary*)getDictionaryData:(CustomerVo*)customerVo;

@end
