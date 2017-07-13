//
//  LSCostAdjustVo.m
//  retailapp
//
//  Created by guozhi on 2017/3/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCostAdjustVo.h"

@implementation LSCostAdjustVo
+ (NSArray *)costAdjustVoWithArray:(NSArray *)array {
    return [LSCostAdjustVo mj_objectArrayWithKeyValuesArray:array];
}

+ (instancetype)objectWithKeyValues:(id)keyValues {
    return [self mj_objectWithKeyValues:keyValues];
}
- (void)setBillsStatus:(int)billsStatus {
    _billsStatus = billsStatus;
    //未提交1 待确认2 已调整3 已拒绝4
    if (billsStatus == 1) {
        _billStatusName = @"未提交";
        _billStatusColor = [ColorHelper getBlueColor];
    } else if (billsStatus == 2) {
        _billStatusName = @"待确认";
        _billStatusColor = [ColorHelper getGreenColor];
    } else if (billsStatus == 3) {
        _billStatusName = @"已调整";
        _billStatusColor = [ColorHelper getTipColor6];
    } else if (billsStatus == 4) {
        _billStatusName = @"已拒绝";
        _billStatusColor = [ColorHelper getRedColor];
    }

}

- (void)setShopType:(int)shopType {
    _shopType = shopType;
}

@end
