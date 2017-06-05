//
//  ActionBase.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//


#import "Base.h"

@interface BaseAction : Base
/**
 * <code>上级功能权限ID</code>.
 */
@property (nonatomic,retain) NSString *parentId;
/**
 * <code>名称</code>.
 */
@property (nonatomic,retain) NSString *name;
/**
 * <code>代码</code>.
 */
@property (nonatomic,retain) NSString *code;

/**
 * <code>状态</code>.
 */
@property short status;


@end
