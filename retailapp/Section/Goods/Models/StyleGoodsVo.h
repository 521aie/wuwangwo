//
//  StyleGoodsVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface StyleGoodsVo : Jastor

/**
 * <code>主键</code>.
 */
@property (nonatomic, strong) NSString *goodsId;

/**
 * <code>店内码</code>.
 */
@property (nonatomic, strong) NSString *innerCode;

/**
 * <code>商品条码</code>.
 */
@property (nonatomic, strong) NSString *barCode;

/**
 * <code>SKC码</code>.
 */
@property (nonatomic, strong) NSString *skcCode;

/**
 * <code>进货价</code>.
 */
@property (nonatomic) double purchasePrice;

/**
 * <code>吊牌价</code>.
 */
@property (nonatomic) double hangTagPrice;

/**
 * <code>会员价</code>.
 */
@property (nonatomic) double memberPrice;

/**
 * <code>批发价</code>.
 */
@property (nonatomic) double wholesalePrice;

/**
 * <code>零售价</code>.
 */
@property (nonatomic) double retailPrice;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

/**
 * <code>商品Sku属性列表</code>.
 */
@property (nonatomic, strong) NSMutableArray *goodsSkuVoList;

/**
 * <code>创建时间</code>.
 */
@property (nonatomic) NSInteger createTime;

/**
 * <code>商品名称</code>.
 */
@property (nonatomic, strong) NSString *name;

/**
 * <code>主图服务器路径</code>.
 */
@property (nonatomic, strong) NSString *filePath;

/**
 * <code>显示用的商品名称</code>.
 */
@property (nonatomic, strong) NSString *styleGoodsName;

/**
 * <code>显示用的颜色名称</code>.
 */
@property (nonatomic, strong) NSString *styleColorName;

/**
 * <code>是否选中</code>.
 */
@property (nonatomic, strong) NSString *isCheck;

+(StyleGoodsVo*)convertToStyleGoodsVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(StyleGoodsVo *)styleGoodsVo;

+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
