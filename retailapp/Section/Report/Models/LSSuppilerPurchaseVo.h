//
//  LSSuppilerPurchaseVo.h
//  retailapp
//
//  Created by wuwangwo on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSuppilerPurchaseVo : NSObject
/** 条形码 */
@property (nonatomic, copy) NSString *barCode;
/** 商品分类 */
@property (nonatomic, copy) NSString *categoryId;
/** 商超商品ID */
@property (nonatomic, copy) NSString *goodsId;
/** 服鞋商品ID */
@property (nonatomic, copy) NSString *styleId;
/** 商品名称 */
@property (nonatomic, copy) NSString *goodsName;
/** 拼音码 */
@property (nonatomic, copy) NSString *goodsSpell;
/** 单号[入库单/退货单] */
@property (nonatomic, copy) NSString *invoiceCode;
/** 单据类型 1进货 2退货*/
@property (nonatomic, strong) NSNumber *invoiceFlag;
/** 单据时间 */
//@property (nonatomic, copy) NSString *invoiceTime;
@property (nonatomic, strong) NSNumber *invoiceTime;
/** 退货金额 */
@property (nonatomic, strong) NSNumber *returnAmount;
/** 退货量 */
@property (nonatomic, strong) NSNumber * returnNum;
/** 简码 */
@property (nonatomic, strong) NSNumber *shortCode;
/** 进货金额 */
@property (nonatomic, strong) NSNumber *stockAmount;
/** 进货量 */
@property (nonatomic, strong) NSNumber *stockNum;
/** 款号 */
@property (nonatomic, copy) NSString *styleCode;
/** 款式名称 */
@property (nonatomic, copy) NSString *styleName;
/** 供应商编号 */
@property (nonatomic, copy) NSString *supplierCode;
/** 供应商ID */
@property (nonatomic, copy) NSString *supplierId;
/** 供应商名称 */
@property (nonatomic, copy) NSString *supplierName;
/** 当前日期 */
@property (nonatomic, strong) NSNumber *currDate;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopId;
/** 图片路径 */
@property (nonatomic, copy) NSString *imgUrl;
/** 交易笔数 */
@property (nonatomic, strong) NSNumber *transactionNum;
/** 总部登录时，选择门店/仓库的shopEntityId */
@property (nonatomic, copy) NSString *shopEntityId;
/** 单店登录时，单店的entityId */
@property (nonatomic, copy) NSString *entityId;
/** 进货价 */
@property (nonatomic,copy) NSString *goodsPrice;
/** 到货日*/
@property (nonatomic,strong) NSNumber *sendEndTime;

+ (NSArray *)objectArrayFromKeyValueArray:(NSArray *)keyValueArray;
@end
