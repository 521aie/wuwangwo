//
//  LSByTimeRechargeRecordVo.h
//  retailapp
//
//  Created by taihangju on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

// 计次充值记录列表和详情页的vo
typedef NS_ENUM(NSInteger ,LSByTimeRechargeRecordOperType) {
    LSByTimeRechargeRecordOperType_Recharge, // 充值
    LSByTimeRechargeRecordOperType_Refund,  // 退款
};

@interface LSByTimeRechargeRecordVo : NSObject

@property (nonatomic, strong) NSString *accountCardId;/**<记次卡id>*/
@property (nonatomic, strong) NSString *accountCardName;/**<计次卡名称>*/
@property (nonatomic, strong) NSNumber *createTime;/**<充值时间>*/
@property (nonatomic, strong) NSNumber *startDate;/**<有效期：开始时间>*/
@property (nonatomic, strong) NSNumber *endDate;/**<有效期：终止时间>*/
@property (nonatomic, strong) NSString *memberNo;/**<会员开号>*/
@property (nonatomic, strong) NSString *memberType;/**<会员卡类型>*/
@property (nonatomic, strong) NSString *memberName;/**<会员名>*/
@property (nonatomic, strong) NSString *opTime;/**<操作时间>*/
@property (nonatomic, strong) NSString *opUserName;/**<操作人>*/
@property (nonatomic, strong) NSNumber *opUserNo;/**<操作人NO.>*/
@property (nonatomic, strong) NSString *operType;/**<操作类型（充值、退款)>*/
@property (nonatomic, strong) NSString *payMode;/**<支付/退款方式:eg 支付宝>*/
@property (nonatomic, strong) NSString *phoneNo;/**<手机号>*/
@property (nonatomic, strong) NSNumber *price;/**<售价>*/

+ (instancetype)byTimeRechargeRecordVo:(NSDictionary *)jsonDic;
+ (NSArray *)byTimeRechargeRecordVoList:(NSArray *)keyValuesArray;
- (LSByTimeRechargeRecordOperType)byTimeRechargeRecordVoOperType;
// 计次服务有效期：
- (NSString *)vailidTimeString;
@end
