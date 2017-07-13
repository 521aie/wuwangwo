//
//  LSCostChangeRecordListController.h
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSCostChangeRecordListController : LSRootViewController
@property (nonatomic, strong) NSMutableDictionary *param;
/** 关键字 */
@property (nonatomic, copy) NSString *keyWord;
@end
