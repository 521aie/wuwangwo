//
//  LSSuppilerPurchaseRecordController.h
//  retailapp
//
//  Created by wuwangwo on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class LSSuppilerPurchaseVo;

@interface LSSuppilerPurchaseRecordController : LSRootViewController
@property (nonatomic, strong) LSSuppilerPurchaseVo *obj;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
/** 总金额 */
@property (nonatomic, strong) NSNumber *totalAmount;
/** 总件数 */
@property (nonatomic, strong) NSNumber *totalNum;
@end
