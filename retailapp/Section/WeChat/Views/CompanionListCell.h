//
//  CompanionListCell.h
//  retailapp
//
//  Created by yumingdong on 15/12/27.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawCheckVo.h"

@interface CompanionListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblMobile;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

//- (void)initData:(Companion *)companion;
- (void)initWithdrawData:(WithdrawCheckVo *)withdrawCheckVo;
@end
