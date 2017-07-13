//
//  SmsNoticeListView.h
//  retailapp
//
//  Created by hm on 15/9/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface SmsNoticeListView : LSRootViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) IBOutlet UITableView* mainGrid;
@property (nonatomic,weak) IBOutlet UIView* spaceView;

@end
