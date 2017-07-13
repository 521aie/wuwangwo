//
//  Wechat_MicroStyleVo.h
//  retailapp
//
//  Created by zhangzt on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "GoodsVo.h"
@interface Wechat_MircoGoodsVo : Jastor

/**
 * <code>商品ID</code>.
 */
@property (nonatomic, strong) NSString *goodsId;
/**
 * <code>店铺ID</code>.
 */
@property (nonatomic, strong) NSString *shopId;

/**
 * <code>微店销售状态(1:不销售 2:销售)</code>.
 */
@property (nonatomic, strong) NSString *isSale;

/**
 * <code>微店上下架 1:上架 2:下架</code>.
 */
@property (nonatomic, strong) NSString *isShelves;

/**
 * <code>优先度</code>.
 */
@property (nonatomic) NSInteger priority;

/**
 * <code>微店销售策略 1:与零售价相同;2:按零售价打折;3:自定义价格"</code>.
 */
@property (nonatomic) short salesStrategy;

/**
 * <code>微店售价</code>.
 */
@property (nonatomic) double weixinPrice;

/**
 * <code>微店折扣率</code>.
 */
@property (nonatomic) double weixinDiscount;

/**
 * <code>详情介绍</code>.
 */
@property (nonatomic, strong) NSString *details;

/**
 * <code>微店商品主图列表信息</code>.
 */
@property (nonatomic, strong) NSMutableArray *mainImageVoList;

/**
 * <code>微店商品详情图片列表</code>.
 */
@property (nonatomic, strong) NSMutableArray *infoImageVoList;

/**
 * <code>最新版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;
/**
 * <code>款式标签</code>.
 */
@property (nonatomic, strong) NSString *goodsLabel;

/**
 * <code>商品条码</code>.
 */
@property (nonatomic, strong) NSString *barcode;

/**
 * <code>商品名称</code>.
 */
@property (nonatomic, strong) NSString *goodsName;

/**
 * <code>品牌名</code>.
 */
@property (nonatomic) NSString *brandName;

/**
 * <code>商品零售价</code>.
 */
@property (nonatomic) double retailPrice;



+(Wechat_MircoGoodsVo *)convertToMicroGoodsVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(Wechat_MircoGoodsVo *)microGoodsVo;
@end
