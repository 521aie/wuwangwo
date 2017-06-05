//
//  KindCardVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface KindCardVo : Jastor

/**
 * <code>会员卡类型ID</code>.
 */
@property (nonatomic, strong) NSString *kindCardId;

/**
 * <code>会员卡类型名称</code>.
 */
@property (nonatomic, strong) NSString *kindCardName;

/**
 * <code>此卡可升级</code>.
 */
@property (nonatomic) short canUpgrade;

/**
 * <code>会员卡类型ID</code>.
 */
@property (nonatomic, strong) NSString *upKindCardId;

/**
 * <code>升级所需积分</code>.
 */
@property (nonatomic) NSInteger upPoint;

/**
 * <code>消费积分比例</code>.
 */
@property (nonatomic) double ratioExchangeDegree;

/**
 * <code>优惠方式</code>.
 */
@property (nonatomic) short mode;

/**
 * <code>折扣率</code>.
 */
@property (nonatomic) double ratio;

/**
 * <code>备注</code>.
 */
@property (nonatomic, strong) NSString *memo;

/**
 * <code>编码</code>.
 */
@property (nonatomic, strong) NSString *code;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

+ (KindCardVo*)convertToKindCard:(NSDictionary*)dic;

@end
