//
//  StockAdjustVo.m
//  retailapp
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StockAdjustVo.h"
#import "MJExtension.h"

@implementation StockAdjustVo

//+ (StockAdjustVo *)converToVo:(NSDictionary *)dic
//{
//    StockAdjustVo *vo = [[StockAdjustVo alloc] init];
//    if ([ObjectUtil isNotEmpty:dic]) {
//        vo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
//        vo.shopName = [ObjectUtil getStringValue:dic key:@"shopName"];
//        vo.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
//        vo.adjustCode = [ObjectUtil getStringValue:dic key:@"adjustCode"];
//        vo.opTime = [ObjectUtil getStringValue:dic key:@"opTime"];
//        vo.opName = [ObjectUtil getStringValue:dic key:@"opName"];
//        vo.opStaffid = [ObjectUtil getStringValue:dic key:@"opStaffid"];
//        vo.createTime = [ObjectUtil getLonglongValue:dic key:@"createTime"];
//        vo.billStatus = [ObjectUtil getShortValue:dic key:@"billStatus"];
//        vo.lastVer = [ObjectUtil getLonglongValue:dic key:@"lastVer"];
//        vo.memo = [ObjectUtil getStringValue:dic key:@"memo"];
//        vo.shopOrOrgId = [ObjectUtil getStringValue:dic key:@"shopOrOrgId"];
//    }
//    return vo;
//}
//
//+ (NSMutableArray *)converToArr:(NSArray *)sourceList
//{
//    if ([ObjectUtil isNotEmpty:sourceList]) {
//        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
//        for (NSDictionary *dic in sourceList) {
//            StockAdjustVo *vo = [StockAdjustVo converToVo:dic];
//            [datas addObject:vo];
//        }
//        return datas;
//    }
//    return [NSMutableArray array];
//}

+ (NSDictionary *)converToDic:(StockAdjustVo *)vo {
    return [StockAdjustVo mj_keyValues];
}

+ (StockAdjustVo *)converToVo:(NSDictionary *)dic {
    return [StockAdjustVo mj_objectWithKeyValues:dic];
}

+ (NSMutableArray *)converToArr:(NSArray *)sourceList {
    return [StockAdjustVo mj_objectArrayWithKeyValuesArray:sourceList];
}

//#pragma mark - ExportListProtocol
//
//- (NSString *)getBillNum {
//    return self.adjustCode;
//}
//
//- (NSString *)getName {
//    return [NSString stringWithFormat:@"%@:(工号%@)" ,self.opName ,self.opStaffid];
//}
//
//- (NSString *)getBillDate {
//    return self.createTime;
//}
//
//- (NSString *)getStatus {
//    return [NSString stringWithFormat:@"%d",self.billStatus];
//}
//
//- (NSInteger)billStatus {
//    return self.billStatus;
//}

@end
