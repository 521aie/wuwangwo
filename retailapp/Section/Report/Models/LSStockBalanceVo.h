//
//  LSStockBalanceVo.h
//  retailapp
//
//  Created by guozhi on 2017/1/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSStockBalanceVo : NSObject
/** 条形码 */
@property (nonatomic, copy) NSString *barCode;
/** 店内码 */
@property (nonatomic, copy) NSString *innerCode;
/** 款号 */
@property (nonatomic, copy) NSString *styleCode;
/** 款式名称 */
@property (nonatomic, copy) NSString *styleName;
/** 简码 */
@property (nonatomic, copy) NSString *shortCode;
/** 商品分类 */
@property (nonatomic, copy) NSString *categoryId;
/** 商品创建时间 */
@property (nonatomic, strong) NSNumber *goodsCreateTime;
/** 商品ID */
@property (nonatomic, copy) NSString *goodsId;
/** <#注释#> */
@property (nonatomic, copy) NSString *styleId;
/** 商品名称 */
@property (nonatomic, copy) NSString *goodsName;
/** 拼音码 */
@property (nonatomic, copy) NSString *goodsSpell;
/** 期初金额 */
@property (nonatomic, strong) NSNumber *initialAmount;
/** 期初数量 */
@property (nonatomic, strong) NSNumber *initialNum;
/** 出库数量 */
@property (nonatomic, strong) NSNumber *refundNum;
/** 结存金额 */
@property (nonatomic, strong) NSNumber *stockAmount;
/** 结存数量 */
@property (nonatomic, strong) NSNumber *stockNum;
/** 入库数量 */
@property (nonatomic, strong) NSNumber *storageNum;
/** <#注释#> */
@property (nonatomic, copy) NSString *currDate;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopId;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopName;
/** 颜色 */
@property (nonatomic, copy) NSString *colorName;
/** 尺码 */
@property (nonatomic, copy) NSString *sizeName;
@end
