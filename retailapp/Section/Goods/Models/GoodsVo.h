//
//  GoodsVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface GoodsVo : Jastor

/**
 * <code>主键</code>.
 */
@property (nonatomic, strong) NSString *goodsId;

/**
 * <code>商品上下架</code>.
 */
@property (nonatomic) short upDownStatus;

/**
 * <code>商品名称</code>.
 */
@property (nonatomic, strong) NSString *goodsName;

/**
 * <code>商品条码</code>.
 */
@property (nonatomic, strong) NSString *barCode;

/**
 * <code>店内码</code>.
 */
@property (nonatomic, strong) NSString *innerCode;

/**
 * <code>商品类型(1.普通商品、2.拆分商品、3.组装商品、4.称重商品、5.原料商品、6:加工商品')</code>.
 */
@property (nonatomic) short type;

/**
 * <code>进货价</code>.
 */
@property (nonatomic) double purchasePrice;

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
 * <code>库存</code>.
 */
@property (nonatomic, strong) NSNumber *number;

/**
 * <code>库存</code>.
 */
@property (nonatomic, strong) NSNumber *nowStore;

/**
 * <code>同步组织/店铺ID</code>.
 */
@property (nonatomic, strong) NSString *synShopId;

/**
 * <code>商品简码</code>.
 */
@property (nonatomic, strong) NSString *shortCode;

/**
 * <code>商品拼音码</code>.
 */
@property (nonatomic, strong) NSString *spell;

/**
 * <code>分类ID</code>.
 */
@property (nonatomic, strong) NSString *categoryId;


/**
 * <code>分类</code>.
 */
@property (nonatomic, strong) NSString *categoryName;

/**
 * <code>单位ID</code>.
 */
@property (nonatomic, strong) NSString *unitId;


/**
 * <code>单位</code>.
 */
@property (nonatomic, strong) NSString *unitName;


/**
 * <code>规格</code>.
 */
@property (nonatomic, strong) NSString *specification;

/**
 * <code>品牌ID</code>.
 */
@property (nonatomic, strong) NSString *brandId;

/**
 * <code>品牌</code>.
 */
@property (nonatomic, strong) NSString *brandName;

/**
 * <code>产地</code>.
 */
@property (nonatomic, strong) NSString *origin;

/**
 * <code>保质期</code>.
 */
@property (nonatomic, strong) NSNumber *period;

/**
 * <code>提成</code>.
 */
@property (nonatomic) double percentage;

/**
 * <code>是否参与积分</code>.
 */
@property (nonatomic, strong) NSNumber *hasDegree;

/**
 * <code>是否参与任何优惠活动</code>.
 */
@property (nonatomic, strong) NSNumber * isSales;

/**
 * <code>是否删除文件服务器上的附件</code>.
 */
@property (nonatomic, strong) NSString *fileDeleteFlg;

/**
 * <code>图片</code>.
 */
@property (nonatomic, strong) NSString *fileName;

/**
 * <code>文件</code>.
 */
@property (nonatomic, strong) NSString *file;

/**
 * <code>路径</code>.
 */
@property (nonatomic, strong) NSString *filePath;

/**
 * <code>是否选中</code>.
 */
@property (nonatomic, strong) NSString *isCheck;

/**
 * <code>创建时间</code>.
 */
@property (nonatomic) long long createTime;

/**
 * <code>基础表ID</code>.
 */
@property (nonatomic, strong) NSString* baseId;


/**
 * <code>备注</code>.
 */
@property (nonatomic, strong) NSString* memo;

/**
 * <code>微店上下架状态</code>.
 */
@property (nonatomic, strong) NSString* microShelveStatus;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

/**
 * <code>拆分商品小件商品反算库存</code>.
 */
@property (nonatomic, strong) NSNumber *splitStore;

/**
 *  自己定义的图片对象 记录商品详情修改的图片回到列表时更改值不是后台定义的
 */
@property (nonatomic, strong) UIImage *image;

/**
 * <code>初始单位成本价</code>.
 */
@property (nonatomic, strong) NSNumber *powerPrice;

/**
 * <code>零售价</code>.
 */
@property (nonatomic) double latestReturnPrice;
/** 1：计重（默认）；2：计价 */
@property (nonatomic, assign) NSInteger priceType;

/** <#注释#> */
@property (nonatomic, assign) CGFloat cellHeight;

+(GoodsVo*)convertToGoodsVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(GoodsVo *)goodsVo;
+ (NSMutableArray *)converToDicArr:(NSMutableArray *)sourceList;
@end
