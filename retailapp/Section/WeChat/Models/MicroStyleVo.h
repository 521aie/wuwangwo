//
//  MicroStyleVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface MicroStyleVo : Jastor

/**
 * <code>款式ID</code>.
 */
@property (nonatomic, strong) NSString *styleId;

/**
 * <code>款式名称</code>.
 */
@property (nonatomic, strong) NSString *styleName;

/**
 * <code>款号</code>.
 */
@property (nonatomic, strong) NSString *styleNo;

/**
 * <code>所属实体</code>.
 */
@property (nonatomic, strong) NSString *entityId;

/**
 * <code>店铺ID</code>.
 */
@property (nonatomic, strong) NSString *shopId;

/**
 * <code>零售价</code>.
 */
@property (nonatomic) double retailPrice;

/**
 * <code>商品标签</code>.
 */
@property (nonatomic, strong) NSString *goodsLabel;

/**
 * <code>商品类别</code>.
 */
@property (nonatomic) short goodsStyle;

/**
 * <code>是否销售</code>.
 */
@property (nonatomic, strong) NSString *saleStatus;

/**
 * <code>是否上架</code>.
 */
@property (nonatomic, strong) NSString *isShelves;

/**
 * <code>销售策略</code>.
 */
@property (nonatomic) short salesStrategy;

/**
 * <code>商品类目</code>.
 */
@property (nonatomic, strong) NSString *categoryId;

/**
 * <code>商品详情</code>.
 */
@property (nonatomic, strong) NSString *details;


//微店管理 增加
/**
 * <code>微店上下架状态</code>.
 */
@property (nonatomic, strong) NSString *upDownStatus;

/**
 * <code>优先度</code>.
 */
@property (nonatomic) int priority;

/**
 * <code>微店售价</code>.
 */
@property (nonatomic) double microPrice;

/**
 * <code>微店折扣率</code>.
 */
@property (nonatomic) double microDiscountRate;

/**
 * <code>微店单品售价类别</code>.
 */
@property (nonatomic) short saleType;

/**
 * <code>微店商品信息列表</code>.
 */
@property (nonatomic, strong) NSMutableArray *goodsVoList;

/**
 * <code>微店款式主图列表</code>.
 */
@property (nonatomic, strong) NSMutableArray *mainImageVoList;

/**
 * <code>微店款式详情图片列表</code>.
 */
@property (nonatomic, strong) NSMutableArray *infoImageVoList;

/**
 * <code>微店款式颜色图片列表</code>.
 */
@property (nonatomic, strong) NSMutableArray *colorImageVoList;

/**
 * <code>款号</code>.
 */
@property (nonatomic, strong) NSString *styleCode;

/**
 * <code>品牌名</code>.
 */
@property (nonatomic, strong) NSString *brandName;

/**
 * <code>吊牌价</code>.
 */
@property (nonatomic) double hangTagPrice;


//只适用于销售包款式图片信息
+(MicroStyleVo*)convertToMicroStyleVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(MicroStyleVo *)microStyleVo;

@end
