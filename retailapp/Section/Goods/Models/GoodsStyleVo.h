//
//  GoodsStyleVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameValueItem.h"


@interface GoodsStyleVo : Jastor<INameValueItem>

/**
 * <code>主键</code>.
 */
@property (nonatomic, strong) NSString *goodsStyleId;

/**
 * <code>款式名称</code>.
 */
@property (nonatomic, strong) NSString *goodsStyleName;


/**
 * <code>款式No</code>.
 */
@property (nonatomic, strong) NSString *goodsStyleNo;

/**
 * <code>店内码</code>.
 */
@property (nonatomic, strong) NSString *innerCode;

/**
 * <code>条形码</code>.
 */
@property (nonatomic, strong) NSString *barCode;

/**
 * <code>颜色</code>.
 */
@property (nonatomic, strong) NSString *colour;

/**
 * <code>尺码</code>.
 */
@property (nonatomic, strong) NSString *size;

/**
 * <code>地区</code>.
 */
@property (nonatomic, strong) NSString *region;

/**
 * <code>skc码</code>.
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
 * <code>是否选中</code>.
 */
@property (nonatomic, strong) NSString *isCheck;

@end
