//
//  LSStockBalanceListController.h
//  retailapp
//
//  Created by guozhi on 2017/1/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSStockBalanceListController : LSRootViewController
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
/** 时间 */
@property (nonatomic, copy) NSString *time;
/** 关键字 */
@property (nonatomic, copy) NSString *keyWord;
/** 1 店内吗  2 条形码 3 款号  4 拼音码 */
@property (nonatomic, assign) int searchType;
@end
