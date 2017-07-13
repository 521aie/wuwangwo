//
//  SkuRuleVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface SkuRuleVo : Jastor

/**
 * <code>属性名id</code>.
 */
@property (nonatomic, strong) NSString *attributeNameId;

/**
 * <code>属性名</code>.
 */
@property (nonatomic, strong) NSString *attributeName;

/**
 * <code>顺序码</code>.
 */
@property (nonatomic) short sortCode;

/**
 * <code>属性类型</code>.
 */
@property (nonatomic) short attributeType;

@end
