//
//  LSCostGoodsEditViewController.h
//  retailapp
//
//  Created by guozhi on 17/4/10.
//  Copyright (c) 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class LSCostAdjustDetailVo;

typedef void(^CostGoodsEditCallBlock)(LSCostAdjustDetailVo *item,NSInteger action);

@interface LSCostGoodsEditViewController : LSRootViewController<UIActionSheetDelegate>

//设置页面参数及回调block
- (void)loadDataWithVo:(LSCostAdjustDetailVo *)detailVo withEdit:(BOOL)isEdit callBack:(CostGoodsEditCallBlock)callBack;

@end
