//
//  LSStockQueryDetailController.h
//  retailapp
//
//  Created by guozhi on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSStockQueryDetailController : LSRootViewController
/**门店或仓库id*/
@property (nonatomic, copy) NSString *shopId;
/**款式id*/
@property (nonatomic, copy) NSString *styleId;
/**是否连锁*/
@property (nonatomic) BOOL isChain;
@property (nonatomic, assign) double price;
@end
