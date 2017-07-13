//
//  SalesGoodsBatchView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesGoodsBatchView : BaseViewController

@property (nonatomic,retain) NSMutableArray *goodsIds;

- (instancetype)initWith:(NSMutableArray *)goodsList discountId:(NSString *)discountId discountType:(NSString *)discountType lastDateTime:(NSString *)lastDateTime searchCode:(NSString *)searchCode;
@end
