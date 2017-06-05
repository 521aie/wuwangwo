//
//  PaperDetailVo.h
//  retailapp
//
//  Created by hm on 15/10/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMultiNameValueItem.h"

@interface PaperDetailVo : NSObject<IMultiNameValueItem>
@property (nonatomic,copy) NSString* paperDetailId;
@property (nonatomic,copy) NSString* goodsId;
@property (nonatomic,copy) NSString* goodsName;
/** 零售价 */
@property (nonatomic, assign) double retailPrice;
/** 总的零售价 */
@property (nonatomic, assign) double goodsTotalPrice;
/** 采购价(暂时用这个) */
@property (nonatomic, assign) double goodsPrice;
/** 服鞋吊牌价合计 */
@property (nonatomic, assign) double goodsHangTagTotalPrice;
/** 服鞋退货价合计 */
@property (nonatomic, assign) double goodsReturnTotalPrice;
/** 商超零售价合计 */
@property (nonatomic, assign) double goodsRetailTotalPrice;
/** 商超进货价(采购价)价合计 */
@property (nonatomic, assign) double goodsPurchaseTotalPrice;
/** 采购价 */
@property (nonatomic, assign) double purchasePrice;
@property (nonatomic,assign) double goodsSum;
@property (nonatomic,assign) long long productionDate; // 生产日期
/**
 * 1.普通商品 2.拆分商品 3.组装商品 4.散装商品 5.原料商品 6:加工商品
 *   目前5 没有用，4类型goodsSum 是小数，其他是整数
 */
@property (nonatomic,assign) short type;
/** 上下架 1 上架  2下架 */
@property (nonatomic, assign) short goodsStatus;
/** 商品图片路径 */
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic,copy) NSString* goodsBarcode;
@property (nonatomic,copy) NSString* goodsInnercode;
@property (nonatomic,copy) NSString* styleId;
@property (nonatomic,copy) NSString* styleCode;
@property (nonatomic,copy) NSString* operateType;
@property (nonatomic,copy) NSString* outShopName;
@property (nonatomic,copy) NSString* inShopNam;
@property (nonatomic,strong) NSNumber *nowStore;
@property (nonatomic,assign) double oldGoodsPrice;
@property (nonatomic,assign) double oldGoodsSum;
/** <#注释#> */
@property (nonatomic, assign) double oldGoodsTotalPrice;
@property (nonatomic,assign) short changeFlag;
@property (nonatomic,assign) NSInteger resonVal;
@property (nonatomic,copy) NSString* resonName;
@property (nonatomic,assign) NSInteger oldResonVal;
@property (nonatomic,assign) long long oldDate;
@property (nonatomic,strong) NSNumber *styleCanReturn;
@property (nonatomic,strong) NSNumber *predictSum;
/** <#注释#> */
@property (nonatomic, assign) BOOL isChange;
+ (PaperDetailVo*)converToVo:(NSDictionary*)dic paperType:(NSInteger)paperType;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList paperType:(NSInteger)paperType;
+ (NSMutableDictionary*)converToDic:(PaperDetailVo*)paperDetailVo paperType:(NSInteger)paperType;
+ (NSMutableDictionary*)converToDicArr:(NSMutableArray*)sourceList paperType:(NSInteger)paperType;
@end
