//
//  LSGoodsTransactionFlowDetailController.h
//  retailapp
//
//  Created by guozhi on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSGoodsTransactionFlowDetailController : LSRootViewController
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
/** 销售时间这个值后台详情不提供只能从上一个页面传人力不可为 */
@property (nonatomic, copy) NSString *salesTime;
/** 1.销售单  2.退货单 */
@property (nonatomic, strong) NSNumber *orderKind;

@end
