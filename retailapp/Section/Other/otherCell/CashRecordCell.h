//
//  CashRecordCell.h
//  retailapp
//
//  Created by qingmei on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawCheckVo.h"
@interface CashRecordCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblCashTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblApplyState;
- (void)initWithdrawCheckVo:(WithdrawCheckVo *)withdrawCheckVo;
@end
