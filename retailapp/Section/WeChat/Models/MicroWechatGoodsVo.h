//
//  MicroWechatGoodsVo.h
//  retailapp
//
//  Created by yanguangfu on 15/11/16.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface MicroWechatGoodsVo : Jastor

@property (nonatomic, strong) NSString *address;

@property (nonatomic) int applyStatus;

@property (nonatomic, strong) NSString *contact;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *entityCode;

@property (nonatomic, strong) NSString *entityId;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *introduce;

@property (nonatomic) int isFreeSend;

@property (nonatomic) int isSelfPickUp;

@property (nonatomic, strong) NSString *lat;

@property (nonatomic, strong) NSString *lng;

@property (nonatomic, strong) NSString *memberCardId;

@property (nonatomic, strong) NSString *memo;

@property (nonatomic, strong) NSString *microMallId;

@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, strong) NSString *publicNo;

@property (nonatomic, strong) NSString *qq;

@property (nonatomic, strong) NSString *relevanceEntityId;

@property (nonatomic) double sendCost;

@property (nonatomic, strong) NSString *sendRange;

@property (nonatomic) long sendStrategy;

@property (nonatomic, strong) NSString *sendTime;

@property (nonatomic, strong) NSString *shopCode;

@property (nonatomic, strong) NSString *shopName;

@property (nonatomic, strong) NSString *sortCode;

@property (nonatomic, strong) NSString *tel;

@property (nonatomic, strong) NSString *weixin;
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
 * <code>商品类型(1.普通商品、2.拆分商品、3.组装商品、4.称重商品、5.原料商品)</code>.
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
@property (nonatomic) double number;

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
 * <code>规格</code>.
 */
@property (nonatomic, strong) NSString *Specification;

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
@property (nonatomic) NSInteger period;

/**
 * <code>提成</code>.
 */
@property (nonatomic) double percentage;

/**
 * <code>是否参与积分</code>.
 */
@property (nonatomic) short hasDegree;

/**
 * <code>是否参与任何优惠活动</code>.
 */
@property (nonatomic) short isSales;

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
 * <code>单位ID</code>.
 */
@property (nonatomic, strong) NSString* unitId;

///** <code>微店上下架状态</code>.
// *  1、商品已上架 2、商品已下架
// */
//@property (nonatomic, strong) NSString* microShelveStatus;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

+ (MicroWechatGoodsVo *)convertToMicroWechatGoodsVo:(NSDictionary *)dic;


@end
