//
//  StockQueryView.h
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VirtualStockBatchView : BaseViewController 

@property (nonatomic, assign) int action; // 可能已经没用了
@property (nonatomic, copy) NSString *val;
@property (nonatomic,copy) NSString *styleId;
@property (nonatomic, strong) NSMutableArray *goodsVos;
@property (nonatomic, strong) NSNumber *maxStore; //最高可分配虚拟库存数

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil shopId:(NSString *)shopId goodsVos:(NSMutableArray *)goodsVos action:(int)action;
@end
