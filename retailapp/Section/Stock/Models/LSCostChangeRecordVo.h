//
//  LSCostChangeRecordVo.h
//  retailapp
//
//  Created by guozhi on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCostChangeRecordVo : NSObject
/** 条形码 */
@property (nonatomic, copy) NSString *barCode;
/** 颜色 */
@property (nonatomic, copy) NSString *goodsColor;
/** 商品Id */
@property (nonatomic, copy) NSString *goodsId;
/** 商品名称 */
@property (nonatomic, copy) NSString *goodsName;
/** 尺码 */
@property (nonatomic, copy) NSString *goodsSize;
/** 店内码 */
@property (nonatomic, copy) NSString *innerCode;
/** 调整前成本价 */
@property (nonatomic, strong) NSNumber *beforeCostPrice;
/** 单号 */
@property (nonatomic, copy) NSString *billsNo;
/** 操作类型 */
@property (nonatomic, copy) NSString *changeType;
/** 成本价差异 */
@property (nonatomic, strong) NSNumber *difCostPrice;
/** 调整后成本价 */
@property (nonatomic, strong) NSNumber *laterCostPrice;
/** 操作时间 */
@property (nonatomic, copy) NSString *opTime;
/** 操作人 */
@property (nonatomic, copy) NSString *opUser;

+ (NSArray *)ls_objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray;
@end
