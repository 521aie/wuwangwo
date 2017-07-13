//
//  LSMemberSummaryInfoVo.h
//  retailapp
//
//  Created by taihangju on 2016/10/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

// 包含月会员信息汇总 和 日新增会员汇总
@interface LSMemberSummaryInfoVo : NSObject

// 共同都有的字段
@property (nonatomic ,strong) NSNumber *cardNum;/*<发卡总数>*/
@property (nonatomic ,strong) NSNumber *customerNum;/*<会员总数>*/
@property (nonatomic ,strong) NSNumber *freshCardNum;/*<新发卡数>*/ // 对应 newCardNum
@property (nonatomic ,strong) NSNumber *cardBalance;/*<会员储蓄余额（元）>*/

// 按天汇总独有字段
@property (nonatomic ,strong) NSNumber *customerNumDay;/*<日新增会员数>*/
@property (nonatomic ,strong) NSNumber *custormerOldNumDay;/*<当日老会员数,()>*/
@property (nonatomic ,strong) NSNumber *rechargeMoneyDay;/*<当日 会员充值金额>*/
@property (nonatomic ,strong) NSNumber *customerPayMoneyDay;/*<当日 会员消费金额>*/
@property (nonatomic ,strong) NSString *date;/*<统计年月日:yyyyMMdd>*/

// 按日汇总独有字段
@property (nonatomic ,strong) NSNumber *customerNumMonth;/*<月新增会员数>*/
@property (nonatomic ,strong) NSNumber *customerOldNumMonth;/*<当月老会员数>*/
@property (nonatomic ,strong) NSNumber *rechargeMoneyMonth;/*<月 充值金额>*/
@property (nonatomic ,strong) NSNumber *customerPayMoneyMonth;/*<当月会员消费金额>*/
@property (nonatomic ,strong) NSString *month;/*<统计年月:yyyyMM>*/

+ (NSArray *)getMemberSummaryInfoVoList:(NSArray *)keyValuesArray;
+ (instancetype)getMembberSummaryInfoVo:(NSDictionary *)dict;
@end

/*
 cardBalance = 0;
 cardNum = 0;
 customerNum = 0;
 customerNumDay = 1;
 date = 20160802;
 newCardNum = 3;
 rechargeMoneyDay = 0;
 */
