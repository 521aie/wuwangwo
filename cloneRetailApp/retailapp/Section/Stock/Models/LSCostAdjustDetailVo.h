//
//  LSCostAdjustDetailVo.h
//  retailapp
//
//  Created by guozhi on 2017/4/7.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCostAdjustDetailVo : NSObject
/** 调整原因 */
@property (nonatomic, copy) NSString *adjustReason;
/** 调整原因Id */
@property (nonatomic, copy) NSString *adjustReasonId;
/** 商品条形码 */
@property (nonatomic, copy) NSString *barCode;
/** 调整前成本价 */
@property (nonatomic, assign) double beforeCostPrice;
/** 商品ID */
@property (nonatomic, copy) NSString *goodsId;
/** 商品名字 */
@property (nonatomic, copy) NSString *goodsName;
/** 调整后成本价 */
@property (nonatomic, assign) double laterCostPrice;
/** 操作类型 add:新增 edit:编辑 del:删除 */
@property (nonatomic, copy) NSString *operateType;
/** 顺序码 */
@property (nonatomic, assign) int sortCode;
/** 款号 */
@property (nonatomic, copy) NSString *styleCode;
/** 款式id */
@property (nonatomic, copy) NSString *styleId;
/** 款式名称 */
@property (nonatomic, copy) NSString *styleName;
/** 商品类型1.普通商品、2.拆分商品、3.组装商品、4.称重商品、5.原料商品、6:加工商品' */
@property (nonatomic, assign) int goodsType;
/** 是库存数 */
@property (nonatomic, assign) double nowStore;
/** 零售价 */
@property (nonatomic, assign) double retailPrice;
/** 图片路径 */
@property (nonatomic, copy) NSString *filePath;
/** 上下架状态 1 上架 2下架 */
@property (nonatomic, assign) int goodsStatus;



/** 旧调整原因 */
@property (nonatomic, copy) NSString *oldAjustReason;
/** 旧调整后成本价 */
@property (nonatomic, assign) double oldLaterCostPrice;
/** 是否显示未保存标志 */
@property (nonatomic, assign) BOOL isShow;
+ (NSArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray;

@end
