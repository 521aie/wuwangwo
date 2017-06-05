//
//  SmsGoodsListView.h
//  retailapp
//
//  Created by hm on 15/9/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

typedef enum
{
    DATED_TYPE=1,       //过期提醒.
    STOCK_TYPE=2,      //库存预警
}MODE_TYPE;

@interface SmsGoodsListView : LSRootViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UIView* bgView;
@property (nonatomic,weak) IBOutlet UIView* headerView;

@property (nonatomic,weak) IBOutlet UILabel* lblName;

@property (nonatomic,weak) IBOutlet UILabel* lblDetail;

@property (nonatomic,weak) IBOutlet UILabel* lblTotalAmount;

@property (nonatomic,weak) IBOutlet UITableView* mainGrid;

@property (nonatomic,weak) IBOutlet UIView* spaceView;

@property (nonatomic) NSInteger type;


@end
