//
//  MemberSearchCondition.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface MemberSearchCondition : Jastor

/**
 * <code>会员名/手机号</code>.
 */
@property (nonatomic, strong) NSString *keywords;

/**
 * <code>查询类型</code>.
 */
@property (nonatomic, strong) NSString *keywordsKind;

/**
 * <code>卡类型</code>.
 */
@property (nonatomic, strong) NSString *kindCardId;

/**
 * <code>卡状态</code>.
 */
@property (nonatomic, strong) NSString *statusCondition;

/**
 * <code>开申领时间</code>.
 */
@property (nonatomic, strong) NSString *activeTimeType;

/**
 * <code>开始申领时间</code>.
 */
@property (nonatomic, strong) NSString *startActiveTime;

/**
 * <code>结束申领时间</code>.
 */
@property (nonatomic, strong) NSString *endActiveTime;

/**
 * <code>分页时间参数</code>.
 */
@property (nonatomic, strong) NSString *lastDateTime;

/**
 * <code>状态</code>.
 */
@property (nonatomic) short flg;

@end
