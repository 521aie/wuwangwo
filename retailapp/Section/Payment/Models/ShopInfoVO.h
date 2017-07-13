//
//  ShopInfoVO.h
//  RestApp
//
//  Created by 果汁 on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSSettleAccountInfoVo.h"
@interface ShopInfoVO : NSObject
@property (nonatomic, strong) NSString *no;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *provinceNo; //查询省份
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *cityNo;     //查询城市
@property (nonatomic, strong) NSString *subBankName;
@property (nonatomic, strong) NSString *subBankNo;   //查询分行
@property (nonatomic, strong) NSString *bankDisplayName; //银行名称  //查询银行
@property (nonatomic, strong) NSString *bankName; //银行代码
@property (nonatomic, strong) NSString *bankProvName; //省份名称
@property (nonatomic, strong) NSString *bankProvNo; //省份代码
@property (nonatomic, strong) NSString *bankCityName; //城市名称
@property (nonatomic, strong) NSString *bankCityNo; //城市代码
@property (nonatomic, strong) NSString *bankSubName; //支行名称
@property (nonatomic, strong) NSString *bankSubNo; //支行代码
@property (nonatomic, strong) NSString *bankAccount; //账户名称
@property (nonatomic, strong) NSString *bankCardNumber; //银行账号
@property (nonatomic, assign) NSInteger shopType;
@property (nonatomic, strong) NSString *shopTypeLabel; //餐饮企业
@property (nonatomic, strong) NSString *isOurWxLabel; //未开通电子支付
@property (nonatomic, assign) NSInteger isOurWx; //是否绑定微信账户(0,未绑定,1已绑定)
@property (nonatomic, assign) NSInteger accountType; //开通类型（1：餐饮企业， 2：对公账户(公司或单位开设的账户))
@property (nonatomic, assign) NSInteger displayWxPay;//是否显示微信支付模块（0不显示，1显示)
@property (nonatomic, assign) NSInteger displayQQ;//是否显示QQ支付模块（0不显示，1显示)
@property (nonatomic, assign) NSInteger displayAlipay;//是否显示支付宝支付模块（0不显示，1显示)
@property (nonatomic, assign) NSInteger displayFund; //是否开通赞助
@property (nonatomic, assign) NSInteger fundBillHoldDay; // T+n天
@property (nonatomic, assign) bool alipayStatus;
@property (nonatomic, assign) bool isOurAlipay;//是否绑定支付宝账户(0,未绑定,1已绑定)
@property (nonatomic, assign) bool  hasCommit;

/**
 * 账户信息
 */
@property(nonatomic, copy) NSString *orgNo; //组织机构代码
@property(nonatomic, assign) NSInteger holderCardType; //开户人证件类型
@property(nonatomic, copy) NSString *holderCardNo; //开户人证件号码
@property(nonatomic, copy) NSString *holderPhone; //开户人手机

/** 账户状态：0，未进件；1，已进件；2，进件失败 */
@property (nonatomic, strong) NSNumber *authStatus;

/**
 * 店铺类型
 */
@property(nonatomic, copy) NSString *locusProvince;//所在省份代码
@property(nonatomic, copy) NSString *locusCity;//所在省份代码
@property(nonatomic, copy) NSString *locusProvinceName;//所在省份名称
@property(nonatomic, copy) NSString *locusCityName;//locusCityName
@property(nonatomic, copy) NSString *ownerName;//负责人姓名
@property(nonatomic, copy) NSString *ownerPhone;//负责人手机
@property(nonatomic, copy) NSString *detailAddress;//详细地址
/** 店家信息 */
@property (nonatomic, strong) LSSettleAccountInfoVo *settleAccountInfo;
@end
