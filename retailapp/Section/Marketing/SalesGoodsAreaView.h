//
//  SalesGoodsAreaView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesGoodsAreaView : BaseViewController

@property (nonatomic, strong) NSString *operateMode;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *isCanDeal;

// 从批量操作页面返回
- (void)loadDatasFromBatchOperateView;
- (instancetype)initWith:(NSString *)discountId discountType:(NSString *)discountType shopId:(NSString *)shopId action:(NSInteger)action;
@end
