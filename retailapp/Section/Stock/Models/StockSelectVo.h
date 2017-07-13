//
//  StockSelectVo.h
//  retailapp
//
//  Created by hm on 15/7/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface StockSelectVo : Jastor
/**商品名称*/
@property (nonatomic,retain) NSString *name;

/**商品条码*/
@property (nonatomic,retain) NSString *barCode;

/**库存价格*/
@property (nonatomic) double currPrice;

/**库存数*/
@property (nonatomic) double nowStore;

/**单类库存金额*/
@property (nonatomic) double goodsMoneyTotal;

@end
