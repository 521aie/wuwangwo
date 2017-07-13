//
//  LSStockQueryListController.h
//  retailapp
//
//  Created by guozhi on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
typedef void(^ChangeKeyWordHandler)(NSString *keyWord);
@interface LSStockQueryListController : LSRootViewController
//传入条件参数及设置回调
- (void)loadDataWithCondition:(NSMutableDictionary *)param callBack:(ChangeKeyWordHandler)handler;
@end
