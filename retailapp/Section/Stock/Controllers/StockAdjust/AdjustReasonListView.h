//
//  AdjustReasonListView.h
//  retailapp
//
//  Created by hm on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
typedef NS_ENUM(NSInteger, AdjustReasonListViewType) {
     AdjustReasonListViewTypeStockAdjust,  //库存调整
    AdjustReasonListViewTypeCostAdjust,   // 成本价调整
};
#import "LSRootViewController.h"

typedef void(^ReasonBack)(NSMutableArray* reasonList);

@interface AdjustReasonListView : LSRootViewController

@property (nonatomic,copy) ReasonBack reasonBack;

//设置页面回调block
- (void)loadData:(ReasonBack)callBack;
- (instancetype)initWithType:(AdjustReasonListViewType)type ;
@end
