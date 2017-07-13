//
//  MemberSalesRechargeVo.h
//  RestApp
//
//  Created by zhangzhiliang on 15/7/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"
#import "Jastor.h"

@interface SaleRechargeVo : Jastor<INameValueItem>

/**
 * <code>ID</code>.
 */
@property (nonatomic,retain) NSString *saleRechargeId;

/**
 * <code>活动名称</code>.
 */
@property (nonatomic,retain) NSString *name;

/**
 * <code>充值金额</code>.
 */
@property (nonatomic) double rechargeThreshold;

/**
 * <code>赠送金额</code>.
 */
@property (nonatomic) double money;

/**
 * <code>开始时间</code>.
 */
@property (nonatomic) long long startTime;

/**
 * <code>结束时间</code>.
 */
@property (nonatomic) long long endTime;

/**
 * <code>赠送积分</code>.
 */
@property (nonatomic) NSInteger point;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

+ (SaleRechargeVo*)convertToSaleRecharge:(NSDictionary*)dic;
+ (NSDictionary*)getDictionaryData:(SaleRechargeVo*)saleRechargeVo;

@end
