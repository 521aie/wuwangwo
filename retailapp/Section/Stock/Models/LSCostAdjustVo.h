//
//  LSCostAdjustVo.h
//  retailapp
//
//  Created by guozhi on 2017/3/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCostAdjustVo : NSObject
/** 单据状态 全部0 未提交1 待确认2 已调整3 已拒绝4 */
@property (nonatomic, assign) int billsStatus;
/** 调整单号 */
@property (nonatomic, copy) NSString *costPriceOpNo;
/** 单据时间 */
@property (nonatomic, strong) NSNumber *createTime;
/** 操作人 */
@property (nonatomic, copy) NSString *opName;
/** 操作人工号 */
@property (nonatomic, copy) NSString *opStaffId;
/** 1 门店/2 机构 */
@property (nonatomic, assign) int shopType;
/** 门店名称 */
@property (nonatomic, copy) NSString *shopName;
/** 备注 */
@property (nonatomic, copy) NSString *memo;
/** 门店/机构id */
@property (nonatomic, copy) NSString *shopOrOrgId;
/** 版本号 */
@property (nonatomic, strong) NSNumber *lastVer;
/** 款式Id */
@property (nonatomic, copy) NSString *styleId;



/** 单据值 */
@property (nonatomic, copy) NSString *billStatusName;
/** 单据颜色 */
@property (nonatomic, strong) UIColor *billStatusColor;
/**
 通过字典数据来创建一个模型数据

 @param array 字典数组
 @return 模型数组
 */
+ (NSArray *)costAdjustVoWithArray:(NSArray *)array;
+ (instancetype)objectWithKeyValues:(id)keyValues;
@end
