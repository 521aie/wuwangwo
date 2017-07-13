//
//  WithdrawListView.h
//  retailapp
//
//  Created by Jianyong Duan on 16/1/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "SearchBar2.h"
#import "EditItemList.h"

@interface WithdrawListView : BaseViewController

//input
@property (nonatomic) NSInteger companionId;

@property (nonatomic) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet SearchBar2 *searchBar2;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//筛选
@property (strong, nonatomic) IBOutlet UIControl *viewFilter;

// 审核状态
@property (weak, nonatomic) IBOutlet EditItemList *lstCheckStatus;
// 申请日期
@property (weak, nonatomic) IBOutlet EditItemList *lstCheckTime;

- (IBAction)closeFilterView:(id)sender;
- (IBAction)filterTypeClick:(UIButton *)sender;

@end
