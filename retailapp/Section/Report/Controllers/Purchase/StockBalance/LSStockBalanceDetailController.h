//
//  LSStockBalanceDetailController.h
//  retailapp
//
//  Created by guozhi on 2017/1/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSStockBalanceDetailController : LSRootViewController
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
/** 时间 */
@property (nonatomic, copy) NSString *time;

@end
