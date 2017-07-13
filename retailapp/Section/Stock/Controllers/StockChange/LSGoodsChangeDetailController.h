//
//  LSGoodsChangeDetailController.h
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class StockChangeLogVo;
@interface LSGoodsChangeDetailController : LSRootViewController
@property (nonatomic ,strong) StockChangeLogVo *stockChangeLogVo1;//上上层的Vo
@property (nonatomic ,strong) StockChangeLogVo *stockChangeLogVo2;//上层的Vo 操作类型
@end
