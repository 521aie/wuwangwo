//
//  LSGoodsPurchaseListController.h
//  retailapp
//
//  Created by guozhi on 2017/1/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSGoodsPurchaseListController : LSRootViewController
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
/** 导出所需参数： */
//1：门店；2：仓库
@property (nonatomic, copy) NSString *shopIdExport;
@property (nonatomic, copy) NSString *entityIdExport;
@property (nonatomic,assign) short shopTypeExport;
@end
