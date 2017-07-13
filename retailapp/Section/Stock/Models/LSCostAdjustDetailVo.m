//
//  LSCostAdjustDetailVo.m
//  retailapp
//
//  Created by guozhi on 2017/4/7.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCostAdjustDetailVo.h"

@implementation LSCostAdjustDetailVo
+ (NSArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray {
    NSArray *list = [LSCostAdjustDetailVo mj_objectArrayWithKeyValuesArray:keyValuesArray];
    [list enumerateObjectsUsingBlock:^(LSCostAdjustDetailVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.oldLaterCostPrice = obj.laterCostPrice;
        obj.oldAjustReason = obj.adjustReason;
        obj.operateType = @"edit";
    }];
    return list;
}

- (BOOL)isShow {
    self.oldAjustReason = [NSString isBlank:self.oldAjustReason] ? @"" : self.oldAjustReason;
    self.adjustReason = [NSString isBlank:self.adjustReason] ? @"" : self.adjustReason;
    return !(self.oldLaterCostPrice == self.laterCostPrice && [self.oldAjustReason isEqualToString:self.adjustReason]);
}
@end
