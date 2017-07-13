//
//  SaleGoodVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface SaleGoodVo : Jastor

/**
 * <code>主键</code>.
 */
@property (nonatomic, strong) NSString *goodId;

/**
 * <code>店内码</code>.
 */
@property (nonatomic, strong) NSString *goodCode;

/**
 * <code>商品名称</code>.
 */
@property (nonatomic, strong) NSString *goodName;

/**
 * <code>商品图片</code>.
 */
@property (nonatomic, strong) NSString *goodPic;

/**
 * <code>创建时间</code>.
 */
@property (nonatomic) NSInteger createTime;

/**
 * <code>商品Sku属性列表</code>.
 */
@property (nonatomic, strong) NSMutableArray *goodsSkuList;

/**
 * <code>是否选中</code>.
 */
@property (nonatomic, strong) NSString *isCheck;

+(SaleGoodVo*)convertToSaleGoodVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(SaleGoodVo *)saleGoodVo;

+ (NSMutableArray*)converToArr:(NSArray*)sourceList;
+ (NSMutableArray*)converToDicArr:(NSArray*)voList;
@end
