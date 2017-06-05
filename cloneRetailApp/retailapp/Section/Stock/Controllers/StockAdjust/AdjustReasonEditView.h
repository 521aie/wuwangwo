//
//  AdjustReasonEditView.h
//  retailapp
//
//  Created by hm on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
typedef NS_ENUM(NSInteger, AdjustReasonEditViewType) {
    AdjustReasonEditViewTypeStockAdjust,  //库存调整
    AdjustReasonEditViewTypeCostAdjust,   // 成本价调整
};
@interface AdjustReasonEditView : LSRootViewController
- (instancetype)initWithType:(AdjustReasonEditViewType)type;
@end
