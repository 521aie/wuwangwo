//
//  LSGoodsPurchaseDetailController.h
//  retailapp
//
//  Created by guozhi on 2017/1/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class LSGoodsPurchaseVo;

@interface LSGoodsPurchaseDetailController : LSRootViewController
/** 商品采购信息包括图片路径 商品名称条形码 进货量退货量 进货金额退货金额 */
@property (nonatomic, strong) LSGoodsPurchaseVo *obj;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
/** 查询时间 */
@property (nonatomic, copy) NSString *time;
@end
