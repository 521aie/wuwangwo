//
//  LSCostAdjustStyleBatchViewController.h
//  retailapp
//
//  Created by guozhi on 2017/4/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
typedef void(^BatchCallBlock)(double cost);
#import "LSRootViewController.h"

@interface LSCostAdjustStyleBatchViewController : LSRootViewController
- (instancetype)initWithCallBlock:(BatchCallBlock)callBlock;
@end
