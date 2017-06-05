//
//  SupplyManageVo.h
//  retailapp
//
//  Created by hm on 15/12/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplyManageVo : NSObject

@property (nonatomic,copy) NSString* entityid;
//供应商id
@property (nonatomic,copy) NSString* supplyId;
//供应商名称
@property (nonatomic,copy) NSString* name;
//供应商简称
@property (nonatomic,copy) NSString* shortName;
//供应商编号
@property (nonatomic,copy) NSString* code;
//供应商类别
@property (nonatomic,copy) NSString* typeName;
@property (nonatomic,copy) NSString* typeVal;
//联系人
@property (nonatomic,copy) NSString* relation;
//联系电话
@property (nonatomic,copy) NSString* mobile;
//手机号
@property (nonatomic,copy) NSString* phone;
//微信
@property (nonatomic,copy) NSString* weixin;
//邮箱
@property (nonatomic,copy) NSString* email;
//传真
@property (nonatomic,copy) NSString* fax;
//联系地址
@property (nonatomic,copy) NSString* address;
//开户行
@property (nonatomic,copy) NSString* bankname;
//银行账户
@property (nonatomic,copy) NSString* bankcardno;
//户名
@property (nonatomic,copy) NSString* bankaccountname;
//版本信息
@property (nonatomic,assign) NSInteger lastver;
//操作者id
@property (nonatomic,copy) NSString* opuserid;

+ (SupplyManageVo *)converToVo:(NSDictionary *)dic;

+ (NSMutableDictionary *)converToDic:(SupplyManageVo *)vo;

@end
