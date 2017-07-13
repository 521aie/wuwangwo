//
//  UserBankVo.h
//  retailapp
//
//  Created by Jianyong Duan on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface UserBankVo : Jastor

//主键Id
@property (nonatomic) NSInteger userBankId;

//实体Id
@property (nonatomic, copy) NSString *entityId;

//用户Id
@property (nonatomic, copy) NSString *userId;

//用户区分
@property (nonatomic) short userType;

//银行名称
@property (nonatomic, copy) NSString *bankName;

//开户名
@property (nonatomic, copy) NSString *accountName;

//银行卡号
@property (nonatomic, copy) NSString *accountNumber;

//省份Id
@property (nonatomic, copy) NSString *provinceId;

//城市Id
@property (nonatomic, copy) NSString *cityId;

//开户支行
@property (nonatomic, copy) NSString *branchName;

//创建时间
@property (nonatomic) long long createTime;

//操作时间
@property (nonatomic) long long opTime;

//是否有效
@property (nonatomic) short isValid;

//版本号
@property (nonatomic) NSInteger lastVer;

//操作人Id
@property (nonatomic, copy) NSString *opUserId;

//银行卡后四位
@property (nonatomic, copy) NSString *lastFourNum;

+ (UserBankVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

- (NSString *)userBankIdString;

@end
