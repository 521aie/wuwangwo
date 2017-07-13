//
//  GoodsOperationList.h
//  retailapp
//
//  Created by guozhi on 16/2/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface GoodsOperationList : LSRootViewController
- (instancetype)initWithTitle:(NSString *)title;
//加载数据
- (void)loadData;
@end
