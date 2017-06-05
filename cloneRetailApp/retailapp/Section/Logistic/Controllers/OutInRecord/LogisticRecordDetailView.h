//
//  LogisticRecordDetailView.h
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class LogisticsVo;
@interface LogisticRecordDetailView : LSRootViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UIView* headerView;

@property (nonatomic,weak) IBOutlet UILabel* lblPaperName;

@property (nonatomic,weak) IBOutlet UILabel* lblSupplier;

@property (nonatomic,weak) IBOutlet UILabel* lblNo;

@property (nonatomic,weak) IBOutlet UILabel* lblDate;

@property (nonatomic,weak) IBOutlet UIView* warehouseView;
//发货仓库
@property (nonatomic,weak) IBOutlet UILabel* lblDeliveWarehouse;
//收货仓库
@property (nonatomic,weak) IBOutlet UILabel* lblReceiveWarehouse;

@property (nonatomic,weak) IBOutlet UITableView* mainGrid;

@property (nonatomic,weak) IBOutlet UIView* footerView;

@property (nonatomic,weak) IBOutlet UILabel* lblTotalCount;

@property (nonatomic,weak) IBOutlet UILabel* lbltotalPrice;
@property (nonatomic,strong) LogisticsVo* logisticsVo;

@end
