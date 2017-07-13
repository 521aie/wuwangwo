//
//  AttributeGroupVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameItem.h"
#import "INameValueItem.h"

@interface AttributeGroupVo : Jastor<INameItem>

/**
 * <code>属性类型id</code>.
 */
@property (nonatomic, strong) NSString *attributeGroupId;

/**
 * <code>属性名id</code>.
 */
@property (nonatomic, strong) NSString *attributeNameId;

/**
 * <code>属性类型名</code>.
 */
@property (nonatomic, strong) NSString *attributeGroupName;

/**
 * <code>属性类别</code>.
 */
@property (nonatomic) short attributeType;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) int lastVer;

/**
 * <code>属性类型下的属性值列表</code>.
 */
@property (nonatomic, strong) NSMutableArray *attributeValVoList;

/**
 * <code>顺序码</code>.
 */
@property (nonatomic) int sortCode;

+(id) attributeValVoList_class;

@end
