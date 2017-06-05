//
//  MicroGoodsVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface MicroGoodsVo : Jastor

/**
 * <code>店铺ID</code>.
 */
@property (nonatomic, strong) NSString *shopId;

/**
 * <code>商品ID</code>.
 */
@property (nonatomic, strong) NSString *goodsId;

/**
 * <code>是否销售(1:不销售 2:销售)</code>.
 */
@property (nonatomic, strong) NSString *isSale;

/**
 * <code>1:上架 2:下架</code>.
 */
//@property (nonatomic, strong) NSString *isShelves;

/**
 * <code>优先度</code>.
 */
@property (nonatomic) NSNumber *priority;

/**
 * <code>1:与零售价相同;2:按零售价打折;3:自定义价格"</code>.
 */
@property (nonatomic) short salesStrategy;

/**
 * <code>商品名称</code>.
 */
@property (nonatomic, strong) NSString *goodsName;

/**
 * <code>品牌名</code>.
 */
@property (nonatomic, strong) NSString *brandName;

/**
 * <code>分类Id</code>.
 */
@property (nonatomic, strong) NSString *categoryId;


/**
 * <code>零售价</code>.
 */
@property (nonatomic) double retailPrice;

/**
 * <code>微信价</code>.
 */
@property (nonatomic) double weixinPrice;

/**
 * <code>微店折扣率 <= 100 </code>.
 */
@property (nonatomic) double weixinDiscount;

/**
 * <code>条码</code>.
 */
@property (nonatomic, strong) NSString *barcode;

/**
 * <code>商品详情</code>.
 */
@property (nonatomic, strong) NSString *details;

/**
 * <code>商品标签</code>.
 */
@property (nonatomic, strong) NSString *goodsLable;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

/**
 * <code>微店商品主图列表信息</code>.
 */
@property (nonatomic, strong) NSMutableArray *mainImageVoList;

/**
 * <code>微店商品详情图片列表信息</code>.
 */
@property (nonatomic, strong) NSMutableArray *infoImageVoList;

+(MicroGoodsVo*)convertToMicroGoodsVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(MicroGoodsVo *)microGoodsVo;

@end
