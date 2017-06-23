//
//  LSMemberRechargeSetVo.h
//  retailapp
//
//  Created by taihangju on 16/10/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSMemberRechargeRuleVo;
@interface LSMemberRechargeSetVo : NSObject

@property (nonatomic ,strong) NSString *kindCardId;/*<会员类型id>*/
@property (nonatomic ,strong) NSString *kindCardName;/*<会员类型name>*/
@property (nonatomic ,strong) NSArray<LSMemberRechargeRuleVo *> *moneyRuleList;/*<对象数组>*/

+ (NSArray *)getMemberRechargeSetVoList:(NSArray *)array;
@end

@interface LSMemberRechargeRuleVo : NSObject

@property (nonatomic ,strong) NSString *sId;/*<>*/
@property (nonatomic ,strong) NSString *kindCardId;/*<会员卡类型id>*/
@property (nonatomic ,strong) NSString *kindCardName;/*<会员卡类型名称>*/
@property (nonatomic ,strong) NSNumber *rule;/*<优惠值：float>*/
@property (nonatomic ,strong) NSString *entityId;/*<实体id>*/
@property (nonatomic ,strong) NSNumber *condition;/*<充值金额：float>*/
@property (nonatomic ,strong) NSNumber *giftDegree;/*<赠送积分>*/
@property (nonatomic ,strong) NSNumber *isValid;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *opTime;/*<操作时间：long>*/
@property (nonatomic ,strong) NSNumber *createTime;/*< :long>*/
@property (nonatomic ,strong) NSNumber *lastVer;/*<:int>*/
@property (nonatomic ,strong) NSString *extendFields;/*<<#说明#>>*/

- (NSString *)rechargeRuleVoJsonString;
+ (NSArray *)getRechargeRuleVoList:(NSArray *)keyValueArray;
@end
