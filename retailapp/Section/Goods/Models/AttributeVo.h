//
//  AttributeVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface AttributeVo : Jastor

/**
 * <code>属性id</code>.
 */
@property (nonatomic, strong) NSString *attributeId;

/**
 * <code>属性集合类型</code>.
 */
@property (nonatomic) short collectionType;

/**
 * <code>编码</code>.
 */
@property (nonatomic, strong) NSString *code;

/**
 * <code>名称</code>.
 */
@property (nonatomic, strong) NSString *name;

/**
 * <code>拼写</code>.
 */
@property (nonatomic, strong) NSString *spell;

/**
 * <code>属性下分类数量</code>.
 */
@property (nonatomic) NSInteger groupCnt;

/**
 * <code>属性下属性值数量</code>.
 */
@property (nonatomic) NSInteger valCnt;

/**
 * <code>属性类型</code>.
 */
@property (nonatomic, strong) NSString *attributeType;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

/**
 * <code>是否选中</code>.
 */
@property (nonatomic, strong) NSString *isCheck;

+(AttributeVo*)convertToAttributeVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
