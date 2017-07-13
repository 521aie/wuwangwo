//
//  LSGoodsChangeListController.h
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class StockChangeLogVo;
@interface LSGoodsChangeListController : LSRootViewController
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) StockChangeLogVo *parentStockChangeLogVo;//上层view选中的cell带的vo
@end
