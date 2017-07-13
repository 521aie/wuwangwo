//
//  LSMemberCardVo.h
//  retailapp
//
//  Created by taihangju on 16/9/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//  会员卡model

#import <Foundation/Foundation.h>
#import "INameItem.h"
#import "LSMemberTypeVo.h"

@class LSMemberCardPwdVo,LSMemberRetreatCardVo,LSMemberRechargeVo;
@interface LSMemberCardVo : NSObject<INameItem>

@property (nonatomic ,strong) NSString *sId;
@property (nonatomic ,strong) NSString *s_Id;/*<>*/
@property (nonatomic ,strong) NSNumber *status; // 卡当前状态
@property (nonatomic ,strong) NSNumber *isDeleted;/*<bool:当前卡是否被删除了>*/
@property (nonatomic ,strong) NSString *entityId;/*<实体id>*/
@property (nonatomic ,strong) NSString *ratioExchangeDegree;/*<>*/
@property (nonatomic ,strong) NSString *isRatioFeeDegree;/*<bool:>*/
@property (nonatomic ,strong) NSString *isPreFeeDegree;/*<bool:>*/
@property (nonatomic ,strong) NSNumber *upDegree;/*<double:升级所需积分>*/
@property (nonatomic ,strong) NSString *upKindCardId;/*<可升级卡类型的id>*/
@property (nonatomic ,strong) NSString *upKindCardName;/*<可升级卡类型的名称>*/
//@property (nonatomic ,strong) NSString *name;/*<当前卡名称>*/
@property (nonatomic ,strong) NSString *operatorName;/*<发卡人>*/
@property (nonatomic ,strong) NSString *shopEntityName;/*<发卡门店, 涉及到更改店名的情况，所以一律获取本地的店名>*/
@property (nonatomic ,strong) NSString *shopEntityId;/*<发卡门店id>*/
@property (nonatomic ,strong) NSString *kindCardId;/*<当前卡所属的会员类型id>*/
@property (nonatomic ,strong) NSString *kindCardName;/*<当前卡所属的会员类型名称>*/
@property (nonatomic ,strong) NSNumber *ratio;/*<bouble:默认折扣率>*/
@property (nonatomic ,strong) NSNumber *mode;/*<优惠模式，参考LSMemberTypeVo中mode>*/
@property (nonatomic ,strong) NSString *memo;/*<会员卡适用情况说明>*/
@property (nonatomic ,strong) NSString *sellerId;/*<销售id>*/
@property (nonatomic ,strong) NSString *attachmentId;/*<图片路径>*/
@property (nonatomic ,strong) NSString *style;/*<会员卡上字体颜色>*/
@property (nonatomic ,strong) NSString *filePath;/*<卡片背景图片下载路径>*/
@property (nonatomic ,strong) NSNumber *isApply;
@property (nonatomic ,strong) NSNumber *isSelfRecharge;/*<会员卡背景图片类型>*/
@property (nonatomic ,strong) NSString *selfCoverPath;/*<上传：卡片背景路径>*/
@property (nonatomic ,strong) NSNumber *coverType;/*<>*/
@property (nonatomic ,strong) NSNumber *isAutoCommit;/*<>*/
@property (nonatomic ,strong) NSString *fontStyle;/*<卡字体颜色>*/
@property (nonatomic ,strong) NSString *code;/*<卡号>*/
@property (nonatomic ,strong) NSString *innerCode;/*<>*/
@property (nonatomic ,strong) NSNumber *realBalance;/*<累计充值>*/
@property (nonatomic ,strong) NSNumber *giftBalance;/*<累计赠送>*/
@property (nonatomic ,strong) NSNumber *payAmount;/*<累计消费>*/
@property (nonatomic ,strong) NSNumber *consumeAmount;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *balance;/*<卡余额>*/
@property (nonatomic ,strong) NSNumber *degree;/*<卡内积分>*/
@property (nonatomic ,strong) NSNumber *activeDate;/*<发卡日期>*/
@property (nonatomic ,strong) LSMemberTypeVo *cardTypeVo;/*<会员卡对应卡类型对象>*/
@property (nonatomic ,strong) LSMemberCardPwdVo *pwdVo;/*<会员卡更改卡密码时需要>*/
@property (nonatomic, strong) NSNumber *byTimeServiceTimes;/**<计次卡中有效的计次服务数量>*/

//@property (nonatomic ,strong) LSMemberRetreatCardVo *retreatVo;/*<会员退卡 时保存退卡信息>*/
//@property (nonatomic ,strong) LSMemberRechargeVo *rechargeVo;/*<会员充值 保存充值信息>*/

@property (nonatomic ,strong) NSNumber *ischeck;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *planName;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *planId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *checkVal;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *cacheExpireTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *orign_Id;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *pledge;//押金
@property (nonatomic ,strong) NSNumber *isTotalShop;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *isSendSms;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *exchangeDegree;/*<double:>*/
@property (nonatomic ,strong) NSNumber *isMoneyRatio;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *isRatioPass;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *isMemberPrice;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *isForceRatio;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *isForcePwd;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *isValid;
@property (nonatomic ,strong) NSNumber *createTime;
@property (nonatomic ,strong) NSNumber *opTime;
@property (nonatomic ,strong) NSNumber *lastVer;
@property (nonatomic ,strong) NSString *optUserId;/*<发卡人>*/

+ (NSArray *)getMemberCardVoList:(NSArray *)array;
+ (LSMemberCardVo *)getMemberCardVo:(NSDictionary *)dic;


// 优惠方式mode对应的string, 按%率显示折扣
- (NSString *)getModeStringShowRatio;
// 获取优惠方式名称
- (NSString *)getPrimeTypeName;
// 获取卡状态对应的string
- (NSString *)getCardStatusString;
// 是否挂失状态
- (BOOL)isLost;
@end

@interface LSMemberCardPwdVo : NSObject

@property (nonatomic, strong)NSString *passward;/*<新密码>*/
@property (nonatomic, strong)NSString *surePassward;/*<确认新密码>*/
@property (nonatomic, strong)NSString *cardId;/*<会员卡id>*/

- (NSDictionary *)dictionary;
@end


//@interface LSMemberRetreatCardVo : NSObject
//
///*
// * 实退金额 (此处设为NSString是为了区分 nil 和 0)
// */
//@property (nonatomic, strong) NSString *realPay;
//
///*
// * 备注
// */
//@property (nonatomic, strong) NSString *memo;
//
///*
// * card_id
// */
//@property (nonatomic, strong) NSString *cardId;
//
///*
// * user_id
// */
//@property (nonatomic, strong) NSString *userId;
//
//- (NSDictionary *)dictionary;
//@end


@interface LSMemberRechargeVo : NSObject

@property (nonatomic ,strong) NSNumber *payTyp;/*<付款方式>*/
@property (nonatomic ,strong) NSNumber *recharegeMoney;/*<充值金额: float>*/
@property (nonatomic ,strong) NSNumber *presentMoney;/*<赠送金额: float>*/
@property (nonatomic ,strong) NSNumber *presentIntegral;/*<赠送积分: int>*/
@property (nonatomic ,strong) NSString *moneyRuleString;/*<充值送金额规则 组合的字符串>*/
@property (nonatomic ,strong) NSString *integralRuleString;/*<充值送积分规则 组成的字符串>*/

+ (NSArray *)getPayTypeItems;
@end
