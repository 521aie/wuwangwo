//
//  SelectPackBoxListView.h
//  retailapp
//
//  Created by hm on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "LSFooterView.h"

typedef void(^SelectPackBoxHandler)();

@interface SelectPackBoxListView : LSRootViewController<UITableViewDelegate,UITableViewDataSource, LSFooterViewDelegate>
@property (nonatomic,strong) UITableView *mainGrid;
@property (nonatomic,strong) LSFooterView *footView;
//设置页面参数
- (void)loadDataWithId:(NSString*)returnGoodsId callBack:(SelectPackBoxHandler)handler;
@end
