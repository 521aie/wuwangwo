//
//  StockCollectVo.h
//  retailapp
//
//  Created by zhangzhiliang on 16/2/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface StockCollectVo : Jastor

/**名称*/
@property (nonatomic, copy) NSString *name;

/**数量*/
@property (nonatomic, strong) NSNumber *num;

/**总价格*/
@property (nonatomic) double money;

+ (StockCollectVo *)converToVo:(NSDictionary *) dic;
+ (NSMutableArray *)converToArr:(NSArray*) sourceList;

@end
