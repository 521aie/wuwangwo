//
//  ReturnMoneyCell.h
//  retailapp
//
//  Created by diwangxie on 16/4/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetailSellReturnVo.h"

@interface ReturnMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblNo;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;

- (void)initWithData:(RetailSellReturnVo *)sellReturnVo;
@end
