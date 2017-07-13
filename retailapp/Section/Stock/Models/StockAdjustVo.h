//
//  StockAdjustVo.h
//  ;;
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ExportListProtocol.h"

@interface StockAdjustVo : NSObject
/**商户id*/
@property (nonatomic, copy) NSString *shopId;
/**商户名称*/
@property (nonatomic, copy) NSString *shopName;
/**所属实体id*/
@property (nonatomic, copy) NSString *entityId;
/**调整单号*/
@property (nonatomic, copy) NSString *adjustCode;
/**操作时间*/
@property (nonatomic, copy) NSString *opTime;
/**操作人名*/
@property (nonatomic, copy) NSString *opName;
/**操作人工号*/
@property (nonatomic, copy) NSString *opStaffid;
/**备注*/
@property (nonatomic, copy) NSString *memo;
/** 1 门店 2仓库 */
@property (nonatomic, assign) int shopType;
/**门店/机构id*/
@property (nonatomic, copy) NSString *shopOrOrgId;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, assign) NSInteger billStatus;
@property (nonatomic, assign) long lastVer;

+ (StockAdjustVo *)converToVo:(NSDictionary *)dic;
+ (NSDictionary *)converToDic:(StockAdjustVo *)vo;
+ (NSMutableArray *)converToArr:(NSArray *)sourceList;
@end
