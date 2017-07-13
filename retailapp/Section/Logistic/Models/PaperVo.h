//
//  PaperVo.h
//  retailapp
//
//  Created by hm on 15/10/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExportListProtocol.h"

@interface PaperVo : NSObject <ExportListProtocol>

@property (nonatomic ,copy) NSString *paperId;
@property (nonatomic ,copy) NSString *paperNo;
@property (nonatomic) long long sendEndTime;
/* 客户退货单
 1、待确认
 2、已退货
 3、已拒绝
 4、单子未提交
 */
@property (nonatomic) NSInteger billStatus; // 单子当前状态
//
@property (nonatomic ,copy) NSString *billStatusName;
@property (nonatomic ,assign) double goodsTotalPrice;
@property (nonatomic ,assign) double goodsTotalSum;
@property (nonatomic ,copy) NSString *supplyId;
@property (nonatomic ,copy) NSString *supplyName;
@property (nonatomic ,copy) NSString *shopId;
@property (nonatomic ,copy) NSString *shopName;
@property (nonatomic ,copy) NSString *outShopName;
@property (nonatomic ,copy) NSString *inShopName;
// "收货入库单"和"调拨单"才有
@property (nonatomic) NSString *lastVer;
// 收货入库单 独有
@property (nonatomic ,copy) NSString *recordType;
/*<单据类型:如叫货单，库存调整单等>*/
@property (nonatomic, assign) NSInteger billType;
/** 供应商有没有被删除 YES 删除 NO 没有删除 */
@property (nonatomic, assign) BOOL supplyCheck;

+ (PaperVo *)converToVo:(NSDictionary *)dic paperType:(NSInteger)paperType;
+ (NSMutableArray *)converToArr:(NSArray *)sourceList paperType:(NSInteger)paperType;
+ (NSDictionary *)converToDic:(PaperVo *)paperVo paperType:(NSInteger)paperType;
// 收货入库单 model - > dic
+ (NSDictionary *)converStockInVoToDic:(PaperVo *)paperVo;
@end
