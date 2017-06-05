//
//  LSPurchaseRecordController.h
//  retailapp
//
//  Created by guozhi on 2017/1/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class LSGoodsPurchaseVo;

@interface LSPurchaseRecordController : LSRootViewController
/** 源数据 */
@property (nonatomic, strong) LSGoodsPurchaseVo *obj;
@property (nonatomic, strong) NSMutableDictionary *param;
@end
