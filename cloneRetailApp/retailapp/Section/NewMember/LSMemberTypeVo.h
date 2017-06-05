//
//  LSMemberTypeVo.h
//  retailapp
//
//  Created by byAlex on 16/9/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//  会员卡类型model

#import <Foundation/Foundation.h>
#import "NameItemVO.h"

typedef NS_ENUM(NSInteger ,CardCoverType) {
    CoverTypeInit, // 默认未设置图片时使用
    CoverTypeOffical, // 使用官方，后台默认设置的背景图
    CoverTypeSelf // 自定义图片作为卡背景
};

// 优惠方式 -> 对应LSMemberTypeVo 的mode 属性
typedef NS_ENUM(NSInteger ,CardPrimeType){
    CardPrimeMember = 1,    // 按会员价
    CardPrimeDiscount = 3,  // 按固定折扣
    CardPrimeRaw = 8,       // 按批发价
};

@interface LSMemberTypeVo : NSObject

@property (nonatomic ,strong) NSString *sId;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *s_Id;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *name;/* <会员卡名称*/
@property (nonatomic ,assign) double upDegree;/* <升级所需积分*/
@property (nonatomic ,strong) NSString *upKindCardId;/* <下一集卡类型*/
@property (nonatomic ,strong) NSString *upKindCardName;/* <下一级卡名称*/
@property (nonatomic ,strong) NSNumber *ratio;/* <默认折扣率: 浮点型*/
@property (nonatomic ,assign) short isMoneyRatio;/* <储值金额是否参与打折*/
@property (nonatomic ,assign) short isRatioPass;/* <打折时是否需要密码*/
@property (nonatomic ,assign) short isMemberPrice;/* <是否使用会员价*/
@property (nonatomic ,assign) double exchangeDegree;/* <兑换1积分所需消费额*/
@property (nonatomic ,assign) double ratioExchangeDegree;/* <刷卡打折消费兑换1积分所需消费额*/
@property (nonatomic ,assign) short isRatioFeeDegree;/* <刷卡打折消费是否积分 默认传1*/
@property (nonatomic ,assign) NSInteger mode;/* <1,使用会员价 3,使用折扣率 4,使用批发价 改动只需修改CardPrimeType枚举对应的值就行了*/
@property (nonatomic ,strong) NSString *attachmentId;/* <附件（图片）ID*/
@property (nonatomic ,strong) NSString *filePath;/* <图片路径*/
@property (nonatomic ,strong) NSString *selfCoverPath;/* <图片服务器下路径*/
@property (nonatomic ,assign) NSInteger coverType;/* <选择作为背景图的类型*/

@property (nonatomic ,assign) NSInteger isSendSms/* <是否发送短信提醒*/;
@property (nonatomic ,assign) short isAutoCommit;/* <申领卡是否允许自动通过*/
@property (nonatomic ,assign) short isApply;/* <允许微店用户自动申领*/
@property (nonatomic ,strong) NSString *memo;/* <卡适用情形说明*/

@property (nonatomic ,strong) NSString *style;/* <卡片背景eg:200,255,255,255|白色*/
@property (nonatomic ,strong) NSString *fontStyle;/* <字体颜色名eg：白色*/


/** 是否选中 营销-> 特价管理中*/
@property (nonatomic, assign) BOOL isSelect;

//@property (nonatomic ,assign) NSInteger code;/* <<#desc#>*/
//@property (nonatomic ,strong) NSString *opUserIf;/* <操作用户id*/
//@property (nonatomic ,assign) short isForcePwd;/* <是否必须密码*/
//@property (nonatomic ,assign) double pledge;/* <押金*/
//@property (nonatomic ,assign) short isForceRatio;/* <是否强制打折*/
//@property (nonatomic ,assign) short isTotalShop;/* <是否全部关联餐店使用*/
@property (nonatomic ,assign) short isPreFeeDegree;/* <预充值额消费是否积分: 因为餐饮那边有该设置，零售这边没有，默认都是1，开启*/
@property (nonatomic ,assign) NSInteger lastVer;/* <上一个版本*/
@property (nonatomic ,assign) long long createTime;/* <创建时间*/
@property (nonatomic ,assign) int isValid;/* <是否有效*/
@property (nonatomic ,assign) long long opTime;/* <操作时间*/
@property (nonatomic ,strong) NSString *entityId;/* <实体id*/
@property (nonatomic ,strong) NSString *entityName;/* <实体名称*/
@property (nonatomic ,assign) NSInteger checkVal;/* <<#desc#>*/
@property (nonatomic ,assign) short isSelfRecharge;/* <<#desc#>*/
@property (nonatomic ,assign) NSInteger sHash;/* <<#desc#>*/

/**
 *  对象转json string
 */
- (NSString *)jsonString;
+ (LSMemberTypeVo *)getMemberTypeVo:(NSDictionary *)dic;
+ (NSArray *)getMemberTypeVos:(NSArray *)dicArray;
- (NSDictionary *)memberTypeDictionary;

// 优惠方式mode对应的string, 按%率显示折扣
- (NSString *)getModeStringShowRatio;
// 获取优惠方式名称
- (NSString *)getPrimeTypeName;

// 获取优惠方式对应的NameItem
+ (NSArray *)getNameItemsForPrimeType;
// 获取当前优惠方式对应的NameItem所在数组中的index
- (NSInteger)getCurrentPrimeTypeNameItemIndex;
@end


