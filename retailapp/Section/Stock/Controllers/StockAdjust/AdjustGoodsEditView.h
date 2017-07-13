//
//  AdjustGoodsEditView.h
//  retailapp
//
//  Created by hm on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class StockAdjustDetailVo;

typedef void(^AdjustGoodsHandler)(StockAdjustDetailVo *item,NSInteger action);

@interface AdjustGoodsEditView : LSRootViewController<UIActionSheetDelegate>

//设置页面参数及回调block
- (void)loadDataWithVo:(StockAdjustDetailVo *)detailVo withEdit:(BOOL)isEdit callBack:(AdjustGoodsHandler)callBack;

@end
