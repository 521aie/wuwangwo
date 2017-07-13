//
//  Wechat_MicroStyleVo.h
//  retailapp
//
//  Created by zhangzt on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface Wechat_MicroStyleVo : Jastor

/**
 * <code>款式ID</code>.
 */
@property (nonatomic, strong) NSString *styleId;

/**
 * <code>分类ID</code>.
 */
@property (nonatomic, strong) NSString *categoryId;

/**
 * <code>微店销售状态(1:不销售 2:销售)</code>.
 */
@property (nonatomic, strong) NSString *saleStatus;

/**
 * <code>微店上下架 1:上架 2:下架</code>.
 */
//@property (nonatomic, strong) NSString *upDownStatus;

/**
 * <code>优先度</code>.
 */
@property (nonatomic) NSInteger priority;

/**
 * <code>微店销售策略 1:与零售价相同;2:按零售价打折;3:自定义价格"</code>.
 */
@property (nonatomic) short saleStrategy;

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
 * <code>商品详情</code>.
 */
@property (nonatomic, strong) NSString *details;

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
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;


/**
 * <code>款式名称</code>.
 */
@property (nonatomic, strong) NSString *styleName;

/**
 * <code>款号</code>.
 */
@property (nonatomic, strong) NSString *styleCode;

/**
 * <code>品牌名</code>.
 */
@property (nonatomic, strong) NSString *brandName;

/**
 * <code>吊牌价价</code>.
 */
@property (nonatomic) double hangTagPrice;

/**
 * <code>零售价</code>.
 */
@property (nonatomic) double retailPrice;
/**
 * <code>最低折扣率</code>.
 */
@property (nonatomic) double singleDiscountConfigVal;

/**
 * <code>商品颜色价格表</code>.
 */
@property (nonatomic, strong) NSMutableArray *attributeValVoList;

+(Wechat_MicroStyleVo *)convertToMicroGoodsVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(Wechat_MicroStyleVo *)microStyleVo;

@end
