//
//  AttributeValVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameItem.h"
@interface AttributeValVo : Jastor<INameItem>

/**
 * <code>属性值id</code>.
 */
@property (nonatomic, strong) NSString *attributeValId;

/**
 * <code>属性名id</code>.
 */
@property (nonatomic, strong) NSString *attributeNameId;

/**
 * <code>属性值</code>.
 */
@property (nonatomic, strong) NSString *attributeVal;

/**
 * <code>属性值分类</code>.
 */
@property (nonatomic, strong) NSString *attributeValGroup;

/**
 * <code>属性值编辑</code>.
 */
@property (nonatomic, strong) NSString *attributeCode;

/**
 * <code>属性类型</code>.
 */
@property (nonatomic) short attributeType;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

/**
 * <code>是否选中</code>.
 */
@property (nonatomic, strong) NSString *isCheck;

/**
 * <code>顺序码</code>.
 */
@property (nonatomic) short sortCode;

@property (nonatomic, strong) NSMutableArray *goodsIdList;

@property (nonatomic) double microGoodPrice;

@property (nonatomic) double colorHangTagPrice;

@property (nonatomic) NSInteger groupSortCode;

+(AttributeValVo*)convertToAttributeValVo:(NSDictionary*)dic;

+(NSDictionary*)getDictionaryData:(AttributeValVo *)attributeValVo;

+ (NSMutableArray *)convertToDicListFromArr:(NSMutableArray *)array;

@end
