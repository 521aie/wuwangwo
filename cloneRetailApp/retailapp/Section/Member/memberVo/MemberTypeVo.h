//
//  MemberTypeVo.h
//  RestApp
//
//  Created by zhangzhiliang on 15/6/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "INameValueItem.h"
#import "INameItem.h"
#import "Jastor.h"
typedef enum
{
    PriceScheme_MEMBER_PRICE=1,      //使用会员价
    PriceScheme_DISCOUNT_RATIO=2,      //打折比例
    PriceScheme_WHOLE_SALE_PRICE=3,   //使用批发价
}MemberTypeVo_PriceScheme;

@interface MemberTypeVo : Jastor<INameItem, INameValueItem>

@property (nonatomic,retain) NSString *cardTypeName;

@property (nonatomic,retain) NSString *cardTypeDiscount;

/**
 * <code>升级所需积分</code>.
 */
@property (nonatomic) double needIntegral;

/**
 * <code>可否升级</code>.
 */
@property (nonatomic,retain) NSString *isUpgrade;

/**
 * <code>消费积分比例</code>.
 */
@property (nonatomic) float integralRatio;

/**
 * <code>价格方案</code>.
 */
@property (nonatomic,retain) NSString *priceScheme;

/**
 * <code>价格方案ID</code>.
 */
@property (nonatomic) short priceSchemeId;

/**
 * <code>折扣比例</code>.
 */
@property (nonatomic) double discountRatio;

/**
 * <code>备注</code>.
 */
@property (nonatomic,retain) NSString *memo;

@end