//
//  StockQueryView.h
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VirtualStockSort : BaseViewController

- (void)loadData;
- (instancetype)initWith:(NSString *)shopId param:(NSDictionary *)params filterModels:(NSArray *)models;
@end
