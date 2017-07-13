//
//  CustomerCommentVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface CustomerCommentVo : Jastor

/**
 * <code>会员评论Id</code>.
 */
@property (nonatomic) long customerCommentId;

/**
 * <code>实体Id</code>.
 */
@property (nonatomic, strong) NSString *entityId;

/**
 * <code>商品/款式Id</code>.
 */
@property (nonatomic, strong) NSString *goodsId;

/**
 * <code>商品区分</code>.
 */
@property (nonatomic) short goodsType;

/**
 * <code>门店/仓库Id</code>.
 */
@property (nonatomic, strong) NSString *shopId;

/**
 * <code>店铺区分</code>.
 */
@property (nonatomic) short shopType;

/**
 * <code>评论内容</code>.
 */
@property (nonatomic, strong) NSString *comment;

/**
 * <code>评价等级</code>.
 */
@property (nonatomic) short commentLevel;

/**
 * <code>会员Id</code>.
 */
@property (nonatomic, strong) NSString *customerId;

/**
 * <code>是否有效</code>.
 */
@property (nonatomic) short isValid;

/**
 * <code>创建时间</code>.
 */
@property (nonatomic) long createTime;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) int lastVer;

/**
 * <code>操作时间</code>.
 */
@property (nonatomic) long opTime;

/**
 * <code>扩展字段</code>.
 */
@property (nonatomic, strong) NSString *extendFields;

@end
