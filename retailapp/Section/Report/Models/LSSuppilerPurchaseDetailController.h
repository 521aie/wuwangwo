//
//  LSSuppilerPurchaseDetailController.h
//  retailapp
//
//  Created by wuwangwo on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class LSSuppilerPurchaseVo;

@interface LSSuppilerPurchaseDetailController : LSRootViewController
/** 供应商采购信息 */
@property (nonatomic, strong) LSSuppilerPurchaseVo *obj;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
/** 查询时间 */
@property (nonatomic, copy) NSString *time;
@end
