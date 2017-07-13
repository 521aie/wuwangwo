//
//  UserBankListView.h
//  retailapp
//
//  Created by Jianyong Duan on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "UserBankVo.h"

typedef void(^SelectUserBankHander)(UserBankVo *userBank);

@interface UserBankListView : BaseViewController

@property (nonatomic,strong) SelectUserBankHander selectUserBankHander;

@property (nonatomic) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *selectId;

//添加
- (IBAction)addUserBankClick:(id)sender;

@end
