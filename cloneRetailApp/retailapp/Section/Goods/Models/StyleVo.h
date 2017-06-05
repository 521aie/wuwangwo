//
//  GoodsStyleVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameValueItem.h"


@interface StyleVo : Jastor

/**
 * <code>主键</code>.
 */
@property (nonatomic, strong) NSString *styleId;

/**
 * <code>款式名称</code>.
 */
@property (nonatomic, strong) NSString *styleName;

/**
 * <code>上下架状态</code>.
 */
@property (nonatomic) int upDownStatus;

/**
 * <code>款式No</code>.
 */
@property (nonatomic, strong) NSString *styleCode;

/**
 * <code>同步组织/店铺ID</code>.
 */
@property (nonatomic, strong) NSString *synShopId;

/**
 * <code>分类ID</code>.
 */
@property (nonatomic, strong) NSString *categoryId;

/**
 * <code>分类名称</code>.
 */
@property (nonatomic, strong) NSString *categoryName;


/**
 * <code>品牌ID</code>.
 */
@property (nonatomic, strong) NSString *brandId;

/**
 * <code>品牌名称</code>.
 */
@property (nonatomic, strong) NSString *brandName;

/**
 * <code>单位Id</code>.
 */
@property (nonatomic, strong) NSString *unitId;

/**
 * <code>单位名称</code>.
 */
@property (nonatomic, strong) NSString *unitName;

/**
 * <code>适用性别</code>.
 */
@property (nonatomic) short applySex;

/**
 * <code>系列属性值ID</code>.
 */
@property (nonatomic, strong) NSString *serialValId;

/**
 * <code>详情</code>.
 */
@property (nonatomic, copy) NSString *details;


/**
 * <code>系列属性值</code>.
 */
@property (nonatomic, strong) NSString *serial;

/**
 * <code>产地</code>.
 */
@property (nonatomic, strong) NSString *origin;

/**
 * <code>年度</code>.
 */
@property (nonatomic, strong) NSString *year;

/**
 * <code>季节属性值ID</code>.
 */
@property (nonatomic, strong) NSString *seasonValId;

/**
 * <code>季节属性值</code>.
 */
@property (nonatomic, strong) NSString *season;

/**
 * <code>阶段</code>.
 */
@property (nonatomic, strong) NSString *stage;

/**
 * <code>面料属性值ID</code>.
 */
@property (nonatomic, strong) NSString *fabricValId;

/**
 * <code>面料属性值</code>.
 */
@property (nonatomic, strong) NSString *fabric;

/**
 * <code>里料属性值ID</code>.
 */
@property (nonatomic, strong) NSString *liningValId;

/**
 * <code>里料属性值</code>.
 */
@property (nonatomic, strong) NSString *lining;

/**
 * <code>标签</code>.
 */
@property (nonatomic, strong) NSString *tag;

/**
 * <code>附件名</code>.
 */
@property (nonatomic, strong) NSString *fileName;

/**
 * <code>附件内容</code>.
 */
@property (nonatomic, strong) NSString *file;

/**
 * <code>主图服务器路径</code>.
 */
@property (nonatomic, strong) NSString *filePath;

/**
 * <code>是否删除文件服务器上的附件</code>.
 */
@property (nonatomic) short fileDeleteFlg;

/**
 * <code>提成</code>.
 */
@property (nonatomic) double percentage;

/**
 * <code>是否积分</code>.
 */
@property (nonatomic, strong) NSNumber *hasDegree;

/**
 * <code>是否参与优惠活动</code>.
 */
@property (nonatomic, strong) NSNumber *isSales;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

/**
 * <code>商品列表信息</code>.
 */
@property (nonatomic, strong) NSMutableArray *styleGoodsVoList;

/**
 * <code>创建时间</code>.
 */
@property (nonatomic) NSInteger createTime;

/**
 * <code>拼音码</code>.
 */
@property (nonatomic, strong) NSString *spell;

/**
 * <code>进货价</code>.
 */
@property (nonatomic, strong) NSNumber *purchasePrice;

/**
 * <code>吊牌价</code>.
 */
@property (nonatomic, strong) NSNumber *hangTagPrice;

/**
 * <code>会员价</code>.
 */
@property (nonatomic, strong) NSNumber *memberPrice;

/**
 * <code>批发价</code>.
 */
@property (nonatomic, strong) NSNumber *wholesalePrice;

/**
 * <code>零售价</code>.
 */
@property (nonatomic, strong) NSNumber *retailPrice;

/**
 * <code>是否选中</code>.
 */
@property (nonatomic, strong) NSString *isCheck;

/**
 * <code>主型属性值ID</code>.
 */
@property (nonatomic, strong) NSString *prototypeValId;

/**
 * <code>辅型属性值ID</code>.
 */
@property (nonatomic, strong) NSString *auxiliaryValId;

/**
 * <code>主型</code>.
 */
@property (nonatomic, strong) NSString *prototype;

/**
 * <code>辅型</code>.
 */
@property (nonatomic, strong) NSString *auxiliary;

/**
 * <code>微店上下架状态</code>.
 */
//@property (nonatomic, strong) NSString *microShelveStatus;

/**
 * <code>微店销售状态</code>.
 */
@property (nonatomic, strong) NSString *microSaleStatus;// 1：不销售，2：销售

/**
 * <code>是否特价</code>.
 */
@property (nonatomic) short isSpecial;  //1：特价，2：非特价

/**
 * <code>特价</code>.
 */
@property (nonatomic) double spacialPrice;

/**
 * <code>微店价格</code>.
 */
@property (nonatomic) double weixinPrice;

/**
 * <code>特价开始时间</code>.
 */
@property (nonatomic) long long spacialPriceStartTime;
/**
 * <code>特价结束时间</code>.
 */
@property (nonatomic) long long spacialPriceEndTime;

/**
 * <code>最低折扣率</code>.
 */
@property (nonatomic) double singleDiscountConfigVal;

/** 销售策略 */
/*------------- 微店商品价格 -------------*/
/** 微店售价策略 */
@property (nonatomic) short salesStrategy;
/** 微店单品售价类别 */
@property (nonatomic) short salesType;
/** 微信折扣率 */
@property (nonatomic) double weixinDiscountRate;

/** 商品颜色价格表 */
@property (nonatomic, strong) NSMutableArray *attributeValVoList;
/** 商品主图 */
@property (nonatomic, strong) NSMutableArray *mainImageVoList;




+(StyleVo*)convertToStyleVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(StyleVo *)styleVo;

@end
