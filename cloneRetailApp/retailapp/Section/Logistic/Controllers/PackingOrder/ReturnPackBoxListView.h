//
//  ReturnPackBoxListView.h
//  retailapp
//
//  Created by hm on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "LSFooterView.h"

typedef void(^ReturnPackBoxHandler)(void);

@interface ReturnPackBoxListView : LSRootViewController<UITableViewDataSource,UITableViewDelegate, LSFooterViewDelegate>
@property (nonatomic,strong) UITableView *mainGrid;
@property (nonatomic,strong) LSFooterView *footView;
/**是否可编辑*/
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) NSInteger paperType;
//设置页面参数及回调block
- (void)loadDataWithEdit:(BOOL)isEdit paperType:(NSInteger)paperType WithPaperId:(NSString*)returnGoodsId callBack:(ReturnPackBoxHandler)handler;
@end
