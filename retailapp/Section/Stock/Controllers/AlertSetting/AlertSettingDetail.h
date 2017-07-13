//
//  StockQueryView.h
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class GoodsVo;
@interface AlertSettingDetail : LSRootViewController
@property (nonatomic, copy) NSString *shopId;
/** <#注释#> */
@property (nonatomic, strong) GoodsVo *obj;
@end
