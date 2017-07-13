//
//  WithdrawCheckVo.h
//  retailapp
//
//  Created by Jianyong Duan on 16/3/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WithdrawCheckVo : NSObject

//伙伴提现审核Id
@property (nonatomic) NSInteger withdrawCheckId;

//实体Id
@property (nonatomic, copy) NSString *entityId;

//申请者Id
@property (nonatomic, copy) NSString *proposerId;

//申请者区分
@property (nonatomic) short proposerType;

//上级伙伴Id
@property (nonatomic) NSInteger parentId;

//操作
@property (nonatomic) short action;

//审核结果  	1：未审核，2：审核不通过，3：审核通过，4：取消
@property (nonatomic) short checkResult;

//发生额
@property (nonatomic) double actionAmount;

//是否有效
@property (nonatomic) short isValid;

//创建时间
@property (nonatomic) long long createTime;

//操作时间
@property (nonatomic) long long opTime;

//版本号
@property (nonatomic) NSInteger lastVer;

//操作人Id
@property (nonatomic, copy) NSString *opUserId;

//审核人Id
@property (nonatomic, copy) NSString *checkUserId;

//提现方式
@property (nonatomic, copy) NSString *withdrawalType;

//开户银行名称
@property (nonatomic, copy) NSString *bankName;

//开户用户姓名
@property (nonatomic, copy) NSString *accountName;

//银行卡号
@property (nonatomic, copy) NSString *accountNumber;

//操作人姓名
@property (nonatomic, copy) NSString *opUserName;

//审核人姓名
@property (nonatomic, copy) NSString *checkUserName;

//审核不同意理由
@property (nonatomic, copy) NSString *refuseReason;

//申请用户Id
@property (nonatomic, copy) NSString *userId;

//申请用户姓名
@property (nonatomic, copy) NSString *userName;

//申请人手机
@property (nonatomic, copy) NSString *mobile;

//手机号后4位
@property (nonatomic, copy) NSString *mobileFour;

//身份证图片列表
@property (nonatomic, strong) NSMutableArray *imageList;

//证件号码
@property (nonatomic, assign) NSString *certificateId;

//证件类型
@property (nonatomic) NSInteger identityTypeId;

//银行卡后四位
@property (nonatomic, copy) NSString *lastFourNum;

+ (WithdrawCheckVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

- (NSDictionary *)converToDic;

@end
