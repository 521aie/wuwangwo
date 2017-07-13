//
//  StockAdjustEditView.h
//  retailapp
//
//  Created by hm on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "INameCode.h"
@class StockAdjustVo;
typedef void(^AdjustPaperHandler)(StockAdjustVo* item, NSInteger action);

@interface StockAdjustEditView : LSRootViewController
/**是否有确认调整权限*/
@property (nonatomic,assign) BOOL hasStockAdjust;
//设置页面参数及回调
- (void)showDetail:(StockAdjustVo*)stockAdjustVo withEditable:(BOOL)enable withAction:(NSInteger)action callBack:(AdjustPaperHandler)handler;

@end
