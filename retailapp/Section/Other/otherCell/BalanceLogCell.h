//
//  BalanceLogCell.h
//  retailapp
//
//  Created by qingmei on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceLogVo.h"
@interface BalanceLogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labFee;
- (void)initWithBalanceLogVo:(BalanceLogVo *)balanceLogVo;
@end
