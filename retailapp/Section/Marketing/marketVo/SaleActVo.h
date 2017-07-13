//
//  SaleActVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameItem.h"
#import "INameValueItem.h"
#import "LSSalesKindCardVo.h"

@interface SaleActVo : NSObject

/**
 * <code>促销活动ID</code>.
 */
@property (nonatomic, strong) NSString *saleActId;

/**
 * <code>编码</code>.
 */
@property (nonatomic, strong) NSString *code;

/**
 * <code>名称</code>.
 */
@property (nonatomic, strong) NSString *name;

/**
 * <code>是否会员专享</code>.
 */
@property (nonatomic) short isMember;

/**
 * <code>是否适用门店</code>.
 */
@property (nonatomic) short isShop;

/**
 * <code>门店价格方案</code>.
 */
@property (nonatomic) short shopPriceScheme;

/**
 * <code>门店会员折上折</code>.
 */
@property (nonatomic) short shopDoubleDiscount;

/**
 * <code>是否适用微店</code>.
 */
@property (nonatomic) short isWeixin;

/**
 * <code>微店价格方案</code>.
 */
@property (nonatomic) short weixinPriceScheme;

/**
 * <code>微店会员折上折</code>.
 */
@property (nonatomic) short weixinDoubleDiscount;

/**
 * <code>开始日期</code>.
 */
@property (nonatomic) long long startDate;

/**
 * <code>结束日期</code>.
 */
@property (nonatomic) long long endDate;

/**
 * <code>活动状态</code>.
 */
@property (nonatomic) short salesStatus;

/**
 * <code>活动类别</code>.
 */
@property (nonatomic) short salesType;

/**
 * 门店范围标志:
 * @连锁下有两种状态：1 “指定门店范围”关闭 2 ”指定门店范围“开启
 * @单店和门店 默认为 0
 */
@property (nonatomic) short shopFlag;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastver;

/**
 * <code>能否修改/删除</code>.
 */
@property (nonatomic) short isCanDeal;

/**
 * <code>商户实体ID列表</code>.
 */
@property (nonatomic, strong) NSMutableArray *createEntityIdList;

/**
 * <code>第N件打折列表</code>.
 */
@property (nonatomic, strong) NSMutableArray *salesNpDiscountList;

/**
 * <code>y优惠券活动状态判断：1正在进行，2未进行</code>.
 */
@property (nonatomic) short couponActive;

/** 创建门店名称 */
@property (nonatomic, copy) NSString *ownOrgName;
/** 是否属于登录门店所创建的活动 1 是自己创建 0不是自己创建 */
@property (nonatomic, assign) short ownOrg;
/** 是否指定会员卡类型 1 是指定 0是不指定 */
@property (nonatomic, assign) short hasKindCard;
/** 制定会员列表 */
@property (nonatomic, strong) NSArray *salesKindCardVos;
/** 创建活动是门店还是机构还是总部区分  1 门店  2机构  3总部*/
@property (nonatomic, assign) short createEntityType;
/** <#注释#> */
@property (nonatomic, assign) long long currentDay;



@end
