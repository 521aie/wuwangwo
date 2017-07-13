//
//  LSGoodsTransactionFlowListController.h
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSGoodsTransactionFlowListController : LSRootViewController
/**查询记录所需参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic,copy) NSString *url;
/** 是否显示导出按钮  */
@property (nonatomic, assign) BOOL showExport;

@end
